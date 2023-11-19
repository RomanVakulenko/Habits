//
//  Format.swift
//  Habits
//
//  Created by Roman Vakulenko on 17.11.2023.
//

import Foundation

enum Format {

    static var timeForHabitRepeats: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        formatter.timeStyle = .short //15:30
        return formatter
    }

    static var dateForDoneHabit: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        formatter.timeStyle = .none
        formatter.dateFormat = "dd MMMM yyyy" // 13 ноября 2023

        return formatter
    }

}
