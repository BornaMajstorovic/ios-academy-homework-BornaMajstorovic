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
import KeychainAccess

final class LoginViewController: UIViewController {
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var checkBoxButton: UIButton!
    @IBOutlet private weak var loginButtonOutlet: UIButton!
    
    
    // MARK: Properties
    
    private var userSaved: User?
    private var token: String?
    private var saveUserSelected:Bool = true
    
    private var savedUserName: String?
    private var savedPassword: String?
    
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    
    // MARK: Actions

    
    @IBAction func loginUserButton(_ sender: UIButton) {
        guard
            let email = usernameTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty
        else {
                print("Username or password is empty")
                return
        }
        loginUserWith(email: email, password: password)
        
        sender.highlightButton()
    }
    
    func save(username:String, password:String) {
        UserCredentials.shared.saveUser(userName: username, password: password) { saved in
            if saved {
                print("saved")
                //TODO: Show save success
            } else {
                print("Not saved")
                //TODO: Show error
            }
        }
    }
    
    @IBAction func createAccountButton(_ sender: UIButton) {
        guard let email = usernameTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty
        else {
            print("Username or password is empty")
            return
        }
          registerUserWith(email: email, password: password)
        
         sender.highlightButton()
    }
    
    @IBAction func checkButtonState(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }) {(success) in
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }
        
        saveUserSelected.toggle()
    }
    
    // MARK: class methods
    
    private func navigateFromLogin() {
        
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        
        if let homeCollectionViewController = storyBoard.instantiateViewController(withIdentifier: "HomeCollectionViewController") as? HomeCollectionViewController {
            //flip over vc
            UIView.beginAnimations("animation", context: nil)
            UIView.setAnimationDuration(1.0)
            //setvc ide novi stack
            let navigationController = self.navigationController
            navigationController?.setViewControllers([self, homeCollectionViewController], animated: false)
            UIView.setAnimationTransition(UIView.AnimationTransition.flipFromLeft, for: (self.navigationController?.view)!, cache: false)
            UIView.commitAnimations()
        }
    }
    
    private func setUpView(){
        loginButtonOutlet.layer.cornerRadius = 8
        checkBoxButton.setImage(UIImage(named: "ic-checkbox-empty"), for: .normal)
        checkBoxButton.setImage(UIImage(named: "ic-checkbox-filled"), for: .selected)
    }
    
}



// TODO: promise call

// MARK: API calls

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
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self](response: DataResponse<LoginData>) in
                    switch response.result {
                    case .success(let loginData):
                        if self?.saveUserSelected ?? false {
                            self?.save(username: email, password: password)
                        }
                        SVProgressHUD.showSuccess(withStatus: "Success")
                        UserCredentials.shared.userToken = loginData.token
                    
                        self?.token = loginData.token
                        // check if user has stored credentials, get them and login automaticly
                        self?.navigateFromLogin()
            
                    case .failure(let error):
                        SVProgressHUD.showError(withStatus: "Failure")
//                        guard let self = self else {return}
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                        print(error.localizedDescription)
                    }
                SVProgressHUD.dismiss()
            }
    }
}

extension UIViewController {
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIButton {
    
     func highlightButton() {
        let transform: CGAffineTransform = isHighlighted ? .init(scaleX: 0.95, y: 0.95) : .identity
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 3,
            options: [.curveEaseInOut],
            animations: {
                self.transform = transform })
    }
}
