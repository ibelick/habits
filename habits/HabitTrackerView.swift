import SwiftUI

struct HabitTrackerView: View {
    @EnvironmentObject var habitData: HabitData
    @State var selectedHabits: [Habit] = []
    let date: Date
    
    var body: some View {
        VStack {
            Text(date, style: .date)
                .font(.headline)
            
            ForEach(habitData.habits) { habit in
                let completedToday = habit.completionDates.contains(date)
                Toggle(isOn: Binding(get: {
                    selectedHabits.contains { $0.id == habit.id }
                }, set: { newValue in
                    if newValue {
                        selectedHabits.append(habit)
                    } else {
                        selectedHabits.removeAll { $0.id == habit.id }
                    }
                })) {
                    Text(habit.name)
                        .foregroundColor(completedToday ? .green : .primary)
                }
            }
            
            Button(action: saveCompletion, label: {
                Text("Save")
            })
            .disabled(selectedHabits.isEmpty)
        }
    }
    
    func saveCompletion() {
        for index in selectedHabits.indices {
            if !selectedHabits[index].completionDates.contains(date) {
                selectedHabits[index].completionDates.append(date)
            }
        }

    }
}

struct HabitTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        HabitTrackerView(date: Date())
            .environmentObject(HabitData())
    }
}
