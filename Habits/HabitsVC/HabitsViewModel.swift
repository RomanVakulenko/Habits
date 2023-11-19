//
//  HabitsViewModel.swift
//  Habits
//
//  Created by Roman Vakulenko on 17.08.2023.
//

import UIKit

final class HabitsViewModel {

    // MARK: - Enum
    enum State {
        case none
        case loading
        case loaded
        case reloadEditedHabit(at: [IndexPath])
        case createHabitAndReloadCollection
        case deleteHabitAndReloadCollection
        case wrong(errorDescription: String) //не юзал
    }

    // MARK: - Public properties
    private(set) var habitsModel: [Habit] = []

    var trackModel: [Date] = HabitsStore.shared.dates

    var closureChangeState: ((State) -> Void)?

    // MARK: - Private properties
    private weak var habitsCoordinator: HabitsCoordinatorProtocol?

    private var state: State = .none {
        didSet {
            closureChangeState?(state)
        }
    }

    // MARK: - Init
    init(coordinator: HabitsCoordinatorProtocol) {
        self.habitsCoordinator = coordinator
    }

    // MARK: - Public methods
    func loadHabits() {
        state = .loading
        mockNetworkRequest { habits in
            self.habitsModel = habits
            self.state = .loaded
        }
    }

    func didTapAddHabit() {
        habitsCoordinator?.pushAddNewHabitVC(habitVCState: .create, delegate: self)
    }

    func didTapHabitCell(at indexPath: IndexPath) {
        let tappedHabit = habitsModel[indexPath.item]
        habitsCoordinator?.pushTrackVCWith(model: tappedHabit, delegate: self, indexPath: indexPath)
    }


    // MARK: - Private methods
    private func mockNetworkRequest(completion: @escaping([Habit]) -> Void) {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + .seconds(1)) {
            let model = HabitsStore.shared.habits
            completion(model)
        }
    }
}


// MARK: - ExtensionDelegate
extension HabitsViewModel: AddHabitDelegate {
    // происходит в момент нажатия Save в AddOrEditHabitVC
    func reloadData() {
        habitsModel = HabitsStore.shared.habits
        print("number of viewModel.habitsModel - \(HabitsStore.shared.habits.count)")
        state = .createHabitAndReloadCollection
    }
}


extension HabitsViewModel: EditHabitDelegate {
    // происходит в момент нажатия Save в AddOrEditHabitVC
    func reloadEditedHabitOrDeleteAt(_ indexPath: IndexPath, dueTo tappedButton: HabitVCState) {
        habitsModel = HabitsStore.shared.habits

        if tappedButton == .edit {
            state = .reloadEditedHabit(at: [indexPath])
        } else if tappedButton == .delete {
            state = .deleteHabitAndReloadCollection
        }
    }
}
