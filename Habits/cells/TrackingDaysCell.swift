//
//  TrackingDaysCell.swift
//  Habits
//
//  Created by Roman Vakulenko on 28.07.2023.
//

import UIKit

final class TrackingDaysCell: UITableViewCell {

//    let store = HabitsStore.shared
//    private let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
//    private let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date())

    private lazy var dateLabelView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Regular", size: 17)
        label.textColor = .black
        label.backgroundColor = .white
        return label
    }()

    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        dateLabelView.text = nil
    }

    //MARK: - private
    private func layout() {
        contentView.addSubview(dateLabelView)

        NSLayoutConstraint.activate([
            dateLabelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabelView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLabelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    func setupAndShowIsTracked(from dates: [Date], at tableIndexPath: IndexPath) {
        var fallingDates = [Date]() //или dates.reversed().map { $0 }
        for date in dates {
            fallingDates.insert(date, at: 0)
        }
        
        if tableIndexPath.row == 0 {
            dateLabelView.text = "Сегодня"
        } else if tableIndexPath.row == 1 {
            dateLabelView.text = "Вчера"
        } else if tableIndexPath.row == 2 {
            dateLabelView.text = "Позавчера"
        } else if tableIndexPath.row > 2 && tableIndexPath.row < dates.count - 1 { //count считает с 1, а не с 0, так мы пропускаем первые 3 строки с подписями текстом и выводим форматированные даты в строковом виде
            dateLabelView.text = Format.dateForDoneHabit.string(from: fallingDates[tableIndexPath.row])
        } else if tableIndexPath.row == dates.count - 1 {
            dateLabelView.text = Format.dateForDoneHabit.string(from: (fallingDates.last ?? Date()) - 1)
        }
    }
}
