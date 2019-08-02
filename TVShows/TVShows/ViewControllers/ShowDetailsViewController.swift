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

final class ShowDetailsViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var newEpisodeButton: UIButton!
    @IBOutlet private weak var episodesNumberLabel: UILabel!
    @IBOutlet private weak var customBackButton: UIButton!
    
    // MARK: Properties
    var showID: String? = UserCredentials.shared.showId
    var token: String? = UserCredentials.shared.userToken
    var showObject: Show?
    private var refreshControl = UIRefreshControl()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    // MARK: Actions
    @IBAction private func newEpisodeButtonSelected(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        if let newEpisodeViewController = storyboard.instantiateViewController(withIdentifier: "NewEpisodeViewController") as? NewEpisodeViewController {
            let navigationController = UINavigationController(rootViewController: newEpisodeViewController)
            newEpisodeViewController.delegate = self
            present(navigationController, animated: true, completion: nil)
        }
        
        sender.highlightButton()
    }
    @IBAction private func customBackButtonSelected(_ sender: UIButton) {
         navigationController?.popViewController(animated: true)
        
        sender.highlightButton()
    }
    
    //MARK: Class methods
    
    private func setUpView() {
        tableView.dataSource = self
        tableView.delegate = self
        if let showObject = showObject {
            image.kf.setImage(with: showObject.fullImageUrl)
        }
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        tableView.alwaysBounceVertical = true
        tableView.refreshControl = refreshControl
        
    }
    
    @objc private func didPullToRefresh(_ sender: Any) {
        refreshControl.endRefreshing()
    }
    
    private func navigateFromShowDetails(showEpisodeobject: ShowEpisodes){
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        
        if let episodeDetailsViewController = storyBoard.instantiateViewController(withIdentifier:"EpisodeDetailsViewController") as? EpisodeDetailsViewController  {
            episodeDetailsViewController.episodeObject = showEpisodeobject
            episodeDetailsViewController.showObject = showObject
            
            navigationController?.pushViewController(episodeDetailsViewController, animated: true)
        }
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
                        self?.tableView.reloadData()
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
        
        //nemogu stavit u showEpisodes zbog koristenja UIColor-a
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) != nil {
            if let episodeObject = episodes?[indexPath.row] {
                navigateFromShowDetails(showEpisodeobject: episodeObject)
            }
        }
    }
}

extension ShowDetailsViewController: ResultSuccessDelagate {
    func didAddEpisode() {
        tableView.reloadData()
        fetchShowListOfEpisodes()
    }
}

