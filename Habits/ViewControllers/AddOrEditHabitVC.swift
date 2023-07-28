//
//  AddOrEditHabitVC.swift
//  Habits
//
//  Created by Roman Vakulenko on 30.06.2023.
//

import UIKit

enum HabitVCState {
    case create, edit
}

final class AddOrEditHabitVC: UIViewController {
    
    private var habit: Habit?
    private var habitState = HabitVCState.create

    private var currentTitle = ""
    private var currentColor = UIColor.orange
    private var currentDate = Date()

    private let baseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "dBackground")
        return view
    }()

    private let nameTitleHabit: UILabel = {
        let nameTitle = UILabel()
        nameTitle.translatesAutoresizingMaskIntoConstraints = false
        nameTitle.font = UIFont(name: "SFProText-Semibold", size: 13)
        nameTitle.textColor = .black
        nameTitle.text = "НАЗВАНИЕ"
        return nameTitle
    }()

    private let textTitleHabit: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont(name: "SFProText-Regular", size: 17)
        text.textColor = .black
        text.placeholder = "Приседать в перерывах; Гимнастика глаз и т.п."
        return text
    }()

    private let colorTitleHabit: UILabel = {
        let color = UILabel()
        color.translatesAutoresizingMaskIntoConstraints = false
        color.font = UIFont(name: "SFProText-Semibold", size: 13)
        color.textColor = .black
        color.text = "ЦВЕТ"
        return color
    }()

    private lazy var pickerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        let large = UIImage.SymbolConfiguration(scale: .large)
        button.setImage(UIImage(systemName: "circle.fill", withConfiguration: large), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = .none
        button.addTarget(self, action: #selector(pickColor(_:)), for: .touchUpInside)
        return button
    }()

    private let timeTitleHabit: UILabel = {
        let time = UILabel()
        time.translatesAutoresizingMaskIntoConstraints = false
        time.font = UIFont(name: "SFProText-Semibold", size: 13)
        time.textColor = .black
        time.text = "ВРЕМЯ"
        return time
    }()

    private let preTimeTextHabit: UILabel = {
        let timeSet = UILabel()
        timeSet.translatesAutoresizingMaskIntoConstraints = false
        timeSet.font = UIFont(name: "SFProText-Regular", size: 17)
        timeSet.textColor = .black
        timeSet.text = "Каждый день в "
        return timeSet
    }()

    private let pickedHabitTime: UILabel = {
        let pickedTime = UILabel()
        pickedTime.translatesAutoresizingMaskIntoConstraints = false
        pickedTime.font = UIFont(name: "SFProText-Regular", size: 17)
        pickedTime.textColor = UIColor(named: "dPurple")
        pickedTime.text = ""
        return pickedTime
    }()

//    private lazy var datePickerLabel: UILabel = {
//        datePickerLabel = UILabel()
//        let dateString = currentDate.formatted(date: .omitted, time: .shortened)
//        setTextDateIntoPickerLabel(with: dateString) // форматирует время и дописывает в строку
//        datePickerLabel.translatesAutoresizingMaskIntoConstraints = false
//        return datePickerLabel
//    }()

    private lazy var datePicker: UIDatePicker = { //константа инициализируется при первом обращении к ней
        let timePicker = UIDatePicker()
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.datePickerMode = UIDatePicker.Mode.time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.backgroundColor = UIColor(named: "dBackground")
        timePicker.addTarget(self, action: #selector(pickTime(_:)), for: .valueChanged) //добавляем таргет на измДанных
        return timePicker
    }()

    private var colorPicker = UIColorPickerViewController()

    private lazy var deleteButton: UIButton = { //a lazy надо использовать для того, чтобы внутри замыкания можно было использовать self
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true //если надо, чтобы она сначала была скрыта
        button.titleLabel?.text = "Удалить привычку"
        button.titleLabel?.textColor = .red
        button.isHidden = true
        button.addTarget(self, action: #selector(showDeleteAlert(_:)), for: .touchUpInside)
        return button
    }()


    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        createDatePickerLabel()

        if let habit { //до установки элементов интерфейса и для экрана "Править"
            currentDate = habit.time
            currentColor = habit.color
            currentTitle = habit.name
        }

        layout()
        textTitleHabit.delegate = self

        if habitState == .edit {
            textTitleHabit.text = currentTitle //1h16min
            pickerButton.tintColor = currentColor //для "Править" если цвет был - то оставляем
            datePicker.date = currentDate
            colorPicker.selectedColor = currentColor
            deleteButton.isHidden = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(
            title: "Сохранить",
            style: .done,
            target: self,
            action: #selector(saveHabit)
        )
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(
            title: "Отменить",
            style: .plain,
            target: self,
            action: #selector(backToHabitsViewController)
        )
        title = habitState == .create ? "Создать" : "Править"
    }
    
    //MARK: - private methods

    private func layout() {
        [nameTitleHabit, textTitleHabit, colorTitleHabit, pickerButton, timeTitleHabit, preTimeTextHabit, pickedHabitTime, datePicker, deleteButton].forEach { baseView.addSubview($0) }
        view.addSubview(baseView)

        NSLayoutConstraint.activate([
            baseView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            baseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            baseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 21),
            baseView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            nameTitleHabit.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            nameTitleHabit.topAnchor.constraint(equalTo: baseView.topAnchor),

            textTitleHabit.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            textTitleHabit.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            textTitleHabit.topAnchor.constraint(equalTo: nameTitleHabit.bottomAnchor, constant: 7),

            colorTitleHabit.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            colorTitleHabit.topAnchor.constraint(equalTo: textTitleHabit.bottomAnchor, constant: 15),

            pickerButton.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            pickerButton.topAnchor.constraint(equalTo: colorTitleHabit.bottomAnchor, constant: 7),

            timeTitleHabit.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            timeTitleHabit.topAnchor.constraint(equalTo: pickerButton.bottomAnchor, constant: 15),

            preTimeTextHabit.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            preTimeTextHabit.topAnchor.constraint(equalTo: timeTitleHabit.bottomAnchor, constant: 7),

            pickedHabitTime.leadingAnchor.constraint(equalTo: preTimeTextHabit.trailingAnchor),
            pickedHabitTime.topAnchor.constraint(equalTo: timeTitleHabit.bottomAnchor, constant: 7),
//            datePickerLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
//            datePickerLabel.topAnchor.constraint(equalTo: timeTitleHabit.bottomAnchor, constant: 7),

            datePicker.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: preTimeTextHabit.bottomAnchor, constant: 15),

            deleteButton.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            deleteButton.widthAnchor.constraint(equalTo: baseView.widthAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            deleteButton.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -8)
        ])
    }

    @objc func backToHabitsViewController() {
        navigationController?.dismiss(animated: true)
    }

    @objc func saveHabit(_ sender: UIBarButtonItem) {
        if habitState == .create {
            HabitsStore.shared.habits.append(
                Habit(name: currentTitle, date: currentDate, color: currentColor)
            )
            dismiss(animated: true) // или navigationController?.popViewController(animated: true)
        } else if habitState == .edit {
            let h = HabitsStore.shared.habits.first {
                $0 == habit
            }
            if let h {
                h.name = currentTitle
                h.color = currentColor
                h.time = currentDate
            }
            let vcs = navigationController!.viewControllers //тут мы уверены, что есть navigationController
            self.navigationController?.popToViewController(vcs[vcs.count-3], animated: true)
        }
    }

    @objc func pickColor(_ sender: UIButton) {
        colorPicker.title = "Take new habit color"
        colorPicker.delegate = self
        colorPicker.modalPresentationStyle = .popover
        present(colorPicker, animated: true)
    }

//    private func createDatePickerLabel() {
//        datePickerLabel = UILabel()
//        let dateString = currentDate.formatted(date: .omitted, time: .shortened)
//        setTextDateIntoPickerLabel(with: dateString) // форматирует время и дописывает в строку
//        datePickerLabel.translatesAutoresizingMaskIntoConstraints = false
//        baseView.addSubview(datePickerLabel)
//
//        NSLayoutConstraint.activate([
//            datePickerLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
//            datePickerLabel.topAnchor.constraint(equalTo: timeTitleHabit.bottomAnchor, constant: 7),
//            ])
//    }

//    //Чтобы сделать текст в одном свойстве и чтобы для частm текста настроить кастомно
//    private func setTextDateIntoPickerLabel(with value: String){
//        let mutableString = NSMutableAttributedString(string: "Каждый день в \(value)")
//        mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "dPurple")!, range: NSRange(location: 12, length: value.count + 2)) //устанавливает цвет текста для указанного диапазона символов после 13ого и по value.count + 2 включительно
//    }

    @objc func pickTime(_ sender: UIDatePicker) {
        currentDate = sender.date
        pickedHabitTime.text = sender.date.formatted(date: .omitted, time: .shortened)
    }

    @objc func showDeleteAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \(String(describing: habit?.name))?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] _ in
            guard let self else { return }
            HabitsStore.shared.habits.removeAll {
                $0.name == self.habit?.name //или $0 == self.habit
            }
            let habitsVC = HabitsViewController()
            self.navigationController?.popToViewController(habitsVC, animated: true)
        }))
        // экраны AddOrEditHabitVC закрываются и привычка пропадает из списка на экране MyHabitsViewController.
        present(alert, animated: true)
    }
}


//MARK: - UIColorPickerViewControllerDelegate
extension AddOrEditHabitVC: UIColorPickerViewControllerDelegate {

    //  Called once you have finished picking the color.
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        colorPicker.dismiss(animated: true) { [weak self] in
            guard let self else {return}
            self.textTitleHabit.textColor = self.colorPicker.selectedColor
            self.pickerButton.tintColor = self.colorPicker.selectedColor
            self.textTitleHabit.font  = UIFont(name: "SFProText-Semibold", size: 17)
        }
    }

    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        currentColor = color //чтобы был текущий - для "Править"
    }
}

extension AddOrEditHabitVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textTitleHabit.resignFirstResponder()
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        currentTitle = textField.text ?? "" //это изменение мы будем сразу сохранять себе (лучше чем навешивать слушателя(?))
    }

}
