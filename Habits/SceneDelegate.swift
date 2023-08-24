//
//  SceneDelegate.swift
//  Habits
//
//  Created by Roman Vakulenko on 29.06.2023.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var mainCoordinator: CoordinatorProtocol?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: scene)
        let mainCoordinator = MainCoordinator()
        window.rootViewController = mainCoordinator.start()
        
        self.window = window
        self.mainCoordinator = mainCoordinator
        window.makeKeyAndVisible()
    }
        
//        let habitsViewController = HabitsViewController()
//        habitsViewController.view.backgroundColor = .white
//        let habitsViewNavigationController = UINavigationController(rootViewController: habitsViewController)
//        habitsViewNavigationController.navigationBar.prefersLargeTitles = true
//
//        let infoViewController = InfoViewController()
//        infoViewController.title = "Информация"
//        let infoViewNavigationController = UINavigationController(rootViewController: infoViewController)
//
//        let tabBarController = UITabBarController()
//
//        let iconConfig = UIImage.SymbolConfiguration(scale: .default)
//        let habitsIcon = UIImage(named: "habits_tab_icon", in: Bundle.main, with: iconConfig)
//        habitsViewNavigationController.tabBarItem = UITabBarItem(title: "Привычки", image: habitsIcon, tag: 0)
//
//        infoViewNavigationController.tabBarItem.image = UIImage(named: "info.circle.fill")
//
//        tabBarController.viewControllers = [habitsViewNavigationController, infoViewNavigationController]
//        tabBarController.tabBar.tintColor = UIColor(named: "dPurple")
//        tabBarController.selectedIndex = 0
//        window.rootViewController = tabBarController


}

