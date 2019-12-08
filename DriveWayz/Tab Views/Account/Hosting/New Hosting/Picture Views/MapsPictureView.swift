//
//  MapsPictureView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 10/29/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import UIKit
import GoogleMaps

class MapsPictureView: UIViewController {
    
    var delegate: HandleHostPictures?
    var panoView: GMSPanoramaView!
    var visibleCoordinate: CLLocationCoordinate2D?
    
    lazy var gradientContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.DARK_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = Theme.DARK_GRAY.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.2
        
        return view
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Align the parking spot within the frame"
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPSemiBoldH2
        label.numberOfLines = 2
        
        return label
    }()
    
    var subLabel: UILabel = {
        let label = UILabel()
        label.text = "You can pan around the map to find the spot. Make sure it is clearly visible."
        label.textColor = Theme.WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.SSPRegularH4
        label.numberOfLines = 3
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "arrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.WHITE
        button.translatesAutoresizingMaskIntoConstraints = false
        button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE
        button.layer.cornerRadius = 35
        button.layer.shadowColor = Theme.DARK_GRAY.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.2
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.DARK_GRAY
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var borderView: CornerView = {
        let view = CornerView(frame: CGRect(x: 0, y: 0, width: phoneWidth, height: phoneHeight))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    var borderWidth: NSLayoutConstraint!
    
    func setupViews() {
        
        panoView = GMSPanoramaView(frame: .zero)
        panoView.translatesAutoresizingMaskIntoConstraints = false
        panoView.navigationLinksHidden = true
        panoView.navigationGestures = false
        if let coordinate = visibleCoordinate {
            panoView.moveNearCoordinate(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        
        view.addSubview(imageView)
        imageView.addSubview(panoView)
        view.addSubview(gradientContainer)
        
        gradientContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        gradientContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        gradientContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        gradientContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -208).isActive = true
        
        panoView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: gradientContainer.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -30, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.bottomAnchor.constraint(equalTo: gradientContainer.topAnchor, constant: -16).isActive = true
        
        view.addSubview(mainLabel)
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainLabel.topAnchor.constraint(equalTo: gradientContainer.topAnchor, constant: 16).isActive = true
        mainLabel.sizeToFit()
        
        view.addSubview(subLabel)
        subLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -112).isActive = true
        subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4).isActive = true
        subLabel.sizeToFit()
        
        view.addSubview(nextButton)
        nextButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 20, width: 70, height: 70)
        
        view.addSubview(borderView)
        borderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        borderView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -124).isActive = true
        borderWidth = borderView.widthAnchor.constraint(equalToConstant: phoneWidth)
            borderWidth.priority = UILayoutPriority.defaultLow
            borderWidth.isActive = true
        
        borderView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -16).isActive = true
        borderView.bottomAnchor.constraint(lessThanOrEqualTo: backButton.topAnchor, constant: -32).isActive = true
        borderView.heightAnchor.constraint(equalTo: borderView.widthAnchor, multiplier: 1.225).isActive = true

        imageView.anchor(top: borderView.topAnchor, left: borderView.leftAnchor, bottom: borderView.bottomAnchor, right: borderView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    @objc func nextButtonPressed() {
        imageView.clipsToBounds = true
        let image = imageView.takeScreenshot()
        imageView.clipsToBounds = false
        dismiss(animated: true) {
            self.delegate?.saveMapScreenshot(image: image)
        }
    }
    
    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

class CornerView: UIView {

    @IBInspectable
    var sizeMultiplier: CGFloat = 0.1 {
        didSet{
            draw(self.bounds)
        }
    }

    @IBInspectable
    var lineWidth: CGFloat = 8 {
        didSet{
            draw(self.bounds)
        }
    }

    @IBInspectable
    var lineColor: UIColor = Theme.WHITE {
        didSet{
            draw(self.bounds)
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }

    func drawCorners()
    {
        let currentContext = UIGraphicsGetCurrentContext()

        currentContext?.setLineWidth(lineWidth)
        currentContext?.setStrokeColor(lineColor.cgColor)

        //first part of top left corner
        currentContext?.beginPath()
        currentContext?.move(to: CGPoint(x: 0, y: 0))
        currentContext?.addLine(to: CGPoint(x: self.bounds.size.width*sizeMultiplier, y: 0))
        currentContext?.strokePath()

        //top rigth corner
        currentContext?.beginPath()
        currentContext?.move(to: CGPoint(x: self.bounds.size.width - self.bounds.size.width*sizeMultiplier, y: 0))
        currentContext?.addLine(to: CGPoint(x: self.bounds.size.width, y: 0))
        currentContext?.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height*sizeMultiplier))
        currentContext?.strokePath()

        //bottom rigth corner
        currentContext?.beginPath()
        currentContext?.move(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height - self.bounds.size.height*sizeMultiplier))
        currentContext?.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height))
        currentContext?.addLine(to: CGPoint(x: self.bounds.size.width - self.bounds.size.width*sizeMultiplier, y: self.bounds.size.height))
        currentContext?.strokePath()

        //bottom left corner
        currentContext?.beginPath()
        currentContext?.move(to: CGPoint(x: self.bounds.size.width*sizeMultiplier, y: self.bounds.size.height))
        currentContext?.addLine(to: CGPoint(x: 0, y: self.bounds.size.height))
        currentContext?.addLine(to: CGPoint(x: 0, y: self.bounds.size.height - self.bounds.size.height*sizeMultiplier))
        currentContext?.strokePath()

        //second part of top left corner
        currentContext?.beginPath()
        currentContext?.move(to: CGPoint(x: 0, y: self.bounds.size.height*sizeMultiplier))
        currentContext?.addLine(to: CGPoint(x: 0, y: 0))
        currentContext?.strokePath()
    }


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        self.drawCorners()
    }


}
