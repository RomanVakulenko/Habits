//
//  HabitDetailsViewController.swift
//  Habits
//
//  Created by Roman Vakulenko on 28.07.2023.
//

import UIKit

final class HabitDetailsViewController: UIViewController {

    private let datesArr = HabitsStore.shared.dates

    private lazy var detailsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(TrackingDaysCell.self, forCellReuseIdentifier: TrackingDaysCell.identifier)
        table.dataSource = self
        table.delegate = self
        return table
    }()

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


// MARK: - Private
    private func navBarSettings(){
        let backButton = UIBarButtonItem(title: "Сегодня", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
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
}

// MARK: - UITableViewDataSource

extension HabitDetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datesArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackingDaysCell.identifier, for: indexPath) as! TrackingDaysCell
        print(datesArr)

        cell.setup(from: datesArr, at: indexPath)
        cell.accessoryType = .checkmark
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HabitDetailsViewController: UITableViewDelegate {

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

