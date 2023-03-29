import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var habitData: HabitData
    @State var selectedDate: Date? = nil
    
    let calendar = Calendar.current
    let startDate = Date().addingTimeInterval(-27 * 24 * 60 * 60)
    let endDate = Date()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var body: some View {
        VStack {
            ForEach(0..<4) { rowIndex in
                HStack(spacing: 4) {
                    ForEach(0..<7) { columnIndex in
                        let dayIndex = rowIndex * 7 + columnIndex
                        if let date = calendar.date(byAdding: .day, value: dayIndex, to: startDate),
                           calendar.isDate(date, equalTo: date, toGranularity: .day) {
                            CalendarDayView(date: date, isCompleted: habitData.habits.contains { $0.completionDateIds.contains(dateFormatter.string(from: date)) })
                                .onTapGesture {
                                    selectedDate = date
                                }
                        } else if dayIndex == 27 {
                            CalendarDayView(date: endDate, isCompleted: false)
                                .onTapGesture {
                                    selectedDate = endDate
                                }
                        } else {
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding(16)
        .sheet(item: $selectedDate, onDismiss: {
            habitData.reloadData()
        }) { date in
            HabitTrackerView(date: date)
                .environmentObject(habitData)
                .navigationTitle(dateFormatter.string(from: date))
        }
    }
}

struct CalendarDayView: View {
    var date: Date
    var isCompleted: Bool
    @EnvironmentObject var habitData: HabitData
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(isCompleted ? Color.green : Color(UIColor.systemGray5))
            .frame(maxWidth: 50, maxHeight: 50)
            .overlay(
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(isCompleted ? .white : Color("CustomColorName"))
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


