//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Borna on 31/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit

final class CommentsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: Properties
    
    
    //MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    //MARK: Actions
    
    
    //MARK: Class methods
     func setUpNavigationBar() {
        navigationItem.title = "Comments"
        let backButton = UIBarButtonItem(image: UIImage(named: "ic-navigate-back"), style: .plain, target: self, action: #selector(backButtonHandler))
        navigationItem.leftBarButtonItem = backButton
    }
    @objc func backButtonHandler() {
       navigationController?.popViewController(animated: true)
    }

   
}
