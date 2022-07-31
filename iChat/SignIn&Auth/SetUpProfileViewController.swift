//
//  SetUpProfileViewController.swift
//  iChat
//
//  Created by Андрей Русин on 04.07.2022.
//

import UIKit
import FirebaseAuth

class SetUpProfileViewController: UIViewController {

    let welcomeLabel = UILabel(text: "Set up Profile!", font: .avenir26())
    let fullNameLabel = UILabel(text: "Full name")
    let aboutMeLabel = UILabel(text: "About me")
    let genderLabel = UILabel(text: "Gender")
    let passwordLabel = UILabel(text: "Password")
    let fullNametextField = OneLineTextField(font: .avenir20())
    let aboutmetextField = OneLineTextField(font: .avenir20())
    let genderSegmentedControl = UISegmentedControl(first: "Male", second: "Female")
    let goToChatsButton = UIButton(title: "Go to chats!", titleColor: .white, backGroundColor: .buttonDark(),  isShadow: true, cornerRadius: 4)
    private let currentUser: User
    init(currentUser: User) {
        
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let fillImageView = AddPhotoView()
    
    //Actions
    lazy var goToChatsButtonAction = UIAction { _ in
        FirestoreService.shared.saveProfileWith(id: self.currentUser.uid, email: self.currentUser.email!, username: self.fullNametextField.text, avatarImageString: "Nil", description: self.aboutmetextField.text, gender: self.genderSegmentedControl.titleForSegment(at: self.genderSegmentedControl.selectedSegmentIndex)) { (result) in
            switch result {
                
            case .success(let muser):
                self.showAlert(with: "Успешно!", and: "Приятного общения!") {
                    self.present(MainTabBarController(), animated: true)
                }
            case .failure(let error):
                self.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
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
       let sexStackView = UIStackView(arrangedSubviews: [genderLabel, genderSegmentedControl], axis: .vertical, spacing: 10)
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
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
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
        let setUpProfileViewController = SetUpProfileViewController(currentUser: Auth.auth().currentUser!)
        func makeUIViewController(context: Context) -> some UIViewController {
            return setUpProfileViewController
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
