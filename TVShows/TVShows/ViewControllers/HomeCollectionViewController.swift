//
//  HomeCollectionViewController.swift
//  TVShows
//
//  Created by Borna on 28/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit
import UIKit
import Alamofire
import SVProgressHUD
import KeychainAccess
//import Kingfisher


final class HomeCollectionViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: Properties
    var userFromKeychain:(username:String, password:String)?
    var loginUser:User?
    var token:String?
    var keychain: Keychain?
    private let itemsPerRow: CGFloat = 2
    
    private var shows:[Show]?
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title =  "Shows"
        fetchShows()
        setUpNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = userFromKeychain {
            loginUserWith(email: user.username, password: user.password)
        }
    }
    
    // MARK: Class methods
    private func navigateFromHome(showObject: Show){
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        
        if let showDetailsViewController = storyBoard.instantiateViewController(withIdentifier:              "ShowDetailsViewController") as? ShowDetailsViewController {
            showDetailsViewController.showID = showObject.id
            showDetailsViewController.token = token
            navigationController?.pushViewController(showDetailsViewController, animated: true)
        }
    }
    
    func setUpNavigationBar() {
        let logoutItem = UIBarButtonItem.init(image: UIImage(named: "ic-logout"), style: .plain, target: self, action: #selector(logoutActionHandler))
        navigationItem.leftBarButtonItem = logoutItem
        
        let gridView = UIBarButtonItem(image: UIImage(named: "ic-gridview"), style: .plain, target: self, action: #selector(toggleActionHandler))
        navigationItem.rightBarButtonItem = gridView
        
    }
    //on logout deleate all stored credentials
    
    @objc private func logoutActionHandler() {
        UserCredentials.shared.deleteUser { userDeleted in
            if userDeleted {
                guard let initialNavigationController = storyboard?.instantiateViewController(withIdentifier: "initialNavigationController") as? UINavigationController, let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else { return }
                    
                    initialNavigationController.viewControllers = [loginViewController]
                    self.present(initialNavigationController, animated: true, completion: nil)

            } else {
                //TODO: Show error
            }
        }
    }
    
    @objc private func toggleActionHandler() {
        
    }
    
    
}

extension HomeCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowCollectionViewCell.IDENTIFIER, for: indexPath) as? ShowCollectionViewCell {
            
            if let showObject = shows?[indexPath.row] {
                cell.configure(with: showObject)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//        let availableWidth = view.frame.width - paddingSpace
//        let widthPerItem = availableWidth / itemsPerRow
//        
//        return CGSize(width: widthPerItem, height: widthPerItem)
//    }
    
    
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
                    guard let self = self else {return}
                    UserCredentials.shared.userToken = loginData.token
                    self.token = loginData.token
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: "Failure")
                    guard let self = self else {return}
                    print(error.localizedDescription)
                }
                SVProgressHUD.dismiss()
        }
    }
    
}

extension HomeCollectionViewController{
    func fetchShows() {
        SVProgressHUD.show()
        guard let token = token else {return}
            let headers = ["Authorization": token]
            Alamofire.request("https://api.infinum.academy/api/shows", method: .get, encoding: JSONEncoding.default, headers:headers)
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {[weak self] (response:DataResponse<[Show]>) in
                    switch response.result {
                    case .success(let arrayOfShows):
                        SVProgressHUD.showSuccess(withStatus: "Success")
                        guard let self = self else {return}
                        self.shows = arrayOfShows
                        self.collectionView.reloadData()
                    case .failure(let error):
                        SVProgressHUD.showError(withStatus: "Failure")
                        guard let self = self else {return }
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                    SVProgressHUD.dismiss()
            
        }
    }
}

