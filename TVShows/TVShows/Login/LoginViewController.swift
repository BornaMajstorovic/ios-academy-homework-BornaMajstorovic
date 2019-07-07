//
//  LoginViewController.swift
//  TVShows
//
//  Created by Borna on 05/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet private weak var touchCountLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBAction func touchBtn(_ sender: UIButton) {
        //  print("First HomeWork 🥳")
        touchCount += 1
        if touchCount % 2 == 0 {
            sender.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            touchCountLabel.textColor = #colorLiteral(red: 1, green: 0.1909307073, blue: 0.190708672, alpha: 1)
        } else {
            sender.backgroundColor = #colorLiteral(red: 1, green: 0.1909307073, blue: 0.190708672, alpha: 1)
            touchCountLabel.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
        
        if indicator.isAnimating {
            indicator.stopAnimating()
        } else {
            indicator.startAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        automaticStart()
    }
    
    private(set) var touchCount = 0 {
        didSet {
            touchCountLabel.text = "Touch count: \(touchCount)"
        }
    }
    
    func setUpView(){
        button.layer.cornerRadius = 10
    }
    
    func automaticStart(){
        indicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.indicator.stopAnimating()
        }
    }
}
