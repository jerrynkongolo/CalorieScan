import Foundation

enum MealType: String, CaseIterable, Codable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
}

struct CalorieEntry: Identifiable, Codable {
    let id: String
    let userId: String
    let calories: Int
    let foodName: String
    let date: Date
    let mealType: MealType
}
