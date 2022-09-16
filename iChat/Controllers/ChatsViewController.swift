//
//  ChatsViewController.swift
//  iChat
//
//  Created by Андрей Русин on 19.08.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import IQKeyboardManagerSwift
import FirebaseFirestore
import PhotosUI

class ChatsViewController: MessagesViewController {
    private let user: MUser
    private let chat: MChat
    private var messages: [MMessage] = []
    private var messageListener: ListenerRegistration?
    
    // MARK: - init with muser and mchat, deinit with messageListener
    
    init(user: MUser, chat: MChat) {
        self.user = user
        self.chat = chat
        super .init(nibName: nil, bundle: nil)
        title = chat.friendUsername
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        messageListener?.remove()
    }
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.backgroundColor = .mainWhite()
        removeAvatar()
        configureMessageInputBar()
        delegatesSetUp()
        setUpMessageListener()
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(ChatsViewController.self)
    }
    
    // MARK: - Setup messageListener
    
    private func setUpMessageListener () {
        messageListener = ListenerService.shared.messagesObserve(chat: chat, completion: { result in
            
            switch result {
            case .success(var message):
                if let url = message.downloadURL{
                    StorageService.shared.downloadImage(url: url) { [weak self] result in
                        guard let self = self else {return}
                        switch result {
                            
                        case .success(let image):
                            message.image = image
                            self.insertNewMessage(message: message)
                        case .failure(let error):
                            self.showAlert(with: "Ошибка!", and: error.localizedDescription)
                        }
                    }
                } else {
                    
                    self.insertNewMessage(message: message)
                }
            case .failure(let error):
                self.showAlert(with: "Ошибка!", and: error.localizedDescription)
            }
        })
    }
    
    // MARK: - delegatesSetUp
    
    private func delegatesSetUp() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    private func insertNewMessage( message: MMessage) {
        guard !messages.contains(message) else {return}
        messages.append(message)
        messages.sort()
        let islatestMessage = messages.firstIndex(of: message) == messages.count - 1
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && islatestMessage
        messagesCollectionView.reloadData()
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToLastItem()
            }
        }
    }
    private func sendImage(image: UIImage) {
        StorageService.shared.uploadImageMessage(photo: image, from: self.user, to: chat) { result in
            switch result {
                
            case .success(let url):
                var message = MMessage(user: self.user, image: image)
                message.downloadURL = url
                FirestoreService.shared.sendMessage(chat: self.chat, message: message) { result in
                    switch result {
                        
                    case .success():
                        self.messagesCollectionView.reloadData()
                        self.messagesCollectionView.scrollToLastItem()
                        
                    case .failure(_):
                        self.showAlert(with: "Ошибка!", and: "Изображение не доставлено")
                    }
                }
            case .failure(let error):
                self.showAlert(with: "Ошибка!", and: error.localizedDescription)
            }
        }
    }
}

// MARK: - ConfigureMessageInputBar

extension ChatsViewController {
    func configureMessageInputBar() {
           messageInputBar.isTranslucent = true
           messageInputBar.separatorLine.isHidden = true
           messageInputBar.backgroundView.backgroundColor = .mainWhite()
           messageInputBar.inputTextView.backgroundColor = .white
           messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
           messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 36)
           messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 36, bottom: 14, right: 36)
           messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 0.4033635232)
           messageInputBar.inputTextView.layer.borderWidth = 0.2
           messageInputBar.inputTextView.layer.cornerRadius = 18.0
           messageInputBar.inputTextView.layer.masksToBounds = true
           messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
           
           
           messageInputBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
           messageInputBar.layer.shadowRadius = 5
           messageInputBar.layer.shadowOpacity = 0.3
           messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
           
           configureSendButton()
           configureCameraIcon()
       }
       
    func configureSendButton() {
           messageInputBar.sendButton.setImage(UIImage(named: "Sent"), for: .normal)
           messageInputBar.sendButton.applyGradients(cornerRadius: 10)
           messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
           messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
           messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
           messageInputBar.middleContentViewPadding.right = -38
       }
    func configureCameraIcon() {
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1)
        let cameraImage = UIImage(systemName: "camera")
        cameraItem.image = cameraImage
        
        let cameraButtonAction = UIAction { [weak self] _ in
            guard let self = self else {return}
            let cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                cameraPicker.sourceType = .camera
                UIApplication.getTopViewController()?.present(cameraPicker, animated: true)
            } else {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 10
            configuration.filter = .images
            let ImagePicker = PHPickerViewController(configuration: configuration)
            ImagePicker.delegate = self
            UIApplication.getTopViewController()?.present(ImagePicker, animated: true)
            }
        }
        
        cameraItem.addAction(cameraButtonAction, for: .primaryActionTriggered)
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
        
        
    }
}

// MARK: - MessagesDataSource

extension ChatsViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: user.id, displayName: user.username)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.item]
        
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if message.sentDate != Date() {
            print("DFDFDF")
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                                      attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 10),
                                                   NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        } else {return nil}
        
    }
}

// MARK: - MessagesLayoutDelegate

extension ChatsViewController: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
       // Лейбл с датой видно только когда дата в  сообщении отличается от даты предыдущего сообщения, и всегда виден у первого сообщения
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        guard indexPath.item > 0 else {return 30}
        let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        let previousMessage = messageForItem(at: previousIndexPath, in: messagesCollectionView)
        if message.sentDate.isInSameDayOf(date: previousMessage.sentDate){
            return 0
        } else {
            return 30
        }
    }
    private func removeAvatar() {
        if let layout = messagesCollectionView.collectionViewLayout as?  MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
        }
    }
    
}

// MARK: - MessagesDisplayDelegate

extension ChatsViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2392156863, alpha: 1) : .white
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
}

// MARK: - InputBarAccessoryViewDelegate

extension ChatsViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = MMessage(user: user, content: text)
        FirestoreService.shared.sendMessage(chat: chat, message: message) { result in
            switch result {
            case .success():
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem()
            case .failure(let error):
                self.showAlert(with: "Ошибка!", and: error.localizedDescription)
            }
        }
        inputBar.inputTextView.text = ""
    }
}

// MARK: - ScrollView Extentiion

extension UIScrollView {
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate

extension ChatsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        sendImage(image: image.scaledToSafeUploadSize!)
    }
}

// MARK: - PHPickerViewControllerDelegate

extension ChatsViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else {return}
        for result in results {
            let provider = result.itemProvider
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self.sendImage(image: image.scaledToSafeUploadSize!)
                          
                        }
                    }
                }
            }
        }
    }
}
