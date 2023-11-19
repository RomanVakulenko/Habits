//
//  TrackViewModel.swift
//  Habits
//
//  Created by Roman Vakulenko on 23.08.2023.
//

import Foundation
import UIKit

final class TrackViewModel {

    enum State {
        case none
        case didGetDates
    }

    // MARK: - Public properties
    private(set) var tappedHabit: Habit?
    private(set) var datesFromFirstLaunch: [Date] = []
    var currentIndexPath: IndexPath?
    
    ///благодаря клоужеру мы bindимся со VC
    var closureChangeState: ((State) -> Void)?
    

    // MARK: - Private properties
    private weak var coordinator: HabitsCoordinatorProtocol?
    private weak var editDelegate: EditHabitDelegate?

    private var state: State = .none {
        didSet {
            closureChangeState?(state)
        }
    }

    // MARK: - Init
    init(coordinator: HabitsCoordinatorProtocol, delegate: EditHabitDelegate, existingModel: Habit, indexPath: IndexPath) {
        self.coordinator = coordinator
        self.editDelegate = delegate
        self.tappedHabit = existingModel
        self.currentIndexPath = indexPath
    }


    // MARK: - Public methods
    func getDates() {
        datesFromFirstLaunch = HabitsStore.shared.dates
        state = .didGetDates
    }

    func didTapEditHabit() {
        if let tappedHabit,
           let delegate = editDelegate,
           let tappedHabitIndexPath = currentIndexPath {
            coordinator?.pushEditVC(
                habitForEdit: tappedHabit,
                habitState: .edit,
                delegate: delegate, //habitVM
                indexPath: tappedHabitIndexPath
            )
        }
    }

}

