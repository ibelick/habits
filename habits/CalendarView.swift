import SwiftUI

struct CalendarView: View {
    var body: some View {
        Text("Calendar View")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.blue)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
