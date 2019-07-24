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
    
    private var episodes:[ShowEpisodes]? {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newEpisodeButton: UIButton!
    @IBOutlet weak var episodesNumberLabel: UILabel!
    
    @IBAction func newEpisodeButtonSelected(_ sender: UIButton) {
        
        
    }
    
    // MARK: Properties
    var showID: String?
    var token: String?

    
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
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions
    
    
    //MARK: Class methods
    
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

