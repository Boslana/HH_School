//
//  ParentViewController.swift
//  ToDo
//
//  Created by Светлана Полоротова on 02.11.2023.
//

import UIKit

class ParentViewController: UIViewController {
    deinit {
        print("\(String(describing: type(of: self))) released")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    func showAlert(title: String, massage: String) {
        let alertVC = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: L10n.NetworkErrorDescription.alertButton, style: .cancel))
        present(alertVC,animated: true)
    }
}
