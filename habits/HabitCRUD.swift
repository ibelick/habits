import SwiftUI

struct Habit: Identifiable {
    let id = UUID()
    var name: String
    var frequency: String
    var completionDates: [Date] = []
}

struct HabitCRUDView: View {
    @EnvironmentObject var habitData: HabitData
    @State private var newHabitName: String = ""
    @State private var newHabitFrequency: String = "Daily"
    @State private var showAddHabitSheet: Bool = false
    
    var frequencyOptions = [
        "Daily",
        "Every other day",
        "3 times per week",
        "4 times per week",
        "5 times per week",
        "6 times per week",
        "Weekly",
        "Monthly"
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(habitData.habits) { habit in
                    HStack {
                        Text(habit.name)
                        Spacer()
                        Text(habit.frequency)
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Habits")
            .navigationBarItems(
                trailing: Button(action: { showAddHabitSheet = true }, label: {
                    Image(systemName: "plus")
                })
            )
            .sheet(isPresented: $showAddHabitSheet, content: {
                addHabitSheet
            })
        }
    }
    
    var addHabitSheet: some View {
        VStack {
            Form {
                Section(header: Text("New Habit Details")) {
                    TextField("Habit Name", text: $newHabitName)
                    Picker(selection: $newHabitFrequency, label: Text("Frequency")) {
                        ForEach(frequencyOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                }
            }
            
            Button(action: addHabit, label: {
                Text("Add Habit")
            })
        }
    }
    
    func addHabit() {
        habitData.addHabit(Habit(name: newHabitName, frequency: newHabitFrequency))
        newHabitName = ""
        newHabitFrequency = "Daily"
        showAddHabitSheet = false
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            habitData.deleteHabit(at: index)
        }
    }
}

struct HabitCRUD_Previews: PreviewProvider {
    static var previews: some View {
        HabitCRUDView().environmentObject(HabitData())
    }
}
