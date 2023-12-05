//
//  ViewController.swift
//  ToDo
//
//  Created by Светлана Полоротова on 26.10.2023.
//

import Combine
import UIKit

final class AuthViewController: ParentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = L10n.Auth.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        emailTextField.setup(placeholder: L10n.Auth.emailTextFieldPlaceholder, text: nil)
        passwordTextField.setup(placeholder: L10n.Auth.passwordTextFieldPlaceholder, text: nil)
        
        signInButton.setTitle(L10n.Auth.signInButton, for: .normal)
        signUpButton.setTitle(L10n.Auth.signUpButton, for: .normal)
        
        signInButton.setup(mode: PrimaryButton.Mode.large)
        signUpButton.setup(mode: TextButton.Mode.normal)
        
        passwordTextField.enableSecurityMode()
        
        addTapToHideKeyboardGesture()
    }
    
    @IBOutlet private var emailTextField: TextInput!
    @IBOutlet private var passwordTextField: TextInput!
    
    @IBOutlet private var signInButton: PrimaryButton!
    @IBOutlet private var signUpButton: TextButton!
    
    @IBAction private func didTapSignIn() {
        var isValid = true
        
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
        }
        
        if isValid {
            Task {
                do {
                    let response = try await NetworkManager.shared.signIn(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
                    log.debug("\(response.accessToken)")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    view.window?.rootViewController = storyboard.instantiateInitialViewController()
                } catch {
                    DispatchQueue.main.async {
                        self.showAlert(title: L10n.NetworkErrorDescription.alertTitle, massage: error.localizedDescription)
                    }
                }
            }
        }
    }
}
