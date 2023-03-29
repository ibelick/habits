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
        let dateString = formatDate(date: date)
        
        for habit in habits {
            if habit.completionDateIds.contains(dateString) {
                habit.completionDateIds.removeAll(where: { $0 == dateString })
            } else {
                habit.completionDateIds.append(dateString)
            }
        }
        save()
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func completedHabits() -> [Int] {
        var completedHabits = Array(repeating: 0, count: 14)
        
        for habit in habits {
            for i in 0..<14 {
                let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
                let dateString = formatDate(date: date)
                
                if habit.completionDateIds.contains(dateString) {
                    completedHabits[i] += 1
                }
            }
        }
        
        return completedHabits
    }
    
    func reloadData() {
        load()
    }
    
    private func save() {
        do {
            let data = try JSONEncoder().encode(habits)
            try data.write(to: HabitData.fileURL)
            
            // log when save
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
            habits = [
                Habit(name: "Drink water", frequency: "Daily"),
                Habit(name: "Read for 30 minutes", frequency: "Daily"),
                Habit(name: "Exercise for 1 hour", frequency: "Daily")
            ]
        }
    }
    
    
    private static var fileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("habits.json")
    }
}
