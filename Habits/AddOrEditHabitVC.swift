//
//  AddOrEditHabitVC.swift
//  Habits
//
//  Created by Roman Vakulenko on 30.06.2023.
//

import UIKit

final class AddOrEditHabitVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(
            title: "Править",
            style: .plain,
            target: self,
            action: #selector(backToHabitsViewController)
        )
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Сегодня",
            style: .plain,
            target: self,
            action: #selector(editHabit)
        )
    }
    @objc func backToHabitsViewController() {
        let _ = navigationController?.popViewController(animated: true)
    }

    @objc func editHabit() {
        let addOrEditHabitVC = AddOrEditHabitVC()
        addOrEditHabitVC.modalTransitionStyle = .coverVertical
        addOrEditHabitVC.modalPresentationStyle = .fullScreen
        addOrEditHabitVC.view.backgroundColor = UIColor(red: 242, green: 242, blue: 247, alpha: 1)

        present(addOrEditHabitVC, animated: true)
    }


}
