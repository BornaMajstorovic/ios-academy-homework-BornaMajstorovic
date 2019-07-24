//
//  NewEpisodeViewController.swift
//  TVShows
//
//  Created by Borna on 22/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class NewEpisodeViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var cameraButton: UIButton!

    // MARK: Properties
    var showID: String?
    var token: String?
    weak var delegate: resultSuccessDelagate?

    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.setBackgroundImage(UIImage(named: "ic-camera"), for: .normal)
        
        setupNavigationBar()
        
    }
    
    // MARK: Actions
    
    // MARK: Class methods
    private func setupNavigationBar() {
    
        if let newEpisodeViewController = storyboard?.instantiateViewController(withIdentifier: "NewEpisodeViewController") as? NewEpisodeViewController {
            let navigationController = UINavigationController(rootViewController: newEpisodeViewController)
            present(navigationController, animated: true)
        }
        
        navigationItem.title = "Add episode"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didSelectAddShow))
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(didSelectAddShow))
    }
    
    @objc func didSelectAddShow() {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "showId": "string",
            "title": "string",
            "description": "string",
            "episodeNumber": "string",
            "season": "string"
        ]
        
        Alamofire.request("https://api.infinum.academy/api/episodes",
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default)
                 .validate()
            .responseString {[weak self] (response:DataResponse<String>) in
                switch response.result{
                case .success(let dissmis):
                    self?.navigationController?.popViewController(animated: true)
                    self?.delegate?.didAddEpisode()
                case .failure(let error):
                   self?.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
        
      
}

}

protocol resultSuccessDelagate: class {
    func didAddEpisode()
}
