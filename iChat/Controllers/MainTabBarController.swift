//
//  MainTabBarController.swift
//  iChat
//
//  Created by Андрей Русин on 06.07.2022.
//

import UIKit
class MainTabBarController: UITabBarController {
    private let currentUser: MUser
    init(currentUser: MUser = MUser(username: "123",
                                    email: "123",
                                    description: "123",
                                    gender: "123",
                                    avatarStringURL: "123",
                                    id: "123")){
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor(red: 142.0/255.0, green: 90.0/255.0, blue: 247.0/255.0, alpha: 1.0/1.0)
        let listViewontroller = ListViewController(currentUser: currentUser)
        let peopleViewController = PeopleViewController(currentUser: currentUser)
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfig)!
        let conversationImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig)!
        
       viewControllers = [generateNavigationController(rootViewController: peopleViewController, title: "People", image: peopleImage), generateNavigationController(rootViewController: listViewontroller, title: "Conversations", image: conversationImage)]
    
    }
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
