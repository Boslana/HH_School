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
        guard let window = window else {
            return
        }

        let snackbarLabel = UILabel()
        snackbarLabel.translatesAutoresizingMaskIntoConstraints = false
        snackbarLabel.textColor = UIColor.Color.white
        snackbarLabel.textAlignment = .center
        snackbarLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        snackbarLabel.numberOfLines = 2
        snackbarLabel.text = message

        let snackbarContainer = UIView()
        snackbarContainer.isUserInteractionEnabled = true
        snackbarContainer.backgroundColor = UIColor.Color.snackbar
        snackbarContainer.alpha = 0
        snackbarContainer.translatesAutoresizingMaskIntoConstraints = false

        window.addSubview(snackbarContainer)
        snackbarContainer.addSubview(snackbarLabel)

        let statusBarHeight = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.statusBarManager?.statusBarFrame.height ?? 54

        NSLayoutConstraint.activate([
            snackbarContainer.topAnchor.constraint(equalTo: window.topAnchor),
            snackbarContainer.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            snackbarContainer.trailingAnchor.constraint(equalTo: window.trailingAnchor),

            snackbarLabel.topAnchor.constraint(equalTo: snackbarContainer.topAnchor, constant: statusBarHeight + 8),
            snackbarLabel.leadingAnchor.constraint(equalTo: snackbarContainer.leadingAnchor, constant: 16),
            snackbarContainer.trailingAnchor.constraint(equalTo: snackbarLabel.trailingAnchor, constant: 16),
            snackbarContainer.bottomAnchor.constraint(equalTo: snackbarLabel.bottomAnchor, constant: 20),
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideSnackbar(_:)))
        snackbarContainer.addGestureRecognizer(tapGesture)

        UIView.animate(withDuration: 0.3) {
            snackbarContainer.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if snackbarContainer.superview != nil {
                UIView.animate(withDuration: 0.3, animations: {
                    snackbarContainer.alpha = 0
                }, completion: { _ in
                    snackbarContainer.removeFromSuperview()
                })
            }
        }
    }

    @objc
    func hideSnackbar(_ sender: UITapGestureRecognizer) {
        if let snackbarContainer = sender.view {
            snackbarContainer.removeFromSuperview()
        }
    }
}
