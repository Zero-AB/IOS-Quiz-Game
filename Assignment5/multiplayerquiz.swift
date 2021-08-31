//
//  multiplayerquiz.swift
//  Assignment5
//
//  Created by Andrew Bell on 4/27/20.
//  Copyright © 2020 Andrew Bell. All rights reserved.
//

import UIKit
import CoreMotion
import MultipeerConnectivity

class multiplayerquiz: UIViewController, UINavigationControllerDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate {
    
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
    
    @IBOutlet weak var player1label: UILabel!
    
    @IBOutlet weak var player2label: UILabel!
    
    @IBOutlet weak var player3label: UILabel!
    
    @IBOutlet weak var player4label: UILabel!
    
    @IBOutlet weak var player1image: UIImageView!
    
    @IBOutlet weak var player2image: UIImageView!
    
    @IBOutlet weak var player3image: UIImageView!
    
    @IBOutlet weak var player4image: UIImageView!
    
    @IBOutlet weak var player1scorelabel: UILabel!
    
    @IBOutlet weak var player2scorelabel: UILabel!
    
    @IBOutlet weak var player3scorelabel: UILabel!
    
    @IBOutlet weak var player4scorelabel: UILabel!
    
    @IBOutlet weak var player1answerlabel: UILabel!
    
    @IBOutlet weak var player2answerlabel: UILabel!
    
    @IBOutlet weak var player3answerlabel: UILabel!
    
    @IBOutlet weak var player4answerlabel: UILabel!
    
    var countdown = Timer()
    
    var countdowncount = 20
    
    var completedcount = 0
    
    var totalquestions = Int()
    
    var player1score = 0
    
    var player2score = 0
    
    var player3score = 0
    
    var player4score = 0
    
    var numberoplayers = 1
    
    let zero = UIImage(named: "noplayer")
    let one = UIImage(named: "player1")
    let two = UIImage(named: "player2")
    let three = UIImage(named: "player3")
    let four = UIImage(named: "player4")
    
    var motionManager = CMMotionManager()
    
    var session: MCSession!
    var peerID: MCPeerID!
    var player2: MCPeerID?
    var player3: MCPeerID?
    var player4: MCPeerID?
    
    var browser: MCBrowserViewController!
    var assistant: MCNearbyServiceAdvertiser!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //multipeer stuff ----------------------
        /*
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
         self.session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
         self.browser = MCBrowserViewController(serviceType: "chat17", session: session)
        // self.assistant = MCAdvertiserAssistant(serviceType: "chat17", discoveryInfo: nil, session: session)
         self.assistant = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "chat17")
         
         */
         
         assistant.delegate = self
         assistant.startAdvertisingPeer()
        // assistant.start()
         session.delegate = self
         browser.delegate = self
        
        // ------------------------------------
        
        
    
        
        monitorDeviceOrientation()
        
        if (numberoplayers == 1) {
            player1image.image = one
            player1image.contentMode = .scaleAspectFit
            player1label.text = ("\(peerID.displayName)")
            player1answerlabel.isHidden = true
            player2image.image = zero
            player2image.contentMode = .scaleAspectFit
            player2label.text = "No Player"
            player2scorelabel.isHidden = true
            player2answerlabel.isHidden = true
            player3image.image = zero
            player3image.contentMode = .scaleAspectFit
            player3label.text = "No Player"
            player3scorelabel.isHidden = true
            player3answerlabel.isHidden = true
            player4image.image = zero
            player4image.contentMode = .scaleAspectFit
            player4label.text = "No Player"
            player4scorelabel.isHidden = true
            player4answerlabel.isHidden = true
        }
        
        if (numberoplayers == 2) {
            //print("connected players = \(session.connectedPeers.count)")
            player2 = session.connectedPeers[0]
            player1image.image = one
            player1image.contentMode = .scaleAspectFit
            player1label.text = ("\(peerID.displayName)")
            player1answerlabel.isHidden = true
            //player1label.text = ("\(String(describing: peerID.displayName))!")
           // print("\(peerID.displayName)")
           // print("\(String(describing: peerID))!")
            player2image.image = two
            player2image.contentMode = .scaleAspectFit
            player2label.text = ("\(String(describing: player2!.displayName))")
            player2answerlabel.isHidden = true
            //print("connected player = \(String(describing: player2?.displayName))")
            player3image.image = zero
            player3image.contentMode = .scaleAspectFit
            player3label.text = "No Player"
            player3scorelabel.isHidden = true
            player3answerlabel.isHidden = true
            player4image.image = zero
            player4image.contentMode = .scaleAspectFit
            player4label.text = "No Player"
            player4scorelabel.isHidden = true
            player4answerlabel.isHidden = true
        }
        
