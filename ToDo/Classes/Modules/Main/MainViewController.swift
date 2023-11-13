//
//  MainViewController.swift
//  ToDo
//
//  Created by Светлана Полоротова on 31.10.2023.
//

import UIKit

final class MainViewController: ParentViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyimageView.image = UIImage.Main.empty
        emptyLable.text = L10n.Main.emptyLable
        emptyButton.setTitle(L10n.Main.emptyButton, for: .normal)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.Main.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.Main.profileButton, style: .plain, target: self, action: nil)
        
        emptyButton.setup(mode: PrimaryButton.Mode.large)
    }
    
    @IBOutlet private var emptyimageView: UIImageView!
    @IBOutlet private var emptyLable: UILabel!
    @IBOutlet private var emptyButton: PrimaryButton!
    
    @IBAction private func didTapEmptyButton() {}
}
