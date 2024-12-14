import Foundation
import HealthKit

class HealthKitService: ObservableObject {
    static let shared = HealthKitService()
    private let healthStore = HKHealthStore()
    private var queries: [HKQuery] = []
    
    @Published var isAuthorized = false
    @Published var isAvailable = false
    @Published var steps: Int = 0
    @Published var activeEnergy: Double = 0
    @Published var exerciseMinutes: Int = 0
    @Published var errorMessage: String?
    
    private init() {
        checkAvailability()
    }
    
    deinit {
        stopQueries()
    }
    
    private func checkAvailability() {
        isAvailable = HKHealthStore.isHealthDataAvailable()
        if !isAvailable {
            errorMessage = "HealthKit is not available on this device"
        }
    }
    
    private func stopQueries() {
        queries.forEach { healthStore.stop($0) }
        queries.removeAll()
    }
    
    func requestAuthorization() {
        guard isAvailable else { return }
        
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isAuthorized = success
                if success {
                    self?.setupObservers()
                } else if let error = error {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchTodayData() {
        guard isAuthorized else { return }
        fetchSteps()
        fetchActiveEnergy()
        fetchExerciseMinutes()
    }
    
    private func setupObservers() {
        stopQueries() // Clean up existing queries
        setupStepsObserver()
        setupActiveEnergyObserver()
        setupExerciseMinutesObserver()
        fetchTodayData() // Initial fetch
    }
    
    private func setupStepsObserver() {
        guard let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let query = createObserverQuery(for: stepsType) { [weak self] in
            self?.fetchSteps()
        }
        healthStore.execute(query)
        queries.append(query)
    }
    
    private func setupActiveEnergyObserver() {
        guard let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        let query = createObserverQuery(for: energyType) { [weak self] in
            self?.fetchActiveEnergy()
        }
        healthStore.execute(query)
        queries.append(query)
    }
    
    private func setupExerciseMinutesObserver() {
        guard let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else { return }
        let query = createObserverQuery(for: exerciseType) { [weak self] in
            self?.fetchExerciseMinutes()
        }
        healthStore.execute(query)
        queries.append(query)
    }
    
    private func createObserverQuery(for quantityType: HKQuantityType, updateHandler: @escaping () -> Void) -> HKObserverQuery {
        let query = HKObserverQuery(sampleType: quantityType, predicate: nil) { _, _, error in
            if error == nil {
                DispatchQueue.main.async {
                    updateHandler()
                }
            }
        }
        return query
    }
    
    private func fetchSteps() {
        guard let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        fetchTodaySum(for: stepsType, unit: HKUnit.count()) { [weak self] steps in
            DispatchQueue.main.async {
                self?.steps = Int(steps)
            }
        }
    }
    
    private func fetchActiveEnergy() {
        guard let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        fetchTodaySum(for: energyType, unit: HKUnit.kilocalorie()) { [weak self] calories in
            DispatchQueue.main.async {
                self?.activeEnergy = calories
            }
        }
    }
    
    private func fetchExerciseMinutes() {
        guard let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else { return }
        fetchTodaySum(for: exerciseType, unit: HKUnit.minute()) { [weak self] minutes in
            DispatchQueue.main.async {
                self?.exerciseMinutes = Int(minutes)
            }
        }
    }
    
    private func fetchTodaySum(for quantityType: HKQuantityType, unit: HKUnit, completion: @escaping (Double) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(
            quantityType: quantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: unit))
        }
        
        healthStore.execute(query)
    }
}