        if (numberoplayers == 3) {
            player2 = session.connectedPeers[0]
            player3 = session.connectedPeers[1]
            player1image.image = one
            player1image.contentMode = .scaleAspectFit
            player1label.text = ("\(peerID.displayName)")
            player1answerlabel.isHidden = true
            player2image.image = two
            player2image.contentMode = .scaleAspectFit
            player2label.text = ("\(String(describing: player2!.displayName))")
            player2answerlabel.isHidden = true
            player3image.image = three
            player3image.contentMode = .scaleAspectFit
            player3label.text = ("\(String(describing: player3!.displayName))")
            player3answerlabel.isHidden = true
            player4image.image = zero
            player4image.contentMode = .scaleAspectFit
            player4label.text = "No Player"
            player4scorelabel.isHidden = true
            player4answerlabel.isHidden = true
        }
        
        if (numberoplayers == 4) {
            player2 = session.connectedPeers[0]
            player3 = session.connectedPeers[1]
            player4 = session.connectedPeers[2]
            player1image.image = one
            player1image.contentMode = .scaleAspectFit
            player1label.text = ("\(peerID.displayName)")
            player1answerlabel.isHidden = true
            player2image.image = two
            player2image.contentMode = .scaleAspectFit
            player2label.text = ("\(String(describing: player2!.displayName))")
            player2answerlabel.isHidden = true
            player3image.image = three
            player3image.contentMode = .scaleAspectFit
            player3label.text = ("\(String(describing: player3!.displayName))")
            player3answerlabel.isHidden = true
            player4image.image = four
            player4image.contentMode = .scaleAspectFit
            player4label.text = ("\(String(describing: player4!.displayName))")
            player4answerlabel.isHidden = true
        }
        
