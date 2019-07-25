//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Borna on 22/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class ShowDetailsViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var newEpisodeButton: UIButton!
    @IBOutlet private weak var episodesNumberLabel: UILabel!
    @IBOutlet weak var customBackButton: UIButton!
    
    // MARK: Properties
    var showID: String?
    var token: String?
    
    private var episodes:[ShowEpisodes]? {
        didSet {
            tableView.reloadData()
        }
    }

    private var showDetails: ShowDetails? {
        didSet {
            titleLabel.text = showDetails?.title
            descriptionTextView.text = showDetails?.description
        }
    }
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchShowDetails()
        setUpView()

    }
    
    // MARK: Actions
    @IBAction private func newEpisodeButtonSelected(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        if let newEpisodeViewController = storyboard.instantiateViewController(withIdentifier: "NewEpisodeViewController") as? NewEpisodeViewController {
            let navigationController = UINavigationController(rootViewController: newEpisodeViewController)
            
            newEpisodeViewController.token = token
            newEpisodeViewController.showID = showID
            newEpisodeViewController.delegate = self

            present(navigationController, animated: true, completion: nil)
        }
    }
    @IBAction func customBackButtonSelected(_ sender: UIButton) {
         navigationController?.popViewController(animated: true)
    }
    
    //MARK: Class methods
    
    private func setUpView() {
        tableView.dataSource = self
        tableView.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
  

}

private extension ShowDetailsViewController {
     func fetchShowDetails() {
        SVProgressHUD.show()
        if let token = token {
            let headers = ["Authorization": token]
            guard let showID = showID else {return}
            
            Alamofire.request("https://api.infinum.academy/api/shows/" + "\(showID)", method: .get, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                    [weak self](response: DataResponse<ShowDetails>) in
                    switch response.result {
                    case .success(let showDetails):
                        SVProgressHUD.showSuccess(withStatus: "Success")
                        self?.showDetails = showDetails
                        self?.fetchShowListOfEpisodes()
                    case .failure(let error):
                        SVProgressHUD.showError(withStatus: "Failure")
                        error.localizedDescription
                    }
                SVProgressHUD.dismiss()
            }
        }
    }
    
     func fetchShowListOfEpisodes() {
        SVProgressHUD.show()
        if let token = token {
            let headers = ["Authorization": token]
            guard let showID = showID else {return}
            
            Alamofire.request("https://api.infinum.academy/api/shows/\(showID)/episodes", method: .get, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                    [weak self](response: DataResponse<[ShowEpisodes]>) in
                    switch response.result {
                    case .success(let episodes):
                        SVProgressHUD.showSuccess(withStatus: "Success")
                        self?.episodes = episodes
                        self?.episodesNumberLabel.text = "Episodes \(episodes.count)"
                    case .failure(let error):
                        SVProgressHUD.showError(withStatus: "Failure")
                        error.localizedDescription
                    }
                 SVProgressHUD.dismiss()
            }
        }
    }
}

extension ShowDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath)
        
        var seasonAndEp: String = "S"
        seasonAndEp.append(episodes![indexPath.row].season)
        seasonAndEp.append(" Ep")
        seasonAndEp.append(episodes![indexPath.row].episodeNumber)
        seasonAndEp.append(" ")
        
        let color = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1)
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        let attributedSeasonAndEp = NSMutableAttributedString(string: seasonAndEp, attributes: attributes)
        
        let titleOfEpisode = episodes![indexPath.row].title
        let attributes2 = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)]
        let attributedTitle = NSMutableAttributedString(string: titleOfEpisode, attributes: attributes2)
        
        let textLabelString = NSMutableAttributedString()
        textLabelString.append(attributedSeasonAndEp)
        textLabelString.append(attributedTitle)
        
        
        cell.textLabel?.attributedText = textLabelString
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension ShowDetailsViewController: resultSuccessDelagate {
    func didAddEpisode() {
        tableView.reloadData()
    }
}

