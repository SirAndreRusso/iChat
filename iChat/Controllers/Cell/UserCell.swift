//
//  UserCell.swift
//  iChat
//
//  Created by Андрей Русин on 19.07.2022.
//

import UIKit
import SDWebImage

class UserCell: UICollectionViewCell, SelfConfiguringCell {
    let userImageView = UIImageView()
    let userName = UILabel(text: "text", font: .laoSangamMN20())
    let containerView = UIView()
    
    static var reuseId: String = "UserCell"
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .white
        setupConstraints()
        self.layer.cornerRadius = 4
        self.layer.shadowColor = UIColor.cellShadowColor().cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    override func layoutSubviews() {
        super .layoutSubviews()
        self.containerView.layer.cornerRadius = 4
        self.containerView.clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // Метод, устанавливающий аватарки на nil при переиспользовании яйчеек
    override func prepareForReuse() {
        userImageView.image = nil
    }
    func configure<U>(with value: U) where U : Hashable {
        guard let user: MUser = value as? MUser else {return}
        // Если в Cloud FireStore нет загруженной картинки, поставить дефолтную
        if  user.avatarStringURL.self == "NotExist" {
            userImageView.image = UIImage(named: "Avatar-placeholder")
        } else if let url = URL(string: user.avatarStringURL){
            // Если есть загруженная картинка, с помощью библиотеки SDWebImage загружаем картинку по урлу
            userImageView.sd_setImage(with: url)
        } else {
            return
        }
        
        
        //        userImageView.image = UIImage(named: user.avatarStringURL)
        userName.text = user.username
    }
    private func setupConstraints() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.backgroundColor = .red
        
        addSubview(containerView)
        containerView.addSubview(userName)
        containerView.addSubview(userImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            userImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor),
            
            userName.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            userName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            userName.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            
        ])
        
    }
    
    
    
}
// MARK: - SwiftUI
import SwiftUI
struct userCellProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        let tabBarVC = MainTabBarController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<userCellProvider.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }
        func updateUIViewController(_ uiViewController: userCellProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<userCellProvider.ContainerView>) {
            
        }
    }
}

