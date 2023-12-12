//
//  ParentViewController.swift
//  ToDo
//
//  Created by Светлана Полоротова on 02.11.2023.
//

import UIKit

class ParentViewController: UIViewController {
    deinit {
        print("\(String(describing: type(of: self))) released")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backButtonDisplayMode = .minimal
    }

    func navigateToAuth() {
        UserManager.shared.set(accessToken: nil)
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        DispatchQueue.main.async {
            self.view.window?.rootViewController = storyboard.instantiateInitialViewController()
        }
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

        view.window?.addSubview(snackbarContainer)
        snackbarContainer.addSubview(snackbarLabel)

        NSLayoutConstraint.activate([
            snackbarContainer.topAnchor.constraint(equalTo: view.topAnchor),
            snackbarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            snackbarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        NSLayoutConstraint.activate([
            snackbarLabel.topAnchor.constraint(equalTo: snackbarContainer.topAnchor, constant: 54),
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
