//
//  LoginViewController.swift
//  TVShows
//
//  Created by Borna on 05/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
   private(set) var touchCount = 0 {
        didSet {
            touchCountLabel.text = "Touch count: \(touchCount)"
        }
    }
    
    @IBOutlet weak var button: UIButton!
    
    
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
    }
    
    @IBOutlet private weak var touchCountLabel: UILabel!
    
    func setButtonIcon(){
        button.setImage(UIImage(named: "inf.png"), for: UIControl.State.normal)
    }
    
    func setUpView(){
        button.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setButtonIcon()
        // Do any additional setup after loading the view.
    }
    
    
   
    
   

}
