//
//  SpeechRecognitionViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/9/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Speech
import CallKit

class SpeechRecognitionViewController: UIViewController {
    
    var delegate: controlSaveLocation?
    var timer: Timer?
    var speechTimer: Timer?
    
    var audioEngine: AVAudioEngine?
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    var pulsatingLayer: CAShapeLayer!
    var pulsatingLayer2: CAShapeLayer!
    
    var microphoneButton: UIButton = {
        let button = UIButton()
        if let myImage = UIImage(named: "selectedMicrophone") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        button.tintColor = Theme.WHITE
        button.backgroundColor = UIColor.clear
//        button.imageEdgeInsets = UIEdgeInsets(top: -25, left: -25, bottom: -25, right: -25)
        button.layer.cornerRadius = 105
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var microphoneBackground: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 120
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 240, height: 240))
        
        let gradient = CAGradientLayer()
        gradient.frame =  button.frame
        gradient.colors = [Theme.PURPLE.cgColor, Theme.PACIFIC_BLUE.cgColor]
        gradient.cornerRadius = button.layer.cornerRadius
        
        let shape = CAShapeLayer()
        shape.lineWidth = 10
        shape.shadowRadius = 5
        shape.shadowOpacity = 0.4
        shape.cornerRadius = button.layer.cornerRadius
        shape.path = UIBezierPath(roundedRect: button.frame, cornerRadius: button.layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        button.layer.addSublayer(gradient)
        
        return button
    }()
    
    var hiddenGradient: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 50
        view.alpha = 0.4
        view.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100))
        
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [Theme.PACIFIC_BLUE.cgColor, Theme.PURPLE.cgColor]
        gradient.cornerRadius = view.layer.cornerRadius
        
        view.layer.addSublayer(gradient)
        return view
    }()
    
    var detectedLabel: UILabel = {
        let label = UILabel()
        label.text = "Begin speaking"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPLightH1
        label.numberOfLines = 3
        
        return label
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Delete")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(exitButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        let background = CAGradientLayer().customColor(topColor: Theme.BLACK.withAlphaComponent(0.95), bottomColor: Theme.BLACK.withAlphaComponent(0.87))
        background.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        background.zPosition = -10
        view.layer.addSublayer(background)

        setupViews()
    }
    
    var microphoneHeightAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(microphoneBackground)
        self.view.addSubview(hiddenGradient)
        self.view.addSubview(microphoneButton)
        
        microphoneBackground.centerXAnchor.constraint(equalTo: microphoneButton.centerXAnchor).isActive = true
        microphoneBackground.centerYAnchor.constraint(equalTo: microphoneButton.centerYAnchor).isActive = true
        microphoneHeightAnchor = microphoneBackground.heightAnchor.constraint(equalToConstant: 240)
            microphoneHeightAnchor.isActive = true
        microphoneBackground.widthAnchor.constraint(equalTo: microphoneBackground.heightAnchor).isActive = true
        
        hiddenGradient.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        hiddenGradient.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 40).isActive = true
        hiddenGradient.heightAnchor.constraint(equalToConstant: 100).isActive = true
        hiddenGradient.widthAnchor.constraint(equalTo: hiddenGradient.heightAnchor).isActive = true
        
        microphoneButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        microphoneButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 40).isActive = true
        microphoneButton.heightAnchor.constraint(equalToConstant: 210).isActive = true
        microphoneButton.widthAnchor.constraint(equalTo: microphoneButton.heightAnchor).isActive = true
        
        self.view.addSubview(detectedLabel)
        detectedLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        detectedLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true
        detectedLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80).isActive = true
        detectedLabel.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        self.view.addSubview(exitButton)
        exitButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        switch device {
        case .iphone8:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24).isActive = true
        case .iphoneX:
            exitButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 36).isActive = true
        }
        
    }
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 40, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.opacity = 0
        layer.lineWidth = 20
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = microphoneButton.center
        return layer
    }
    
    @objc func exitButtonPressed(sender: UIButton) {
        self.endSpeechRecognition()
        UIView.animate(withDuration: animationIn) {
            self.view.alpha = 0
            self.view.layoutIfNeeded()
        }
    }

    private func isOnPhoneCall() -> Bool {
        for call in CXCallObserver().calls {
            if call.hasEnded == false {
                return true
            }
        }
        return false
    }
    
    func recordAndRecognizeSpeech() {
//        audioEngine = AVAudioEngine()
//        requestSpeechAuthorization()
//
//        if !isOnPhoneCall() {
//            let node = audioEngine?.inputNode
//            let recordingFormat = node?.outputFormat(forBus: 0)
//            node?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
//                self.request.append(buffer)
//            }
//            audioEngine?.prepare()
//            do {
//                try audioEngine?.start()
//                self.beginAnimating()
//            } catch {
//                return print(error)
//            }
//            guard let recognizer = SFSpeechRecognizer() else { return }
//            if !recognizer.isAvailable {
//                return
//            }
//            recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
//                if let result = result {
//                    let bestString = result.bestTranscription.formattedString
//                    self.detectedLabel.text = bestString
//                    self.restartSpeechTimer()
//                } else if let error = error {
//                    print(error)
//                }
//            })
//        }
    }
    
    func beginAnimating() {
        animating()
        rotateView(targetView: microphoneBackground)
        speechTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(animating), userInfo: nil, repeats: true)
    }
    
    @objc func animating() {
        UIView.animate(withDuration: 3, delay: 0, options: [.curveEaseIn], animations: {
            self.microphoneBackground.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.hiddenGradient.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }) { (success) in
            UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseOut], animations: {
                self.microphoneBackground.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.hiddenGradient.transform = CGAffineTransform(scaleX: 2.8, y: 2.8)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func rotateView(targetView: UIView, duration: Double = 2.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat.pi)
        }) { finished in
            self.rotateView(targetView: targetView, duration: duration)
        }
    }

    
    func endSpeechRecognition() {
//        audioEngine?.stop()
//        request.endAudio()
//        speechTimer?.invalidate()
//        self.microphoneBackground.layer.removeAllAnimations()
//        self.microphoneBackground.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        self.hiddenGradient.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//        if let address = self.detectedLabel.text {
//            if self.detectedLabel.text != "Begin speaking" {
//                self.delegate?.zoomToSearchLocation(address: address)
//            }
//            UIView.animate(withDuration: animationOut, animations: {
//                self.view.alpha = 0
//                self.view.layoutIfNeeded()
//            }) { (success) in
//                self.detectedLabel.text = "Begin speaking"
//            }
//        }
    }
    
    func restartSpeechTimer() {
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
//            self.endSpeechRecognition()
//        })
    }
    
    func requestSpeechAuthorization() {
//        SFSpeechRecognizer.requestAuthorization { (authStatus) in
//            OperationQueue.main.addOperation {
//                switch authStatus {
//                case .authorized:
//                    self.microphoneButton.alpha = 1
//                case .denied:
//                    self.microphoneButton.alpha = 0.5
//                    self.detectedLabel.text = "User denied access to the microphone"
//                case .restricted:
//                    self.microphoneButton.alpha = 0.5
//                    self.detectedLabel.text = "Speech recognition restricted on this device"
//                case .notDetermined:
//                    self.microphoneButton.alpha = 0.5
//                    self.detectedLabel.text = "Speech recognition not yet authorized"
//                }
//            }
//        }
    }
    
}
