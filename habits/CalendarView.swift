import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var habitData: HabitData
    @State var selectedDate: Date? = nil
    
    let calendar = Calendar.current
    let startDate = Date().addingTimeInterval(-13 * 24 * 60 * 60)
    let endDate = Date()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var body: some View {
        VStack {
            ForEach(getWeeks(), id: \.self) { week in
                HStack(spacing: 4) {
                    ForEach(week, id: \.self) { date in
                        CalendarDayView(date: date, isCompleted: habitData.habits.contains { $0.completionDateIds.contains(dateFormatter.string(from: date)) })
                            .onTapGesture {
                                selectedDate = date
                            }
                    }
                }
            }
        }
        .sheet(item: $selectedDate,  onDismiss: {
            habitData.reloadData()
        }) { date in
            HabitTrackerView(date: date)
                .environmentObject(habitData)
                .navigationTitle(dateFormatter.string(from: date))
        }
    }
    
    func getWeeks() -> [[Date]] {
        var weeks: [[Date]] = []
        var currentWeek: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            currentWeek.append(currentDate)
            
            if calendar.isDateInToday(currentDate) {
                weeks.append(currentWeek)
                break
            } else if calendar.component(.weekday, from: currentDate) == 7 {
                weeks.append(currentWeek)
                currentWeek = []
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return weeks
    }
}

struct CalendarDayView: View {
    var date: Date
    var isCompleted: Bool
    @EnvironmentObject var habitData: HabitData
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(isCompleted ? Color.green : Color(UIColor.systemGray5))
            .frame(width: 20, height: 20)
            .overlay(
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(isCompleted ? .white : .primary)
            )
            .disabled(!habitData.habits.contains { $0.completionDateIds.contains(dateFormatter.string(from: date)) })
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

extension Date: Identifiable {
    public var id: String {
        return DateFormatter.localizedString(from: self, dateStyle: .medium, timeStyle: .none)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(HabitData())
    }
}
