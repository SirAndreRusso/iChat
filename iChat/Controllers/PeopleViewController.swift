//
//  PeopleViewController.swift
//  iChat
//
//  Created by Андрей Русин on 06.07.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PeopleViewController: UIViewController {
    //    var users: [MUser] = Bundle.main.decode([MUser].self, from: "users.json")
    private let currentUser: MUser
    var users = [MUser]()
    private var usersListener: ListenerRegistration?
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MUser>!
    enum Section: Int, CaseIterable{
        case users
        func description (usersCount: Int) -> String {
            switch self {
            case .users:
                return "\(usersCount) people nearby"
            }
        }
    }
    
    // MARK: - currentUser init
    
    init(currentUser: MUser){
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        //Отображаем имя пользователя в заголовке VC
        title = currentUser.username
    }
    deinit {
        usersListener?.remove()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        setUpCollectionView()
        createDataSource()
        userListenerSetUp()
    }
    
// MARK: - userListenerSetUp
    
    private func userListenerSetUp() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(signOut))
        usersListener = ListenerService.shared.usersObserve(users: users, completion: { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let users):
                self.users = users
                self.reloadData(with: nil)
            case .failure(let error):
                self.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        })
    }
    
    @objc private func signOut(){
        let alertController = UIAlertController(title: nil, message: "Are you shure you want to sign out?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Sign out", style: .destructive, handler: {(_) in
            do {
                try Auth.auth().signOut()
                UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
            } catch {
                print("Sign out error \(error.localizedDescription)")
            }
        }))
        present(alertController, animated: true)
    }
}

// MARK: - Data Source

extension PeopleViewController {
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MUser>(collectionView: collectionView, cellProvider: { [weak self] (collectionView, indexPath, user) -> UICollectionViewCell? in
            guard let self = self else {return nil}
            guard let section = Section(rawValue: indexPath.section)
            else {fatalError("Unknown section kind")}
            switch section {
                
            case .users:
                return self.configure(collectionView: collectionView, cellType: UserCell.self, with: user, for: indexPath)
            }
        })
        dataSource?.supplementaryViewProvider = {
            [weak self] (collectionView, kind, indexPath) in
            guard let self = self else {return nil}
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseID, for: indexPath) as? SectionHeader
            else {fatalError("Can not create new section header")}
            guard let section = Section(rawValue: indexPath.section)
            else {fatalError("Unknown section kind")}
            let items = self.dataSource.snapshot().itemIdentifiers(inSection: .users)
            sectionHeader.configure(text: section.description(usersCount: items.count), font: .systemFont(ofSize: 36, weight: .light), textColor: .label)
            return sectionHeader
        }
    }
}
    
// MARK: - Create Layout

extension PeopleViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else {return nil}
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section")
            }
            switch section {
            case .users:
                return self.createUsersSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createUsersSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(15)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 15, bottom: 0, trailing: 15)
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

// MARK: - setUp Layout

extension PeopleViewController {
    private func setUpCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseID)
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseId)
        collectionView.delegate = self
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
    private func reloadData(with searchText: String?) {
        let filtred = users.filter { (user) -> Bool in
            user.contains(filter: searchText)
        }
        var snapShop = NSDiffableDataSourceSnapshot<Section, MUser>()
        snapShop.appendSections([.users])
        snapShop.appendItems(filtred, toSection: .users)
        dataSource?.apply(snapShop, animatingDifferences: true)
    }
}

// MARK: - UISearchBarDelegate

extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
}

// MARK: - CollectionViewDelegate

extension PeopleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = self.dataSource.itemIdentifier(for: indexPath)
        else { return }
        let profileVC = ProfileViewController(user: user)
        present(profileVC, animated: true)
    }
}

// MARK: - SwiftUI

import SwiftUI

struct PeopleViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        let tabBarVC = MainTabBarController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<PeopleViewControllerProvider.ContainerView>) -> some MainTabBarController {
            return tabBarVC
        }
        func updateUIViewController(_ uiViewController: PeopleViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<PeopleViewControllerProvider.ContainerView>) {
        }
    }
}
