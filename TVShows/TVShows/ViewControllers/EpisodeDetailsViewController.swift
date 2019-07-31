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
    var token: String?
    var episodeObject: ShowEpisodes?
    var showObject: Show?
    
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setupView() {
        if let showObject = showObject {
            imageView.kf.setImage(with: showObject.fullImageUrl)
        }
        titleLabel.text = episodeObject?.title
       // seasonLabel.text = episodeObject?.season + episodeObject?.episodeNumber
        episodeDescription.text = episodeObject?.description
        
    }
    
    // MARK: Actions
    @IBAction func navigateToComments(_ sender: UIButton) {
    }
    
    // MARK: Class methods
    
}
