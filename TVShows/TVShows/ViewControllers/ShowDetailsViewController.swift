//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Borna on 22/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit
import Alamofire

class ShowDetailsViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var newEpisodeButton: UIButton!
    @IBOutlet private weak var episodesNumberLabel: UILabel!
    
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
            present(newEpisodeViewController, animated: true, completion: nil)
            newEpisodeViewController.token = token
            newEpisodeViewController.showID = showID
            newEpisodeViewController.delegate = self
        }
    }
    
    //MARK: Class methods
    
    private func setUpView() {
        tableView.dataSource = self
        tableView.delegate = self
        newEpisodeButton.backgroundColor = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1)
        newEpisodeButton.layer.cornerRadius = 0.5 * newEpisodeButton.bounds.size.width
        newEpisodeButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        self.navigationItem.setHidesBackButton(true, animated:false)
       // self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "ic-navigate-back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        let barButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButton
        
        
    }
    @objc func backButtonPressed(sender:UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
   
    
}

private extension ShowDetailsViewController {
     func fetchShowDetails() {
        if let token = token {
            let headers = ["Authorization": token]
            guard let showID = showID else {return}
            
            //"\(BASE_URL)\(NEKAKAV_ENDPOINT)\(showID)"
            
            Alamofire.request("https://api.infinum.academy/api/shows/" + "\(showID)", method: .get, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                    [weak self](response: DataResponse<ShowDetails>) in
                    switch response.result {
                    case .success(let showDetails):
                        self?.showDetails = showDetails
                        self?.fetchShowListOfEpisodes()
                    case .failure(let error):
                        error.localizedDescription
                    }
            }
        }
    }
    
     func fetchShowListOfEpisodes() {
        if let token = token {
            let headers = ["Authorization": token]
            guard let showID = showID else {return}
            
            Alamofire.request("https://api.infinum.academy/api/shows/\(showID)/episodes", method: .get, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                    [weak self](response: DataResponse<[ShowEpisodes]>) in
                    switch response.result {
                    case .success(let episodes):
                        self?.episodes = episodes
                        self?.episodesNumberLabel.text = "Episodes \(episodes.count)"
                    case .failure(let error):
                        error.localizedDescription
                    }
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
        cell.textLabel?.text = episodes?[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension ShowDetailsViewController: resultSuccessDelagate {
    func didAddEpisode() {
        tableView.reloadData()
    }
}

