import SwiftUI

struct TodayView: View {
    @EnvironmentObject var habitData: HabitData
    @State private var selectedHabits: [Habit] = []
    let today = Date()

    var body: some View {
        VStack {
            Text(today, style: .date)
                .font(.headline)

            ForEach(habitData.habits) { habit in
                let completedToday = habit.completionDates.contains(today)
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
            if !selectedHabits[index].completionDates.contains(today) {
                selectedHabits[index].completionDates.append(today)
            }
        }
        selectedHabits.removeAll()
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .environmentObject(HabitData())
    }
}
