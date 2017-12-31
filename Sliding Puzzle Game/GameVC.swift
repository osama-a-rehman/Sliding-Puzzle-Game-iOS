//
//  GameVC.swift
//  Sliding Puzzle Game
//
//  Created by Osama on 31/12/2017.
//  Copyright © 2017 Osama. All rights reserved.
//

import UIKit

class GameVC: UIViewController {
    
    @IBOutlet weak var gameView: UIView!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var gameViewHeightContraint: NSLayoutConstraint!
    
    let blocksArray: NSMutableArray = []
    let centersArray: NSMutableArray = []
    
    var timeCount: Int = 0
    var gameTimer: Timer = Timer()
    
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initialize()
        
        randomizeArray()
        
        print("Centers: \(centersArray.count)")
        print("Blocks: \(blocksArray.count)")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        
        print("Touch")
        print(blocksArray.contains(touch.view as Any))
        
        if blocksArray.contains(touch.view as Any) {
            touch.view?.alpha = 0
            print("Touch on view")
        }
    }
    
    @IBAction func btnResetPressed(_ sender: AnyObject) {
        randomizeArray()
        
        timerLabel.text = "0:00"
        
        initializeTimer()
    }
    
    func initialize(){
        
        let gameViewWidth = gameView.frame.size.width
        
        let blockSize = gameViewWidth/4
        let padding: CGFloat = 3
        //        let gameViewPadding: CGFloat = 10
        
        var xCen = blockSize/2
        var yCen = blockSize/2
        
        gameViewHeightContraint.constant = gameViewWidth + padding*4
        
        var labelNumber = 1
        
        for _ in 0..<4 {
            for _ in 0..<4 {
                
                let blockFrame = CGRect(x: 0, y: 0, width: blockSize - padding, height: blockSize)
                let blockCenter = CGPoint(x: xCen, y: yCen)
                
                let block = GameBlock(frame: blockFrame)
                block.center = blockCenter
                block.origCenter = blockCenter
                block.backgroundColor = UIColor.darkGray
                block.text = "\(labelNumber)"
                block.textAlignment = NSTextAlignment.center
                block.font = UIFont(name: "Helvetica Neue", size: 19)
                block.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                block.isUserInteractionEnabled = true
                
                gameView.addSubview(block)
                
                xCen += blockSize
                
                labelNumber += 1
                
                centersArray.add(blockCenter)
                blocksArray.add(block)
            }
            
            xCen = blockSize/2
            yCen = yCen + blockSize + padding
        }
        
        let lastBlock = blocksArray[blocksArray.count-1] as! GameBlock
        lastBlock.removeFromSuperview()
        blocksArray.remove(blocksArray.count-1)
        
        initializeTimer()
    }
    
    func randomizeArray(){
        let tempCentersArray = centersArray.mutableCopy() as! NSMutableArray
        
        for block in blocksArray {
            let randomIndex = Int(arc4random()) % tempCentersArray.count
            let randomCenter = tempCentersArray[randomIndex] as! CGPoint
            
            (block as! GameBlock).center = randomCenter
            tempCentersArray.removeObject(at: randomIndex)
        }
    }
    
    func initializeTimer(){
        timeCount = 0
        gameTimer.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    func timerAction(){
        timeCount += 1
        
        let minutes: Int = timeCount / 60
        let seconds: Int = timeCount % 60
        
        if seconds < 10 {
            timerLabel.text = "\(minutes):0\(seconds)"
        }else{
            timerLabel.text = "\(minutes):\(seconds)"
        }
        
    }
}

