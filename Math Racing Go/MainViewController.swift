//
//  Main.swift
//  Math Racing Go
//
//  Created by Quan Tran on 4/17/21.
//  Copyright © 2021 QuanTran. All rights reserved.
//

import UIKit
import AVFoundation
import SQLite

class ViewController: UIViewController {
    
    // MARK: Properties
    
    var score: Int?
    var level: Int = 1
    var hightScore: Int = 0
    
    var audioPlayer = AVAudioPlayer()
    var isMuted: Bool = false
    
    let radioController = RadioButtonController()
    
    var database: Connection!
    let usersScoreTable = Table("users")
    let id = Expression<Int>("id")
    let scorePlayer = Expression<Int>("score")
    var countElements: Int?
    
    @IBOutlet weak var ScoreMainLable: UILabel!
    @IBOutlet weak var LevelMainLable: UILabel!
    @IBOutlet weak var HighScoreMainLable: UILabel!
    
    @IBOutlet weak var PlayButtonOutlet: UIButton!
    @IBOutlet weak var SoundButtonOutLet: UIButton!
    
    @IBOutlet weak var Radio1Button: UIButton!
    @IBOutlet weak var Radio2Button: UIButton!
    @IBOutlet weak var Radio3Button: UIButton!
    
    // MARK: Actions
    
    @IBAction func SoundButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.setImage(UIImage(named: "Mute"), for: .normal)
            sender.backgroundColor = UIColor(named: "GrayCustom")
            isMuted = true
        } else {
            sender.setImage(UIImage(named: "Unmute"), for: .normal)
            sender.backgroundColor = UIColor(named: "GreenCustom")
            isMuted = false
            playAudioFromProject(audioName: "Correct")
        }
    }
    
    @IBAction func Radio1ButtonAction(_ sender: UIButton) {
        playAudioFromProject(audioName: "Level")
        radioController.buttonArrayUpdated(buttonSelected: sender)
        level = 1
        LevelMainLable.text = "Level: \(level)"
    }
    
    @IBAction func Radio2ButtonAction(_ sender: UIButton) {
        playAudioFromProject(audioName: "Level")
        radioController.buttonArrayUpdated(buttonSelected: sender)
        level = 2
        LevelMainLable.text = "Level: \(level)"
    }
    
    @IBAction func Radio3ButtonAction(_ sender: UIButton) {
        playAudioFromProject(audioName: "Level")
        radioController.buttonArrayUpdated(buttonSelected: sender)
        level = 3
        LevelMainLable.text = "Level: \(level)"
    }
    
    @IBAction func PlayButtonAction(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Player") as! InterfacePlayer
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        vc.highScoreInterfaceVC = hightScore
        vc.dataLevel = "Level: \(level)"
        vc.dataHighScore = "HighScore: \(hightScore)"
        
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func ShareHighScore(_ sender: UIButton) {
        // set the default sharing message.
        let message = "My heighest score for Math Racing Go is: \(hightScore). Please download this app here in App Store: https://apps.apple.com"
        // creating share sheet
        if let link = NSURL(string: "https://facebook.com") {
            let objectsToShare = [message,link] as [Any]
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.message, UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToFacebook]
            // present share sheet on an iPad
            activityViewController.popoverPresentationController?.sourceView = sender
            activityViewController.popoverPresentationController?.sourceRect = sender.frame
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: Overridden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make play button corner circle
        PlayButtonOutlet.layer.cornerRadius = 20
        
        // creat scale animation for play button
        PlayButtonOutlet.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.PlayButtonOutlet.transform = CGAffineTransform.identity
        },
                       completion: { Void in() }
        )
        
        // make speaker button corner circle
        SoundButtonOutLet.layer.cornerRadius = SoundButtonOutLet.frame.size.width / 2
        SoundButtonOutLet.layer.masksToBounds = true
        
        //initialization button array with defaul check box is Radio1 Button
        radioController.buttonArray = [Radio1Button, Radio2Button, Radio3Button]
        radioController.defaulButton = Radio1Button
        
        // set up local database
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileURL.path)
            self.database = database
        } catch {
            print(error)
        }
        
        // create table
        let createTable = self.usersScoreTable.create { (table) in
            table.column(id, primaryKey: true)
            table.column(scorePlayer)
        }
        
        do {
            try self.database.run(createTable)
            print("Created Table")
        } catch {
            print(error)
        }
        
        // insert value highest score into local database
        do {
            countElements = try self.database.scalar(self.usersScoreTable.count)
            if countElements == 0 {
                do {
                    try self.database.run(self.usersScoreTable.insert(self.scorePlayer <- 0))
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }
        
        // request highest score from local database
        do {
            let userScore = try self.database.prepare(self.usersScoreTable)
            for user in userScore {
                print("id: \(user[id]), score: \(user[scorePlayer])")
                HighScoreMainLable.text = "HighScore: \(user[scorePlayer])"
                hightScore = user[scorePlayer]
            }
        } catch {
            print(error)
        }
        
        // delete database
        
/*         do {
         try self.database.run(usersScoreTable.delete())
         } catch {
         print(error)
         }
*/
    }
}

// MARK: Extension

extension ViewController:PassDataDelegate {
    //function to pass data score from Interface View Controller
    func passDataScore(dataScore: Int) {
        ScoreMainLable.text = "Score: \(dataScore)"
    }
    
    // function to pass data highest score from Interface View Controller and update high score in database
    func passDataHighScore(dataHighScore: Int) {
        HighScoreMainLable.text = "HighScore: \(dataHighScore)"
        let user = self.usersScoreTable.filter(self.id == 1)
        do {
            hightScore = dataHighScore
            let updateScore = user.update(self.scorePlayer <- dataHighScore)
            try database.run(updateScore)
            print("Updated the highest score")
        } catch {
            print(error)
        }
    }
    
    // function to play sound depends on the Sound button
    func playAudioFromProject(audioName: String) {
        guard let url = Bundle.main.url(forResource: audioName, withExtension: "mp3") else {
            print("error to get the mp3 file")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("audio file error")
        }
        
        if isMuted {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
    }
}
