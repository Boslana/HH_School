//
//  ViewController.swift
//  ToDo
//
//  Created by Светлана Полоротова on 26.10.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = L10n.Auth.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        emailTextField.placeholder = L10n.Auth.emailTextFieldPlaceholder
        passwordTextField.placeholder = L10n.Auth.passwordTextFieldPlaceholder
        
        signInButton.setTitle(L10n.Auth.signInButton, for: .normal)
        signUpButton.setTitle(L10n.Auth.signUpButton, for: .normal)
    }
    
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    
    @IBOutlet private var signInButton: UIButton!
    @IBOutlet private var signUpButton: UIButton!
    
    @IBAction private func didTapSignIn() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NavMainVC")
        view.window?.rootViewController = vc
    }
}
