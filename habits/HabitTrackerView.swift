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
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(habitData.habits) { habit in
                        let isCompleted = habit.completionDateIds.contains(dateFormatter.string(from: date))
                        HabitCardView(habit: habit, isCompleted: isCompleted, date: date)
                    }
                }
            }
        }.padding()
    }
    
}

struct HabitCardView: View {
    @EnvironmentObject var habitData: HabitData
    var habit: Habit
    @State var isCompleted: Bool
    var date: Date
    
    var body: some View {
        Button(action: {
            self.isCompleted.toggle()
            habitData.toggleCompletion(for: [habit], on: date)
            habitData.reloadData()
        }) {
            VStack {
                Text(habit.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(isCompleted ? .white : .primary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(isCompleted ? Color("Primary") : Color.white)
            )
            .frame(maxWidth: .infinity, minHeight: 80, alignment: .center)
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct HabitTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        HabitTrackerView(date: Date())
            .environmentObject(HabitData())
    }
}
