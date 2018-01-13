//
//  StartVC.swift
//  Sliding Puzzle Game
//
//  Created by Osama on 13/01/2018.
//  Copyright © 2018 Osama. All rights reserved.
//

import UIKit

class StartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func btnHighScoresPressed(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Sorry", message: "No functionality for high scores yet", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnExitPressed(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Sorry", message: "No functionality for high scores yet", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
}
