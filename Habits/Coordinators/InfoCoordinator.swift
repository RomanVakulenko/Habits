//
//  InfoCoordinator.swift
//  Habits
//
//  Created by Roman Vakulenko on 17.08.2023.
//

import UIKit

final class InfoCoordinator {

    // MARK: - Private properties
    private var navigationController: UINavigationController

    private weak var parentCoordinator: TabBarCoordinator?


    // MARK: - Init
    init(navigationController: UINavigationController, parentCoordinator: TabBarCoordinator) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }

    // MARK: - Private methods
    private func makeInfoVC() -> UIViewController {
        let viewModel = InfoViewModel(coordinator: self)
        let infoVC = InfoViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: infoVC)
        navigationController = navController
        return navigationController
    }

}

extension InfoCoordinator: CoordinatorProtocol {
    func start() -> UIViewController {
        let infoVC = makeInfoVC()
        return infoVC
    }


}

