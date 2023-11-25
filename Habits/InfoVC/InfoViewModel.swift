//
//  TrackViewModel.swift
//  Habits
//
//  Created by Roman Vakulenko on 17.08.2023.
//

import UIKit

final class InfoViewModel {

    // MARK: - Private properties
    private weak var coordinator: InfoCoordinatorProtocol?

    // MARK: - init
    init(coordinator: InfoCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    // MARK: - Public methods
    func didTapInfoSourceVC() {
        coordinator?.pushInfoSourceVC()
    }
}