        countdown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(multiplayerquiz.multitimeaction), userInfo: nil, repeats: true)
        readLocalJSONData()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
        
        if (reloading > 0) {
            player1scorelabel.text = "\(player1score)"
            player2scorelabel.text = "\(player2score)"
            player3scorelabel.text = "\(player3score)"
            player4scorelabel.text = "\(player4score)"
            
            player1answerlabel.isHidden = true
            player2answerlabel.isHidden = true
            player3answerlabel.isHidden = true
            player4answerlabel.isHidden = true
        
        countdown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(multiplayerquiz.multitimeaction), userInfo: nil, repeats: true)
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
            if (rightanswer == "A") {player1score += 1
                scoreup()
            }
            done += 1
            submitted()
            player1answerlabel.text = "A"
            answereda()
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
            if (rightanswer == "B") {player1score += 1
                scoreup()
            }
            done += 1
            submitted()
            player1answerlabel.text = "B"
            answeredb()
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
            if (rightanswer == "C") {player1score += 1
                scoreup()
            }
            done += 1
            submitted()
            player1answerlabel.text = "C"
            answeredc()
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
                   if (rightanswer == "D") {player1score += 1
                    scoreup()
                }
                   done += 1
                submitted()
                player1answerlabel.text = "D"
                answeredd()
               }
               
               else {
                   selecta.setBackgroundImage(noback, for: .normal)
                   selectb.setBackgroundImage(noback, for: .normal)
                   selectc.setBackgroundImage(noback, for: .normal)
                   selectd.setBackgroundImage(noback, for: .normal)
               }
    }
    
    
    
    func scoreup() {
        
        let messg = "scoreup"
        
        
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: messg)
        
        do{
            try session.send(dataToSend, toPeers: session.connectedPeers, with: .reliable)
        }
        catch let err {
            print("Error in sending data \(err)")
        }
        
    }
    
    func submitted() {
        
        let messag = "selected"
        
        
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: messag)
        
        do{
            try session.send(dataToSend, toPeers: session.connectedPeers, with: .reliable)
        }
        catch let err {
            print("Error in sending data \(err)")
        }
        
    }
    
    func answereda(){
        let rc = "answereda"
        
        
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: rc)
        
        do{
            try session.send(dataToSend, toPeers: session.connectedPeers, with: .reliable)
        }
        catch let err {
            print("Error in sending data \(err)")
        }
        
    }
    
    func answeredb(){
        let ra = "answeredb"
        
        
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: ra)
        
        do{
            try session.send(dataToSend, toPeers: session.connectedPeers, with: .reliable)
        }
        catch let err {
            print("Error in sending data \(err)")
        }
        
    }
    
    func answeredc(){
        let rd = "answeredc"
        
        
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: rd)
        
        do{
            try session.send(dataToSend, toPeers: session.connectedPeers, with: .reliable)
        }
        catch let err {
            print("Error in sending data \(err)")
        }
        
    }
    
    func answeredd(){
        let rt = "answeredd"
        
        
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: rt)
        
        do{
            try session.send(dataToSend, toPeers: session.connectedPeers, with: .reliable)
        }
        catch let err {
            print("Error in sending data \(err)")
        }
        
    }
    
    
    
    
    @objc func multitimeaction() {
        completedcount += 1
         
         //print("\(done)")
        // print("\(completedcount)")
         
         countdowncount -= 1
         qcountdown.text = "\(countdowncount)"
         
         
         
         if ((countdowncount == 0 && questionnumber < (totalquestions - 1)) || (firstrun == 0 && done == (numberoplayers) && questionnumber < (totalquestions - 1))) {
             completedcount = 0
             firstrun = 1
             selecta.isEnabled = false
             selectb.isEnabled = false
             selectc.isEnabled = false
             selectd.isEnabled = false
             player1scorelabel.text = "\(player1score)"
             player2scorelabel.text = "\(player2score)"
             player3scorelabel.text = "\(player3score)"
             player4scorelabel.text = "\(player4score)"
             player1answerlabel.isHidden = false
             player2answerlabel.isHidden = false
             player3answerlabel.isHidden = false
             player4answerlabel.isHidden = false
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
         
        if ((countdowncount == 0 && questionnumber >= (totalquestions - 1)) || (firstrun == 0 && done == (numberoplayers) && questionnumber >= (totalquestions - 1))) {
         completedcount = 0
         firstrun = 1
         selecta.isEnabled = false
         selectb.isEnabled = false
         selectc.isEnabled = false
         selectd.isEnabled = false
         player1scorelabel.text = "\(player1score)"
         player2scorelabel.text = "\(player2score)"
         player3scorelabel.text = "\(player3score)"
         player4scorelabel.text = "\(player4score)"
         player1answerlabel.isHidden = false
         player2answerlabel.isHidden = false
         player3answerlabel.isHidden = false
         player4answerlabel.isHidden = false
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
         

         
         if ((countdowncount < 0 && questionnumber < (totalquestions - 1)) || (completedcount > 0 && done == (numberoplayers) && questionnumber < (totalquestions - 1))) {
             countdowncount = 20
             firstrun = 0
             let noback = UIImage(systemName: "default")
             questionnumber += 1
             player1answerlabel.isHidden = true
             player2answerlabel.isHidden = true
             player3answerlabel.isHidden = true
             player4answerlabel.isHidden = true
             
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
         
         if ((countdowncount < 0 && questionnumber >= (totalquestions - 1)) || (completedcount > 0 && done == (numberoplayers) && questionnumber >= (totalquestions - 1))) {
         qcountdown.text = "0"
         sleep(3)
         
         countdown.invalidate()
         restartquiz()
         }
         
    }
    
    
    
    func restartquiz() {
        // Declare Alert
        
        var title = ""
        
        if ((player1score >= player2score) && (player1score >= player3score) && (player1score >= player4score)) {
            
            if ((player1score > player2score) && (player1score > player3score) && (player1score > player4score)) {
                title = "You Won!"
            }
            
            else {title = "You Are One Of The Winners"}
        }
        
        else {
            title = "You Lost"
        }
        
        
        let restartMessage = UIAlertController(title: ("\(title)"), message: "Restart With New Quiz?", preferredStyle: .alert)
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
                self.player1score = 0
                self.player2score = 0
                self.player3score = 0
                self.player4score = 0
                self.firstrun = 0
                self.countdowncount = 21
                let mg = "restart"
                
                
                let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: mg)
                
                do{
                    try self.session.send(dataToSend, toPeers: self.session.connectedPeers, with: .reliable)
                }
                catch let err {
                    print("Error in sending data \(err)")
                }
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
                self.player1score = 0
                self.player2score = 0
                self.player3score = 0
                self.player4score = 0
                self.firstrun = 0
                self.countdowncount = 21
                let ms = "restart"
                
                
                let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: ms)
                
                do{
                    try self.session.send(dataToSend, toPeers: self.session.connectedPeers, with: .reliable)
                }
                catch let err {
                    print("Error in sending data \(err)")
                }
                self.viewDidAppear(true)
                
            }
            
        })

        // Create no button with action handlder
        let no = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in
            print("No button click...")
            let mesg = "no"
            
            
            let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: mesg)
            
            do{
                try self.session.send(dataToSend, toPeers: self.session.connectedPeers, with: .unreliable)
            }
            catch let err {
                print("Error in sending data \(err)")
            }
            self.countdown.invalidate()
            self.navigationController?.popToRootViewController(animated: true)
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
        
        let mesg = "back"
                   
                   
                   let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: mesg)
                   
                   do{
                       try session.send(dataToSend, toPeers: session.connectedPeers, with: .unreliable)
                   }
                   catch let err {
                       print("Error in sending data \(err)")
                   }

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
                if (rightanswer == "A") {
                    player1score += 1
                    scoreup()
                }
                done += 1
                submitted()
                player1answerlabel.text = "A"
                answereda()
            }
                
            else if (bpressed == 1) {
                selectb.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "B") {
                    player1score += 1
                    scoreup()
                    
                }
                done += 1
                submitted()
                player1answerlabel.text = "B"
                answeredb()
            }
            
            else if (cpressed == 1) {
                selectc.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "C") {
                    player1score += 1
                    scoreup()
                    
                }
                done += 1
                submitted()
                player1answerlabel.text = "C"
                answeredc()
            }
            
            
            else if (dpressed == 1) {
                selectd.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "D") {
                    player1score += 1
                    scoreup()
                    
                }
                done += 1
                submitted()
                player1answerlabel.text = "D"
                answeredd()
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
                if (rightanswer == "A") {
                    player1score += 1
                    scoreup()
                    
                }
                done += 1
                submitted()
                player1answerlabel.text = "A"
                answereda()
            }
                
            else if (bpressed == 1) {
                selectb.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "B") {
                    player1score += 1
                    scoreup()
                    
                }
                done += 1
                submitted()
                player1answerlabel.text = "B"
                answeredb()
            }
            
            else if (cpressed == 1) {
                selectc.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "C") {
                    player1score += 1
                    scoreup()
                    
                }
                done += 1
                submitted()
                player1answerlabel.text = "C"
                answeredc()
            }
            
            
            else if (dpressed == 1) {
                selectd.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "D") {
                    player1score += 1
                    scoreup()
                    
                }
                done += 1
                submitted()
                player1answerlabel.text = "D"
                answeredd()
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
                if (rightanswer == "A") {
                    player1score += 1
                    scoreup()
                    
                }
                done += 1
                submitted()
                player1answerlabel.text = "A"
                answereda()
            }
                
            else if (bpressed == 1) {
                selectb.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "B") {
                    player1score += 1
                    scoreup()
                    
                }
                done += 1
                submitted()
                player1answerlabel.text = "B"
                answeredb()
            }
            
            else if (cpressed == 1) {
                selectc.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "C") {
                    player1score += 1
                    scoreup()
                    
                }
                done += 1
                submitted()
                player1answerlabel.text = "C"
                answeredc()
            }
            
            
            else if (dpressed == 1) {
                selectd.setBackgroundImage(clickedtwice, for: .normal)
                selecta.isEnabled = false
                selectb.isEnabled = false
                selectc.isEnabled = false
                selectd.isEnabled = false
                if (rightanswer == "D") {
                    player1score += 1
                    scoreup()
                    
                }
                done += 1
                submitted()
                player1answerlabel.text = "D"
                answeredd()
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
    
    
    
    
    
    
    //**********************************************************
    // required functions for MCBrowserViewControllerDelegate
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        // Called when the browser view controller is dismissed
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        // Called when the browser view controller is cancelled
        dismiss(animated: true, completion: nil)
    }
     //**********************************************************
    
    
    
    
    //**********************************************************
    // required functions for MCSessionDelegate
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        print("inside didReceiveData")
        
        DispatchQueue.main.async(execute: {
            
            if let receivedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? String{
            
                if (receivedString == "selected") {
                    //self.performSegue(withIdentifier: "maintomulti", sender: self)
                    
                    if (self.player2 == peerID) {
                        self.done += 1
                    }
                    
                    if (self.player3 == peerID) {
                        self.done += 1
                    }
                    
                    if (self.player4 == peerID) {
                        self.done += 1
                    }
                
                    
                    
                }
                
                if (receivedString == "scoreup") {
                    //self.performSegue(withIdentifier: "maintomulti", sender: self)
                    
                    if (self.player2 == peerID) {
                        self.player2score += 1
                    }
                    
                    if (self.player3 == peerID) {
                        self.player3score += 1
                    }
                    
                    if (self.player4 == peerID) {
                        self.player4score += 1
                    }
                
                    
                    
                }
                
                if (receivedString == "answereda") {
                    //self.performSegue(withIdentifier: "maintomulti", sender: self)
                    
                    if (self.player2 == peerID) {
                        self.player2answerlabel.text = "A"
                    }
                    
                    if (self.player3 == peerID) {
                        self.player3answerlabel.text = "A"
                    }
                    
                    if (self.player4 == peerID) {
                        self.player4answerlabel.text = "A"
                    }
                    
                }
                
                if (receivedString == "answeredb") {
                    //self.performSegue(withIdentifier: "maintomulti", sender: self)
                    
                    if (self.player2 == peerID) {
                        self.player2answerlabel.text = "B"
                    }
                    
                    if (self.player3 == peerID) {
                        self.player3answerlabel.text = "B"
                    }
                    
                    if (self.player4 == peerID) {
                        self.player4answerlabel.text = "B"
                    }
                    
                }
                
                if (receivedString == "answeredc") {
                    //self.performSegue(withIdentifier: "maintomulti", sender: self)
                    
                    if (self.player2 == peerID) {
                        self.player2answerlabel.text = "C"
                    }
                    
                    if (self.player3 == peerID) {
                        self.player3answerlabel.text = "C"
                    }
                    
                    if (self.player4 == peerID) {
                        self.player4answerlabel.text = "C"
                    }
                    
                }
                
                if (receivedString == "answeredd") {
                    //self.performSegue(withIdentifier: "maintomulti", sender: self)
                    
                    if (self.player2 == peerID) {
                        self.player2answerlabel.text = "D"
                    }
                    
                    if (self.player3 == peerID) {
                        self.player3answerlabel.text = "D"
                    }
                    
                    if (self.player4 == peerID) {
                        self.player4answerlabel.text = "D"
                    }
                    
                }
                
                
                if (receivedString == "restart") {
                    //self.performSegue(withIdentifier: "maintomulti", sender: self)
                    let noback = UIImage(systemName: "default")
                    
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
                        self.player1score = 0
                        self.player2score = 0
                        self.player3score = 0
                        self.player4score = 0
                        self.firstrun = 0
                        self.countdowncount = 21
                        self.dismiss(animated: true, completion: nil)
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
                        self.player1score = 0
                        self.player2score = 0
                        self.player3score = 0
                        self.player4score = 0
                        self.firstrun = 0
                        self.countdowncount = 21
                        self.dismiss(animated: true, completion: nil)
                        self.viewDidAppear(true)
                    }
                    
                    
                    
                }
                
                if (receivedString == "back") {
                    //self.performSegue(withIdentifier: "maintomulti", sender: self)
                    
                    self.countdown.invalidate()
                    self.navigationController?.popToRootViewController(animated: true)
                    
                    
                }
                
                if (receivedString == "no") {
                    //self.performSegue(withIdentifier: "maintomulti", sender: self)
                    
                    self.countdown.invalidate()
                    self.dismiss(animated: true, completion: nil)
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    
                    
                    
                }
                
                
                
            }
            
            
            
            
        })
        
       
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        // Called when a connected peer changes state (for example, goes offline)
        DispatchQueue.main.async(execute: {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            
        @unknown default:
            print("Default")
        }
        })
        
    }
    

    //**********************************************************

    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    invitationHandler(true, session)
        }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
