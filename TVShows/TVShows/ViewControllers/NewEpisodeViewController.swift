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
    @IBOutlet private weak var cameraButton: UIButton!
    @IBOutlet private weak var episodeTitle: UITextField!
    @IBOutlet private weak var seasonNumber: UITextField!
    @IBOutlet private weak var episodeNumber: UITextField!
    @IBOutlet private weak var episodeDescription: UITextField!
    
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
    
    // MARK: Class methods
    private func setupNavigationBar() {
        
        navigationItem.title = "Add episode"
        
         let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didSelectCancel))
        
        let addButton = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(didSelectAddShow))
    
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = addButton
        
        cancelButton.tintColor = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1)
        addButton.tintColor = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1)
    }
    
    
    
    @objc func didSelectCancel() {
        self.dismiss(animated: true, completion: nil)
    }
        
    
    @objc func didSelectAddShow() {
        SVProgressHUD.show()
        
        if let token = token {
            let headers = ["Authorization": token]
        
            guard let title = episodeTitle.text, let description = episodeDescription.text, let episodeNumber =  episodeNumber.text, let seasonNumber = seasonNumber.text, let showID = showID else {
                print("text fields are empty")
                return
            }
        
            let parameters: [String: String] = [
                "showId": showID,
                "title": title,
                "description": description,
                "episodeNumber": episodeNumber,
                "season": seasonNumber
            ]
        
            Alamofire.request("https://api.infinum.academy/api/episodes",
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers)
                    .validate()
                    .responseString {[weak self] (response:DataResponse<String>) in
                        switch response.result{
                        case .success:
                            SVProgressHUD.showSuccess(withStatus: "Success")
                            self?.dismiss(animated: true, completion: nil)
                            self?.delegate?.didAddEpisode()
                        case .failure(let error):
                            SVProgressHUD.showError(withStatus: "Failure")
                            self?.showAlert(title: "Error", message: error.localizedDescription)
                        }
                    }
                SVProgressHUD.dismiss()
        }
    }
}

protocol resultSuccessDelagate: class {
    func didAddEpisode()
}
