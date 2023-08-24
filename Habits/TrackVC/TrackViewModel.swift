//
//  TrackViewModel.swift
//  Habits
//
//  Created by Roman Vakulenko on 23.08.2023.
//

import Foundation
import UIKit

final class TrackViewModel {

    // MARK: - Enum
    enum State {
        case none
        case didGetDates
    }

    // MARK: - Public properties
    private(set) var trackModel: [Date] = []
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
    func getDates() {
        trackModel = HabitsStore.shared.dates
        state = .didGetDates
    }

}
