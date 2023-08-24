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
        let habitsNavController = UINavigationController(rootViewController: habitsVC)
        navigationController = habitsNavController
        navigationController.title = "Сегодня"
        navigationController.navigationBar.backgroundColor = UIColor(named: "dBackground")
        return navigationController
    }

    private func makeTrackVC(model: Date, delegate: AddOrEditHabitDelegate, indexPath: IndexPath) -> UIViewController {
        let viewModel = TrackViewModel(coordinator: self)
        let trackVC = TrackHabitViewController(viewModel: viewModel)
        trackVC.title = HabitsStore.shared.habits[indexPath.row].name
        return trackVC
    }

    private func makeAddOrEditVC(model: Habit, delegate: AddOrEditHabitDelegate, indexPath: IndexPath) -> UIViewController {
        let viewModel = AddOrEditViewModel(
            coordinator: self,
            model: model,
            delegate: delegate,
            indexPath: indexPath
        )
        let addOrEditVC = AddOrEditHabitVC(viewModel: viewModel)
        return addOrEditVC
    }
}

extension HabitsCoordinator: CoordinatorProtocol {

    func start() -> UIViewController {
        let habitVC = makeHabitsVC()
        return habitVC
    }

    func pushTrackVC(model: Date, delegate: AddOrEditHabitDelegate, indexPath: IndexPath) {
        let vc = makeTrackVC(
            model: model,
            delegate: delegate,
            indexPath: indexPath
        )
        navigationController.pushViewController(vc, animated: true)
    }

    func pushAddOrEditVC(model: Habit, delegate: AddOrEditHabitDelegate, indexPath: IndexPath) {
        let vc = makeAddOrEditVC(
            model: model,
            delegate: delegate,
            indexPath: indexPath
        )
        navigationController.pushViewController(vc, animated: true)
    }

}
