//
//  ProfileViewController.swift
//  ToDo
//
//  Created by Светлана Полоротова on 08.12.2023.
//

import Dip
import Kingfisher
import UIKit

final class ProfileViewController: ParentViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @Injected private var networkManager: ProfileManager!

    private var profile: ProfileResponse?
    private var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.Profile.title

        avatarImageButton.layer.cornerRadius = avatarImageButton.frame.height / 2
        avatarImageButton.imageView?.contentMode = .scaleAspectFit
        avatarImageButton.imageView?.clipsToBounds = true
        avatarImageButton.contentHorizontalAlignment = .fill
        avatarImageButton.contentVerticalAlignment = .fill
        avatarImageButton.clipsToBounds = true

        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 2

        exitButton.setup(mode: .destructive)
        exitButton.setTitle(L10n.Profile.exitButton, for: .normal)

        getProfileData()
    }

    @IBOutlet private var avatarImageButton: UIButton!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var exitButton: TextButton!

    @IBAction private func didTapAvatar(_: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }

    private func getProfileData() {
        Task {
            do {
                profile = try await networkManager.profile()
                nameLabel.text = profile?.name
                loadAvatarImage()
            } catch {
                DispatchQueue.main.async {
                    self.showSnackbar(message: error.localizedDescription)
                }
            }
        }
    }

    private func loadAvatarImage() {
        guard let imageId = profile?.imageId else {
            return
        }

        let modifier = AnyModifier { request in
            var request = request
            if let token = UserManager.shared.accessToken {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            return request
        }

        avatarImageButton.kf.cancelImageDownloadTask()
        let urlString = "http://45.144.64.179/api/user/photo/\(imageId)"
        avatarImageButton.kf.setImage(
            with: URL(string: urlString),
            for: .normal,
            placeholder: UIImage.Profile.profileAvatar,
            options: [.requestModifier(modifier)]
        )
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage, let imageData = selectedImage.jpegData(compressionQuality: 0.9) {
            let fileName = (info[UIImagePickerController.InfoKey.imageURL] as? URL)?.lastPathComponent ?? "profile_photo.jpg"

            Task {
                do {
                    _ = try await networkManager.uploadProfilePhoto(imageData: imageData, fileName: fileName)
                    self.avatarImageButton.setImage(selectedImage, for: .normal)
                } catch {
                    DispatchQueue.main.async {
                        self.showSnackbar(message: error.localizedDescription)
                    }
                }
            }
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
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
