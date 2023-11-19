//
//  HabitsCoordinator.swift
//  Habits
//
//  Created by Roman Vakulenko on 17.08.2023.
//

import UIKit

protocol HabitsCoordinatorProtocol: AnyObject {
    func pushAddNewHabitVC(habitVCState: HabitVCState, delegate: AddHabitDelegate)
    func pushTrackVCWith(model: Habit,  delegate: EditHabitDelegate, indexPath: IndexPath)
    func pushEditVC(habitForEdit: Habit, habitState: HabitVCState, delegate: EditHabitDelegate, indexPath: IndexPath)
    func popToRootVC()
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


    private func makeAddNewHabitVC(addDelegate: AddHabitDelegate, habitState: HabitVCState) -> UIViewController {
        let viewModel = AddOrEditViewModel(coordinator: self, addDelegate: addDelegate)
        let addVC = AddOrEditHabitVC(viewModel: viewModel, habitState: habitState)
        return addVC
    }


    private func makeTrackVC(habitModel: Habit, editDelegate: EditHabitDelegate, indexPath: IndexPath) -> UIViewController {
        let viewModel = TrackViewModel(
            coordinator: self,
            delegate: editDelegate,
            existingModel: habitModel,
            indexPath: indexPath
        )
        let trackVC = TrackHabitViewController(viewModel: viewModel)
        trackVC.title = HabitsStore.shared.habits[indexPath.row].name
        return trackVC
    }


    private func makeEditVC(modelForEdit: Habit, habitState: HabitVCState, editDelegate: EditHabitDelegate, indexPath: IndexPath) -> UIViewController {
        let viewModel = AddOrEditViewModel(
            coordinator: self,
            existingModel: modelForEdit,
            delegate: editDelegate,
            indexPath: indexPath
        )
        let editVC = AddOrEditHabitVC(viewModel: viewModel, habitState: habitState)
        return editVC
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

    func pushAddNewHabitVC(habitVCState: HabitVCState, delegate: AddHabitDelegate) {
        let vc = makeAddNewHabitVC(addDelegate: delegate, habitState: habitVCState)
        navigationController.pushViewController(vc, animated: true)
    }


    func pushTrackVCWith(model: Habit, delegate: EditHabitDelegate, indexPath: IndexPath) {
        let vc = makeTrackVC(habitModel: model, editDelegate: delegate, indexPath: indexPath)
        navigationController.pushViewController(vc, animated: true)
    }


    func pushEditVC(habitForEdit: Habit, habitState habitVCState: HabitVCState, delegate: EditHabitDelegate, indexPath: IndexPath) {
        let vc = makeEditVC(
            modelForEdit: habitForEdit, habitState: habitVCState,
            editDelegate: delegate,
            indexPath: indexPath
        )
        navigationController.pushViewController(vc, animated: true)
    }

    func popToRootVC() {
        navigationController.popToRootViewController(animated: true)
    }
}


