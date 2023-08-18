//
//  HabitsCoordinator.swift
//  Habits
//
//  Created by Roman Vakulenko on 17.08.2023.
//

import UIKit

final class HabitsCoordinator {

    // MARK: - Private properties
    private var navigationController: UINavigationController

    private weak var parentCoordinator: TabBarCoordinator?

    // MARK: - Init
    init(navigationController: UINavigationController, parentCoordinator: TabBarCoordinator) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }

    // MARK: - Private methods

    private func makeHabitsVC() -> UIViewController {
        let viewModel = HabitsViewModel(coordinator: self)
        let habitsVC =  HabitsViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: habitsVC)
        navigationController = navController
        return navigationController
    }

    private func makeTrackVC(model: Date) -> UIViewController {
        let viewModel = ...
        let trackVC = TrackHabitViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: trackVC)
        navigationController = navController
        return navigationController
    }
}

extension HabitsCoordinator: CoordinatorProtocol {

    func start() -> UIViewController {
        let habitVC = makeHabitsVC()
        return habitVC
    }

    func pushTrackVC(model: Date) {
        let vc = makeTrackVC(model: model)
        navigationController.pushViewController(vc, animated: true)

    }


}
