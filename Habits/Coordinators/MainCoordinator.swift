//
//  MainCoordinator.swift
//  Habits
//
//  Created by Roman Vakulenko on 17.08.2023.
//

import UIKit

protocol MainCoordinatorProtocol: CoordinatorProtocol {
}

final class MainCoordinator {

    // MARK: - Private properties
    private var childCoordinators: [CoordinatorProtocol] = []

    
    // MARK: - Private methods
    private func makeTabBarCoordinator() -> CoordinatorProtocol {
        let tabBarCoordinator = TabBarCoordinator(
            tabBarController: UITabBarController(),
            parentCoordinator: self
        )
        return tabBarCoordinator
    }

    private func addChildCoordinator(_ coordinator: CoordinatorProtocol) {
        guard !childCoordinators.contains(where: { $0 === coordinator })  else { return }
        childCoordinators.append(coordinator)
    }

    private func removeChildCoordinator(_ coordinator: CoordinatorProtocol) { //зачем в MainCoordinator метод removeChildCoordinator ?
        childCoordinators.removeAll(where: { $0 === coordinator })
    }

}

// MARK: - Extensions
extension MainCoordinator: CoordinatorProtocol {

    func start() -> UIViewController {
        let tabBarCoordinator = makeTabBarCoordinator()
        addChildCoordinator(tabBarCoordinator)
        return tabBarCoordinator.start()
    }
}
