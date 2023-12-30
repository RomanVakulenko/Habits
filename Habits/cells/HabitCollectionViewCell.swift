//
//  HabitCollectionViewCell.swift
//  Habits
//
//  Created by Roman Vakulenko on 21.07.2023.
//

import UIKit

final class HabitCollectionViewCell: UICollectionViewCell {

    private var habit: Habit!
    private var checkMarkBtnStateClosure: (() -> Void)! //0. cоздали, чтобы обновлять табличку и показывать check тут же

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

    private let timeToPracticeHabit: UILabel = {
        let time = UILabel()
        time.translatesAutoresizingMaskIntoConstraints = false
        time.textColor = .systemGray2
        time.text = ""
        time.font = UIFont(name: "SFProText-Regular", size: 12)
        return time
    }()

    private let counterLabel: UILabel = {
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

    private lazy var checkMarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.init(systemName: "circle"))
        imageView.backgroundColor = .none
        imageView.layer.cornerRadius = 19
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

//вариант создания кнопки
//    private let checkedButton = UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate) //позволяет создать шаблонное изображение, которое может быть затемнено или окрашено в другой цвет, используя эту картинку
//    private let uncheckedButton = UIImage(systemName: "circle")?.withRenderingMode(.alwaysTemplate)

// MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        setTapGestureAtCheckMark()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - setup
    private func setTapGestureAtCheckMark(){
        let tapToCheckMark = UITapGestureRecognizer(target: self, action: #selector(checkMarkTapped(_:)))
        checkMarkImageView.addGestureRecognizer(tapToCheckMark)
    }

    func setup(habit: Habit, completion: @escaping () -> Void){
        self.habit = habit
        self.checkMarkBtnStateClosure = completion //1. в closure сохраним сбегающее замыкание, будет вызвано когда-то после работы самого метода setup.

        nameOfHabit.text = habit.name
        nameOfHabit.textColor = habit.color
        timeToPracticeHabit.text = habit.dateString
        amountOfRepeats.text = String(habit.trackDates.count)

        if habit.isAlreadyTakenToday {
//            checkMarkButton.setImage(checkedButton, for: .normal)
            checkMarkImageView.image = UIImage.init(systemName: "checkmark.circle.fill")
        } else {
//            checkMarkButton.setImage(uncheckedButton, for: .normal)
            checkMarkImageView.image = UIImage.init(systemName: "circle")
        }
        checkMarkImageView.tintColor = habit.color
    }

//MARK: - private methods

    private func layout() {
        [nameOfHabit, everyDayLabel, timeToPracticeHabit, counterLabel, amountOfRepeats, checkMarkImageView].forEach { habitView.addSubview($0) }
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

            timeToPracticeHabit.leadingAnchor.constraint(equalTo: everyDayLabel.trailingAnchor),
            timeToPracticeHabit.topAnchor.constraint(equalTo: nameOfHabit.bottomAnchor, constant: 4),

            counterLabel.leadingAnchor.constraint(equalTo: habitView.leadingAnchor, constant: 20),
            counterLabel.bottomAnchor.constraint(equalTo: habitView.bottomAnchor, constant: -20),

            amountOfRepeats.leadingAnchor.constraint(equalTo: counterLabel.trailingAnchor),
            amountOfRepeats.bottomAnchor.constraint(equalTo: habitView.bottomAnchor, constant: -20),

            checkMarkImageView.trailingAnchor.constraint(equalTo: habitView.trailingAnchor, constant: -25),
            checkMarkImageView.heightAnchor.constraint(equalToConstant: 38),
            checkMarkImageView.widthAnchor.constraint(equalToConstant: 38),
            checkMarkImageView.bottomAnchor.constraint(equalTo: habitView.bottomAnchor, constant: -46),
        ])
    }

    @objc func checkMarkTapped(_ sender: UIButton) {
        if habit.isAlreadyTakenToday == false {
            HabitsStore.shared.track(habit)
            self.checkMarkBtnStateClosure() //2. вызываем клоужер - и в этот момент он обновляет конкретную ячейку
        }
    }

}
