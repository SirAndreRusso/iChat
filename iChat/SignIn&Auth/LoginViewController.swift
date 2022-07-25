//
//  LoginViewController.swift
//  iChat
//
//  Created by Андрей Русин on 04.07.2022.
//

import UIKit

class LoginViewController: UIViewController {
    let welcomeLabel = UILabel(text: "Welcome back")
    let loginWithlabel = UILabel(text: "Login with")
    let orLabel = UILabel(text: "Or")
    let emailLabel = UILabel(text: "E-mail")
    let passwordLabel = UILabel(text: "Password")
    let needAnAccountLabel = UILabel(text: "Need an account?")
    let googleButton = UIButton(title: "Google", titleColor: .black, backGroundColor: .white,  isShadow: true)
    let loginButton = UIButton(title: "Login", titleColor: .white, backGroundColor: .buttonDark(),  isShadow: false, cornerRadius: 4)
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir20()
        return button
    }()
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    
    //Actions
    lazy var loginButtonAction = UIAction {_ in
        AuthService.shared.login(email: self.emailTextField.text!, password: self.passwordTextField.text!) { (result) in
            switch result {
                
            case .success(let user):
                self.showAlert(with: "Success", and: "You loged in successfully")
            case .failure(let error):
                self.showAlert(with: "error", and: error.localizedDescription)
            }
        }
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleButton.customiedGoogleButton()
        view.backgroundColor = .white
        setUpConstraints()
        loginButton.addAction(loginButtonAction, for: .touchUpInside)
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
        signInButton.contentHorizontalAlignment = .leading
        let bottomStackView = UIStackView(arrangedSubviews: [needAnAccountLabel, signInButton], axis: .horizontal, spacing: 10)
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
            
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 60),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
            
            
        ])
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
