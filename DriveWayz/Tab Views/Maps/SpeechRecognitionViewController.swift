//
//  SpeechRecognitionViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/9/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Speech

class SpeechRecognitionViewController: UIViewController {
    
    var delegate: controlSaveLocation?
    
    var audioEngine: AVAudioEngine?
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    var pulsatingLayer: CAShapeLayer!
    var pulsatingLayer2: CAShapeLayer!
    
    var microphoneButton: UIButton = {
        let button = UIButton(type: .custom)
        if let myImage = UIImage(named: "microphoneButton") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            button.setImage(tintableImage, for: .normal)
        }
        button.tintColor = Theme.WHITE
        button.backgroundColor = Theme.PURPLE
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.layer.cornerRadius = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        //        button.addTarget(self, action: #selector(locatorButtonAction(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    var microphoneBackground: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = Theme.OFF_WHITE
        button.layer.cornerRadius = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var detectedLabel: UILabel = {
        let label = UILabel()
        label.text = "Begin speaking"
        label.textColor = Theme.BLACK
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
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(exitButtonPressed(sender:)), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    var microphoneBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        self.view.addSubview(microphoneBackground)
        microphoneBackground.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        microphoneBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
        microphoneBackground.heightAnchor.constraint(equalToConstant: 80).isActive = true
        microphoneBackground.widthAnchor.constraint(equalTo: microphoneBackground.heightAnchor).isActive = true
        
        self.view.addSubview(microphoneButton)
        microphoneButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        microphoneBottomAnchor = microphoneButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40)
            microphoneBottomAnchor.isActive = true
        microphoneButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        microphoneButton.widthAnchor.constraint(equalTo: microphoneButton.heightAnchor).isActive = true
        
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: .clear)
        pulsatingLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(pulsatingLayer)
        pulsatingLayer2 = createCircleShapeLayer(strokeColor: .clear, fillColor: .clear)
        pulsatingLayer2.fillColor = UIColor.clear.cgColor
        pulsatingLayer.position = microphoneButton.center
        pulsatingLayer2.position = microphoneButton.center
        view.layer.addSublayer(pulsatingLayer2)
        view.bringSubviewToFront(microphoneButton)
        
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
            self.microphoneBottomAnchor.constant = -40
            self.view.layoutIfNeeded()
        }
    }

    func recordAndRecognizeSpeech() {
        audioEngine = AVAudioEngine()
        requestSpeechAuthorization()
        let node = audioEngine?.inputNode
        let recordingFormat = node?.outputFormat(forBus: 0)
        node?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        audioEngine?.prepare()
        do {
            try audioEngine?.start()
            self.beginAnimating()
        } catch {
            return print(error)
        }
        guard let recognizer = SFSpeechRecognizer() else { return }
        if !recognizer.isAvailable {
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                self.detectedLabel.text = bestString
                self.restartSpeechTimer()
            } else if let error = error {
                print(error)
            }
        })
    }
    
    func beginAnimating() {
        UIView.animate(withDuration: animationIn) {
            self.pulsatingLayer.opacity = 1
            self.pulsatingLayer2.opacity = 1
            self.microphoneBottomAnchor.constant = -160
            self.view.layoutIfNeeded()
        }
        pulsatingLayer.position = microphoneButton.center
        pulsatingLayer.fillColor = Theme.PACIFIC_BLUE.withAlphaComponent(0.2).cgColor
        pulsatingLayer2.position = microphoneButton.center
        pulsatingLayer2.fillColor = Theme.PACIFIC_BLUE.withAlphaComponent(0.5).cgColor
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.6
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        let animation2 = CABasicAnimation(keyPath: "transform.scale")
        animation2.toValue = 1.2
        animation2.duration = 0.8
        animation2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation2.autoreverses = true
        animation2.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsing")
        pulsatingLayer2.add(animation2, forKey: "pulsing")
    }
    
    func endSpeechRecognition() {
        audioEngine?.stop()
        request.endAudio()
        if let address = self.detectedLabel.text {
            if self.detectedLabel.text != "Begin speaking" {
                self.delegate?.zoomToSearchLocation(address: address)
            }
            UIView.animate(withDuration: animationOut, animations: {
                self.view.alpha = 0
                self.pulsatingLayer.opacity = 0
                self.pulsatingLayer2.opacity = 0
                self.microphoneBottomAnchor.constant = -40
                self.view.layoutIfNeeded()
            }) { (success) in
                self.detectedLabel.text = "Begin speaking"
            }
        }
    }
    
    var timer: Timer?
    
    func restartSpeechTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
            self.endSpeechRecognition()
        })
    }
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.microphoneButton.alpha = 1
                case .denied:
                    self.microphoneButton.alpha = 0.5
                    self.detectedLabel.text = "User denied access to the microphone"
                case .restricted:
                    self.microphoneButton.alpha = 0.5
                    self.detectedLabel.text = "Speech recognition restricted on this device"
                case .notDetermined:
                    self.microphoneButton.alpha = 0.5
                    self.detectedLabel.text = "Speech recognition not yet authorized"
                }
            }
        }
    }
    
}
