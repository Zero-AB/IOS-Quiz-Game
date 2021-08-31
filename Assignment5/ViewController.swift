//
//  ViewController.swift
//  Assignment5
//
//  Created by Andrew Bell on 4/27/20.
//  Copyright © 2020 Andrew Bell. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, UINavigationControllerDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate {
    
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
            }
    
    
    @IBOutlet weak var mainlogo: UIImageView!
    
    @IBOutlet weak var over: UILabel!
    
    @IBOutlet weak var start: UIButton!
    
    @IBOutlet weak var matter: UILabel!
    
    @IBOutlet weak var singlemulti: UISegmentedControl!
    
    @IBOutlet weak var connectbutton: UIBarButtonItem!
    
    var playerchoice = 1
    
    var numberofplayers = 1
    
    var session: MCSession!
    var peerID: MCPeerID!
    
    var browser: MCBrowserViewController!
    var assistant: MCNearbyServiceAdvertiser!
   // var assistant: MCAdvertiserAssistant!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        self.browser = MCBrowserViewController(serviceType: "chat17", session: session)
       // self.assistant = MCAdvertiserAssistant(serviceType: "chat17", discoveryInfo: nil, session: session)
        self.assistant = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "chat17")
        
        assistant.delegate = self
        assistant.startAdvertisingPeer()
       // assistant.start()
        session.delegate = self
        browser.delegate = self
        
        connectbutton.isEnabled = false
        
    }
    
    
    
    @IBAction func playerchoice(_ sender: Any) {
        
        switch singlemulti.selectedSegmentIndex
        {
        case 0:
            playerchoice = 1
            connectbutton.isEnabled = false
            numberofplayers = 1
        case 1:
            playerchoice = 2
            connectbutton.isEnabled = true
        default:
            break
        }
    
    }
    
    
    @IBAction func startquiz(_ sender: Any) {
        
        if (playerchoice == 1) {
        performSegue(withIdentifier: "maintosingle", sender: self)
        }
        
        else if (playerchoice == 2) {
            if (session.connectedPeers.count < 1) {
               // print("\(session.connectedPeers.count)")
                noplayerserror()
            }
                
            else if (session.connectedPeers.count > 3) {
               // print("\(session.connectedPeers.count)")
                toomanyplayerserror()
            }
            
            else {
                
                let msg = "start"
                
                
                let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: msg)
                
                do{
                    try session.send(dataToSend, toPeers: session.connectedPeers, with: .reliable)
                    print("connected players = \(session.connectedPeers.count)")
                    performSegue(withIdentifier: "maintomulti", sender: self)
                }
                catch let err {
                    print("Error in sending data \(err)")
                }
                
                
                
                //performSegue(withIdentifier: "maintomulti", sender: self)
              //  print("\(session.connectedPeers.count)")
            }
        }
            
        else {}
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
             if segue.identifier == "maintomulti" {
                   
                   if let multi = segue.destination as? multiplayerquiz {
                    
                    numberofplayers = session.connectedPeers.count + 1
                    
                       
                    multi.numberoplayers = self.numberofplayers
                    multi.peerID = self.peerID
                    multi.session = self.session
                    multi.assistant = self.assistant
                    multi.browser = self.browser
                     
                   }
             }
        }
    
    
    
    
    func noplayerserror () {
        let Message = UIAlertController(title: "Not Enough Players", message: "Please Invite A Friend", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                   print("Ok button clicked")
               }
        
        Message.addAction(ok)

        // Present dialog message to user
        self.present(Message, animated: true, completion: nil)
        
    }
    
    func toomanyplayerserror () {
        let Messages = UIAlertController(title: "Too Many Players", message: "Please Disconnect A Player", preferredStyle: .alert)
        
        let k = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                   print("Ok button clicked")
               }
        
        Messages.addAction(k)

        // Present dialog message to user
        self.present(Messages, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func connection(_ sender: Any) {
        
        present(browser, animated: true, completion: nil)
        
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
            
                if (receivedString == "start") {self.performSegue(withIdentifier: "maintomulti", sender: self)}
                
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

    
    
    
    
    
    
    
    


}

