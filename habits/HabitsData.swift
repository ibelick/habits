import Foundation

class Habit: Identifiable, Codable {
    var id = UUID()
    var name: String
    var frequency: String
    var completionDateIds: [String]

    init(name: String, frequency: String) {
        self.name = name
        self.frequency = frequency
        self.completionDateIds = []
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
    
    func toggleCompletion(for habits: [Habit], on date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Calendar.current.startOfDay(for: date))

        for habit in habits {
            if habit.completionDateIds.contains(dateString) {
                habit.completionDateIds.removeAll(where: { $0 == dateString })
            } else {
                habit.completionDateIds.append(dateString)
            }
        }
        save()
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(habits)
            try data.write(to: HabitData.fileURL)
            
            print(String(data: data, encoding: .utf8) ?? "")
        } catch {
            print(error)
        }
    }

    private func load() {
        do {
            let data = try Data(contentsOf: HabitData.fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            habits = try decoder.decode([Habit].self, from: data)
        } catch {
            print(error)
        }
    }

    
    private static var fileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("habits.json")
    }
}
