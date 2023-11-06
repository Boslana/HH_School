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

        userNameTextField.placeholder = L10n.SignUp.userNameTextFieldPlaceholder
        emailTextField.placeholder = L10n.SignUp.emailTextFieldPlaceholder
        passwordTextField.placeholder = L10n.SignUp.passwordTextFieldPlaceholder
        
        signUpButton.setTitle(L10n.SignUp.signUpButton, for: .normal)
        
        addTapToHideKeyboardGesture()
    }
    
    @IBOutlet private var userNameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    
    @IBOutlet private var signUpButton: UIButton!
}
