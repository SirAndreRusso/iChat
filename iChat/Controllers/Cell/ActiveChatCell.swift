//
//  ActiveChatCell.swift
//  iChat
//
//  Created by Андрей Русин on 14.07.2022.
//

import Foundation
import UIKit
class ActiveChatCell: UICollectionViewCell, SelfConfiguringCell{
    
    static var reuseId: String = "ActiveChatCell"
    let friendImageView = UIImageView()
    let friendName = UILabel(text: "User name", font: .laoSangamMN20())
    let lastMessage = UILabel(text: "How are you?", font: .laoSangamMN18())
    let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: .gradientStartColor(), endColor: .gradientEndColor())
    override init(frame: CGRect) {
        super .init(frame: frame)
        setUpConstraints()
        backgroundColor = .white
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
//    func configure(with value: MChat) {
//        friendImageView.image = UIImage(named: value.userImageString)
//        friendName.text = value.username
//        lastMessage.text = value.lastMessage
//    }
    func configure<U>(with value: U) where U : Hashable {
        guard let activeChat: MChat = value as? MChat else {return}
        friendImageView.image = UIImage(named: activeChat.friendAvatarStringURL)
        friendName.text = activeChat.friendUsername
        lastMessage.text = activeChat.lastMessageContent
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Setup constraints

extension ActiveChatCell {
    private func setUpConstraints (){
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        friendName.translatesAutoresizingMaskIntoConstraints = false
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        friendImageView.backgroundColor = .red
        gradientView.backgroundColor = .black
        addSubview(friendImageView)
        addSubview(gradientView)
        addSubview(friendName)
        addSubview(lastMessage)
        NSLayoutConstraint.activate([
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            friendImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            friendImageView.heightAnchor.constraint(equalToConstant: 78),
            friendImageView.widthAnchor.constraint(equalToConstant: 78),
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            gradientView.heightAnchor.constraint(equalToConstant: 78),
            gradientView.widthAnchor.constraint(equalToConstant: 8),
            friendName.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            friendName.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            friendName.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16),
            lastMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            lastMessage.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            lastMessage.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16)
            
            
        ])
    }
}
// MARK: - SwiftUI
import SwiftUI
struct ActiveChatProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        let tabBarVC = MainTabBarController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<ActiveChatProvider.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }
        func updateUIViewController(_ uiViewController: ActiveChatProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ActiveChatProvider.ContainerView>) {
            
        }
    }
    
    
}
