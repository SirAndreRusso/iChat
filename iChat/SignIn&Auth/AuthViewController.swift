//
//  ViewController.swift
//  iChat
//
//  Created by Андрей Русин on 23.06.2022.
//

import UIKit
import GoogleSignIn

class AuthViewController: UIViewController {
    let logoImageView = UIImageView(image: UIImage(named: "Logo"), contentMode: .scaleAspectFit)
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or register with")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    let googleButton = UIButton(title: "Google", titleColor: .black, backGroundColor: .white, isShadow: true)
    let eMailbutton = UIButton(title: "E-mail", titleColor: .white, backGroundColor: .buttonDark(),  isShadow: false)
    let loginButton = UIButton(title: "Login", titleColor: .buttonRed(), backGroundColor: .white,  isShadow: true)
    lazy var registrationVC = RegistrationViewController()
    lazy var loginVC = LoginViewController()
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleButton.customiedGoogleButton()
        view.backgroundColor = .white
        setUpConstraints()
        registrationVC.delegate = self
        loginVC.delegate = self
        setupButtonsActions()
    }
}

//MARK: - setUpButtonsActions

extension AuthViewController {
    private func setupButtonsActions() {
        let emailButtonAction = UIAction {[weak self] _ in
            guard let self = self else {return}
            self.present(self.registrationVC, animated: true, completion: nil)
        }
        let loginButtonAction = UIAction {[weak self] _ in
            guard let self = self else {return}
            self.present(self.loginVC, animated: true, completion: nil)
        }
        let googleButtonAction = UIAction {[weak self] _ in
            guard let self = self else {return}
            AuthService.shared.googleSignIn(presentingViewController: self) {(result) in
                
                switch result {
                    
                case .success(let user):
                    FirestoreService.shared.getUserData(user: user) { result in
                        switch result {
                            
                        case .success(let muser):
                            UIApplication.getTopViewController()?.showAlert(with: "Вы уже зарегистрированы!", and: "Хотите продолжить как \(muser.username)?", completion: {
                                let mainTabBar = MainTabBarController(currentUser: muser)
                                mainTabBar.modalPresentationStyle = .fullScreen
                                self.present(mainTabBar, animated: true)
                            })
                        case .failure(_):
                            self.showAlert(with: "Успешно", and: "Теперь вы зарегистрированы в iChat") {
                                self.present(SetUpProfileViewController(currentUser: user), animated: true)
                            }
                        }
                    }
                case .failure(let error):
                    self.showAlert(with: "Ошибка", and: error.localizedDescription)
                }
            }
        }
        eMailbutton.addAction(emailButtonAction, for: .touchUpInside)
        loginButton.addAction(loginButtonAction, for: .touchUpInside)
        googleButton.addAction(googleButtonAction, for: .touchUpInside)
    }
}

//MARK: - Setup constraints

extension AuthViewController {
    private func setUpConstraints(){
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let googleView = ButtonFormView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormView(label: emailLabel, button: eMailbutton)
        let loginView = ButtonFormView(label: alreadyOnboardLabel, button: loginButton)
        
        let stackView = UIStackView(arrangedSubviews: [googleView,emailView,loginView], axis: .vertical, spacing: 40)
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

// MARK: - AuthNavigationDelegate

extension AuthViewController: AuthNavigationDelegate {
    func toLoginVC() {
        present(loginVC, animated: true)
    }
    func toRegistrationVC() {
        present(registrationVC, animated: true)
    }
}

// MARK: - SwiftUI

import SwiftUI
struct AuthViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        let authViewController = AuthViewController()
        func makeUIViewController(context: Context) -> some UIViewController {
            return authViewController
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

