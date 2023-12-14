//
//  ParentViewController.swift
//  ToDo
//
//  Created by Светлана Полоротова on 02.11.2023.
//

import UIKit

class ParentViewController: UIViewController {
    var window: UIWindow? { UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.last }

    deinit {
        print("\(String(describing: type(of: self))) released")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backButtonDisplayMode = .minimal
    }

    static func navigateToAuth() {
        UserManager.shared.reset()
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.last?.rootViewController = storyboard.instantiateInitialViewController()
    }

    func showSnackbar(message: String, duration: TimeInterval = 3.0) {
        let snackbarLabel = UILabel()
        snackbarLabel.translatesAutoresizingMaskIntoConstraints = false
        snackbarLabel.textColor = UIColor.Color.white
        snackbarLabel.textAlignment = .center
        snackbarLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        snackbarLabel.numberOfLines = 2
        snackbarLabel.text = message

        let snackbarContainer = UIView()
        snackbarContainer.backgroundColor = UIColor.Color.snackbar
        snackbarContainer.alpha = 0
        snackbarContainer.translatesAutoresizingMaskIntoConstraints = false

        window?.addSubview(snackbarContainer)
        snackbarContainer.addSubview(snackbarLabel)

        let statusBarHeight = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.statusBarManager?.statusBarFrame.height ?? 54

        NSLayoutConstraint.activate([
            snackbarContainer.topAnchor.constraint(equalTo: view.topAnchor),
            snackbarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            snackbarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            snackbarLabel.topAnchor.constraint(equalTo: snackbarContainer.topAnchor, constant: statusBarHeight + 8),
            snackbarLabel.leadingAnchor.constraint(equalTo: snackbarContainer.leadingAnchor, constant: 16),
            snackbarContainer.trailingAnchor.constraint(equalTo: snackbarLabel.trailingAnchor, constant: 16),
            snackbarContainer.bottomAnchor.constraint(equalTo: snackbarLabel.bottomAnchor, constant: 20),
        ])

        UIView.animate(withDuration: 0.3, animations: {
            snackbarContainer.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: duration, options: [], animations: {
                snackbarContainer.alpha = 0
            }, completion: { _ in
                snackbarContainer.removeFromSuperview()
            })
        })
    }
}
