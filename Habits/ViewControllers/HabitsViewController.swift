//
//  HabitsViewController.swift
//  Habits
//
//  Created by Roman Vakulenko on 29.06.2023.
//

import UIKit

final class HabitsViewController: UIViewController {

    private var store = HabitsStore.shared
    
    private lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical

        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor(named: "dBackground")
        collection.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.identifier)
        collection.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.identifier)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()

//MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        navigationItem.title = "Сегодня"
        store.habits.removeAll()
        store.habits.append(Habit(name: "Приседания в перерывах", date: Date(), color: .systemBlue))

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addHabit)
        )
        navigationController?.navigationBar.tintColor = UIColor(named: "dPurple")
        collectionView.reloadData()
    }


//MARK: - methods

    private func layout() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc func addHabit() {
        let addOrEditHabitVC = AddOrEditHabitVC()
        let navController = UINavigationController(rootViewController: addOrEditHabitVC) // Creating a navigation controller with addOrEditHabitVC at the root of the navigation stack.
        navController.view.backgroundColor = UIColor(named: "dBackground")
        navController.modalTransitionStyle = .coverVertical
        navController.modalPresentationStyle = .fullScreen
        navController.navigationBar.tintColor = UIColor(named: "dPurple")
        present(navController, animated: true)
    }
    
}

//MARK: - UICollectionViewDataSource

extension HabitsViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfItems = 0
        if section == 0 {
            numberOfItems = 1
        } else {
            numberOfItems = store.habits.count
        }
        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath == [0,0] {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath) as? ProgressCollectionViewCell else { return UICollectionViewCell()}
            cell.setupProgressCell(with: store.todayProgress)
            return cell
        } else {
            guard let habitCell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitCollectionViewCell.identifier, for: indexPath) as? HabitCollectionViewCell else { return UICollectionViewCell()}
            habitCell.setup(habit: store.habits[indexPath.item]){
                collectionView.reloadData()
            }
            return habitCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let habitDetailsVC = HabitDetailsViewController()
        navigationController?.pushViewController(habitDetailsVC, animated: true)
        habitDetailsVC.title = HabitsStore.shared.habits[indexPath.row].name
        habitDetailsVC.indexOfHabit = indexPath.row
    }
}


//MARK: - UICollectionViewDelegateFlowLayout

extension HabitsViewController: UICollectionViewDelegateFlowLayout {

    private var inset: CGFloat { return 16 }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - inset * 2
        var height = 0.0
        if indexPath == [0,0] {
            height = 60
        } else {
            height = 130
        }
        return CGSize(width: width, height: height)
    }
    //отступы по периметру дисплея
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 22, left: inset, bottom: 0, right: inset)
    }
    //отступы между рядами-строками для вертикальной коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       12
    }

}
