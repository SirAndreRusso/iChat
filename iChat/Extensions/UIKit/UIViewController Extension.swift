//
//  UIViewController Extension.swift
//  iChat
//
//  Created by Андрей Русин on 19.07.2022.
//

import UIKit

extension UIViewController {
    func configure<T: SelfConfiguringCell, U: Hashable>(collectionView: UICollectionView, cellType: T.Type, with value: U, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else {fatalError("Unable to dequeue \(cellType)")}
        cell.configure(with: value)
        return cell
    }
}

// MARK: - showAlert Function

extension UIViewController {
    func showAlert(with title: String, and message: String, completion: @escaping () -> Void = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {(_) in
            completion()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
