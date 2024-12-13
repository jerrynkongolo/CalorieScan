import Foundation

struct Meal: Identifiable {
    let id = UUID()
    let name: String
    let timestamp: Date
    let calories: Int
    let icon: String // SF Symbol name
    
    static let sampleMeals = [
        Meal(name: "Breakfast", timestamp: Date(timeIntervalSince1970: 1703138400), calories: 320, icon: "cup.and.saucer.fill"),
        Meal(name: "Lunch", timestamp: Date(timeIntervalSince1970: 1703156400), calories: 520, icon: "fork.knife"),
        Meal(name: "Snack", timestamp: Date(timeIntervalSince1970: 1703167200), calories: 150, icon: "apple.logo"),
    ]
}
