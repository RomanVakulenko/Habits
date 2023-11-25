//
//  SourceVCModel.swift
//  Habits
//
//  Created by Roman Vakulenko on 24.11.2023.
//

import Foundation

final class SourceVCModel {

    private let coordinator: InfoCoordinatorProtocol?

    init(coordinator: InfoCoordinatorProtocol) {
        self.coordinator = coordinator
    }

}
