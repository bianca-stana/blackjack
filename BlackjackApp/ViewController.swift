//
//  ViewController.swift
//  WarApp
//
//  Created by Alex on 11/02/2018.
//  Copyright © 2018 Bianca Bucur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var playerTotalLabel: UILabel!
    @IBOutlet weak var dealerTotalLabel: UILabel!
    
    @IBOutlet weak var playerScoreLabel: UILabel!
    @IBOutlet weak var dealerScoreLabel: UILabel!
    
    @IBOutlet weak var dealerStackView: UIStackView!
    @IBOutlet weak var dealerImageView1: UIImageView!
    @IBOutlet weak var dealerImageView2: UIImageView!
    
    @IBOutlet weak var playerStackView: UIStackView!
    @IBOutlet weak var playerImageView1: UIImageView!
    @IBOutlet weak var playerImageView2: UIImageView!
    
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var standButton: UIButton!
    
    @IBOutlet weak var endGameLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    var playerTotal = 0
    var dealerTotal = 0
    
    var playerScore = 0
    var dealerScore = 0
    
    let cardValues = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 11]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let randNumber = arc4random_uniform(13) + 2
        dealerImageView2.image = UIImage(named: "card\(randNumber)")
        dealerScore += cardValues[Int(randNumber) - 1]
        dealerScoreLabel.text = "..."
        
        let randNumber1 = arc4random_uniform(13) + 2
        playerImageView1.image = UIImage(named: "card\(randNumber1)")
        let randNumber2 = arc4random_uniform(13) + 2
        playerImageView2.image = UIImage(named: "card\(randNumber2)")
        
        let cardValue1 = cardValues[Int(randNumber1) - 1]
        let cardValue2 = cardValues[Int(randNumber2) - 1]
        if cardValue1 + cardValue2 > 21 && cardValue1 == 11 {
            playerScore = 1 + cardValue2
        } else if cardValue1 + cardValue2 > 21 && cardValue2 == 11 {
            playerScore = cardValue1 + 1
        } else {
            playerScore = cardValue1 + cardValue2
        }
        playerScoreLabel.text = String(playerScore)
        
        if playerScore == 21 {
            endGameLabel.text = "Blackjack!\nYou won!"
            hideButtons(hit: true, stand: true, endGame: false, playAgain: false)
            increaseDealerTotal()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func hitTapped(_ sender: Any) {
        let randNumber = arc4random_uniform(13) + 2
        playerScore = randNumber == 14 && playerScore > 10 ?
            playerScore + 1 :
            playerScore + cardValues[Int(randNumber) - 1]
        playerScoreLabel.text = String(playerScore)
        
        let newImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 172.0, height: 170))
        newImageView.image = UIImage(named: "card\(randNumber)")
        newImageView.contentMode = UIViewContentMode.scaleAspectFit
        playerStackView.addArrangedSubview(newImageView)
        
        if playerScore >= 21 {
            if playerScore == 21 {
                endGameLabel.text = "Blackjack!\nYou won!"
                increasePlayerTotal()
            } else {
                endGameLabel.text = "Bust!"
                increaseDealerTotal()
            }
            
            hideButtons(hit: true, stand: true, endGame: false, playAgain: false)
        }
    }
    
    @IBAction func standTapped(_ sender: Any) {
        let randNumber = arc4random_uniform(13) + 2
        dealerImageView1.image = UIImage(named: "card\(randNumber)")
        
        let cardValue = cardValues[Int(randNumber) - 1]
        if dealerScore + cardValue > 21 && dealerScore == 11 {
            dealerScore = 1 + cardValue
        } else if dealerScore + cardValue > 21 && cardValue == 11 {
            dealerScore = dealerScore + 1
        } else {
            dealerScore += cardValue
        }
        dealerScoreLabel.text = String(dealerScore)
        
        if dealerScore >= 21 {
            if dealerScore == 21 {
                endGameLabel.text = "Blackjack!\nYou lost!"
                increaseDealerTotal()
            } else {
                endGameLabel.text = "You won!"
                increasePlayerTotal()
            }
        }
        
        while dealerScore < 17 {
            let randNumber = arc4random_uniform(13) + 2
            dealerScore = randNumber == 14 && dealerScore > 10 ?
                dealerScore + 1 :
                dealerScore + cardValues[Int(randNumber) - 1]
            dealerScoreLabel.text = String(dealerScore)
            
            let newImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 172.0, height: 170))
            newImageView.image = UIImage(named: "card\(randNumber)")
            newImageView.contentMode = UIViewContentMode.scaleAspectFit
            dealerStackView.addArrangedSubview(newImageView)
        }
        
        if dealerScore == 21 {
            endGameLabel.text = "Blackjack!\nYou lost!"
            increaseDealerTotal()
        } else if dealerScore > 21 || dealerScore < playerScore {
            endGameLabel.text = "You won!"
            increasePlayerTotal()
        } else if dealerScore > playerScore {
            endGameLabel.text = "You lost!"
            increaseDealerTotal()
        } else {
            endGameLabel.text = "Draw!"
        }
        
        hideButtons(hit: true, stand: true, endGame: false, playAgain: false)
    }
    
    @IBAction func playAgainTapped(_ sender: Any) {
        dealerScore = 0
        playerScore = 0
        
        var dealerSubviewsCount = dealerStackView.arrangedSubviews.count
        while dealerSubviewsCount > 2 {
            let dealerSubview = dealerStackView.arrangedSubviews[dealerSubviewsCount - 1]
            dealerStackView.removeArrangedSubview(dealerSubview)
            dealerSubview.removeFromSuperview()
            dealerSubviewsCount -= 1
        }
        
        var playerSubviewsCount = playerStackView.arrangedSubviews.count
        while playerSubviewsCount > 2 {
            let playerSubview = playerStackView.arrangedSubviews[playerSubviewsCount - 1]
            playerStackView.removeArrangedSubview(playerSubview)
            playerSubview.removeFromSuperview()
            playerSubviewsCount -= 1
        }
        
        dealerImageView1.image = UIImage(named: "back")
        
        hideButtons(hit: false, stand: false, endGame: true, playAgain: true)
        
        viewDidLoad()
    }
    
    func hideButtons(hit: Bool, stand: Bool, endGame: Bool, playAgain: Bool) {
        hitButton.isHidden = hit
        standButton.isHidden = stand
        endGameLabel.isHidden = endGame
        playAgainButton.isHidden = playAgain
    }
    
    func increasePlayerTotal() {
        playerTotal += 1
        playerTotalLabel.text = String(playerTotal)
    }
    
    func increaseDealerTotal() {
        dealerTotal += 1
        dealerTotalLabel.text = String(dealerTotal)
    }
}

