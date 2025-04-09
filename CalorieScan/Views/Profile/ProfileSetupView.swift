import SwiftUI
import CalorieScan

struct ProfileSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState
    @StateObject private var userDataService = UserDataService.shared
    @State private var profile = ProfileFormData()
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var showingDatePicker = false
    
    private let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.minimumDaysInFirstWeek = 1
        return calendar
    }()
    
    var body: some View {
        NavigationStack {
            Form {
                personalInfoSection
                bodyMeasurementsSection
                weightGoalSection
                fitnessGoalsSection
            }
            .navigationTitle("Set Up Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveProfile() }
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
        }
        .withGradientBackground()
    }
    
    private var personalInfoSection: some View {
        Section("Personal Information") {
            TextField("Name", text: $profile.name)
                .textContentType(.name)
                .autocorrectionDisabled()
            Stepper("Age: \(profile.age)", value: $profile.age, in: 13...100)
        }
    }
    
    private var bodyMeasurementsSection: some View {
        Section("Body Measurements") {
            HStack {
                Text("Weight")
                Spacer()
                TextField("Weight", value: $profile.weight, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 60)
                Text("kg")
            }
            
            HStack {
                Text("Height")
                Spacer()
                TextField("Height", value: $profile.height, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 60)
                Text("cm")
            }
        }
    }
    
    private var weightGoalSection: some View {
        Section("Weight Goal Settings") {
            HStack {
                Text("Target Weight")
                Spacer()
                TextField("Target Weight", value: $profile.targetWeight, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 60)
                Text("kg")
            }
            
            DatePicker(
                "Target Date",
                selection: $profile.targetDate,
                in: Date()...,
                displayedComponents: .date
            )
            
            if profile.weight != profile.targetWeight {
                let weeksBetween = calendar.dateComponents([.day], from: Date(), to: profile.targetDate).day! / 7
                let weightDifference = abs(profile.targetWeight - profile.weight)
                let weeklyChange = weightDifference / Double(max(1, weeksBetween))
                
                HStack {
                    Text("Weekly Change")
                    Spacer()
                    Text(String(format: "%.1f kg", weeklyChange))
                        .foregroundColor(weeklyChange > 1 ? .red : .secondary)
                }
                
                if weeklyChange > 1 {
                    Text("A weekly change of more than 1kg might be unhealthy. Consider adjusting your target weight or extending your timeframe.")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    private var fitnessGoalsSection: some View {
        Section("Fitness Goals") {
            Picker("Workout Frequency", selection: $profile.workoutFrequency) {
                ForEach(WorkoutFrequency.allCases, id: \.self) { frequency in
                    Text(frequency.rawValue).tag(frequency)
                }
            }
            
            Picker("Weight Goal", selection: $profile.weightGoal) {
                ForEach(WeightGoal.allCases, id: \.self) { goal in
                    Text(goal.rawValue).tag(goal)
                }
            }
            
            HStack {
                Text("Daily Calorie Target")
                Spacer()
                Text("\(calculateDailyCalories())")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func calculateDailyCalories() -> Int {
        // Calculate BMR using Mifflin-St Jeor Equation
        let s = 5 // Male = +5, Female = -161 (we can add gender selection later)
        let bmr = (10 * profile.weight) + (6.25 * profile.height) - (5 * Double(profile.age)) + Double(s)
        
        // Calculate TDEE (Total Daily Energy Expenditure)
        let tdee = bmr * profile.workoutFrequency.activityMultiplier
        
        // Adjust based on weight goal
        let adjustedCalories = tdee + profile.weightGoal.calorieAdjustment
        
        return Int(adjustedCalories)
    }
    
    private func saveProfile() {
        // Validate required fields
        guard !profile.name.isEmpty else {
            showingError = true
            errorMessage = "Please enter your name"
            return
        }
        
        let calculatedCalories = calculateDailyCalories()
        
        let userProfile = UserProfile(
            name: profile.name,
            age: profile.age,
            weight: profile.weight,
            height: profile.height,
            workoutFrequency: profile.workoutFrequency,
            weightGoal: profile.weightGoal,
            targetWeight: profile.targetWeight,
            targetDate: profile.targetDate,
            dailyCalorieTarget: calculatedCalories,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        Task {
            do {
                try await userDataService.updateProfile(userProfile)
                appState.hasCompletedProfile = true
                dismiss()
            } catch {
                showingError = true
                errorMessage = error.localizedDescription
            }
        }
    }
}

// Helper struct to manage form data
private struct ProfileFormData {
    var name: String = ""
    var age: Int = 25
    var weight: Double = 70.0
    var height: Double = 170.0
    var workoutFrequency: WorkoutFrequency = .moderate
    var weightGoal: WeightGoal = .maintain
    var targetWeight: Double = 70.0
    var targetDate: Date = Date().addingTimeInterval(90 * 24 * 60 * 60) // 90 days from now
}

struct ProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupView()
    }
}
