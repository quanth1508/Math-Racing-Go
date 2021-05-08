//
//  InterfacePlayer.swift
//  Math Racing Go
//
//  Created by Quan Tran on 4/17/21.
//  Copyright © 2021 QuanTran. All rights reserved.
//

import UIKit

protocol PassDataDelegate {
    func passDataScore(dataScore: Int)
    func passDataHighScore(dataHighScore: Int)
    func playAudioFromProject(audioName: String)
}

class InterfacePlayer: UIViewController {
    
    // MARK: Properties
    
    var delegate: PassDataDelegate?
    
    var dataLevel: String?
    var dataHighScore: String?
    
    var timer: Timer = Timer()
    
    var score: Int = 0
    var highScoreInterfaceVC: Int?
    
    @IBOutlet weak var ProgressTimer: UIProgressView!
    
    @IBOutlet weak var ScoreLable: UILabel!
    @IBOutlet weak var LevelLable: UILabel!
    @IBOutlet weak var HighScoreLable: UILabel!
    
    @IBOutlet weak var Number1Lable: UILabel!
    @IBOutlet weak var Number2Lable: UILabel!
    @IBOutlet weak var ResultLable: UILabel!
    @IBOutlet weak var CaculationLable: UILabel!
    @IBOutlet weak var EqualLable: UILabel!
    @IBOutlet weak var FailImage: UIImageView!
    
    @IBOutlet weak var FalseButton: UIButton!
    @IBOutlet weak var TrueButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func TrueButtonAction(_ sender: UIButton) {
        if checkResult() {
            if LevelLable.text! == "Level: 1" {
                easy()
            } else if LevelLable.text! == "Level: 2" {
                hard()
            } else {
                veryHard()
            }
        } else {
            timer.invalidate()
            fail()
            print("You are Failed")
            return
        }
    }
    
    @IBAction func FalseButtonAction(_ sender: UIButton) {
        if !checkResult() {
            if LevelLable.text! == "Level: 1" {
                easy()
            } else if LevelLable.text! == "Level: 2" {
                hard()
            } else {
                veryHard()
            }
        } else {
            timer.invalidate()
            fail()
            print("You are Failed")
            return
        }
    }
    
    // MARK: Overridden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        play()
        
        // makes buttons to circle
        FalseButton.layer.cornerRadius = FalseButton.frame.width / 2
        FalseButton.layer.masksToBounds = true
        TrueButton.layer.cornerRadius = TrueButton.frame.width / 2
        TrueButton.layer.masksToBounds = true
        
        // make to button fail
        FailImage.image = UIImage(named: "Fail")
        FailImage.isHidden = true
        
