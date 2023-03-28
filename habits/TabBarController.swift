import SwiftUI

struct TabBarController: UIViewControllerRepresentable {
    let habitData = HabitData()
    
    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController = UITabBarController()
        let todayViewController = UIHostingController(rootView: TodayView().environmentObject(habitData))
        let habitCRUDViewController = UIHostingController(rootView: HabitCRUDView().environmentObject(habitData))
        let calendarViewController = UIHostingController(rootView: CalendarView().environmentObject(habitData))
        
        todayViewController.tabBarItem = UITabBarItem(title: "Today", image: UIImage(systemName: "sun.max"), tag: 0)
        habitCRUDViewController.tabBarItem = UITabBarItem(title: "Habits", image: UIImage(systemName: "list.dash"), tag: 1)
        calendarViewController.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(systemName: "calendar"), tag: 2)
        
        tabBarController.viewControllers = [todayViewController, calendarViewController, habitCRUDViewController]
        return tabBarController
    }
    
    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
        
    }
}
