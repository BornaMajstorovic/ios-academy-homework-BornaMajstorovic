//
//  LoginViewController.swift
//  TVShows
//
//  Created by Borna on 05/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    // MARK: Properties
    private var checkBoxCount = 0
   
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButtonOutlet.layer.cornerRadius = 6
        checkBoxButton.setImage(UIImage(named: "ic-checkbox-empty"), for: .normal)
        checkBoxButton.setImage(UIImage(named: "ic-checkbox-filled"), for: .selected)
        
    }
    
    
    // MARK: Actions

    @IBAction func checkBoxButtonAction(_ sender: UIButton) {
        
    }
    @IBAction func logInButton(_ sender: UIButton) {
        
    }
    
    @IBAction func createAccountButton(_ sender: UIButton) {
    }
    
    // MARK: Class methods
    
//    func setUpLoginButton() {
//        loginButtonOutlet.layer.cornerRadius = 6
//
//    }
//
//    func setUpCheckBoxButton() {
//        checkBoxButton.setImage(UIImage(named: "ic-checkbox-empty"), for: .normal)
//        checkBoxButton.setImage(UIImage(named: "ic-checkbox-filled"), for: .selected)
//
//
//    }
    
    @IBAction func checkMarkTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
        }) { (success) in
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }
    }
    
   
}
