//
//  AddOrEditViewModel.swift
//  Habits
//
//  Created by Roman Vakulenko on 23.08.2023.
//

import Foundation
import UIKit


protocol AddHabitDelegate: AnyObject {
    func reloadData()
}

protocol EditHabitDelegate: AnyObject {
    func reloadEditedHabitOrDeleteAt(_ indexPath: IndexPath, dueTo tappedButton: HabitVCState)
}


final class AddOrEditViewModel {

    // MARK: - Public properties
    private(set) var habitModel: Habit?

    // MARK: - Private properties
    private weak var coordinator: HabitsCoordinatorProtocol?

    private weak var addHabitDelegate: AddHabitDelegate?
    private weak var editHabitDelegate: EditHabitDelegate?

    private var currentIndexPath: IndexPath? 

    // MARK: - Init
    init(coordinator: HabitsCoordinatorProtocol, existingModel: Habit, delegate: EditHabitDelegate, indexPath: IndexPath) {
        self.coordinator = coordinator
        self.habitModel = existingModel
        self.editHabitDelegate = delegate
        self.currentIndexPath = indexPath
    }

    init(coordinator: HabitsCoordinatorProtocol, addDelegate: AddHabitDelegate) {
        self.coordinator = coordinator
        self.addHabitDelegate = addDelegate
    }
    

    // MARK: - Public methods

    func didTapSaveOrCancelOrDelete(tapped state: HabitVCState) {

        if let indexPath = currentIndexPath {
            switch state {
            case .edit:
                editHabitDelegate?.reloadEditedHabitOrDeleteAt(indexPath, dueTo: .edit)
            case .delete:
                editHabitDelegate?.reloadEditedHabitOrDeleteAt(indexPath, dueTo: .delete)
            default: break
            }
        } else if state == .create {
            addHabitDelegate?.reloadData()
        }

        coordinator?.popToRootVC()
    }

}
