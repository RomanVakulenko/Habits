//
//  TrackViewModel.swift
//  Habits
//
//  Created by Roman Vakulenko on 17.08.2023.
//

import UIKit

final class InfoViewModel {

    // MARK: - Enum
    enum InfoState {
        case none
    }

    // MARK: - Public properties
    var closureChangeState: ((InfoState) -> Void)?

    // MARK: - Private properties
    private var infoModel: [String] = []

    private weak var coordinator: CoordinatorProtocol?

    private var infoState: InfoState = .none {
        didSet {
            closureChangeState?(infoState)
        }
    }

    // MARK: - Init
    init(coordinator: CoordinatorProtocol?) {
        self.coordinator = coordinator
    }

    // MARK: - Private methods
    private func didTapTabBar() {
        
    }
}
