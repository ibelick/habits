import SwiftUI

struct CalendarView: View {
    @State private var selectedDate: Date?
    
    var body: some View {
        let today = Date()
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -14, to: today)!
        let endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!

        let days = calendar.dateComponents([.day], from: startDate, to: endDate).day!
        let dayCount = min(days, 14)
        let range = (0..<dayCount + 1).map { calendar.date(byAdding: .day, value: $0, to: startDate)! }
        
        VStack(spacing: 10) {
            HStack {
                ForEach(range.prefix(7), id: \.self) { day in
                    VStack {
                        Text("\(calendar.component(.day, from: day))")
                            .fontWeight(.bold)
                            .font(.title3)

                        Circle()
                            .fill(selectedDate == day ? Color.blue : Color.clear)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                }
            }

            HStack {
                ForEach(range.dropFirst(7), id: \.self) { day in
                    VStack {
                        Text("\(calendar.component(.day, from: day))")
                            .fontWeight(.bold)
                            .font(.title3)

                        Circle()
                            .fill(selectedDate == day ? Color.blue : Color.clear)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
