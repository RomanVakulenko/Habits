//
//  InfoCoordinator.swift
//  Habits
//
//  Created by Roman Vakulenko on 17.08.2023.
//

import UIKit

protocol InfoCoordinatorProtocol: AnyObject {
    func pushInfoSourceVC()
}

final class InfoCoordinator {

    // MARK: - Private properties
    private var navigationController: UINavigationController
//    private weak var parentCoordinator: TabBarCoordinator? // нужно если мы имеем логин флоу


    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
//        self.parentCoordinator = parentCoordinator //нужно если мы имеем логин флоу
    }

    // MARK: - Private methods
    private func makeInfoVC() -> UIViewController {
        let viewModel = InfoViewModel(coordinator: self)
        let infoVC = InfoViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: infoVC)
        navigationController = navController
        return navigationController
    }

    private func makeInfoSourceVC() -> UIViewController {
        let viewModel = SourceVCModel(coordinator: self)
        let infoSourceVC = SourceOfDescriptionVC(viewModel: viewModel)
        return infoSourceVC
    }
}

// MARK: - CoordinatorProtocol
extension InfoCoordinator: CoordinatorProtocol {
    func start() -> UIViewController {
        let infoVC = makeInfoVC()
        return infoVC
    }
}
//MARK: - InfoCoordinatorProtocol
extension InfoCoordinator: InfoCoordinatorProtocol {

    func pushInfoSourceVC() {
        let vc = makeInfoSourceVC()
        navigationController.pushViewController(vc, animated: true)
    }
}

