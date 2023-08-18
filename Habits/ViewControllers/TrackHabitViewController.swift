//
//  TrackHabitViewController.swift
//  Habits
//
//  Created by Roman Vakulenko on 28.07.2023.
//

import UIKit

final class TrackHabitViewController: UIViewController {

    var indexOfHabit = Int()

    // MARK: - Private properties
    private let store = HabitsStore.shared

    private let datesArr = HabitsStore.shared.dates

    private var viewModel: TrackViewModel

    
    // MARK: - Subviews
    private lazy var detailsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(TrackingDaysCell.self, forCellReuseIdentifier: TrackingDaysCell.identifier)
        table.dataSource = self
        table.delegate = self
        return table
    }()


    // MARK: - Init
    init(viewModel: TrackViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "dBackground")
        layout()
        navBarSettings()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }

    // MARK: - Private methods

    private func navBarSettings(){
        let backButton = UIBarButtonItem(title: "Сегодня", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(editHabit))
    }

    private func layout(){
        view.addSubview(detailsTableView)

        NSLayoutConstraint.activate([
            detailsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc func editHabit(_ sender: UIBarButtonItem){
        let editVC = AddOrEditHabitVC()
        editVC.habit = store.habits[indexOfHabit]
        editVC.habitState = .edit
        navigationController?.pushViewController(editVC, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension TrackHabitViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datesArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackingDaysCell.identifier, for: indexPath) as! TrackingDaysCell

        cell.setup(from: datesArr, at: indexPath)
        var fallingDates = [Date]() //dates.reversed().map { $0 } //развернутый массив дат
        for i in datesArr {
            fallingDates.insert(i, at: 0)
        }
        if store.habit(store.habits[indexOfHabit], isTrackedIn: fallingDates[indexPath.row]) {
            cell.accessoryType = .checkmark
        }
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TrackHabitViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderDetailHabit()
        header.setup(textForHeader: "АКТИВНОСТЬ")

        if section == 0 {
            header.backgroundColor = UIColor(named: "dBackground")
            return header
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        } else {
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return .leastNonzeroMagnitude
        } else {
            return UITableView.automaticDimension
        }
    }
}

