import Foundation
import FirebaseFirestore
import os.log

class UserDataService: ObservableObject {
    static let shared = UserDataService()
    private let db = Firestore.firestore()
    private let logger = Logger(subsystem: "com.jerrynkongolo.CalorieScan", category: "UserData")
    
    @Published var currentProfile: UserProfile?
    @Published var isProfileComplete: Bool = false
    
    private init() {
        // Generate a unique device ID if not exists
        if UserDefaults.standard.string(forKey: "device_id") == nil {
            UserDefaults.standard.set(UUID().uuidString, forKey: "device_id")
        }
        setupProfileListener()
    }
    
    private var deviceId: String {
        UserDefaults.standard.string(forKey: "device_id") ?? UUID().uuidString
    }
    
    func fetchProfile() async throws -> UserProfile? {
        let userRef = db.collection("users").document(deviceId)
        let snapshot = try await userRef.getDocument()
        
        guard let data = snapshot.data(),
              let name = data["name"] as? String,
              !name.isEmpty else {
            return nil
        }
        
        return UserProfile(
            id: UUID(uuidString: deviceId) ?? UUID(),
            name: name,
            age: data["age"] as? Int ?? 25,
            weight: data["weight"] as? Double ?? 70.0,
            height: data["height"] as? Double ?? 170.0,
            workoutFrequency: WorkoutFrequency(rawValue: data["workoutFrequency"] as? String ?? "moderate") ?? .moderate,
            weightGoal: WeightGoal(rawValue: data["weightGoal"] as? String ?? "maintain") ?? .maintain,
            targetWeight: data["targetWeight"] as? Double ?? 70.0,
            targetDate: (data["targetDate"] as? Timestamp)?.dateValue() ?? Date().addingTimeInterval(90 * 24 * 60 * 60),
            dailyCalorieTarget: data["dailyCalorieTarget"] as? Int ?? 2000,
            createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
            updatedAt: (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
        )
    }
    
    public func refreshProfile() {
        setupProfileListener()
    }
    
    private func setupProfileListener() {
        let userRef = db.collection("users").document(deviceId)
        userRef.addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                self?.logger.error("Error loading profile: \(error.localizedDescription)")
                return
            }
            
            if let data = snapshot?.data(),
               let name = data["name"] as? String,
               !name.isEmpty {
                DispatchQueue.main.async {
                    self?.currentProfile = UserProfile(
                        id: UUID(uuidString: self?.deviceId ?? "") ?? UUID(),
                        name: name,
                        age: data["age"] as? Int ?? 25,
                        weight: data["weight"] as? Double ?? 70.0,
                        height: data["height"] as? Double ?? 170.0,
                        workoutFrequency: WorkoutFrequency(rawValue: data["workoutFrequency"] as? String ?? "moderate") ?? .moderate,
                        weightGoal: WeightGoal(rawValue: data["weightGoal"] as? String ?? "maintain") ?? .maintain,
                        targetWeight: data["targetWeight"] as? Double ?? 70.0,
                        targetDate: (data["targetDate"] as? Timestamp)?.dateValue() ?? Date().addingTimeInterval(90 * 24 * 60 * 60),
                        dailyCalorieTarget: data["dailyCalorieTarget"] as? Int ?? 2000,
                        createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                        updatedAt: (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
                    )
                    self?.isProfileComplete = true
                }
            } else {
                DispatchQueue.main.async {
                    self?.currentProfile = nil
                    self?.isProfileComplete = false
                }
            }
        }
    }
    
    func updateProfile(_ profile: UserProfile) async throws {
        let data: [String: Any] = [
            "name": profile.name,
            "age": profile.age,
            "weight": profile.weight,
            "height": profile.height,
            "workoutFrequency": profile.workoutFrequency.rawValue,
            "weightGoal": profile.weightGoal.rawValue,
            "targetWeight": profile.targetWeight,
            "targetDate": Timestamp(date: profile.targetDate),
            "dailyCalorieTarget": profile.dailyCalorieTarget,
            "createdAt": Timestamp(date: profile.createdAt),
            "updatedAt": Timestamp(date: Date())
        ]
        
        try await db.collection("users").document(deviceId).setData(data, merge: true)
        DispatchQueue.main.async {
            self.currentProfile = profile
            self.isProfileComplete = true
        }
    }
    
    // Add method to save calorie entries
    func saveCalorieEntry(_ entry: CalorieEntry) async throws {
        let data: [String: Any] = [
            "userId": deviceId,
            "calories": entry.calories,
            "foodName": entry.foodName,
            "date": Timestamp(date: entry.date),
            "mealType": entry.mealType.rawValue
        ]
        
        try await db.collection("calorie_entries")
            .document(deviceId)
            .collection("entries")
            .addDocument(data: data)
        
        logger.info("Saved calorie entry: \(entry.calories) calories for \(entry.foodName)")
    }
    
    // Add method to fetch calorie entries for a date range
    func fetchCalorieEntries(from startDate: Date, to endDate: Date) async throws -> [CalorieEntry] {
        let snapshot = try await db.collection("calorie_entries")
            .document(deviceId)
            .collection("entries")
            .whereField("date", isGreaterThanOrEqualTo: Timestamp(date: startDate))
            .whereField("date", isLessThanOrEqualTo: Timestamp(date: endDate))
            .getDocuments()
        
        return snapshot.documents.compactMap { document in
            let data = document.data()
            guard let calories = data["calories"] as? Int,
                  let foodName = data["foodName"] as? String,
                  let date = (data["date"] as? Timestamp)?.dateValue(),
                  let mealTypeRaw = data["mealType"] as? String,
                  let mealType = MealType(rawValue: mealTypeRaw) else {
                return nil
            }
            
            return CalorieEntry(
                id: document.documentID,
                userId: data["userId"] as? String ?? "",
                calories: calories,
                foodName: foodName,
                date: date,
                mealType: mealType
            )
        }
    }
}
