//
//  LoginViewController.swift
//  TVShows
//
//  Created by Borna on 05/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var switchButton: UIButton!
    @IBOutlet private weak var touchCountLabel: UILabel!
    @IBOutlet private weak var onTouchIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    private(set) var touchCount = 0 {
        didSet {
            touchCountLabel.text = "Touch count: \(touchCount)"
        }
    }
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        automaticStart()
    }
    
    // MARK: Actions
    @IBAction func touchSwitchButton(_ sender: UIButton) {
        //  print("First HomeWork 🥳")
        
        // TODO: touchCount.isMultiple(of: 2) not working?
        
        touchCount += 1
        if touchCount%2 == 0 {
            sender.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            touchCountLabel.textColor = #colorLiteral(red: 1, green: 0.1909307073, blue: 0.190708672, alpha: 1)
        } else {
            sender.backgroundColor = #colorLiteral(red: 1, green: 0.1909307073, blue: 0.190708672, alpha: 1)
            touchCountLabel.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
        
        if onTouchIndicator.isAnimating {
            onTouchIndicator.stopAnimating()
        } else {
            onTouchIndicator.startAnimating()
        }
    }
    
    // MARK: Class methods
    private func setUpView(){
        switchButton.layer.cornerRadius = 10
    }
    
    private func automaticStart(){
        onTouchIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.onTouchIndicator.stopAnimating()
        }
    }
}
