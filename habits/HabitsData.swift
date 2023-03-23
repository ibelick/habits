import Foundation

class HabitData: ObservableObject {
    @Published var habits: [Habit] = [
        Habit(name: "Drink 8 cups of water", frequency: "Daily"),
        Habit(name: "Exercise for 30 minutes", frequency: "3 times per week"),
        Habit(name: "Read for 30 minutes", frequency: "5 times per week")
    ]
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
    }

    func deleteHabit(at index: Int) {
        habits.remove(at: index)
    }
}
