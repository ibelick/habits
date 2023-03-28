import SwiftUI

struct HabitTrackerView: View {
    @EnvironmentObject var habitData: HabitData
    @State var selectedHabits: [Habit] = []
    let date: Date
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    var body: some View {
        VStack {
            Text(date, style: .date)
                .font(.headline)
            
            ForEach(habitData.habits) { habit in
                let completedToday = habit.completionDateIds.contains(dateFormatter.string(from: date))
                
                Toggle(isOn: Binding(
                    get: { selectedHabits.contains { $0.id == habit.id } },
                    set: { newValue in
                        if newValue {
                            selectedHabits.append(habit)
                        } else {
                            selectedHabits.removeAll { $0.id == habit.id }
                        }
                    }
                )) {
                    Text(habit.name)
                        .foregroundColor(completedToday ? .green : .primary)
                }
            }
            
            Button(action: {
                habitData.toggleCompletion(for: selectedHabits, on: date)
                selectedHabits = []
            }, label: {
                Text("Save")
            })
            .disabled(selectedHabits.isEmpty)
        }
    }
}

struct HabitTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        HabitTrackerView(date: Date())
            .environmentObject(HabitData())
    }
}
