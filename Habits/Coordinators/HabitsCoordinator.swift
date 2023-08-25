//
//  HabitsCoordinator.swift
//  Habits
//
//  Created by Roman Vakulenko on 17.08.2023.
//

import UIKit

protocol HabitsCoordinatorProtocol: AnyObject {
    func pushTrackVC(model: Date, delegate: AddOrEditHabitDelegate, indexPath: IndexPath)
    func pushAddOrEditVC(model: Habit, delegate: AddOrEditHabitDelegate, indexPath: IndexPath)
}

final class HabitsCoordinator {

    // MARK: - Private properties
    private var navigationController: UINavigationController

    //    private weak var parentCoordinator: TabBarCoordinator? // нужно если мы имеем логин флоу

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        //        self.parentCoordinator = parentCoordinator // нужно если мы имеем логин флоу
    }

    // MARK: - Private methods

    private func makeHabitsVC() -> UIViewController {
        let viewModel = HabitsViewModel(coordinator: self)
        let habitsVC =  HabitsViewController(viewModel: viewModel)
        let habitsNavController = UINavigationController(rootViewController: habitsVC)
        navigationController = habitsNavController
        
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

// MARK: - CoordinatorProtocol
extension HabitsCoordinator: CoordinatorProtocol {

    func start() -> UIViewController {
        let habitVC = makeHabitsVC()
        return habitVC
    }
}


// MARK: - HabitsCoordinatorProtocol
extension HabitsCoordinator: HabitsCoordinatorProtocol {
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


