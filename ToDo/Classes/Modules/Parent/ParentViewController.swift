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
}
