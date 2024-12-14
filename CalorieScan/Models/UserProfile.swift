import Foundation
import FirebaseFirestore

enum WorkoutFrequency: String, Codable, CaseIterable {
    case sedentary = "Sedentary"
    case light = "Light Exercise"
    case moderate = "Moderate Exercise"
    case active = "Very Active"
    case athlete = "Athlete"
    
    var activityMultiplier: Double {
        switch self {
        case .sedentary: return 1.2
        case .light: return 1.375
        case .moderate: return 1.55
        case .active: return 1.725
        case .athlete: return 1.9
        }
    }
}

enum WeightGoal: String, Codable, CaseIterable {
    case lose = "Lose Weight"
    case maintain = "Maintain Weight"
    case gain = "Gain Weight"
    
    var calorieAdjustment: Double {
        switch self {
        case .lose: return -500
        case .maintain: return 0
        case .gain: return 500
        }
    }
}

struct UserProfile: Codable, Identifiable {
    let id: UUID
    var name: String
    var age: Int
    var weight: Double
    var height: Double
    var workoutFrequency: WorkoutFrequency
    var weightGoal: WeightGoal
    var targetWeight: Double
    var targetDate: Date
    var dailyCalorieTarget: Int
    let createdAt: Date
    var updatedAt: Date
    
    var bmi: Double {
        let heightInMeters = height / 100
        return weight / (heightInMeters * heightInMeters)
    }
    
    var bmr: Double {
        // Using Mifflin-St Jeor Equation
        return (10 * weight) + (6.25 * height) - (5 * Double(age)) + 5
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        age: Int,
        weight: Double,
        height: Double,
        workoutFrequency: WorkoutFrequency,
        weightGoal: WeightGoal,
        targetWeight: Double,
        targetDate: Date,
        dailyCalorieTarget: Int,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.weight = weight
        self.height = height
        self.workoutFrequency = workoutFrequency
        self.weightGoal = weightGoal
        self.targetWeight = targetWeight
        self.targetDate = targetDate
        self.dailyCalorieTarget = dailyCalorieTarget
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
