//
//  singleplayerquiz.swift
//  Assignment5
//
//  Created by Andrew Bell on 4/27/20.
//  Copyright © 2020 Andrew Bell. All rights reserved.
//

import UIKit
import CoreMotion

class singleplayerquiz: UIViewController, UINavigationControllerDelegate {
    
    var quiznumber = 1
    
    var reloading = 0
    
    var questionnumber = 0
    
    var rightanswer = "A"
    
    let recenttitle = UIView()
    
    let naviglabel = UILabel()
    
    var apressed = 0
    
    var bpressed = 0
    
    var cpressed = 0
    
    var dpressed = 0
    
    var done = 0
    
    var firstrun = 0
    
    @IBOutlet weak var questionasked: UILabel!
    
    @IBOutlet weak var selecta: UIButton!
    
    @IBOutlet weak var selectb: UIButton!
    
    @IBOutlet weak var selectc: UIButton!
    
    @IBOutlet weak var selectd: UIButton!
    
    @IBOutlet weak var qcountdown: UILabel!
    
    @IBOutlet weak var questionof: UILabel!
    
    @IBOutlet weak var scorelabel: UILabel!
    
    var countdown = Timer()
    
    var countdowncount = 20
    
    var completedcount = 0
    
    var greeting = String()
    
    var totalquestions = Int()
    
    var score = 0
    
    var motionManager = CMMotionManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        monitorDeviceOrientation()
    
