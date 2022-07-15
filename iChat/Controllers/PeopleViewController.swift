//
//  PeopleViewController.swift
//  iChat
//
//  Created by Андрей Русин on 06.07.2022.
//

import UIKit

class PeopleViewController: UIViewController {
    var users: [MUser] = Bundle.main.decode([MUser].self, from: "users.json")
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


override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setUpSearchBar()
    setUpCollectionView()
    createDataSource()
    reloadData()
}
    private func setUpCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseID)

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
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
    private func reloadData() {
        var snapShop = NSDiffableDataSourceSnapshot<Section, MUser>()
        snapShop.appendSections([.users])
        snapShop.appendItems(users, toSection: .users)
        dataSource?.apply(snapShop, animatingDifferences: true)
    }
}
// MARK: - Data Source
extension PeopleViewController {
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MUser>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section)
            else {fatalError("Unknown section kind")}
            switch section {
                
            case .users:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath)
                cell.backgroundColor = .systemBlue
                return cell
            }
        })
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
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
// MARK: - Setup Layout
extension PeopleViewController {
private func createCompositionalLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
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
// MARK: - UISearchBarDelegate
extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

