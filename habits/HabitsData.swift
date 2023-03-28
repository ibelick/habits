import Foundation

class Habit: Identifiable, Codable {
    var id = UUID()
    var name: String
    var frequency: String
    var completionDates: [Date]

    init(name: String, frequency: String) {
        self.name = name
        self.frequency = frequency
        self.completionDates = []
    }
}

class HabitData: ObservableObject {
    @Published var habits: [Habit] = []
    
    init() {
        load()
    }
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        save()
    }

    func deleteHabit(at index: Int) {
        habits.remove(at: index)
        save()
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(habits)
            try data.write(to: HabitData.fileURL)
        } catch {
            print(error)
        }
    }
    
    private func load() {
        do {
            let data = try Data(contentsOf: HabitData.fileURL)
            habits = try JSONDecoder().decode([Habit].self, from: data)
        } catch {
            print(error)
        }
    }
    
    private static var fileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("habits.json")
    }
}
