//
//  SetUpProfileViewController.swift
//  iChat
//
//  Created by Андрей Русин on 04.07.2022.
//

import UIKit
import FirebaseAuth
import PhotosUI
import SDWebImage

class SetUpProfileViewController: UIViewController {
    let welcomeLabel = UILabel(text: "Set up Profile!", font: .avenir26())
    let fullImageView = AddPhotoView()
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
        if let userName = currentUser.displayName {
            fullNametextField.text = userName
        }
        if let photoURL = currentUser.photoURL {
            fullImageView.circleImageView.sd_setImage(with: photoURL)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpConstraints()
        setUpTextFieldDelegate()
        setUpButtonsActions()
    }
    private func setUpTextFieldDelegate() {
        fullNametextField.delegate = self
        aboutmetextField.delegate = self
        fullNametextField.returnKeyType = .next
        aboutmetextField.returnKeyType = .go
    }
}

// MARK: - setUpButtonsActions

extension SetUpProfileViewController {
    private func setUpButtonsActions() {
        let goToChatsButtonAction = UIAction { [weak self] _ in
            guard let self = self else {return}
            FirestoreService.shared.saveProfileWith(id: self.currentUser.uid, email: self.currentUser.email!, username: self.fullNametextField.text, avatarImage: self.fullImageView.circleImageView.image, description: self.aboutmetextField.text, gender: self.genderSegmentedControl.titleForSegment(at: self.genderSegmentedControl.selectedSegmentIndex)) { (result) in
                switch result {
                    
                case .success(let muser):
                    self.showAlert(with: "Успешно!", and: "Приятного общения!") {
                        let mainTabBar = MainTabBarController(currentUser: muser)
                        mainTabBar.modalPresentationStyle = .fullScreen
                        self.present(mainTabBar, animated: true)
                    }
                case .failure(let error):
                    self.showAlert(with: "Ошибка", and: error.localizedDescription)
                }
            }
        }
        let plusButtonAction = UIAction { [weak self] (_) in
            guard let self = self else {return}
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            UIApplication.getTopViewController()?.present(picker, animated: true)
        }
        goToChatsButton.addAction(goToChatsButtonAction, for: .touchUpInside)
        fullImageView.plusButton.addAction(plusButtonAction, for: .touchUpInside)
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
        fullImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(fullImageView)
        view.addSubview(stackView)
        view.addSubview(goToChatsButton)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            fullImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            goToChatsButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            goToChatsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            goToChatsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}
//MARK: - UITextField Delegate

extension SetUpProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case fullNametextField:
            aboutmetextField.becomeFirstResponder()
        case aboutmetextField:
            aboutmetextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
//MARK: - PHPickerViewController Delegate

extension SetUpProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        guard !results.isEmpty else { return }
        for result in results {
            let provider = result.itemProvider
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self.fullImageView.circleImageView.image = image.scaledToSafeUploadSize
                            StorageService.shared.uploadImage(photo: image) { (result) in
                                switch result{
                                    
                                case .success(_):
                                    return
                                case .failure(let error):
                                    UIApplication.getTopViewController()?.showAlert(with: "Oops", and: "\(error)")
                                }
                            }
                        }
                    }
                }
            }
        }
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
