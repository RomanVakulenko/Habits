//
//  HabitCollectionViewCell.swift
//  Habits
//
//  Created by Roman Vakulenko on 21.07.2023.
//

import UIKit

final class HabitCollectionViewCell: UICollectionViewCell {

    private var habit: Habit!
    private var stateBntTapClosure: (() -> Void)! //чтобы мы могли снаружи перезагружать табличку

    private let habitView: UIView = {
        let whiteView = UIView()
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 8
        return whiteView
    }()

    private let nameOfHabit: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blue
        label.text = ""
        label.numberOfLines = 2
        label.font = UIFont(name: "SFProText-Semibold", size: 17)
        return label
    }()

    private let everyDayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray2
        label.font = UIFont(name: "SFProText-Regular", size: 12)
        return label
    }()

    private let timeOfHabit: UILabel = {
        let time = UILabel()
        time.translatesAutoresizingMaskIntoConstraints = false
        time.textColor = .systemGray2
        time.text = ""
        time.font = UIFont(name: "SFProText-Regular", size: 12)
        return time
    }()

    private let counterOfHabit: UILabel = {
        let counterName = UILabel()
        counterName.translatesAutoresizingMaskIntoConstraints = false
        counterName.textColor = .systemGray
        counterName.text = "Счётчик: "
        counterName.font = UIFont(name: "SFProText-Semibold", size: 13)
        return counterName
    }()

    private let amountOfRepeats: UILabel = {
        let digit = UILabel()
        digit.translatesAutoresizingMaskIntoConstraints = false
        digit.textColor = .systemGray
        digit.text = "0"
        digit.font = UIFont(name: "SFProText-Semibold", size: 13)
        return digit
    }()

    private lazy var checkButtonButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        let large = UIImage.SymbolConfiguration(scale: .large)
        button.setImage(UIImage(systemName: "circle", withConfiguration: large), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = .none
        button.addTarget(target, action: #selector(checkMarkTapped(_:)), for: .touchUpInside)
        return button
    }()

    private let checkedButton = UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate) //позволяет создать шаблонное изображение, которое может быть затемнено или окрашено в другой цвет, используя эту картинку
    private let uncheckedButton = UIImage(systemName: "circle")?.withRenderingMode(.alwaysTemplate)

// MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - setup

    func setup(habit: Habit, closure: @escaping () -> Void){
        self.habit = habit
        self.stateBntTapClosure = closure

        nameOfHabit.text = habit.name
        nameOfHabit.textColor = habit.color
        timeOfHabit.text = habit.dateString
        amountOfRepeats.text = String(habit.trackDates.count)

        if habit.isAlreadyTakenToday {
            checkButtonButton.setImage(checkedButton, for: .normal)
        } else {
            checkButtonButton.setImage(uncheckedButton, for: .normal)
        }
        checkButtonButton.tintColor = habit.color
    }

    override func prepareForReuse() {
        nameOfHabit.text = nil
        nameOfHabit.textColor = nil
        timeOfHabit.text = nil
        amountOfRepeats.text = nil
//        checkButtonButton.imageView?.image = nil
    }

//MARK: - private methods

    private func layout() {
        [nameOfHabit, everyDayLabel, timeOfHabit, counterOfHabit, amountOfRepeats, checkButtonButton].forEach { habitView.addSubview($0) }
        contentView.addSubview(habitView)

        NSLayoutConstraint.activate([
            habitView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            habitView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            habitView.topAnchor.constraint(equalTo: contentView.topAnchor),
            habitView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            nameOfHabit.leadingAnchor.constraint(equalTo: habitView.leadingAnchor, constant: 20),
            nameOfHabit.trailingAnchor.constraint(equalTo: habitView.trailingAnchor, constant: -(25*2+38)),
            nameOfHabit.topAnchor.constraint(equalTo: habitView.topAnchor, constant: 20),
            nameOfHabit.bottomAnchor.constraint(equalTo: habitView.bottomAnchor, constant: -88),

            everyDayLabel.leadingAnchor.constraint(equalTo: nameOfHabit.leadingAnchor),
            everyDayLabel.topAnchor.constraint(equalTo: nameOfHabit.bottomAnchor, constant: 4),

            timeOfHabit.leadingAnchor.constraint(equalTo: everyDayLabel.trailingAnchor),
            timeOfHabit.topAnchor.constraint(equalTo: nameOfHabit.bottomAnchor, constant: 4),

            counterOfHabit.leadingAnchor.constraint(equalTo: habitView.leadingAnchor, constant: 20),
            counterOfHabit.bottomAnchor.constraint(equalTo: habitView.bottomAnchor, constant: -20),

            amountOfRepeats.leadingAnchor.constraint(equalTo: counterOfHabit.trailingAnchor),
            amountOfRepeats.bottomAnchor.constraint(equalTo: habitView.bottomAnchor, constant: -20),

            checkButtonButton.trailingAnchor.constraint(equalTo: habitView.trailingAnchor, constant: -25),
            checkButtonButton.widthAnchor.constraint(equalToConstant: 38),
            checkButtonButton.heightAnchor.constraint(equalToConstant: 38),
            checkButtonButton.centerYAnchor.constraint(equalTo: habitView.centerYAnchor)

        ])
    }

    @objc func checkMarkTapped(_ sender: UIButton) {
        if habit.isAlreadyTakenToday == false {
            checkButtonButton.setImage(checkedButton, for: .normal)
            HabitsStore.shared.track(habit)
            self.stateBntTapClosure()
        }
    }

}
