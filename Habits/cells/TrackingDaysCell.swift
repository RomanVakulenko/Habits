//
//  TrackingDaysCell.swift
//  Habits
//
//  Created by Roman Vakulenko on 28.07.2023.
//

import UIKit

final class TrackingDaysCell: UITableViewCell {

    let store = HabitsStore.shared
    private let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
    private let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date())

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
//
//    func setupYesterday(){
//        dateLabelView.text = "Вчера"
//    }
//
//    func setupTwoDaysAgo(){
//        dateLabelView.text = "Позавчера"
//    }

    func setup (from dates: [Date], at index: IndexPath) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeZone = .autoupdatingCurrent
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.dateFormat = "dd MMMM yyyy"

        var fallingDates = [Date]() //dates.reversed().map { $0 } //развернутый массив дат
        for i in dates {
            fallingDates.insert(i, at: 0)
        }
        print(fallingDates)
        if index.row == 0 {
            dateLabelView.text = "Вчера"
        } else if index.row == 1 {
            dateLabelView.text = "Позавчера"
        } else if index.row > 1 && index.row < dates.count - 1 { //count считает с 1, не с 0 (-1 дает и < дают на 2 строки меньше, которые у нас как раз заняты "вчера" и "позавчера"
            dateLabelView.text = formatter.string(from: fallingDates[index.row + 1]) //ПОЧЕМУ в девятую строку(индек 8) тейблВью не выводится 19 июля 2023, а почему выводится 20 июля 2023, хотя fallingDates[8 + 1] == 19 июля 2023 ??? почему?
        } else if index.row == dates.count - 1 {
            dateLabelView.text = formatter.string(from: (fallingDates.last ?? Date()) - 1)
        }
    }
}
