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
    setUpCapture()
        
    }


    @IBAction func Identify_TouchUpInside(_ sender: Any) {
        
        //switch statement
        identifying = !identifying
        
        if identifying {
           
            //if you set the image on another  UIButton

            
            identifyButtonOutlet.setImage(UIImage(named: "stop-1"), for: .normal)
            startCapturing()
            
        } else {
            identifyButtonOutlet.setImage(UIImage(named: "identify-160"), for: [])
            stopCapturing()
            
            
        }
        
    }
    
    //start Capture Session
    func startCapturing() {
        captureSession.startRunning()
        
    }
    
    func stopCapturing() {
        captureSession.stopRunning()
    }
    
    //setting capture session
    func setUpCapture() {
        
        
        captureSession.sessionPreset = .photo //live feed of camera
        
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        //use guard on 'call can throw' try, if error return
        guard let input = try? AVCaptureDeviceInput(device: captureDevice!) else { return }
        
        captureSession.addInput(input)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 80)
    
        //out of camera
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        captureSession.addOutput(dataOutput)
        
    }
    
    // MARK:  AVCaptureVideoDataOutputSampleBufferDelegate
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    //  print ("captured frame", Date())
        
        let cvPixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
   
    //Set up Core Model to take info /get output what it thinks in picture - MobileNet
        
        guard let model = try? VNCoreMLModel(for: MobileNet().model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            if error != nil {
                print("error \(error!.localizedDescription)")
                return
            }
            
            print("request \(request.results)")
       
            guard let result = request.results as? [VNClassificationObservation]
            else { return }
            
            guard let firstObservation = result.first else {
                return
            }
            
            //for label
            DispatchQueue.main.async {
                let confidence = String(format: "K %.2f", firstObservation.confidence * 100)
                self.objectLabel.text = "\(firstObservation.identifier, confidence)%"
                
                
                
                
                
                
            }
            
            
            
        }
    }
    
    
    
}
