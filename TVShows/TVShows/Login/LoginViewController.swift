//
//  LoginViewController.swift
//  TVShows
//
//  Created by Borna on 05/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD
import PromiseKit




final class LoginViewController: UIViewController {
    
    
    // MARK: Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    
    // MARK: Properties
    
    private var userSaved: User?
    private var token: String?
    
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    
    // MARK: Actions
    
    @IBAction func navigateFromLogin(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func loginUserButton(_ sender: UIButton) {
        guard let email = usernameTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty
        else {
                print("Username or password is empty")
                return
        }
        loginUserWith(email: email, password: password)
        
    }
    
    @IBAction func createAccountButton(_ sender: UIButton) {
        guard let email = usernameTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty
        else {
            print("Username or password is empty")
            return
        }
          registerUserWith(email: email, password: password)
    }
    
    @IBAction func checkButtonState(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }) { (success) in
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }
    }
    
    // MARK: Class methods
    func setUpView(){
        loginButtonOutlet.layer.cornerRadius = 8
        checkBoxButton.setImage(UIImage(named: "ic-checkbox-empty"), for: .normal)
        checkBoxButton.setImage(UIImage(named: "ic-checkbox-filled"), for: .selected)
    }
}


// TODO: promise call

// Mark: API calls

private extension LoginViewController {
    func registerUserWith(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
    
    
        Alamofire.request("https://api.infinum.academy/api/users",
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default)
                 .validate()
                 .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<User>) in
                    switch response.result {
                        case .success(let user):
                            SVProgressHUD.showSuccess(withStatus: "Success")
                            guard let self = self else {return}
                            self.userSaved = user
                            self.loginUserWith(email: email, password: password)
                        case .failure(let error):
                            SVProgressHUD.showError(withStatus: "Failure")
                            print("API failure: \(error)")
                        }
                     SVProgressHUD.dismiss()
                }
        
    }
}

private extension LoginViewController {
    func loginUserWith(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request("https://api.infinum.academy/api/users/sessions",
                           method: .post,
                           parameters: parameters,
                           encoding: JSONEncoding.default)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<LoginData>) in
                    switch response.result {
                    case .success(let loginData):
                        SVProgressHUD.showSuccess(withStatus: "Success")
                        self?.token = loginData.token
                    case .failure(let error):
                        SVProgressHUD.showError(withStatus: "Failure")
                        print(error.localizedDescription)
                    }
                SVProgressHUD.dismiss()
            }
    }
}
