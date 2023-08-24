//
//  AddOrEditViewModel.swift
//  Habits
//
//  Created by Roman Vakulenko on 23.08.2023.
//

import Foundation
import UIKit


protocol AddOrEditHabitDelegate: AnyObject {
    func passAddOrEdit(habitName: String, color: UIColor, time: Date, at indexPath: IndexPath)
}


final class AddOrEditViewModel {

    // MARK: - Enum
    enum State {
        case none
        case add
        case edit
    }


    // MARK: - Public properties
    private(set) var habitModel: Habit

    var closureChangeState: ((State) -> Void)?

    // MARK: - Private properties
    private weak var coordinator: HabitsCoordinator?

    private weak var dataDelegate: AddOrEditHabitDelegate?

    private var currentIndexPath: IndexPath

    private var state: State = .none {
        didSet{
            closureChangeState?(state)
        }
    }

    // MARK: - Init
    init(coordinator: HabitsCoordinator?, model: Habit, delegate: AddOrEditHabitDelegate?, indexPath: IndexPath) {
        self.coordinator = coordinator
        self.habitModel = model
        self.dataDelegate = delegate
        self.currentIndexPath = indexPath
    }

    

    // MARK: - Public methods
    func getHabitIfEdit(at indexPath: IndexPath) {
        habitModel = HabitsStore.shared.habits[indexPath.item]
    }

    func didTapSave() {
        dataDelegate?.passAddOrEdit(
            habitName: habitModel.name,
            color: habitModel.color,
            time: habitModel.date,
            at: currentIndexPath
        )
    }




    // MARK: - Private methods






}