        countdown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(singleplayerquiz.singletimeaction), userInfo: nil, repeats: true)
        readLocalJSONData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        
        if (reloading > 0) {
            scorelabel.text = "\(score)"
        countdown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(singleplayerquiz.singletimeaction), userInfo: nil, repeats: true)
        readLocalJSONData()
    
        print("did appear")
        }
        
        else {
            motionManager.deviceMotionUpdateInterval = 1/10
            
            
            motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical)
            
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateDeviceMotion), userInfo: nil, repeats: true)
        }
        
    }
    

    // TO READ JSON DATA
    func readLocalJSONData(){
       // print("inside read local JSON")
        
        let url = Bundle.main.url(forResource: "quiz" + "\(quiznumber)", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        do {
            
            let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            if let dictionary = object as? [String: AnyObject] {
                readJSONData(dictionary)
            }
            
        } catch {
            // Handle Error for end of quiz
            reloading += 1
            quiznumber = 1
            self.viewDidAppear(true)
            
        }
        
        
        
    }

    
    func readJSONData(_ object: [String: AnyObject]) {
        if let numberofquestions = object["numberOfQuestions"] as? Int,
            let topic = object["topic"] as? String,
            
            let questions = object["questions"] as? [[String: AnyObject]] {
            
            naviglabel.text = topic
            naviglabel.sizeToFit()
            naviglabel.center = recenttitle.center
            naviglabel.textAlignment = NSTextAlignment.center
            recenttitle.addSubview(naviglabel)
            self.navigationItem.titleView = recenttitle
            recenttitle.sizeToFit()
            
            
            print("Question \(questions[questionnumber]["number"]!) is \(questions[questionnumber]["questionSentence"]!)")
            //questions[0]
            
            totalquestions = numberofquestions
            
            let answera = ("\(String(describing: questions[questionnumber]["options"]!["A"]! as! String))")
            let answerb = ("\(String(describing: questions[questionnumber]["options"]!["B"]! as! String))")
            let answerc = ("\(String(describing: questions[questionnumber]["options"]!["C"]! as! String))")
            let answerd = ("\(String(describing: questions[questionnumber]["options"]!["D"]! as! String))")
            
            selecta.setTitle("A) \(answera)", for: .normal)
            selectb.setTitle("B) \(answerb)", for: .normal)
            selectc.setTitle("C) \(answerc)", for: .normal)
            selectd.setTitle("D) \(answerd)", for: .normal)
            
            questionof.text = "Question \(questionnumber + 1) of \(numberofquestions)"
            questionasked.text = "\(questions[questionnumber]["questionSentence"]!)"
            rightanswer = (questions[questionnumber]["correctOption"]! as! String)
            print("\(rightanswer)")
            
            /*
            for question in questions {
                
                let answera = ("\(String(describing: question["options"]!["A"]! as! String))")
                let answerb = ("\(String(describing: question["options"]!["B"]! as! String))")
                let answerc = ("\(String(describing: question["options"]!["C"]! as! String))")
                let answerd = ("\(String(describing: question["options"]!["D"]! as! String))")
                
                questionnumber += 1
                
                questionof.text = "Question \(questionnumber) of \(numberofquestions)"
                
                questionasked.text = "\(question["questionSentence"]!)"
                
                selecta.setTitle("A) \(answera)", for: .normal)
                selectb.setTitle("B) \(answerb)", for: .normal)
                selectc.setTitle("C) \(answerc)", for: .normal)
                selectd.setTitle("D) \(answerd)", for: .normal)
                
                print("Question \(question["number"]!) is \(question["questionSentence"]!)")
                
                
            }
                */
        
            
            //ask restart here
        }
    }
    
    
    @IBAction func aselected(_ sender: Any) {
        apressed += 1
        bpressed = 0
        cpressed = 0
        dpressed = 0
        
        let noback = UIImage(systemName: "default")
        let clickedonce = UIImage(systemName: "pencil")
        let clickedtwice = UIImage(systemName: "pencil.and.outline")
        
        if (apressed == 1) {
            selecta.setBackgroundImage(clickedonce, for: .normal)
            selectb.setBackgroundImage(noback, for: .normal)
            selectc.setBackgroundImage(noback, for: .normal)
            selectd.setBackgroundImage(noback, for: .normal)
        }
        
        else if (apressed == 2) {
            selecta.setBackgroundImage(clickedtwice, for: .normal)
            selecta.isEnabled = false
            selectb.isEnabled = false
            selectc.isEnabled = false
            selectd.isEnabled = false
            if (rightanswer == "A") {score += 1}
            done += 1
        }
        
        else {
            selecta.setBackgroundImage(noback, for: .normal)
            selectb.setBackgroundImage(noback, for: .normal)
            selectc.setBackgroundImage(noback, for: .normal)
            selectd.setBackgroundImage(noback, for: .normal)
        }
        
    }
    
    
    @IBAction func bselected(_ sender: Any) {
        apressed = 0
        bpressed += 1
        cpressed = 0
        dpressed = 0
        
        let noback = UIImage(systemName: "default")
        let clickedonce = UIImage(systemName: "pencil")
        let clickedtwice = UIImage(systemName: "pencil.and.outline")
        
        if (bpressed == 1) {
            selectb.setBackgroundImage(clickedonce, for: .normal)
            selecta.setBackgroundImage(noback, for: .normal)
            selectc.setBackgroundImage(noback, for: .normal)
            selectd.setBackgroundImage(noback, for: .normal)
        }
        
        else if (bpressed == 2) {
            selectb.setBackgroundImage(clickedtwice, for: .normal)
            selecta.isEnabled = false
            selectb.isEnabled = false
            selectc.isEnabled = false
            selectd.isEnabled = false
            if (rightanswer == "B") {score += 1}
            done += 1
        }
        
        else {
            selecta.setBackgroundImage(noback, for: .normal)
            selectb.setBackgroundImage(noback, for: .normal)
            selectc.setBackgroundImage(noback, for: .normal)
            selectd.setBackgroundImage(noback, for: .normal)
        }
    }
    
    
    @IBAction func cselected(_ sender: Any) {
        apressed = 0
        bpressed = 0
        cpressed += 1
        dpressed = 0
        
        let noback = UIImage(systemName: "default")
        let clickedonce = UIImage(systemName: "pencil")
        let clickedtwice = UIImage(systemName: "pencil.and.outline")
        
        if (cpressed == 1) {
            selectc.setBackgroundImage(clickedonce, for: .normal)
            selectb.setBackgroundImage(noback, for: .normal)
            selecta.setBackgroundImage(noback, for: .normal)
            selectd.setBackgroundImage(noback, for: .normal)
        }
        
        else if (cpressed == 2) {
            selectc.setBackgroundImage(clickedtwice, for: .normal)
            selecta.isEnabled = false
            selectb.isEnabled = false
            selectc.isEnabled = false
            selectd.isEnabled = false
            if (rightanswer == "C") {score += 1}
            done += 1
        }
        
        else {
            selecta.setBackgroundImage(noback, for: .normal)
            selectb.setBackgroundImage(noback, for: .normal)
            selectc.setBackgroundImage(noback, for: .normal)
            selectd.setBackgroundImage(noback, for: .normal)
        }
    }
    
    
    @IBAction func dselected(_ sender: Any) {
        apressed = 0
        bpressed = 0
        cpressed = 0
        dpressed += 1
        
        let noback = UIImage(systemName: "default")
        let clickedonce = UIImage(systemName: "pencil")
        let clickedtwice = UIImage(systemName: "pencil.and.outline")
        
        if (dpressed == 1) {
            selectd.setBackgroundImage(clickedonce, for: .normal)
            selectb.setBackgroundImage(noback, for: .normal)
            selectc.setBackgroundImage(noback, for: .normal)
            selecta.setBackgroundImage(noback, for: .normal)
        }
        
        else if (dpressed == 2) {
            selectd.setBackgroundImage(clickedtwice, for: .normal)
            selecta.isEnabled = false
            selectb.isEnabled = false
            selectc.isEnabled = false
            selectd.isEnabled = false
            if (rightanswer == "D") {score += 1}
            done += 1
        }
        
        else {
            selecta.setBackgroundImage(noback, for: .normal)
            selectb.setBackgroundImage(noback, for: .normal)
            selectc.setBackgroundImage(noback, for: .normal)
            selectd.setBackgroundImage(noback, for: .normal)
        }
    }
    
    
    
    
    
    
    
    
    
    
    @objc func singletimeaction() {
        completedcount += 1
        
        //print("\(done)")
       // print("\(completedcount)")
        
        countdowncount -= 1
        qcountdown.text = "\(countdowncount)"
        
        
        
        if ((countdowncount == 0 && questionnumber < (totalquestions - 1)) || (firstrun == 0 && done == 1 && questionnumber < (totalquestions - 1))) {
            completedcount = 0
            firstrun = 1
            selecta.isEnabled = false
            selectb.isEnabled = false
            selectc.isEnabled = false
            selectd.isEnabled = false
            scorelabel.text = "\(score)"
            if (rightanswer == "A") {
                selecta.setTitleColor(UIColor.green, for: .normal)
                selectb.setTitleColor(UIColor.red, for: .normal)
                selectc.setTitleColor(UIColor.red, for: .normal)
                selectd.setTitleColor(UIColor.red, for: .normal)
            }
            if (rightanswer == "B") {
                selectb.setTitleColor(UIColor.green, for: .normal)
                selecta.setTitleColor(UIColor.red, for: .normal)
                selectc.setTitleColor(UIColor.red, for: .normal)
                selectd.setTitleColor(UIColor.red, for: .normal)
            }
            if (rightanswer == "C") {
                selectc.setTitleColor(UIColor.green, for: .normal)
                selectb.setTitleColor(UIColor.red, for: .normal)
                selecta.setTitleColor(UIColor.red, for: .normal)
                selectd.setTitleColor(UIColor.red, for: .normal)
            }
            if (rightanswer == "D") {
                selectd.setTitleColor(UIColor.green, for: .normal)
                selectb.setTitleColor(UIColor.red, for: .normal)
                selectc.setTitleColor(UIColor.red, for: .normal)
                selecta.setTitleColor(UIColor.red, for: .normal)
            }
        }
        
       if ((countdowncount == 0 && questionnumber >= (totalquestions - 1)) || (firstrun == 0 && done == 1 && questionnumber >= (totalquestions - 1))) {
        completedcount = 0
        firstrun = 1
        selecta.isEnabled = false
        selectb.isEnabled = false
        selectc.isEnabled = false
        selectd.isEnabled = false
        scorelabel.text = "\(score)"
        if (rightanswer == "A") {
            selecta.setTitleColor(UIColor.green, for: .normal)
            selectb.setTitleColor(UIColor.red, for: .normal)
            selectc.setTitleColor(UIColor.red, for: .normal)
            selectd.setTitleColor(UIColor.red, for: .normal)
        }
        if (rightanswer == "B") {
            selectb.setTitleColor(UIColor.green, for: .normal)
            selecta.setTitleColor(UIColor.red, for: .normal)
            selectc.setTitleColor(UIColor.red, for: .normal)
            selectd.setTitleColor(UIColor.red, for: .normal)
        }
        if (rightanswer == "C") {
            selectc.setTitleColor(UIColor.green, for: .normal)
            selectb.setTitleColor(UIColor.red, for: .normal)
            selecta.setTitleColor(UIColor.red, for: .normal)
            selectd.setTitleColor(UIColor.red, for: .normal)
        }
        if (rightanswer == "D") {
            selectd.setTitleColor(UIColor.green, for: .normal)
            selectb.setTitleColor(UIColor.red, for: .normal)
            selectc.setTitleColor(UIColor.red, for: .normal)
            selecta.setTitleColor(UIColor.red, for: .normal)
        }
        
        }
        

        
        if ((countdowncount < 0 && questionnumber < (totalquestions - 1)) || (completedcount > 0 && done == 1 && questionnumber < (totalquestions - 1))) {
            countdowncount = 20
            firstrun = 0
            let noback = UIImage(systemName: "default")
            questionnumber += 1
            
            sleep(3)
            done = 0
            selecta.setTitleColor(UIColor.white, for: .normal)
            selectb.setTitleColor(UIColor.white, for: .normal)
            selectc.setTitleColor(UIColor.white, for: .normal)
            selectd.setTitleColor(UIColor.white, for: .normal)
            selecta.isEnabled = true
            selectb.isEnabled = true
            selectc.isEnabled = true
            selectd.isEnabled = true
            apressed = 0
            bpressed = 0
            cpressed = 0
            dpressed = 0
            selecta.setBackgroundImage(noback, for: .normal)
            selectb.setBackgroundImage(noback, for: .normal)
            selectc.setBackgroundImage(noback, for: .normal)
            selectd.setBackgroundImage(noback, for: .normal)
            qcountdown.text = "\(countdowncount)"
            readLocalJSONData()
        }
        
        if ((countdowncount < 0 && questionnumber >= (totalquestions - 1)) || (completedcount > 0 && done == 1 && questionnumber >= (totalquestions - 1))) {
        qcountdown.text = "0"
        sleep(3)
        
        countdown.invalidate()
        restartquiz()
        }
        
        
        
    }
    
    func restartquiz() {
        // Declare Alert
        let restartMessage = UIAlertController(title: "Total Score is \(score)", message: "Restart With New Quiz?", preferredStyle: .alert)
        let noback = UIImage(systemName: "default")
        // Create Yes button with action handler
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
             print("Yes button click...")
            if (self.quiznumber < 3) {
                self.quiznumber += 1
                self.reloading += 1
                self.questionnumber = 0
                self.apressed = 0
                self.bpressed = 0
                self.cpressed = 0
                self.dpressed = 0
                self.selecta.setBackgroundImage(noback, for: .normal)
                self.selectb.setBackgroundImage(noback, for: .normal)
                self.selectc.setBackgroundImage(noback, for: .normal)
                self.selectd.setBackgroundImage(noback, for: .normal)
                self.selecta.setTitleColor(UIColor.white, for: .normal)
                self.selectb.setTitleColor(UIColor.white, for: .normal)
                self.selectc.setTitleColor(UIColor.white, for: .normal)
                self.selectd.setTitleColor(UIColor.white, for: .normal)
                self.selecta.isEnabled = true
                self.selectb.isEnabled = true
                self.selectc.isEnabled = true
                self.selectd.isEnabled = true
                self.done = 0
                self.completedcount = 0
                self.score = 0
                self.firstrun = 0
                self.countdowncount = 21
                self.viewDidAppear(true)
            }
            else {
                self.quiznumber = 1
                self.reloading += 1
                self.questionnumber = 0
                self.apressed = 0
                self.bpressed = 0
                self.cpressed = 0
                self.dpressed = 0
                self.selecta.setBackgroundImage(noback, for: .normal)
                self.selectb.setBackgroundImage(noback, for: .normal)
                self.selectc.setBackgroundImage(noback, for: .normal)
                self.selectd.setBackgroundImage(noback, for: .normal)
                self.selecta.setTitleColor(UIColor.white, for: .normal)
                self.selectb.setTitleColor(UIColor.white, for: .normal)
                self.selectc.setTitleColor(UIColor.white, for: .normal)
                self.selectd.setTitleColor(UIColor.white, for: .normal)
                self.selecta.isEnabled = true
                self.selectb.isEnabled = true
                self.selectc.isEnabled = true
                self.selectd.isEnabled = true
                self.done = 0
                self.completedcount = 0
                self.score = 0
                self.firstrun = 0
                self.countdowncount = 21
                self.viewDidAppear(true)
            }
            
        })

        // Create no button with action handlder
        let no = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in
            print("No button click...")
            //self.navigationController?.popToRootViewController(animated: true)
        }

        //Add OK and Cancel button to dialog message
        restartMessage.addAction(yes)
        restartMessage.addAction(no)

        // Present dialog message to user
        self.present(restartMessage, animated: true, completion: nil)
    }
    
    
    
    //this is for when the back button is pressed, the timer is stopped
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIDevice.current.endGeneratingDeviceOrientationNotifications()

        if self.isMovingFromParent {
            countdown.invalidate()
        }
    }
    
    //for core motion
    
    func monitorDeviceOrientation(){
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientedChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func orientedChanged(){
        print("Orientation: \(UIDevice.current.orientation.rawValue)")
        
        let noback = UIImage(systemName: "default")
        let clickedonce = UIImage(systemName: "pencil")
        let clickedtwice = UIImage(systemName: "pencil.and.outline")
        
        if (UIDevice.current.orientation.rawValue == 3) {
            //print("submit")
            
            if (apressed == 1) {
                selecta.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "A") {score += 1}
                done += 1
            }
                
            else if (bpressed == 1) {
                selectb.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "B") {score += 1}
                done += 1
            }
            
            else if (cpressed == 1) {
                selectc.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "C") {score += 1}
                done += 1
            }
            
            
            else if (dpressed == 1) {
                selectd.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "D") {score += 1}
                done += 1
            }
            
            else {
                selecta.setBackgroundImage(noback, for: .normal)
                selectb.setBackgroundImage(noback, for: .normal)
                selectc.setBackgroundImage(noback, for: .normal)
                selectd.setBackgroundImage(noback, for: .normal)
            }
            
            
        }
        
        if (UIDevice.current.orientation.rawValue == 4) {
            //print("submit")
            
            if (apressed == 1) {
                selecta.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "A") {score += 1}
                done += 1
            }
                
            else if (bpressed == 1) {
                selectb.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "B") {score += 1}
                done += 1
            }
            
            else if (cpressed == 1) {
                selectc.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "C") {score += 1}
                done += 1
            }
            
            
            else if (dpressed == 1) {
                selectd.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "D") {score += 1}
                done += 1
            }
            
            else {
                selecta.setBackgroundImage(noback, for: .normal)
                selectb.setBackgroundImage(noback, for: .normal)
                selectc.setBackgroundImage(noback, for: .normal)
                selectd.setBackgroundImage(noback, for: .normal)
            }
            
            
        }
        
        if (UIDevice.current.orientation.rawValue == 5) {
            //print("A")
            
                           apressed = 1
                           bpressed = 0
                           cpressed = 0
                           dpressed = 0
                           
            
                           
                           if (apressed == 1) {
                               selecta.setBackgroundImage(clickedonce, for: .normal)
                               selectb.setBackgroundImage(noback, for: .normal)
                               selectc.setBackgroundImage(noback, for: .normal)
                               selectd.setBackgroundImage(noback, for: .normal)
                           }
                           
                           
                           else {
                               selecta.setBackgroundImage(noback, for: .normal)
                               selectb.setBackgroundImage(noback, for: .normal)
                               selectc.setBackgroundImage(noback, for: .normal)
                               selectd.setBackgroundImage(noback, for: .normal)
                           }
            
            
        }
        
        if (UIDevice.current.orientation.rawValue == 6) {
            //print("B")
                           apressed = 0
                           bpressed = 1
                           cpressed = 0
                           dpressed = 0
                           
            
                           
                           if (bpressed == 1) {
                               selectb.setBackgroundImage(clickedonce, for: .normal)
                               selectd.setBackgroundImage(noback, for: .normal)
                               selectc.setBackgroundImage(noback, for: .normal)
                               selecta.setBackgroundImage(noback, for: .normal)
                           }
                           
                           
                           else {
                               selecta.setBackgroundImage(noback, for: .normal)
                               selectb.setBackgroundImage(noback, for: .normal)
                               selectc.setBackgroundImage(noback, for: .normal)
                               selectd.setBackgroundImage(noback, for: .normal)
                           }
            
            
        }
        
    }
    
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        let noback = UIImage(systemName: "default")
        let clickedonce = UIImage(systemName: "pencil")
        
        
        if motion == .motionShake {
            let randomnum = Int.random(in: 1 ... 4)
            
            if (randomnum == 1) {
                
                               apressed = 1
                               bpressed = 0
                               cpressed = 0
                               dpressed = 0
                               
                
                               
                               if (apressed == 1) {
                                   selecta.setBackgroundImage(clickedonce, for: .normal)
                                   selectb.setBackgroundImage(noback, for: .normal)
                                   selectc.setBackgroundImage(noback, for: .normal)
                                   selectd.setBackgroundImage(noback, for: .normal)
                               }
                               
                               
                               else {
                                   selecta.setBackgroundImage(noback, for: .normal)
                                   selectb.setBackgroundImage(noback, for: .normal)
                                   selectc.setBackgroundImage(noback, for: .normal)
                                   selectd.setBackgroundImage(noback, for: .normal)
                               }
                
            }
            
            else if (randomnum == 2) {
                
                               apressed = 0
                               bpressed = 1
                               cpressed = 0
                               dpressed = 0
                               
                
                               
                               if (bpressed == 1) {
                                   selectb.setBackgroundImage(clickedonce, for: .normal)
                                   selectd.setBackgroundImage(noback, for: .normal)
                                   selectc.setBackgroundImage(noback, for: .normal)
                                   selecta.setBackgroundImage(noback, for: .normal)
                               }
                               
                               
                               else {
                                   selecta.setBackgroundImage(noback, for: .normal)
                                   selectb.setBackgroundImage(noback, for: .normal)
                                   selectc.setBackgroundImage(noback, for: .normal)
                                   selectd.setBackgroundImage(noback, for: .normal)
                               }
                
            }
            
            else if (randomnum == 3) {
                
                               apressed = 0
                               bpressed = 0
                               cpressed = 1
                               dpressed = 0
                               
                
                               
                               if (cpressed == 1) {
                                   selectc.setBackgroundImage(clickedonce, for: .normal)
                                   selectb.setBackgroundImage(noback, for: .normal)
                                   selectd.setBackgroundImage(noback, for: .normal)
                                   selecta.setBackgroundImage(noback, for: .normal)
                               }
                               
                               
                               else {
                                   selecta.setBackgroundImage(noback, for: .normal)
                                   selectb.setBackgroundImage(noback, for: .normal)
                                   selectc.setBackgroundImage(noback, for: .normal)
                                   selectd.setBackgroundImage(noback, for: .normal)
                               }
                
            }
            
            else {
                               apressed = 0
                               bpressed = 0
                               cpressed = 0
                               dpressed = 1
                               
                
                               
                               if (dpressed == 1) {
                                   selectd.setBackgroundImage(clickedonce, for: .normal)
                                   selectb.setBackgroundImage(noback, for: .normal)
                                   selectc.setBackgroundImage(noback, for: .normal)
                                   selecta.setBackgroundImage(noback, for: .normal)
                               }
                               
                               
                               else {
                                   selecta.setBackgroundImage(noback, for: .normal)
                                   selectb.setBackgroundImage(noback, for: .normal)
                                   selectc.setBackgroundImage(noback, for: .normal)
                                   selectd.setBackgroundImage(noback, for: .normal)
                               }
                
            }
            
         //   print("Device SHAKED")
            
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        print("motion ended")
    
    }
    
    
    
    
    @objc func updateDeviceMotion(){
        
        if let data = motionManager.deviceMotion {
            
            let attitude = data.attitude
            
            let userAcceleration = data.userAcceleration
            
            let noback = UIImage(systemName: "default")
            let clickedonce = UIImage(systemName: "pencil")
            let clickedtwice = UIImage(systemName: "pencil.and.outline")
            
            
            
            
           if (attitude.roll > 1.4 && attitude.pitch > 1.35 && attitude.yaw > -1) {
            //print("D")
            
                   apressed = 0
                   bpressed = 0
                   cpressed = 0
                   dpressed = 1
                   
    
                   
                   if (dpressed == 1) {
                       selectd.setBackgroundImage(clickedonce, for: .normal)
                       selectb.setBackgroundImage(noback, for: .normal)
                       selectc.setBackgroundImage(noback, for: .normal)
                       selecta.setBackgroundImage(noback, for: .normal)
                   }
                   
                   
                   else {
                       selecta.setBackgroundImage(noback, for: .normal)
                       selectb.setBackgroundImage(noback, for: .normal)
                       selectc.setBackgroundImage(noback, for: .normal)
                       selectd.setBackgroundImage(noback, for: .normal)
                   }
            
            }
            
           if (attitude.roll < -1.2 && attitude.roll > -2 && attitude.pitch > 1.35 && attitude.yaw > -1) {
            //print("C")
            
                           apressed = 0
                           bpressed = 0
                           cpressed = 1
                           dpressed = 0
                           
            
                           
                           if (cpressed == 1) {
                               selectc.setBackgroundImage(clickedonce, for: .normal)
                               selectb.setBackgroundImage(noback, for: .normal)
                               selectd.setBackgroundImage(noback, for: .normal)
                               selecta.setBackgroundImage(noback, for: .normal)
                           }
                           
                           
                           else {
                               selecta.setBackgroundImage(noback, for: .normal)
                               selectb.setBackgroundImage(noback, for: .normal)
                               selectc.setBackgroundImage(noback, for: .normal)
                               selectd.setBackgroundImage(noback, for: .normal)
                           }
            
            }
            
          //  pitch: \(attitude.pitch),
            
           // print(" roll: \(attitude.roll), yaw: \(attitude.yaw)")
            
            if (userAcceleration.z > 1.2) {print("submit")
           // print("z-acceleration: \(userAcceleration.z)")
            
            if (apressed == 1) {
                selecta.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "A") {score += 1}
                done += 1
            }
                
            else if (bpressed == 1) {
                selectb.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "B") {score += 1}
                done += 1
            }
            
            else if (cpressed == 1) {
                selectc.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "C") {score += 1}
                done += 1
            }
            
            
            else if (dpressed == 1) {
                selectd.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "D") {score += 1}
                done += 1
            }
            
            else {
                selecta.setBackgroundImage(noback, for: .normal)
                selectb.setBackgroundImage(noback, for: .normal)
                selectc.setBackgroundImage(noback, for: .normal)
                selectd.setBackgroundImage(noback, for: .normal)
            }
            
            }
            
        }
        
        
    }
    
    
    

}


