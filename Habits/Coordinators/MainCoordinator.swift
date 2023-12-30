//
//  MainCoordinator.swift
//  Habits
//
//  Created by Roman Vakulenko on 17.08.2023.
//

import UIKit

//protocol MainCoordinatorProtocol: CoordinatorProtocol { // нужно если мы имеем логин флоу
//    func switchFlow()
//}

final class MainCoordinator {

    // MARK: - Private properties
    private var childCoordinators: [CoordinatorProtocol] = []

    
    // MARK: - Private methods
    private func makeTabBarCoordinator() -> CoordinatorProtocol {
        let tabBarCoordinator = TabBarCoordinator(
            tabBarController: UITabBarController()
//            parentCoordinator: self // нужно если мы имеем логин флоу
        )
        return tabBarCoordinator
    }

    private func addChildCoordinator(_ coordinator: CoordinatorProtocol) {
        guard !childCoordinators.contains(where: { $0 === coordinator })  else { return }
        childCoordinators.append(coordinator)
    }
    
// нужно если мы имеем логин флоу
//    private func removeChildCoordinator(_ coordinator: CoordinatorProtocol) {  removeChildCoordinator ?
//        childCoordinators.removeAll(where: { $0 === coordinator })
//    }

}

// MARK: - Extensions
extension MainCoordinator: CoordinatorProtocol {

    func start() -> UIViewController {
        let tabBarCoordinator = makeTabBarCoordinator()
        addChildCoordinator(tabBarCoordinator)
        return tabBarCoordinator.start()
    }
}

// нужно если мы имеем логин флоу
//extension MainCoordinator: MainCoordinatorProtocol {
//    func switchFlow() {
//        ()
//    }
//}
