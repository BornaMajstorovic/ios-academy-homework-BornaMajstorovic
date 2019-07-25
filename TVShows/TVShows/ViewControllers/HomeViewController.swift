//
//  HomeViewController.swift
//  TVShows
//
//  Created by Borna on 15/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HomeViewController: UIViewController {
    

    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    private let TITLE = "Shows"
    var loginUser:User?
    var token:String?
    
    private var shows:[Show]?

    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = TITLE
        fetchShows()
       
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
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ShowTableViewCell.IDENTIFIER, for: indexPath) as? ShowTableViewCell {
            
            if let showObject = shows?[indexPath.row] {
                cell.configure(with: showObject)
            }

            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.destructive, title: "Delete") { [weak self](action, indexPath) in
            guard let self = self else {return}
            self.shows?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil {
            if let showObject = shows?[indexPath.row] {
                    navigateFromHome(showObject: showObject)
            }
        }
    }
}

// MARK: API calls

private extension HomeViewController {
    func fetchShows() {
        SVProgressHUD.show()
        if let token = token {
            let headers = ["Authorization": token]
            Alamofire.request("https://api.infinum.academy/api/shows", method: .get, encoding: JSONEncoding.default, headers:headers)
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {[weak self] (response:DataResponse<[Show]>) in
                    switch response.result {
                    case .success(let arrayOfShows):
                        SVProgressHUD.showSuccess(withStatus: "Success")
                        self?.shows = arrayOfShows
                        self?.tableView.reloadData()
                    case .failure(let error):
                        SVProgressHUD.showError(withStatus: "Failure")
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    }
                     SVProgressHUD.dismiss()
            }
        }
    }
    
}
