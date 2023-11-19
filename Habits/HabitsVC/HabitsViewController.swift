//
//  HabitsViewController.swift
//  Habits
//
//  Created by Roman Vakulenko on 29.06.2023.
//

import UIKit

final class HabitsViewController: UIViewController {

    // MARK: - Private properties
    private var viewModel: HabitsViewModel

    private var store = HabitsStore.shared

    private lazy var modelOfHabits: [Habit] = {
        let model = viewModel.habitsModel
        return model
    }()

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = Constants.inset * 2 // удобно, когда 1 коллекция, чтобы не писать func в delegate
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor(named: "dBackground")
        collection.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: ProgressCollectionViewCell.identifier)
        collection.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: HabitCollectionViewCell.identifier)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()


    // MARK: - Init
    init(viewModel: HabitsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstaints()
        viewModel.loadHabits() //при запуске приложения
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
        bindViewModel()
    }


    // MARK: - Private methods
    private func setupView() {
        view.addSubview(collectionView)
        view.backgroundColor = UIColor(named: "dBackground")
        title = "Сегодня"
    }

    private func setupConstaints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func bindViewModel() {
        viewModel.closureChangeState = { [weak self] state in
            guard let self else {return}

            switch state {
            case .none:
                ()
            case .loading:
                () //нужен если есть анимация загрузки
            case .loaded:
                self.collectionView.reloadData()

            case .createHabitAndReloadCollection:
                modelOfHabits = viewModel.habitsModel
                self.collectionView.reloadData()

            case .reloadEditedHabit(let indexPaths):
                modelOfHabits = viewModel.habitsModel
                self.collectionView.reloadItems(at: indexPaths)

            case .deleteHabitAndReloadCollection:
                modelOfHabits = viewModel.habitsModel
                self.collectionView.reloadData()

            case .wrong(errorDescription: let errorDescription):
                () //не заюзал
            }
        }
    }

    // MARK: - Actions
    @objc func addHabit() {
        viewModel.didTapAddHabit()
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
            numberOfItems = viewModel.habitsModel.count
            print("numberOfItems in 2nd section - \(numberOfItems)")
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
            habitCell.setup(habit: modelOfHabits[indexPath.item]){
                collectionView.reloadItems(at: [indexPath]) // этот completion сохранен в checkMarkBtnStateClosure, чтобы его вызвать, когда нажмем на checkMark и тогда он сделает то, что в нем написано - reloadItems
            }
            return habitCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            viewModel.didTapHabitCell(at: indexPath)
        }
    }
}


//MARK: - UICollectionViewDelegateFlowLayout

extension HabitsViewController: UICollectionViewDelegateFlowLayout {

    private var inset: CGFloat { return 16 }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - inset * 2
        var height: CGFloat
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
    //spacing между рядами/строками для вертикальной коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       12
    }

}
