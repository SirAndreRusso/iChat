//
//  ListViewController.swift
//  iChat
//
//  Created by Андрей Русин on 06.07.2022.
//

import UIKit
import FirebaseFirestore

class ListViewController: UIViewController {
    private let currentUser: MUser
    private var waitingThatListener: ListenerRegistration?
    var activeChats = [MChat]()
    var waitingChats = [MChat]()
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MChat>?
    enum Section: Int, CaseIterable{
        case waitingChats
        case activeChats
        func description() -> String {
            switch self {
            case .waitingChats:
                return "Waiting chats"
            case .activeChats:
                return "Active chats"
            }
        }
    }
    
// MARK: - currentUser init, waitingChatListener deinit
    
    init(currentUser: MUser){
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        //Отображаем имя пользователя в заголовке VC
        title = currentUser.username
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        waitingThatListener?.remove()
    }
// MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpSearchBar()
        createDataSource()
        reloadData()
        waitingThatListener = ListenerService.shared.waitingChatsObserve(chats: waitingChats, completion: { result in
            switch result {
            case .success(let waitingChats):
// TODO: - Сделать изначальную загрузку чатов из памяти устройства, и сравнивать этот массив с массивом из файрбейс, в случае отличий, показывать чатреквест вьюконтроллер
                if self.waitingChats != [], self.waitingChats.count <= waitingChats.count {
                    let chatRequestVC = ChatRequestViewController(chat: waitingChats.last!)
                    chatRequestVC.delegate = self
                    self.present(chatRequestVC, animated: true)
                }
                self.waitingChats = waitingChats
                self.reloadData()
            case .failure(let error):
                self.showAlert(with: "Ошибка!", and: error.localizedDescription)
            }
        })
    }
    
// MARK: - Setup Layout
    
    private func setUpCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(collectionView)
        
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseID)
        collectionView.delegate = self
    }
    private func reloadData() {
        var snapShop = NSDiffableDataSourceSnapshot<Section, MChat>()
        snapShop.appendSections([.waitingChats, .activeChats])
        snapShop.appendItems(activeChats, toSection: .activeChats)
        snapShop.appendItems(waitingChats, toSection: .waitingChats)
        dataSource?.apply(snapShop, animatingDifferences: true)
    }
    private func setUpSearchBar() {
        navigationController?.navigationBar.barTintColor = .mainWhite()
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
}

// MARK: - DataSource

extension ListViewController {
    private func createDataSource() {
            dataSource = UICollectionViewDiffableDataSource<Section, MChat>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chat) -> UICollectionViewCell? in
                guard let section = Section(rawValue: indexPath.section) else {
                    fatalError("Unknown section kind")
                }
                
                switch section {
                case .waitingChats:
                     return self.configure(collectionView: collectionView, cellType: WaitingChatCell.self, with: chat, for: indexPath)
                case .activeChats:
                    return self.configure(collectionView: collectionView, cellType: ActiveChatCell.self, with: chat, for: indexPath)
                }
            })

        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseID, for: indexPath) as? SectionHeader
            else {fatalError("Can not create new section header")}
            guard let section = Section(rawValue: indexPath.section)
            else {fatalError("Unknown section kind")}
            sectionHeader.configure(text: section.description(), font: .laoSangamMN20(), textColor: .sectionHeaderColor())
            return sectionHeader
        }
    }
}

// MARK: - WaitindChatNavigationDelegate

extension ListViewController: WaitingChatsNavigation {
    func removeWaitingChat(chat: MChat) {
        FirestoreService.shared.deleteWaitingChat(chat: chat) { result in
            switch result {
            case .success():
                self.showAlert(with: "Успешно", and: "Чат с \(chat.friendUsername) удален")
            case .failure(let error):
                self.showAlert(with: "Ошибка!", and: error.localizedDescription)
            }
        }
    }
    
    func makeChatActive(chat: MChat) {
        print(#function)
    }
    
    
}

// MARK: - UICollectionViewDelegate

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let chat = self.dataSource?.itemIdentifier(for: indexPath) else {return}
        guard let section = Section(rawValue: indexPath.section) else {return}
        switch section {
        case .waitingChats:
        let chatRequestVC = ChatRequestViewController(chat: chat)
            chatRequestVC.delegate = self
            self.present(chatRequestVC, animated: true)
        case .activeChats:
            print(indexPath)
        }
    }
}

// MARK: - SetUp layout

extension ListViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else {return nil}
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section")
            }
            switch section {
            case .activeChats:
                return self.createActiveChats()
            case .waitingChats:
                return self.createWaitingChats()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createWaitingChats()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88), heightDimension: .absolute(88))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createActiveChats()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(78))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    private func createSectionHeader() ->NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        return sectionHeader
    }
}
// MARK: - UISearchBarDelegate
extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
// MARK: - SwiftUI
import SwiftUI
struct ListViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        let tabBarVC = MainTabBarController()
        func makeUIViewController(context: Context) -> some UIViewController {
            return tabBarVC
        }
        func updateUIViewController(_ uiViewController: ListViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ListViewControllerProvider.ContainerView>) {
        }
    }
}
