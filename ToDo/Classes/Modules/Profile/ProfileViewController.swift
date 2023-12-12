//
//  ProfileViewController.swift
//  ToDo
//
//  Created by Светлана Полоротова on 08.12.2023.
//

import UIKit

final class ProfileViewController: ParentViewController {
    var profile: ProfileResponse?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.Profile.title

        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2

        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 2

        if let profileName = profile?.name {
            nameLabel.text = profileName
        }

        exitButton.setup(mode: .destructive)
        exitButton.setTitle(L10n.Profile.exitButton, for: .normal)
    }

    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var exitButton: TextButton!

    @IBAction private func didTapExitButton(_: Any) {
        let alert = UIAlertController(title: L10n.Profile.alertTitle, message: nil, preferredStyle: .actionSheet)

        let exitAction = UIAlertAction(title: L10n.Profile.alertExitButton, style: .destructive) { [weak self] _ in
            self?.navigateToAuth()
        }
        alert.addAction(exitAction)

        let cancelAction = UIAlertAction(title: L10n.Profile.alertCancelButton, style: .cancel)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}
