import SwiftUI

struct TabBarController: UIViewControllerRepresentable {
    let habitData = HabitData()
    
    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController = UITabBarController()
        let firstViewController = UIHostingController(rootView: ContentView().environmentObject(habitData))
        let secondViewController = UIHostingController(rootView: CalendarView().environmentObject(habitData))
        
        firstViewController.tabBarItem = UITabBarItem(title: "Habits", image: UIImage(systemName: "list.dash"), tag: 0)
        secondViewController.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(systemName: "calendar"), tag: 1)
        
        tabBarController.viewControllers = [firstViewController, secondViewController]
        return tabBarController
    }
    
    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
        
    }
}
