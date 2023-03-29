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
                            CalendarDayView(date: date)
                                .onTapGesture {
                                    selectedDate = date
                                }
                        } else if dayIndex == 27 {
                            CalendarDayView(date: endDate)
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
            VStack {
                Text(date, style: .date)
                    .font(.headline)
                    .padding()
                HabitTrackerView(date: date)
                    .environmentObject(habitData)
                    .navigationTitle(dateFormatter.string(from: date))
            }
        }
    }
}

struct CalendarDayView: View {
    var date: Date
    @EnvironmentObject var habitData: HabitData
    
    var body: some View {
        let habitsForDate = habitData.habits.filter {
            $0.completionDateIds.contains(habitData.formatDate(date: date))
        }
        let percentageComplete = Double(habitsForDate.count) / Double(habitData.habits.count)
        let backgroundColor = getColorForPercentage(percentageComplete)
        
        
        RoundedRectangle(cornerRadius: 12)
            .fill(backgroundColor)
            .frame(maxWidth: 50, maxHeight: 50)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .disabled(!habitData.habits.contains { $0.completionDateIds.contains(dateFormatter.string(from: date)) })
    }
    
    private func getColorForPercentage(_ percentage: Double) -> Color {
        switch percentage {
        case 0.0:
            return Color(UIColor.systemGray5)
        case 0.01..<0.25:
            return Color ("PrimaryLightest")
        case 0.25..<0.5:
            return Color("PrimaryMedium")
        case 0.5..<0.75:
            return Color("PrimaryDark")
        case 0.75...1.0:
            return Color("PrimaryDarkest")
        default:
            return Color(UIColor.systemGray5)
        }
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


