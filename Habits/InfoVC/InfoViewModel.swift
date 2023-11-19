//
//  TrackViewModel.swift
//  Habits
//
//  Created by Roman Vakulenko on 17.08.2023.
//

import UIKit

final class InfoViewModel {

    // MARK: - Private properties
    private var infoModel: [String] = []
    private weak var coordinator: CoordinatorProtocol?

    // MARK: - init
    init(coordinator: CoordinatorProtocol) {
        self.coordinator = coordinator
    }
}
