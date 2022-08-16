//
//  SignUpViewController.swift
//  iChat
//
//  Created by Андрей Русин on 04.07.2022.
//

import UIKit

class RegistrationViewController: UIViewController {
    weak var delegate: AuthNavigationDelegate?
    let welcomeLabel = UILabel(text: "Glad to see you!")
    let emailLabel = UILabel(text: "E-mail")
    let passwordLabel = UILabel(text: "Password")
    let confirmPasswordLabel = UILabel(text: "Confirm password")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    let registrationButton = UIButton(title: "Register", titleColor: .white, backGroundColor: .buttonDark(),  isShadow: true, cornerRadius: 4)
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir20()
        return button
    }()
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    let confirmPasswordTextField = OneLineTextField(font: .avenir20())
    
// MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraints()
        setUpButtonsActions()
    }
}

// MARK: - setUpButtonsActions

extension RegistrationViewController {
    private func setUpButtonsActions() {
        lazy var signInButtonAction = UIAction { [weak self] _ in
            guard let self = self else {return}
            AuthService.shared.register(email: self.emailTextField.text, password: self.passwordTextField.text, confirmPassword: self.confirmPasswordTextField.text) { (result) in
                switch result {
                    
                case .success(let user):
                    self.showAlert(with: "Успешно", and: "Теперь вы зарегистрированы в iChat") {
                        self.present(SetUpProfileViewController(currentUser: user), animated: true)
                    }
                case .failure(let error):
                    self.showAlert(with: "Ошибка", and: error.localizedDescription)
                }
            }
        }
        lazy var loginButtonAction = UIAction {[weak self] _ in
            guard let self = self else {return}
            self.dismiss(animated: true) {
                self.delegate?.toLoginVC()
            }}
        registrationButton.addAction(signInButtonAction, for: .touchUpInside)
        loginButton.addAction(loginButtonAction, for: .touchUpInside)
    }
}

// MARK: - SetUpConstraints

extension RegistrationViewController {
    private func setUpConstraints(){
        view.backgroundColor = .white
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passWordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        let confirmPasswordStackView = UIStackView(arrangedSubviews: [confirmPasswordLabel, confirmPasswordTextField], axis: .vertical, spacing: 0)
        registrationButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews: [emailStackView, passWordStackView, confirmPasswordStackView, registrationButton], axis: .vertical, spacing: 40)
        loginButton.contentHorizontalAlignment = .leading
        let bottomStackView = UIStackView(arrangedSubviews: [alreadyOnboardLabel, loginButton], axis: .horizontal, spacing: 10)
        bottomStackView.alignment = .firstBaseline
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 160),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 60),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
            
        ])
    }
}

// MARK: - showAlert Function

extension UIViewController {
    func showAlert(with title: String, and message: String, completion: @escaping () -> Void = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {(_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

// MARK: - SwiftUI

import SwiftUI
struct SignUpViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        let signUpViewController = RegistrationViewController()
        func makeUIViewController(context: Context) -> some UIViewController {
            return signUpViewController
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
