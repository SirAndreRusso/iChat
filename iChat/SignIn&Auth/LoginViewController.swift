//
//  LoginViewController.swift
//  iChat
//
//  Created by Андрей Русин on 04.07.2022.
//

import UIKit

class LoginViewController: UIViewController {
    weak var delegate: AuthNavigationDelegate?
    let welcomeLabel = UILabel(text: "Welcome back")
    let loginWithlabel = UILabel(text: "Login with")
    let orLabel = UILabel(text: "Or")
    let emailLabel = UILabel(text: "E-mail")
    let passwordLabel = UILabel(text: "Password")
    let needAnAccountLabel = UILabel(text: "Need an account?")
    let googleButton = UIButton(title: "Google", titleColor: .black, backGroundColor: .white,  isShadow: true)
    let loginButton = UIButton(title: "Login", titleColor: .white, backGroundColor: .buttonDark(),  isShadow: false, cornerRadius: 4)
    let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir20()
        return button
    }()
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    
// MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleButton.customiedGoogleButton()
        view.backgroundColor = .white
        setUpConstraints()
        setUpButtonsActions()
        setUpTextFields()
        
    }
    
// MARK: - setUpTextFields
    
    private func setUpTextFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .go
    }
}

// MARK: - setUpButtons Actions

extension LoginViewController {
     private func setUpButtonsActions() {
         let googleButtonAction = UIAction { [weak self] _ in
             guard let self = self else {return}
             AuthService.shared.googleSignIn(presentingViewController: self) {(result) in
                 switch result {
                     
                 case .success(let user):
                     self.showAlert(with: "", and: "Вы успешно авторизованы") {
                         FirestoreService.shared.getUserData(user: user) { (result) in
                             switch result {
                                 
                             case .success(let muser):
                                 let mainTabBar = MainTabBarController(currentUser: muser)
                                 mainTabBar.modalPresentationStyle = .fullScreen
                                 self.present(mainTabBar, animated: true)
                                 
                             case .failure(let error):
                                 print(error.localizedDescription)
                                 self.showAlert(with: "Успешно!", and: "Вы зарегистрированы")
                                 self.present(SetUpProfileViewController(currentUser: user), animated: true)
                             }
                         }
                     }
                 case .failure(let error):
                     self.showAlert(with: "Ошибка", and: error.localizedDescription)
                 }
             }
         }
         let loginButtonAction = UIAction {[weak self] _ in
             guard let self = self else {return}
             AuthService.shared.login(email: self.emailTextField.text!, password: self.passwordTextField.text!) { (result) in
                 switch result {
                     
                 case .success(let user):
                     self.showAlert(with: "", and: "Вы успешно авторизованы") {
                         FirestoreService.shared.getUserData(user: user) { (result) in
                             switch result {
                                 
                             case .success(let muser):
                                 let mainTabBar = MainTabBarController(currentUser: muser)
                                 mainTabBar.modalPresentationStyle = .fullScreen
                                 self.present(mainTabBar, animated: true)
                                 
                             case .failure(_):
                                 self.present(SetUpProfileViewController(currentUser: user), animated: true)
                             }
                         }
                     }
                 case .failure(let error):
                     self.showAlert(with: "Ошибка!", and: error.localizedDescription)
                 }
             }
         }
         let registrationButtonAction = UIAction{[weak self] _ in
             guard let self = self else {return}
             self.dismiss(animated: true) {
                 self.delegate?.toRegistrationVC()
             }
         }
         loginButton.addAction(loginButtonAction, for: .touchUpInside)
         registrationButton.addAction(registrationButtonAction, for: .touchUpInside)
         googleButton.addAction(googleButtonAction, for: .touchUpInside)
     }
}
// MARK: - Setup constraints

extension LoginViewController {
    private func setUpConstraints (){
        let loginWithView = ButtonFormView(label: loginWithlabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews: [loginWithView, orLabel, emailStackView, passwordStackView, loginButton], axis: .vertical, spacing: 40)
        registrationButton.contentHorizontalAlignment = .center
        let bottomStackView = UIStackView(arrangedSubviews: [needAnAccountLabel, registrationButton], axis: .horizontal, spacing: 10)
        bottomStackView.alignment = .firstBaseline
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 80),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
            
            
        ])
    }
}

// MARK: - UITextfieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
// MARK: - SwiftUI

import SwiftUI
struct LoginVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        let loginViewController = LoginViewController()
        func makeUIViewController(context: Context) -> some UIViewController {
            return loginViewController
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
