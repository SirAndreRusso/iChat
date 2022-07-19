//
//  WaitingChatCell.swift
//  iChat
//
//  Created by Андрей Русин on 14.07.2022.
//

import UIKit
class WaitingChatCell: UICollectionViewCell, SelfConfiguringCell {
   
    static var reuseId: String = "WaitingChatCell"
    let friendImageView = UIImageView()
//    func configure(with value: MChat) {
//        friendImageView.image = UIImage(named: value.userImageString)
//    }
    func configure<U>(with value: U) where U : Hashable {
        guard let waitingChat: MChat = value as? MChat else {return}
        friendImageView.image = UIImage(named: waitingChat.userImageString)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraints()
        backgroundColor = .white
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    private func setUpConstraints(){
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(friendImageView)
        NSLayoutConstraint.activate([
            friendImageView.topAnchor.constraint(equalTo: self.topAnchor),
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            friendImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - SwiftUI
import SwiftUI
struct WaitingChatCellProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        let tabBarVC = MainTabBarController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<WaitingChatCellProvider.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }
        func updateUIViewController(_ uiViewController: WaitingChatCellProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<WaitingChatCellProvider.ContainerView>) {
            
        }
    }
}
