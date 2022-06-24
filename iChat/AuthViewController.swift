//
//  ViewController.swift
//  iChat
//
//  Created by Андрей Русин on 23.06.2022.
//

import UIKit

class AuthViewController: UIViewController {
    let logoImageView = UIImageView(image: UIImage(named: "Logo"), contentMode: .scaleAspectFit)
    
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backGroundColor: .white, isShadow: true)
    let eMailbutton = UIButton(title: "E-mail", titleColor: .white, backGroundColor: .buttonDark(),  isShadow: false)
    let loginButton = UIButton(title: "Login", titleColor: .buttonRed(), backGroundColor: .white,  isShadow: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpConstraints()
        
    }
    private func setUpConstraints(){
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       
        
        
        
        let googleView = ButtonFormView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormView(label: emailLabel, button: eMailbutton)
        let loginView = ButtonFormView(label: alreadyOnboardLabel, button: loginButton)
       
        let stackView = UIStackView(arrangedSubviews: [googleView,emailView,loginView], axis: .vertical, spacing: 40)
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
  
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 160),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
      
        
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
