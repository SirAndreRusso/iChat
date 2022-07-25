//
//  SetUpProfileViewController.swift
//  iChat
//
//  Created by Андрей Русин on 04.07.2022.
//

import UIKit

class SetUpProfileViewController: UIViewController {

    let welcomeLabel = UILabel(text: "Set up Profile!", font: .avenir26())
    let fullNameLabel = UILabel(text: "Full name")
    let aboutMeLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")
    let passwordLabel = UILabel(text: "Password")
    let fullNametextField = OneLineTextField(font: .avenir20())
    let aboutmetextField = OneLineTextField(font: .avenir20())
    let sexSegmentedControl = UISegmentedControl(first: "Male", second: "Female")
    let goToChatsButton = UIButton(title: "Go to chats!", titleColor: .white, backGroundColor: .buttonDark(),  isShadow: true, cornerRadius: 4)

    let fillImageView = AddPhotoView()
    
    //Actions
    lazy var goToChatsButtonAction = UIAction { _ in
        print("123")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpConstraints()
        goToChatsButton.addAction(goToChatsButtonAction, for: .touchUpInside)
        
    }
}
// MARK: - Setup constraints
extension SetUpProfileViewController {
   private func setUpConstraints() {
       let fullNameStackView = UIStackView(arrangedSubviews: [fullNameLabel, fullNametextField], axis: .vertical, spacing: 0)
       let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutmetextField], axis: .vertical, spacing: 0)
       let sexStackView = UIStackView(arrangedSubviews: [sexLabel, sexSegmentedControl], axis: .vertical, spacing: 10)
       goToChatsButton.translatesAutoresizingMaskIntoConstraints = false
       goToChatsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
       let stackView = UIStackView(arrangedSubviews: [fullNameStackView, aboutMeStackView, sexStackView, goToChatsButton], axis: .vertical, spacing: 40)
       welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
       fillImageView.translatesAutoresizingMaskIntoConstraints = false
       stackView.translatesAutoresizingMaskIntoConstraints = false
     
       view.addSubview(welcomeLabel)
       view.addSubview(fillImageView)
       view.addSubview(stackView)
       view.addSubview(goToChatsButton)
    
       NSLayoutConstraint.activate([
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
        
        fillImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
        fillImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
        stackView.topAnchor.constraint(equalTo: fillImageView.bottomAnchor, constant: 40),
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        goToChatsButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
        goToChatsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
        goToChatsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
       ])
    }
}
// MARK: - SwiftUI
import SwiftUI
struct SetUpProfileViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        let setUpProfileViewController = SetUpProfileViewController()
        func makeUIViewController(context: Context) -> some UIViewController {
            return setUpProfileViewController
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
