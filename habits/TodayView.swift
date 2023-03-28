import SwiftUI

struct TodayView: View {
    @EnvironmentObject var habitData: HabitData
    
    let date = Date()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var body: some View {
        VStack {
            HabitTrackerView(date: date)
        }
        .padding()
    }
    
    func toggleDayComplete() {
        let dateString = dateFormatter.string(from: date)
        let habitIDs = habitData.habits.map { $0.id }
        let completedHabitIDs = habitData.habits.filter { $0.completionDateIds.contains(dateString) }.map { $0.id }
        let incompleteHabitIDs = habitIDs.filter { !completedHabitIDs.contains($0) }
        
        if incompleteHabitIDs.isEmpty {
            for index in habitData.habits.indices {
                if let habitIndex = habitData.habits[index].completionDateIds.firstIndex(of: dateString) {
                    habitData.habits[index].completionDateIds.remove(at: habitIndex)
                }
            }
        } else {
            for index in habitData.habits.indices {
                if incompleteHabitIDs.contains(habitData.habits[index].id) {
                    habitData.habits[index].completionDateIds.append(dateString)
                } else {
                    if let habitIndex = habitData.habits[index].completionDateIds.firstIndex(of: dateString) {
                        habitData.habits[index].completionDateIds.remove(at: habitIndex)
                    }
                }
            }
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .environmentObject(HabitData())
    }
}
