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
//        self.parentCoordinator = self //нужно если мы имеем логин флоу
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
    }


    private func addChildCoordinator(_ coordinator: CoordinatorProtocol) {
        guard !childCoordinators.contains(where: { $0 === coordinator })  else { return }
        childCoordinators.append(coordinator)
    }

    private func removeChildCoordinator(_ coordinator: CoordinatorProtocol) {
        childCoordinators.removeAll(where: { $0 === coordinator })
    }

}


// MARK: - Extensions
extension TabBarCoordinator: CoordinatorProtocol {

    func start() -> UIViewController {
        let habitsCoordinator = makeHabitsCoordinator()
        addChildCoordinator(habitsCoordinator)
        let infoCoordinator = makeInfoCoordinator()
        addChildCoordinator(infoCoordinator)

        setupTabBarController(viewControllers: [habitsCoordinator.start(), infoCoordinator.start()])
        return self.tabBarController
    }

}
