//
//  ChatRequestViewController.swift
//  iChat
//
//  Created by Андрей Русин on 20.07.2022.
//

import UIKit

class ChatRequestViewController: UIViewController {
    let containerView = UIView()
    let imageView = UIImageView(image: UIImage(named: "Human1"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Peter Pen", font: .systemFont(ofSize: 20, weight: .light))
    let aboutMeLabel = UILabel(text: "Start new chat", font: .systemFont(ofSize: 16, weight: .light))
    let acceptButton = UIButton(title: "Accept", titleColor: .white, backGroundColor: .green, font: .laoSangamMN20(), isShadow: false, cornerRadius: 10)
    let denyButton = UIButton(title: "Deny", titleColor: .denyButtonColor(), backGroundColor: .mainWhite(), font: .laoSangamMN20(), isShadow: false, cornerRadius: 10)
    private var chat: MChat
    weak var delegate: WaitingChatsNavigation?
    
// MARK: chat init
    
    init(chat: MChat) {
        self.chat = chat
        nameLabel.text = chat.friendUsername
        imageView.sd_setImage(with: URL(string: chat.friendAvatarStringURL), completed: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite()
        customizeElements()
        setupConstraints()
        setUpButtonsAction()
    }
    
    // MARK: - customizeElements
    
    private func customizeElements() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        denyButton.layer.borderWidth = 1.2
        denyButton.layer.borderColor = UIColor.denyButtonColor().cgColor
        
        
        
        aboutMeLabel.numberOfLines = 0
        
        containerView.backgroundColor = .mainWhite()
        containerView.layer.cornerRadius = 30
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.acceptButton.applyGradients(cornerRadius: 10)
    }
    
// MARK: - setUpButtonsActions
    
    private func setUpButtonsAction() {
        let denyButtonAction = UIAction { _ in
            self.dismiss(animated: true)
            self.delegate?.removeWaitingChat(chat: self.chat)
        }
        let acceptButtonAction = UIAction { _ in
            self.dismiss(animated: true)
            self.delegate?.makeChatActive(chat: self.chat)
        }
        denyButton.addAction(denyButtonAction, for: .touchUpInside)
        acceptButton.addAction(acceptButtonAction, for: .touchUpInside)
    }
}

// MARK: - Setup constraints

extension ChatRequestViewController {
    private func setupConstraints() {
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutMeLabel)
        acceptButton.applyGradients(cornerRadius: 10)
        let buttonStackView = UIStackView(arrangedSubviews: [acceptButton, denyButton], axis: .horizontal, spacing: 7)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.distribution = .fillEqually
        containerView.addSubview(buttonStackView)
        
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
            
            buttonStackView.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 24),
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            buttonStackView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}

//// MARK: - SwiftUI
//
//import SwiftUI
//
//struct ChatrequestVCProvider: PreviewProvider {
//    static var previews: some View {
//        ContainerView().edgesIgnoringSafeArea(.all)
//    }
//    
//    struct ContainerView: UIViewControllerRepresentable {
//        let chatRequestVC = ChatRequestViewController()
//        func makeUIViewController(context: UIViewControllerRepresentableContext<ChatrequestVCProvider.ContainerView>) -> some ChatRequestViewController {
//            return chatRequestVC
//        }
//        func updateUIViewController(_ uiViewController: ChatrequestVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ChatrequestVCProvider.ContainerView>) {
//        }
//    }
//}
