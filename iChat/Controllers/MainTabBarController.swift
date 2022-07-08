//
//  MainTabBarController.swift
//  iChat
//
//  Created by Андрей Русин on 06.07.2022.
//

import UIKit
class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor(red: 142.0/255.0, green: 90.0/255.0, blue: 247.0/255.0, alpha: 1.0/1.0)
        let listViewontroller = ListViewController()
        let peopleViewController = PeopleViewController()
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfig)!
        let conversationImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig)!
        
       viewControllers = [generateNavigationController(rootViewController: listViewontroller, title: "Conversations", image: conversationImage),
                              generateNavigationController(rootViewController: peopleViewController, title: "People", image: peopleImage)
       ]
    }
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
