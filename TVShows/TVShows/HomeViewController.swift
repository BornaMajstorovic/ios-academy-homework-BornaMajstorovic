//
//  HomeViewController.swift
//  TVShows
//
//  Created by Borna on 15/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    private let TITLE = "Shows"
    var loginUser:User?
    var token:String?
    
    private var shows:[Show]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = TITLE
        fetchShows()
       
    }
    
    // MARK: Class methods
    
    private func fetchShows() {
        if let token = token {
            let headers = ["Authorization": token]
            Alamofire.request("https://api.infinum.academy/api/shows", method: .get, encoding: JSONEncoding.default, headers:headers)
                     .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (response:DataResponse<[Show]>) in
                        switch response.result {
                        case .success(let arrayOfShows):
                            self.shows = arrayOfShows
                        case .failure(let error):
                            self.showAlert(title: "Error", message: error.localizedDescription)
                        }
                    }
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
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.destructive, title: "Delete") { (action, indexPath) in
            self.shows?.remove(at: indexPath.row)
        }
        return [deleteAction]
    }
}
