//
//  ViewController.swift
//  IdentifyThis
//
//  Created by Cons Bulaqueña on 19/03/2018.
//  Copyright © 2018 consios. All rights reserved.
//

import UIKit
import AVKit
import Vision


class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    //AVcapture -everytime camera gets, record frame, tell delegate or view the frame
    
    @IBOutlet var objectLabel: UILabel!
    @IBOutlet var identifyButtonOutlet: UIButton!
    
    var captureSession: AVCaptureSession!
    var identifying = false //stop button
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    captureSession = AVCaptureSession()
    
        
    }


    @IBAction func Identify_TouchUpInside(_ sender: Any) {
        
        //switch statement
        identifying = !identifying
        
        if identifying {
           
            //if you set the image on another  UIButton

            
            identifyButtonOutlet.setImage(UIImage(named: "stop-1"), for: .normal)
        } else {
            identifyButtonOutlet.setImage(UIImage(named: "identify-160"), for: [])
            


        }
        
        }
        
}
    


