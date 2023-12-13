//
//  ProfileViewController.swift
//  ToDo
//
//  Created by Светлана Полоротова on 08.12.2023.
//

import UIKit

final class ProfileViewController: ParentViewController {
    private var profile: ProfileResponse?
    private var statefulView: StatefullView? {
        view as? StatefullView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.Profile.title

        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2

        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 2

        exitButton.setup(mode: .destructive)
        exitButton.setTitle(L10n.Profile.exitButton, for: .normal)

        getProfileData()
    }

    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var exitButton: TextButton!

    private func getProfileData() {
        Task {
            do {
                profile = try await NetworkManager.shared.profile()
                nameLabel.text = profile?.name
            } catch {
                DispatchQueue.main.async {
                    self.showSnackbar(message: error.localizedDescription)
                }
            }
        }
    }

    @IBAction private func didTapExitButton(_: Any) {
        let alert = UIAlertController(title: L10n.Profile.alertTitle, message: nil, preferredStyle: .actionSheet)

        let exitAction = UIAlertAction(title: L10n.Profile.alertExitButton, style: .destructive) { _ in
            ProfileViewController.navigateToAuth()
        }
        alert.addAction(exitAction)

        let cancelAction = UIAlertAction(title: L10n.Profile.alertCancelButton, style: .cancel)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}
