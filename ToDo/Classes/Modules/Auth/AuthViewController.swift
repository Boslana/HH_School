//
//  ViewController.swift
//  ToDo
//
//  Created by Светлана Полоротова on 26.10.2023.
//

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
        
        passwordTextField.enableSecurityMode()
        
        addTapToHideKeyboardGesture()
    }
    
    @IBOutlet private var emailTextField: TextInput!
    @IBOutlet private var passwordTextField: TextInput!
    
    @IBOutlet private var signInButton: UIButton!
    @IBOutlet private var signUpButton: UIButton!
    
    @IBAction private func didTapSignIn() {
        passwordTextField.show(error: "Ошибка!")
     //   let storyboard = UIStoryboard(name: "Main", bundle: nil)
     //   let vc = storyboard.instantiateViewController(withIdentifier: "NavMainVC")
     //   view.window?.rootViewController = vc
    }
}
