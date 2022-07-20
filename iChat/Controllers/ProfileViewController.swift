//
//  ProfileViewController.swift
//  iChat
//
//  Created by Андрей Русин on 20.07.2022.

import UIKit
class ProfileViewController: UIViewController {
    let containerView = UIView()
    let imageView = UIImageView(image: UIImage(named: "Human1"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Peter Pen", font: .systemFont(ofSize: 20, weight: .light))
    let aboutMeLabel = UILabel(text: "Chat with me", font: .systemFont(ofSize: 16, weight: .light))
    let myTextField = InsertableTextField()
    override func viewDidLoad() {
        super .viewDidLoad()
        customizeElements()
        setupConstraints()
        view.backgroundColor = .white
    }
    private func customizeElements() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        myTextField.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.numberOfLines = 0
        
        containerView.backgroundColor = .mainWhite()
        containerView.layer.cornerRadius = 30
        
        if let button = myTextField.rightView as? UIButton {
            button.addTarget(self,  action: #selector(sendMessage), for: .touchUpInside)
        }
    }
        @objc func sendMessage() {
            print("123")
        }
}
// MARK: - Setup constraints
extension ProfileViewController {
    
    private func setupConstraints() {
       
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutMeLabel)
        containerView.addSubview(myTextField)
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 206),
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            aboutMeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            aboutMeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            aboutMeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            myTextField.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 10),
            myTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            myTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            myTextField.heightAnchor.constraint(equalToConstant: 45)
            
        ])
    }
}
// MARK: - SwiftUI
import SwiftUI
struct ProfileViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        let profileVC = ProfileViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProfileViewControllerProvider.ContainerView>) -> some ProfileViewController {
            return profileVC
        }
        func updateUIViewController(_ uiViewController: ProfileViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProfileViewControllerProvider.ContainerView>) {
            
        }
    }
    
    
}
