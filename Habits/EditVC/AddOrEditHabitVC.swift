//
//  AddOrEditHabitVC.swift
//  Habits
//
//  Created by Roman Vakulenko on 30.06.2023.
//

import UIKit

enum HabitVCState {
    case create, edit, cancel, delete
}


final class AddOrEditHabitVC: UIViewController {
    // MARK: - Private properties
    private var habitState: HabitVCState

    private lazy var habitStore: HabitsStore = {
        return HabitsStore.shared
    }()

    private var viewModel: AddOrEditViewModel

    private lazy var model: Habit? = { [unowned self] in
        self.viewModel.habitModel
    }()
    ///ставятся после ввода  или уже передаются заполненными, если жмем "править"
    private var currentTitle = ""
    private var currentDate = Date()
    private var currentColor = UIColor.systemBlue

    private let baseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "dBackground")
        return view
    }()

    private let titleOfHabit: UILabel = {
        let nameTitle = UILabel()
        nameTitle.translatesAutoresizingMaskIntoConstraints = false
        nameTitle.font = UIFont(name: "SFProText-Semibold", size: 13)
        nameTitle.textColor = .black
        nameTitle.text = "НАЗВАНИЕ"
        return nameTitle
    }()

    private lazy var nameOfHabit: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont(name: "SFProText-Regular", size: 17)
        text.textColor = .systemBlue
        text.placeholder = "Приседать в перерывах; Гимнастика глаз и т.п."
        text.delegate = self
        return text
    }()

    private let colorOfHabitTitle: UILabel = {
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

    private let timeToPracticeHabit: UILabel = {
        let timeSet = UILabel()
        timeSet.translatesAutoresizingMaskIntoConstraints = false
        timeSet.font = UIFont(name: "SFProText-Regular", size: 17)
        timeSet.textColor = .black
        timeSet.text = "Каждый день в "
        return timeSet
    }()

    private lazy var pickedTime: UILabel = {
        let pickedTime = UILabel()
        pickedTime.translatesAutoresizingMaskIntoConstraints = false
        pickedTime.font = UIFont(name: "SFProText-Regular", size: 17)
        pickedTime.textColor = UIColor(named: "dPurple")
        return pickedTime
    }()

    private lazy var datePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.datePickerMode = UIDatePicker.Mode.time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.locale = .init(identifier: "ru_RU")
        timePicker.backgroundColor = UIColor(named: "dBackground")
        timePicker.addTarget(self, action: #selector(pickTime(_:)), for: .valueChanged)
        return timePicker
    }()

    private lazy var colorPicker: UIColorPickerViewController = {
        let colorPicker = UIColorPickerViewController()
        colorPicker.title = "Take new habit color"
        colorPicker.modalPresentationStyle = .popover
        colorPicker.selectedColor = currentColor
        colorPicker.delegate = self
        return colorPicker
    }()

    private lazy var deleteButton: UIButton = { //lazy, чтобы внутри замыкания использовать self
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true //сначала скрыта
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(showDeleteAlert(_:)), for: .touchUpInside)
        return button
    }()


    // MARK: - Init

    init(viewModel: AddOrEditViewModel, habitState: HabitVCState) {
        self.viewModel = viewModel
        self.habitState = habitState
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layout()
        presetDataForEditingHabit()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Сохранить",
            style: .done,
            target: self,
            action: #selector(saveHabit)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Отменить",
            style: .plain,
            target: self,
            action: #selector(backToHabitsViewController)
        )
        title = habitState == .create ? "Создать" : "Править"

        if habitState == .edit {
            nameOfHabit.font = UIFont(name: "SFProText-Semibold", size: 17)
        }
    }

    // MARK: - Private methods
    private func setupView() {
        [titleOfHabit, nameOfHabit, colorOfHabitTitle, pickerButton, timeTitleHabit, timeToPracticeHabit, pickedTime, datePicker, deleteButton].forEach { baseView.addSubview($0) }
        view.addSubview(baseView)
        view.backgroundColor = UIColor(named: "dBackground")
    }

    private func layout() {
        NSLayoutConstraint.activate([
            baseView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            baseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            baseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 21),
            baseView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            titleOfHabit.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            titleOfHabit.topAnchor.constraint(equalTo: baseView.topAnchor),

            nameOfHabit.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            nameOfHabit.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            nameOfHabit.topAnchor.constraint(equalTo: titleOfHabit.bottomAnchor, constant: 7),

            colorOfHabitTitle.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            colorOfHabitTitle.topAnchor.constraint(equalTo: nameOfHabit.bottomAnchor, constant: 15),

            pickerButton.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            pickerButton.topAnchor.constraint(equalTo: colorOfHabitTitle.bottomAnchor, constant: 7),

            timeTitleHabit.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            timeTitleHabit.topAnchor.constraint(equalTo: pickerButton.bottomAnchor, constant: 15),

            timeToPracticeHabit.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            timeToPracticeHabit.topAnchor.constraint(equalTo: timeTitleHabit.bottomAnchor, constant: 7),

            pickedTime.leadingAnchor.constraint(equalTo: timeToPracticeHabit.trailingAnchor),
            pickedTime.topAnchor.constraint(equalTo: timeTitleHabit.bottomAnchor, constant: 7),

            datePicker.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: timeToPracticeHabit.bottomAnchor, constant: 15),

            deleteButton.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            deleteButton.widthAnchor.constraint(equalTo: baseView.widthAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            deleteButton.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -8)
        ])
    }

    ///предустановка для экрана "Править"
    private func presetDataForEditingHabit() {
        guard let model else {return}
        if model.name != "",
           habitState == .edit {
            currentTitle = model.name
            currentDate = model.date
            currentColor = model.color

            deleteButton.isHidden = false

            nameOfHabit.text = currentTitle
            nameOfHabit.textColor = currentColor
            pickerButton.tintColor = currentColor //для "Править", если цвет был - то оставляем
            datePicker.date = currentDate

            pickedTime.text = Format.timeForHabitRepeats.string(from: currentDate)
            pickedTime.textColor = UIColor(named: "dPurple")
            colorPicker.selectedColor = currentColor
        }
    }


    @objc func saveHabit(_ sender: UIBarButtonItem) {
        if habitState == .create {
            HabitsStore.shared.habits.append( //добавляем привычку в store
                Habit(name: currentTitle,
                      date: currentDate,
                      color: currentColor)
            )
            habitStore.save() //записываем в UserDefaults
            viewModel.didTapSaveOrCancelOrDelete(tapped: .create)
        } else if habitState == .edit {
            if let model,
               let tappedHabit = HabitsStore.shared.habits.first(where: { $0.name == model.name }) {
                tappedHabit.name = currentTitle
                tappedHabit.color = currentColor
                tappedHabit.date = currentDate
            }
            habitStore.save() //
            viewModel.didTapSaveOrCancelOrDelete(tapped: .edit)
        }
    }

    @objc func backToHabitsViewController() {
        viewModel.didTapSaveOrCancelOrDelete(tapped: .cancel)
    }

    @objc func pickColor(_ sender: UIButton) {
        currentColor = colorPicker.selectedColor
        present(colorPicker, animated: true)
    }

    @objc func pickTime(_ sender: UIDatePicker) {
        currentDate = sender.date //записывается сразу
        pickedTime.text = Format.timeForHabitRepeats.string(from: currentDate)

    }

    @objc func showDeleteAlert(_ sender: UIButton) {
        guard let model else {return}
        if model.name != "" {
            let alert = UIAlertController(
                title: "Удалить привычку",
                message: """
                         Вы хотите удалить привычку "\(model.name)?"
                         """,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
                HabitsStore.shared.habits.removeAll {
                    $0.name == self.currentTitle
                }
                self.habitStore.save()
            }))

            present(alert, animated: true)
            self.viewModel.didTapSaveOrCancelOrDelete(tapped: .delete)
        }

    }
}


//MARK: - UIColorPickerViewControllerDelegate
extension AddOrEditHabitVC: UIColorPickerViewControllerDelegate {

    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        colorPicker.dismiss(animated: true) { [weak self] in
            guard let self else {return}
            self.nameOfHabit.textColor = self.colorPicker.selectedColor
            self.pickerButton.tintColor = self.colorPicker.selectedColor
            self.nameOfHabit.font  = UIFont(name: "SFProText-Semibold", size: 17)
        }
    }

    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        currentColor = color
    }
}

//MARK: - UITextFieldDelegate
extension AddOrEditHabitVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        currentTitle = textField.text ?? "" //как только текст в поле меняется, то записывается в currentTitle
        if habitState == .create {
            nameOfHabit.font = UIFont(name: "SFProText-Semibold", size: 17)
        }
    }

}
