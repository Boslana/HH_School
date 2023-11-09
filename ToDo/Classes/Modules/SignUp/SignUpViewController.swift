//
//  SignUpViewController.swift
//  ToDo
//
//  Created by Светлана Полоротова on 03.11.2023.
//

import UIKit

final class SignUpViewController: ParentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.SignUp.title

        userNameTextField.setup(placeholder: L10n.SignUp.userNameTextFieldPlaceholder, text: nil)
        emailTextField.setup(placeholder: L10n.SignUp.emailTextFieldPlaceholder, text: nil)
        passwordTextField.setup(placeholder: L10n.SignUp.passwordTextFieldPlaceholder, text: nil)
        
        signUpButton.setTitle(L10n.SignUp.signUpButton, for: .normal)
        
        passwordTextField.enableSecurityModeWithoutEye()
        
        addTapToHideKeyboardGesture()
    }
    
    @IBOutlet private var userNameTextField: TextInput!
    @IBOutlet private var emailTextField: TextInput!
    @IBOutlet private var passwordTextField: TextInput!
    
    @IBOutlet private var signUpButton: UIButton!
    
    @IBAction private func didTapSignUpButton() {
        if userNameTextField.isEmpty() {
            userNameTextField.show(error: L10n.SignUp.errorEmptyTextField)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NavMainVC")
            view.window?.rootViewController = vc
            }
        }
    }
