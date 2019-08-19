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
    var chatLogController = CommentsController(collectionViewLayout: UICollectionViewLayout())
    
    var incomingColor = lineColor
    var outgoingColor = Theme.BLUE
    
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
//            playerLayer?.frame = bubbleView.bounds
//            bubbleView.layer.addSublayer(playerLayer!)

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
    
//    var bubbleView: BubbleView = {
//        let view = BubbleView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.clipsToBounds = true
//        view.backgroundColor = UIColor.clear
//
//        return view
//    }()
    
//    let textView: UITextView = {
//        let tv = UITextView()
//        tv.text = ""
//        tv.font = Fonts.SSPRegularH4
//        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.backgroundColor = UIColor.clear
//        tv.textColor = UIColor.white
//        tv.isEditable = false
//        tv.isUserInteractionEnabled = false
//
//        return tv
//    }()
//
//    let bubbleView: UIView = {
//        let view = UIView()
//        view.backgroundColor = Theme.BLUE
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 18
//        view.clipsToBounds = true
//
//        return view
//    }()
//
//    lazy var messageImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(named: "profile")
//        imageView.layer.cornerRadius = 16
//        imageView.layer.masksToBounds = true
//        imageView.isUserInteractionEnabled = true
//        imageView.contentMode = .scaleAspectFill
//        imageView.backgroundColor = UIColor.clear
//        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
//
//        return imageView
//    }()
    
    @objc func handleZoomTap(_ tapGesture: UITapGestureRecognizer) {
        if message?.videoURL != nil {
            return
        }
        if let imageView = tapGesture.view as? UIImageView {
            self.chatLogController.performZoomForStartingImageView(startingImageView: imageView)
        }
    }
    
//    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = Theme.WHITE
        
//        addSubview(bubbleView)
//        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12)
//            bubbleViewLeftAnchor?.isActive = true
//        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12)
//            bubbleViewRightAnchor?.isActive = false
//        bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: phoneWidth/2 - 12).isActive = true
//        bubbleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        
        
//        addSubview(textView)
//        bubbleView.addSubview(messageImageView)
//
//        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
//        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
//        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
//        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
//
//        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 12).isActive = true
//        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
//        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//
//        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
//            bubbleViewRightAnchor?.isActive = true
//        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
//            bubbleViewLeftAnchor?.isActive = false
//
//        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
//            bubbleWidthAnchor?.isActive = true
//        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//
//        bubbleView.addSubview(playButton)
//        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
//        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
//        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        bubbleView.addSubview(activityIndicatorView)
//        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
//        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
//        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func showBubbleMessage(text: String, isIncoming: Bool) {
        
        let views = self.subviews
        for view in views {
            self.willRemoveSubview(view)
            view.removeFromSuperview()
        }
        
        let label =  UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = Fonts.SSPRegularH4
        if isIncoming {
            label.textColor = Theme.DARK_GRAY
        } else {
            label.textColor = Theme.WHITE
        }
        label.text = text
        
        let constraintRect = CGSize(width: 0.66 * self.frame.width,
                                    height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: label.font!],
                                            context: nil)
        let labelSize = CGSize(width: ceil(boundingBox.width),
                                  height: ceil(boundingBox.height))
        
        let bubbleSize = CGSize(width: labelSize.width + 28,
                                height: labelSize.height + 20)
        
        let bubbleView = BubbleView()
        bubbleView.isIncoming = isIncoming
        bubbleView.frame.size = bubbleSize
        bubbleView.backgroundColor = .clear
        bubbleView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(bubbleView)
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12)
            bubbleViewLeftAnchor?.isActive = true
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12)
            bubbleViewRightAnchor?.isActive = false
        bubbleView.widthAnchor.constraint(equalToConstant: bubbleSize.width).isActive = true
        bubbleView.heightAnchor.constraint(equalToConstant: bubbleSize.height).isActive = true
        
        self.addSubview(label)
        label.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: labelSize.width).isActive = true
        label.heightAnchor.constraint(equalToConstant: labelSize.height).isActive = true

        if isIncoming {
            self.bubbleViewLeftAnchor?.isActive = true
            self.bubbleViewRightAnchor?.isActive = false
        } else {
            self.bubbleViewRightAnchor?.isActive = true
            self.bubbleViewLeftAnchor?.isActive = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
