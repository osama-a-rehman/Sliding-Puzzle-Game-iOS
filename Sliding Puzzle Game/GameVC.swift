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
    
    @IBOutlet weak var tilesMovedLabel: UILabel!
    
    var blockSize: CGFloat!
    
    let blocksArray: NSMutableArray = []
    let centersArray: NSMutableArray = []
    
    var timeCount: Int = 0
    var gameTimer: Timer = Timer()
    
    var emptyAreaPoint: CGPoint!
    
    var tilesMovedCount = 0
    
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
        
        //print("Centers: \(centersArray.count)")
        //print("Blocks: \(blocksArray.count)")
    }
    
    @IBAction func btnResetPressed(_ sender: AnyObject) {
        resetGame()
    }
    
    
    @IBAction func btnClosePressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func initialize(){
        
        let gameViewWidth = gameView.frame.size.width
        
        blockSize = gameViewWidth/4
        let padding: CGFloat = 3
        //let gameViewPadding: CGFloat = 10
        
        var xCen = blockSize/2
        var yCen = blockSize/2
        
        gameViewHeightContraint.constant = gameViewWidth
        
        var labelNumber = 1
        
        for _ in 0..<4 {
            for _ in 0..<4 {
                
                let blockFrame = CGRect(x: 0, y: 0, width: blockSize - padding, height: blockSize - padding)
                let blockCenter = CGPoint(x: xCen, y: yCen)
                
                let block = GameBlock(frame: blockFrame)
                block.center = blockCenter
                block.origCenter = blockCenter
                block.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                block.text = "\(labelNumber)"
                block.textAlignment = NSTextAlignment.center
                block.font = UIFont(name: "Helvetica Neue", size: 19)
                block.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                block.isUserInteractionEnabled = true
                block.blockId = labelNumber
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(blockPressed(sender:)))
                
                block.addGestureRecognizer(tapGesture)
                
                gameView.addSubview(block)
                
                xCen += blockSize
                
                labelNumber += 1
                
                centersArray.add(blockCenter)
                blocksArray.add(block)
            }
            
            xCen = blockSize/2
            yCen = yCen + blockSize
        }
        
        let lastBlock = blocksArray[blocksArray.count-1] as! GameBlock
        lastBlock.removeFromSuperview()
        blocksArray.removeLastObject()
        
        initializeTimer()
    }
    
    func randomizeArray(){
        let tempCentersArray = centersArray.mutableCopy() as! NSMutableArray
        
        for block in blocksArray {
            let randomIndex = Int(arc4random()) % tempCentersArray.count
            let randomCenter = tempCentersArray[randomIndex] as! CGPoint
            
            let randomBlock = block as! GameBlock
            randomBlock.center = randomCenter
            
            if randomBlock.center == randomBlock.origCenter {
                randomBlock.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            }else{
                randomBlock.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
            
            tempCentersArray.removeObject(at: randomIndex)
        }
        
        emptyAreaPoint = tempCentersArray[0] as! CGPoint
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
    
    func blockPressed(sender: UIGestureRecognizer){
        let tappedBlock = sender.view as! GameBlock
        
        let distance = findDistance(block: tappedBlock)
        
        if distance == blockSize {
            let tempCenter = tappedBlock.center
            
            // Animate & Change color if correct
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.2)
            
            tappedBlock.center = emptyAreaPoint
            
            UIView.commitAnimations()
            
            if tappedBlock.origCenter == emptyAreaPoint {
                tappedBlock.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            }else{
                tappedBlock.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
            
            emptyAreaPoint = tempCenter
            
            tilesMovedLabel.text = "Tiles Moved: \(tilesMovedCount)"
            
            tilesMovedCount = tilesMovedCount + 1
            
            if checkWin() {
                let alertController = UIAlertController(title: "Congrats", message: "You've won", preferredStyle: .alert)
                let playAgainAction = UIAlertAction(title: "Play Again", style: .default, handler: { (action) in
                    self.resetGame()
                })
                
                alertController.addAction(playAgainAction)
                present(alertController, animated: true, completion: nil)
                
                gameTimer.invalidate()
            }
        }
    }
    
    func findDistance(block: GameBlock) -> CGFloat{
        let xDif: CGFloat = block.center.x - emptyAreaPoint.x
        let yDif: CGFloat = block.center.y - emptyAreaPoint.y
        
        return sqrt(pow(xDif, 2) + pow(yDif, 2))
    }
    
    func checkWin() -> Bool {
        var numberOfCorrectBlocks = 0
        
        for block in blocksArray {
            if (block as! GameBlock).backgroundColor == #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1) {
                numberOfCorrectBlocks = numberOfCorrectBlocks + 1
            }
        }
        
        //print(numberOfCorrectBlocks)
        
        return numberOfCorrectBlocks == 15
    }
    
    func resetGame(){
        randomizeArray()
        
        timerLabel.text = "0:00"
        tilesMovedCount = 0
        tilesMovedLabel.text = "Tiles Moved: \(tilesMovedCount)"
        
        initializeTimer()
    }
}

