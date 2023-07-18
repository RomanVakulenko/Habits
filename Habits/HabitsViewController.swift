//
//  HabitsViewController.swift
//  Habits
//
//  Created by Roman Vakulenko on 29.06.2023.
//

import UIKit

final class HabitsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addHabit))
    }


    @objc func addHabit() {
        let addOrEditHabitVC = AddOrEditHabitVC()
        addOrEditHabitVC.modalTransitionStyle = .coverVertical
        addOrEditHabitVC.modalPresentationStyle = .fullScreen
        addOrEditHabitVC.view.backgroundColor = UIColor(red: 242, green: 242, blue: 247, alpha: 1)

        present(addOrEditHabitVC, animated: true)
    }
    
}