        // delegate data from forward view controller to current view controller
        LevelLable.text = dataLevel
        HighScoreLable.text = dataHighScore
        
    }
    
    // MARK: Functions
    
    private func easy() {
        LevelLable.text = "Level: 1"
        play()
        self.score += 1
        self.delegate?.playAudioFromProject(audioName: "Correct")
        ScoreLable.text! = String("Score: \(score)")
        resetTime()
        if score >= 10 {
            LevelLable.text = "Level: 2"
        }
    }
    
    private func hard() {
        LevelLable.text = "Level: 2"
        play()
        score += 2
        self.delegate?.playAudioFromProject(audioName: "Correct")
        ScoreLable.text! = String("Score: \(score)")
        resetTime()
        if score >= 20 {
            LevelLable.text = "Level: 3"
        }
    }
    
    private func veryHard() {
        LevelLable.text = "Level: 3"
        play()
        score += 3
        self.delegate?.playAudioFromProject(audioName: "Correct")
        ScoreLable.text! = String("Score: \(score)")
        resetTime()
    }
    
    // running time when you choose
    private func timePlay() {
        var progressValue = 1.0
        var interval = 0.0
        
        // set time interval with level choosed
        if LevelLable.text! == "Level: 1" {
            interval = 0.02
        } else if LevelLable.text! == "Level: 2" {
            interval = 0.015
        } else {
            interval = 0.01
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: true, block: { (time) in
            progressValue -= 0.01
            self.ProgressTimer.progress = Float(progressValue)
            if self.ProgressTimer.progress == 0.0 {
                self.timer.invalidate()
                self.fail()
                return
            }
        })
    }
    
    // reset time interval when you choose true
    private func resetTime() {
        timer.invalidate()
        timePlay()
    }
    
    // function to number interger random
    private func randomNumber() -> Int {
        if LevelLable.text! == "Level: 1" || LevelLable.text! == "Level: 2" {
            let randomInt = Int.random(in: 0...10)
            return randomInt
        } else {
            let randomInt = Int.random(in: 0...13)
            return randomInt
        }
    }
    
    // function to operation random
    private func randomOperators() -> String {
        if LevelLable.text! == "Level: 1" || LevelLable.text! == "Level: 2" {
            let operators: Array<String> = ["+", "-"]
            let operatorsRandom = operators.randomElement()!
            return operatorsRandom
        } else {
            let operators: Array<String> = ["+", "-", "x"]
            let operatorsRandom = operators.randomElement()!
            return operatorsRandom
        }
    }
    
    // function to check choose
    private func checkResult () -> Bool {
        let operation = CaculationLable.text!
        switch operation {
            
        //addition
        case "+":
            let number1 = Int(Number1Lable.text!)!
            let number2 = Int(Number2Lable.text!)!
            let tempResult = Int(ResultLable.text!)
            
            let result = number1 + number2
            
            if result == tempResult {
                return true
            }
            return false
            
        // subtraction
        case "-":
            let number1 = Int(Number1Lable.text!)!
            let number2 = Int(Number2Lable.text!)!
            let tempResult = Int(ResultLable.text!)
            
            let result = number1 - number2
            
            if result == tempResult {
                return true
            }
            return false
            
        // multiplication
        default:
            let number1 = Int(Number1Lable.text!)!
            let number2 = Int(Number2Lable.text!)!
            let tempResult = Int(ResultLable.text!)
            
            let result = number1 * number2
            
            if result == tempResult {
                return true
            }
            return false
        }
    }
    
    // function to compute main operation
    private func play() {
        let operatorsRandom = randomOperators()
        CaculationLable.text = operatorsRandom
        
        // if randomControl return true, need to create an correct expression. And vice versa
        switch operatorsRandom {
        // addition
        case "+":
            playWithAdd()
            break
        // subtraction
        case "-":
            playWithSub()
            break
        // multiplication
        default:
            playWithMul()
            break
        }
    }
    
    private func playWithAdd() {
        var sum: Int
        let randomControl = Bool.random()
        
        if (randomControl) {
            let number1 = randomNumber()
            let number2 = randomNumber()
            
            Number1Lable.text = String(number1)
            Number2Lable.text = String(number2)
            
            let sum = number1 + number2
            ResultLable.text = String(sum)
            
        } else {
            let number1 = randomNumber()
            let number2 = randomNumber()
            
            Number1Lable.text = String(number1)
            Number2Lable.text = String(number2)
            
            repeat {
                sum = randomNumber()
            } while sum == number1 + number2
            
            ResultLable.text = String(sum)
        }
    }
    
    private func playWithSub() {
        var sub: Int
        let randomControl = Bool.random()
        
        if (randomControl) {
            let number1 = randomNumber()
            let number2 = randomNumber()
            
            Number1Lable.text = String(number1)
            Number2Lable.text = String(number2)
            
            let sub = number1 - number2
            ResultLable.text = String(sub)
        } else {
            let number1 = randomNumber()
            let number2 = randomNumber()
            
            Number1Lable.text = String(number1)
            Number2Lable.text = String(number2)
            
            repeat {
                sub = randomNumber()
            } while sub == number1 - number2
            ResultLable.text = String(sub)
        }
    }
    
    private func playWithMul() {
        var mul: Int
        let randomControl = Bool.random()
        
        if (randomControl) {
            let number1 = randomNumber()
            let number2 = randomNumber()
            
            Number1Lable.text = String(number1)
            Number2Lable.text = String(number2)
            
            let sub = number1 - number2
            ResultLable.text = String(sub)
        } else {
            let number1 = randomNumber()
            let number2 = randomNumber()
            
            Number1Lable.text = String(number1)
            Number2Lable.text = String(number2)
            
            repeat {
                mul = randomNumber()
            } while mul == number1 * number2
            
            ResultLable.text = String(mul)
        }
    }
    
    // back to previous viewcontroller when you are fail
    private func fail() {
        TrueButton.isHidden = true
        FalseButton.isHidden = true
        
        self.delegate?.playAudioFromProject(audioName: "Wrong")
        
        
        if highScoreInterfaceVC! < score {
            highScoreInterfaceVC = score
            HighScoreLable.text! = "HighScore: \(highScoreInterfaceVC!)"
        }
        
        // set up fail animation
        UIView.animate(withDuration: 0.001,
                       animations: {
                        self.FailImage.transform = CGAffineTransform(scaleX: 10, y: 10)
        },
                       completion: { _ in UIView.animate(withDuration: 0.4, animations: {
                        self.FailImage.isHidden = false
                        self.FailImage.transform = CGAffineTransform(scaleX: 2, y: 2)
                       })
                        
        })
        
        // execute dismiss after two seconds and return data previous view controller
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
            print("Score Player: \(self.score) and HighScore temporary: \(self.highScoreInterfaceVC!)")
            self.delegate?.passDataScore(dataScore: self.score)
            self.delegate?.passDataHighScore(dataHighScore: self.highScoreInterfaceVC!)
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}
