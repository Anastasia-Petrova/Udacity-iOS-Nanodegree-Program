//
//  SentMemesViewController.swift
//  Meme
//
//  Created by Anastasia Petrova on 21/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

class SentMemesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Sent Memes"
        setUpNavigationBar()
    }
    
    private func setUpNavigationBar() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,  action: #selector(pushEditorViewController))
        navigationItem.rightBarButtonItem = addItem
    }
    
    @objc func pushEditorViewController() {
        let vc = MemeEditorViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
