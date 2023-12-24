//
//  SignUpViewController.swift
//  ToDo
//
//  Created by Светлана Полоротова on 03.11.2023.
//

import Combine
import Dip
import UIKit

final class SignUpViewController: ParentViewController {
    @Injected private var networkManager: SignUpManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.SignUp.title

        userNameTextField.setup(placeholder: L10n.SignUp.userNameTextFieldPlaceholder, text: nil)
        emailTextField.setup(placeholder: L10n.SignUp.emailTextFieldPlaceholder, text: nil)
        passwordTextField.setup(placeholder: L10n.SignUp.passwordTextFieldPlaceholder, text: nil)

        signUpButton.setTitle(L10n.SignUp.signUpButton, for: .normal)

        signUpButton.setup(mode: PrimaryButton.Mode.large)

        passwordTextField.enableSecurityMode()

        addTapToHideKeyboardGesture()
    }

    @IBOutlet private var userNameTextField: TextInput!
    @IBOutlet private var emailTextField: TextInput!
    @IBOutlet private var passwordTextField: TextInput!

    @IBOutlet private var signUpButton: PrimaryButton!

    @IBAction private func didTapSignUpButton() {
        var isValid = true

        if userNameTextField.text?.isEmpty ?? true {
            userNameTextField.show(error: L10n.Validation.emptyTextField)
            isValid = false
        } else if !ValidationManager.isValid(commonText: userNameTextField.text, symbolsCount: 70) {
            userNameTextField.show(error: L10n.Validation.symbolsCountUserNameTextField)
            isValid = false
        }

        if emailTextField.text?.isEmpty ?? true {
            emailTextField.show(error: L10n.Validation.emptyTextField)
            isValid = false
        } else if !ValidationManager.isValid(email: emailTextField.text) {
            emailTextField.show(error: L10n.Validation.emailTextField)
            isValid = false
        }

        if passwordTextField.text?.isEmpty ?? true {
            passwordTextField.show(error: L10n.Validation.emptyTextField)
            isValid = false
        } else if !ValidationManager.isValid(commonText: passwordTextField.text, symbolsCount: 256) {
            passwordTextField.show(error: L10n.Validation.symbolsCountPasswordTextField)
            isValid = false
        }

        if isValid, let name = userNameTextField.text, let email = emailTextField.text, let password = passwordTextField.text {
            signUpButton.setLoading(true)
            Task {
                do {
                    let response = try await networkManager.signUp(name: name, email: email, password: password)
                    log.debug("\(response.accessToken)")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    view.window?.rootViewController = storyboard.instantiateInitialViewController()
                } catch {
                    signUpButton.setLoading(false)
                    DispatchQueue.main.async {
                        self.showSnackbar(message: error.localizedDescription)
                    }
                }
            }
        }
    }
}
