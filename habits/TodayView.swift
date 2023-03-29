import SwiftUI

struct TodayView: View {
    @EnvironmentObject var habitData: HabitData
    let date = Date()

    var body: some View {
        VStack {
            Text(date, style: .date).font(.headline)
            CircleProgressView(date: date)
            HabitTrackerView(date: date)
        }
        .padding()
    }
}
struct CircleProgressView: View {
    var date: Date
    @EnvironmentObject var habitData: HabitData
    private let circleSize: CGFloat = 180
    private let lineWidth: CGFloat = 8
    private let animationDuration: Double = 0.5
    
    var body: some View {
        let habitsForDate = habitData.habits.filter {
            $0.completionDateIds.contains(habitData.formatDate(date: date))
        }
        let percentageComplete = Double(habitsForDate.count) / Double(habitData.habits.count)
        let dotSize = percentageComplete == 0 ? 10 : percentageComplete * circleSize
        
        ZStack {
            Circle()
                .stroke(Color("Primary"), lineWidth: lineWidth)
                .frame(width: circleSize, height: circleSize)
            
            Circle()
                .fill(Color("Primary"))
                .frame(width: dotSize, height: dotSize)
                .scaleEffect(1) // Only show dot if percentageComplete > 0
                .animation(.easeInOut(duration: animationDuration))
            
        }
        .frame(width: circleSize, height: circleSize)
        .padding(.vertical)
    }
}


struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
            .environmentObject(HabitData())
    }
}
