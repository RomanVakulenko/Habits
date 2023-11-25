//
//  TabBarCoordinator.swift
//  Habits
//
//  Created by Roman Vakulenko on 18.08.2023.
//

import UIKit

final class TabBarCoordinator {

    // MARK: - Private properties
    private var childCoordinators: [CoordinatorProtocol] = []
    private var tabBarController: UITabBarController
    
//    private weak var parentCoordinator: CoordinatorProtocol? // нужно если мы имеем логин флоу

    // MARK: - Init
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
//    self.parentCoordinator = self //нужно если мы имеем логин флоу
    }

    // MARK: - Private methods
    private func makeHabitsCoordinator() -> CoordinatorProtocol {
        let coordinator = HabitsCoordinator(navigationController: UINavigationController())
        return coordinator
    }

    private func makeInfoCoordinator() -> CoordinatorProtocol {
        let coordinator = InfoCoordinator(navigationController: UINavigationController())
       return coordinator
    }

    private func setupTabBarController(viewControllers: [UIViewController]) {
        tabBarController.setViewControllers(viewControllers, animated: false)
        tabBarController.tabBar.backgroundColor = UIColor(named: "dBackground")
        tabBarController.tabBar.tintColor = UIColor(named: "dPurple")
        tabBarController.selectedIndex = 0
    }

    private func addChildCoordinator(_ coordinator: CoordinatorProtocol) {
        guard !childCoordinators.contains(where: { $0 === coordinator })  else { return }
        childCoordinators.append(coordinator)
    }

//    private func removeChildCoordinator(_ coordinator: CoordinatorProtocol) {
//        childCoordinators.removeAll(where: { $0 === coordinator })
//    }

}


// MARK: - Extensions
extension TabBarCoordinator: CoordinatorProtocol {

    func start() -> UIViewController {
        let habitsCoordinator = makeHabitsCoordinator()
        addChildCoordinator(habitsCoordinator)
        let habitsVC = habitsCoordinator.start()

        let infoCoordinator = makeInfoCoordinator()
        addChildCoordinator(infoCoordinator)
        let infoVC = infoCoordinator.start()

        setupTabBarController(viewControllers: [habitsVC, infoVC])
        
        let tabBarItem1 = self.tabBarController.tabBar.items?[0]
        let tabBarItem2 = self.tabBarController.tabBar.items?[1]

        tabBarItem1?.title = "Привычки"
        let iconConfig = UIImage.SymbolConfiguration(scale: .default)
        let habitsIcon = UIImage(named: "habits_tab_icon", in: Bundle.main, with: iconConfig)
        tabBarItem1?.image = habitsIcon

        tabBarItem2?.title = "Информация"
        tabBarItem2?.image = UIImage(systemName: "info.circle")
        tabBarItem2?.selectedImage = UIImage(named: "info.circle.fill")

        return self.tabBarController
    }
}
