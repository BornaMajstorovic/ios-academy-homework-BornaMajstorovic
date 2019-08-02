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
import Kingfisher


final class HomeCollectionViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: Properties
    var userFromKeychain: (username:String, password:String)?
    var loginUser: User?
    var token: String? = UserCredentials.shared.userToken
    var keychain: Keychain?
    private var showGridLayout: Bool = true
    
    private var shows:[Show]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let gridImage = UIImage(named: "ic-gridview")
    private let listImage = UIImage(named: "ic-listview")
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title =  "Shows"
        if token != nil {
            fetchShows()
        } else {

            guard let user = userFromKeychain else {return}
                loginUserWith(email: user.username, password: user.password)
            
        }
        setUpNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = userFromKeychain {
            loginUserWith(email: user.username, password: user.password)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: animated)

    }
    
    // MARK: Class methods
    private func navigateFromHome(showObject: Show){
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        
        if let showDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "ShowDetailsViewController") as? ShowDetailsViewController {
            showDetailsViewController.showObject = showObject
            navigationController?.pushViewController(showDetailsViewController, animated: true)
        }
    }
    
    func setUpNavigationBar() {
        let logoutItem = UIBarButtonItem.init(image: UIImage(named: "ic-logout"), style: .plain, target: self, action: #selector(logoutActionHandler))
        navigationItem.leftBarButtonItem = logoutItem
        
        let gridView = UIBarButtonItem(image: gridImage, style: .plain, target: self, action: #selector(toggleActionHandler))
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
                print("logout didn't happen")
            }
        }
    }
    
    @objc private func toggleActionHandler() {
        //toogle
        navigationItem.rightBarButtonItem?.image = listImage
        showGridLayout.toggle()
        collectionView.reloadData()
        navigationItem.rightBarButtonItem?.image = showGridLayout ? gridImage : listImage
        
    }
    
    
}

extension HomeCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if showGridLayout {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowCollectionViewCell.IDENTIFIER, for: indexPath) as? ShowCollectionViewCell {
                
                if let showObject = shows?[indexPath.row] {
                    UserCredentials.shared.showId = showObject.id
                    cell.configure(with: showObject)
                }
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowTableViewCell.IDENTIFIER, for: indexPath) as? ShowTableViewCell {
                
                if let showObject = shows?[indexPath.row] {
                    UserCredentials.shared.showId = showObject.id
                    cell.configure(with: showObject)
                }
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height:CGFloat = 120.0
        if showGridLayout {
            return CGSize(width: width / 2.1, height: height)
        } else {
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) != nil {
            if let showObject = shows?[indexPath.row] {
                navigateFromHome(showObject: showObject)
            }
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
    
    //Potrebno za login ako imamo stored credientials
    
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
                    self.fetchShows()
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: "Failure")
                    print(error.localizedDescription)
                }
                SVProgressHUD.dismiss()
        }
    }
    }

