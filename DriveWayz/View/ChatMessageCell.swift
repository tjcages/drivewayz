//
//  ChatMessageCell.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 6/17/19.
//  Copyright © 2019 COAD. All rights reserved.
//
//  ChatMessageCell.swift


import UIKit
import AVFoundation

class ChatMessageCell: UICollectionViewCell {
    
    var message: Message?
    var chatLogController = CurrentMessageViewController()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        
        return aiv
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "playButton")
        button.tintColor = UIColor.white
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handlePlayVideo), for: .touchUpInside)
        
        return button
    }()
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    @objc func handlePlayVideo() {
        if let videoURLString = message?.videoURL, let url = URL(string: videoURLString) {
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubbleView.bounds
            
            bubbleView.layer.addSublayer(playerLayer!)
            
            
            
            player?.play()
            
            activityIndicatorView.startAnimating()
            
            playButton.isHidden = true
            
        }
        
    }
    
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        playerLayer?.removeFromSuperlayer()
        
        player?.pause()
        
        activityIndicatorView.stopAnimating()
        
    }
    
    
    
    let textView: UITextView = {
        
        let tv = UITextView()
        
        tv.text = "SAMPLE"
        
        tv.font = Fonts.SSPRegularH5
        
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        tv.backgroundColor = UIColor.clear
        
        tv.textColor = UIColor.white
        
        tv.isEditable = false
        
        tv.isUserInteractionEnabled = false
        
        
        
        return tv
        
    }()
    
    
    
    let bubbleView: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = Theme.SEA_BLUE
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.cornerRadius = 18
        
        view.clipsToBounds = true
        
        
        
        return view
        
    }()
    
    
    
    lazy var messageImageView: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: "profile")
        
        imageView.layer.cornerRadius = 16
        
        imageView.layer.masksToBounds = true
        
        imageView.isUserInteractionEnabled = true
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.backgroundColor = UIColor.clear
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        
        
        
        return imageView
        
    }()
    
    
    
    var permissionView: UIView = {
        
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = Theme.OFF_WHITE
        
        view.clipsToBounds = true
        
        view.alpha = 0
        
        
        
        return view
        
    }()
    
    
    
    var permissionClosed: UIButton = {
        
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .clear
        
        button.setTitle("Closed", for: .normal)
        
        button.titleLabel?.textColor = Theme.BLACK
        
        button.titleLabel?.font = Fonts.SSPLightH3
        
        
        
        return button
        
    }()
    
    
    
    var permissionOpened: UIButton = {
        
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .clear
        
        button.setTitle("Open", for: .normal)
        
        button.titleLabel?.textColor = Theme.BLACK
        
        button.titleLabel?.font = Fonts.SSPLightH3
        
        
        
        return button
        
    }()
    
    
    
    var permissionLine: UIView = {
        
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = Theme.BLACK
        
        
        
        return view
        
    }()
    
    
    
    @objc func handleZoomTap(_ tapGesture: UITapGestureRecognizer) {
        
        if message?.videoURL != nil {
            
            return
            
        }
        
        if let imageView = tapGesture.view as? UIImageView {
            
            self.chatLogController.performZoomForStartingImageView(startingImageView: imageView)
            
        }
        
    }
    
    
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    
    var bubbleViewRightAnchor: NSLayoutConstraint?
    
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        
        
        self.backgroundColor = Theme.WHITE
        
        
        
        addSubview(bubbleView)
        
        addSubview(textView)
        
        bubbleView.addSubview(messageImageView)
        
        
        
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 12).isActive = true
        
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        
        bubbleViewLeftAnchor?.isActive = false
        
        
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        
        bubbleView.addSubview(playButton)
        
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        bubbleView.addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        setupPermissions()
        
        
        
    }
    
    
    
    func setupPermissions() {
        
        
        
        bubbleView.addSubview(permissionView)
        
        permissionView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        
        permissionView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        
        permissionView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 70).isActive = true
        
        permissionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
        
        permissionView.addSubview(permissionClosed)
        
        permissionClosed.leftAnchor.constraint(equalTo: permissionView.leftAnchor).isActive = true
        
        permissionClosed.rightAnchor.constraint(equalTo: permissionView.centerXAnchor).isActive = true
        
        permissionClosed.topAnchor.constraint(equalTo: permissionView.topAnchor).isActive = true
        
        permissionClosed.bottomAnchor.constraint(equalTo: permissionView.bottomAnchor).isActive = true
        
        
        
        permissionView.addSubview(permissionOpened)
        
        permissionOpened.leftAnchor.constraint(equalTo: permissionView.centerXAnchor).isActive = true
        
        permissionOpened.rightAnchor.constraint(equalTo: permissionView.rightAnchor).isActive = true
        
        permissionOpened.topAnchor.constraint(equalTo: permissionView.topAnchor).isActive = true
        
        permissionOpened.bottomAnchor.constraint(equalTo: permissionView.bottomAnchor).isActive = true
        
        
        
        permissionView.addSubview(permissionLine)
        
        permissionLine.centerYAnchor.constraint(equalTo: permissionView.topAnchor).isActive = true
        
        permissionLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        permissionLine.leftAnchor.constraint(equalTo: permissionView.leftAnchor).isActive = true
        
        permissionLine.rightAnchor.constraint(equalTo: permissionView.rightAnchor).isActive = true
        
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    
    
    
    
    
}
