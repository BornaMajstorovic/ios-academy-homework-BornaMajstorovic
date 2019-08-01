//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Borna on 31/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit

final class EpisodeDetailsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var seasonLabel: UILabel!
    @IBOutlet private weak var episodeDescription: UITextView!
    @IBOutlet private weak var commentsButton: UIButton!
    
    // MARK: Properties
    var token: String? = UserCredentials.shared.userToken
    var episodeObject: ShowEpisodes?
    var showObject: Show?
    
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        attributedSeasonAndEpisode()
        
    }
    
    private func setupView() {
        if let showObject = showObject {
            imageView.kf.setImage(with: showObject.fullImageUrl)
        }
        titleLabel.text = episodeObject?.title
        episodeDescription.text = episodeObject?.description
        
    }
    
    // MARK: Actions
    @IBAction func navigateToComments(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        if let commentsViewController = storyboard.instantiateViewController(withIdentifier: "CommentsViewController") as? CommentsViewController {
            navigationController?.pushViewController(commentsViewController, animated: true)
        }
        
    }
    
    @IBAction func customBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    // MARK: Class methods
    
    private func setImage() {
        imageView.kf.setImage(with: episodeObject?.fullImageUrl)
    }
    
    private func attributedSeasonAndEpisode() {
        guard
            let season = episodeObject?.season,
            let episode = episodeObject?.episodeNumber
            else {return}
            
        var seasonAndEp: String = "S"
        seasonAndEp.append(season)
        seasonAndEp.append(" Ep")
        seasonAndEp.append(episode)
        seasonAndEp.append(" ")
        
        let color = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1)
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        let attributedSeasonAndEp = NSMutableAttributedString(string: seasonAndEp, attributes: attributes)
        
        seasonLabel.attributedText = attributedSeasonAndEp
    }
    
}
