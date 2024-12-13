import Foundation

struct Food: Identifiable {
    let id = UUID()
    let name: String
    let calories: Int
    let imageName: String
    
    static let sampleFoods = [
        Food(name: "Greek Salad", calories: 320, imageName: "greek_salad"),
        Food(name: "Grilled Chicken", calories: 165, imageName: "grilled_chicken"),
        Food(name: "Quinoa Bowl", calories: 420, imageName: "quinoa_bowl"),
        Food(name: "Salmon", calories: 367, imageName: "salmon"),
        Food(name: "Avocado Toast", calories: 280, imageName: "avocado_toast")
    ]
}
