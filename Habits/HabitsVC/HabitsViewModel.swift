//
//  HabitsViewModel.swift
//  Habits
//
//  Created by Roman Vakulenko on 17.08.2023.
//

import UIKit

final class HabitsViewModel {

    // MARK: - Enum
    enum State { ///мин для работы с сетью, но может быть больше состояний
        case none
        case loading
        case loaded
        case reloadItems(at: [IndexPath])
        case wrong(errorDescription: String)
    }

    // MARK: - Public properties
    var habitsModel: [Habit] = []
    var trackModel: [Date] = HabitsStore.shared.dates
    ///благодаря клоужеру мы bindимся (в связи - bind вся суть MVVM )
    var closureChangeState: ((State) -> Void)?

    // MARK: - Private properties
    private weak var coordinator: HabitsCoordinator?

    private var state: State = .none {
        didSet {
            closureChangeState?(state)
        }
    }

    // MARK: - Init
    init(coordinator: HabitsCoordinator?) {
        self.coordinator = coordinator
    }

    // MARK: - Public methods
    func requestHabits() {
        state = .loading
        mockNetworkAPI { habits in
            self.habitsModel = habits
            self.state = .loaded
        }
    }

    func didTapCell(at indexPath: IndexPath) {
        let model = trackModel[indexPath.item] //если бы даты не сохранялись бы в UserDefaults, то откуда бы мы тогда брали бы модель? Тоже из сети?
        coordinator?.pushTrackVC(model: model) //в TrackVC var model: Date
    }


    // MARK: - Private methods
    private func mockNetworkAPI(completion: @escaping([Habit]) -> Void) {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + .seconds(1)) {
            let model = HabitsStore.shared.habits
            completion(model)
        }
    }
}
