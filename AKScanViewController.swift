//
//  AKScanViewController.swift
//  piojos
//
//  Created by Alvaro Royo on 10/4/17.
//  Copyright © 2017 Alvaro Royo. All rights reserved.
//

import UIKit
import AVFoundation

enum AKScanType {
    case QR
    case EAN13
    case EAN8
}

protocol AKScanDelegate: class {
    func scanner(result:String!)
}

class AKScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    weak var delegate:AKScanDelegate?
    var type:AKScanType = AKScanType.QR
    private var trueType:String!
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var resultLbl: UILabel!
    
    @IBOutlet weak var qrView: UIView!
    @IBOutlet weak var barCodeView: UIView!
    
    private var captureSession:AVCaptureSession!
    private var videoPreviewLayer:AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do{
            
            let input = try AVCaptureDeviceInput.init(device: captureDevice)
            
            self.captureSession = AVCaptureSession()
            self.captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            self.captureSession.addOutput(captureMetadataOutput)
            
            let concurrentQueue = DispatchQueue(label: "SCAN_CODES_THREAD", attributes: .concurrent)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: concurrentQueue)
            
            switch self.type {
            case .QR:
                captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
                self.trueType = AVMetadataObjectTypeQRCode
                self.qrView.isHidden = false
                break
            case .EAN13:
                captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code]
                self.trueType = AVMetadataObjectTypeEAN13Code
                self.barCodeView.isHidden = false
                break
            case .EAN8:
                captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code]
                self.trueType = AVMetadataObjectTypeEAN8Code
                self.barCodeView.isHidden = false
                break
            }
            
            self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            self.videoView.layer.addSublayer(self.videoPreviewLayer)
            self.videoPreviewLayer.frame = self.videoView.frame
            
            self.videoPreviewLayer.connection.videoOrientation = .portrait
            
            self.captureSession.startRunning()
            
        } catch {
            
            print("Es posible que el dispositivo no tenga cámara. O la aplicación no disponga de permisos para usarla.")
            
        }
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        let metadataObj = metadataObjects.first as! AVMetadataMachineReadableCodeObject
        
        if(metadataObj.type == self.trueType){
            
            let result = metadataObj.stringValue
            
            print("Code readed: %@",result!)
            
            self.captureSession.stopRunning()
            
            DispatchQueue.main.async {
                self.resultLbl.text = result
            }
            
        }
        
    }

}
