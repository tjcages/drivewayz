//
//  NavigationInstructionsView.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/20/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import Mapbox
import MapboxNavigation
import MapboxCoreNavigation
import MapboxDirections
import CarPlay

@IBDesignable
class NavigationInstructionsView: BaseInstructionsBannerView, NavigationComponent {
    public func navigationService(_ service: NavigationService, didPassVisualInstructionPoint instruction: VisualInstructionBanner, routeProgress: RouteProgress) {
        update(for: instruction)
    }
}

class BaseInstructionsBannerView: UIControl {
    
    weak var instructionDelegate: VisualInstructionDelegate? {
        didSet {
            primaryLabel.instructionDelegate = instructionDelegate
            secondaryLabel.instructionDelegate = instructionDelegate
        }
    }
    
    let distanceFormatter = DistanceFormatter()
    public var distance: CLLocationDistance? {
        didSet {
            distanceLabel.attributedDistanceString = nil
            
            if let distance = distance {
                if isFinalDestination, let formatString = distanceFormatter.attributedString(for: distance) {
                    let distanceString = formatDistanceString(attributedDistanceString: formatString)
                    if let side = recentInstruction?.primaryInstruction.maneuverDirection {
                        switch side {
                        case .left, .sharpLeft, .slightLeft:
                            if distance == 0 {
                                secondaryLabel.text = "On your left"
                            } else {
                                secondaryLabel.text = "\(distanceString.string) on the left"
                            }
                        case .right, .sharpRight, .slightRight:
                            if distance == 0 {
                                secondaryLabel.text = "On your right"
                            } else {
                                secondaryLabel.text = "\(distanceString.string) on the right"
                            }
                        default:
                            if distance == 0 {
                                secondaryLabel.text = "Straight ahead"
                            } else {
                                secondaryLabel.text = "\(distanceString.string) straight ahead"
                            }
                        }
                    }
                } else {
                    distanceLabel.attributedDistanceString = distanceFormatter.attributedString(for: distance)
                }
            } else {
                distanceLabel.text = nil
            }
        }
    }
    
    var recentInstruction: VisualInstructionBanner?
    var finalWaypoint: Waypoint?
    var isFinalDestination: Bool = false
    
    var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        
        return view
    }()
    
    var maneuverView: NavigationManeuverView = {
        let view = NavigationManeuverView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.alpha = 0
        
        return view
    }()
    
    var finalView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "pin_filled")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.WHITE
        button.layer.cornerRadius = 45/2
        button.layer.borderWidth = 2
        button.layer.borderColor = Theme.WHITE.cgColor
        button.isUserInteractionEnabled = false
        button.isHidden = true
        
        return button
    }()
    
    lazy var primaryLabel: InstructionLabel = {
        let label = InstructionLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_BLACK
        label.instructionDelegate = instructionDelegate
        label.font = Fonts.SSPSemiBoldH1
        label.numberOfLines = 2
        label.minimumScaleFactor = 27.0 / 30.0
        label.lineBreakMode = .byTruncatingTail
        label.alpha = 0
        label.text = "Begin navigation"
        
        return label
    }()
    
    lazy var secondaryLabel: SecondaryLabel = {
        let label = SecondaryLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.GRAY_BLACK
        label.font = Fonts.SSPSemiBoldH1
        label.instructionDelegate = instructionDelegate
        label.numberOfLines = 1
        label.minimumScaleFactor = 27.0 / 30.0
        label.lineBreakMode = .byTruncatingTail
        label.alpha = 0
        
        return label
    }()
    
    var distanceLabel: NavigationDistanceLabel = {
        let label = NavigationDistanceLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.WHITE
        label.font = Fonts.SSPBoldH0
        label.adjustsFontSizeToFitWidth = false
        label.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        label.alpha = 0
        label.text = "Start"
        
        return label
    }()
    
    var exitSymbol: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.WHITE.withAlphaComponent(0.2)
        button.setTitle("Exit 20", for: .normal)
        button.setTitleColor(Theme.WHITE, for: .normal)
        button.titleLabel?.font = Fonts.SSPSemiBoldH2
        button.layer.cornerRadius = 4
        button.alpha = 0
        
        return button
    }()
    
    var lanesView: LanesView = {
        let view = LanesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.hide()
        
        return view
    }()
    
    var speedLimitView = NavigationSpeedLimitView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        layer.shadowColor = Theme.BLACK.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.2
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        setupViews()
        centerYAlignInstructions()
        setupAvailableBounds()
    }
    
    
    // Updates the instructions banner info with a given `VisualInstructionBanner`.
    public func update(for instruction: VisualInstructionBanner?) {
        recentInstruction = instruction
        
        if !isFinalDestination {
            let primaryInstruction = instruction?.primaryInstruction
            let secondaryInstruction = instruction?.secondaryInstruction
            primaryLabel.numberOfLines = secondaryInstruction == nil ? 2 : 1
            
            maneuverView.visualInstruction = instruction?.primaryInstruction
            maneuverView.drivingSide = instruction?.drivingSide ?? .right
            secondaryLabel.instruction = secondaryInstruction
            
            if var components = instruction?.primaryInstruction.components {
                var hasExit: Bool = false
                components.forEach { (comp) in
                    if let type = comp.dictionary?["type"] as? String, let text = comp.dictionary?["text"] as? String, type == "exit-number" {
                        components = components.filter {$0 != comp}
                        hasExit = true
                        showExitSymbol(text: text)
                    } else if let type = comp.dictionary?["type"] as? String, type == "exit" {
                        components = components.filter {$0 != comp}
                    }
                }
                if !hasExit {
                    hideExitSymbol()
                }
                let newInstruction = VisualInstruction(text: primaryInstruction?.text, maneuverType: primaryInstruction?.maneuverType, maneuverDirection: primaryInstruction?.maneuverDirection, components: components, degrees: primaryInstruction?.finalHeading)
                primaryLabel.instruction = newInstruction
            } else {
                primaryLabel.instruction = primaryInstruction
            }
            monitorInstructionHeight(secondaryInstruction: secondaryInstruction)
        } else if let waypoint = finalWaypoint {
            showEndDestination(waypoint: waypoint)
        }
    }
    
    func showExitSymbol(text: String) {
        exitSymbol.setTitle("Exit \(text)", for: .normal)
        UIView.animateOut(withDuration: animationIn, animations: {
            self.exitSymbol.alpha = 1
        }, completion: nil)
    }
    
    func hideExitSymbol() {
        UIView.animateOut(withDuration: animationIn, animations: {
            self.exitSymbol.alpha = 0
        }, completion: nil)
    }
    
    func showEndDestination(waypoint: Waypoint) {
        isFinalDestination = true
        if let address = waypoint.name {
            distanceLabel.text = address
            primaryLabel.text = nil
            
            baselineAlignInstructions()
            UIView.animateOut(withDuration: animationOut, animations: {
                self.primaryLabel.isHidden = true
                self.maneuverView.isHidden = true
                self.finalView.isHidden = false
                if self.containerBottomAnchor.constant != 160 {
                    self.containerBottomAnchor.constant = 168
                    self.layoutIfNeeded()
                }
            }, completion: nil)
        }
    }
    
    func monitorInstructionHeight(secondaryInstruction: VisualInstruction?) {
        let lines = primaryLabel.calculateMaxLines()
        if secondaryInstruction == nil {
            centerYAlignInstructions()
            if lines > 1 {
                // Expand instruction banner
                containerBottomAnchor.constant = 200
            } else {
                // Minimize instruction banner
                containerBottomAnchor.constant = 168
            }
        } else {
            // Expand instruction banner
            baselineAlignInstructions()
            containerBottomAnchor.constant = 200
        }
        UIView.animateOut(withDuration: animationOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func monitorSpeedLimit(routeProgress: RouteProgress) {
        if let speedLimit = routeProgress.currentLegProgress.currentSpeedLimit {
            let limit = speedLimit.converted(to: UnitSpeed.milesPerHour)
            speedLimitView.valueLabel.text = String(Int(limit.value.rounded()))
            if speedLimitView.alpha == 0 {
                UIView.animate(withDuration: animationIn) {
                    self.speedLimitView.alpha = 1
                }
            }
        } else {
            if speedLimitView.alpha == 1 {
                UIView.animate(withDuration: animationIn) {
                    self.speedLimitView.alpha = 0
                }
            }
        }
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        maneuverView.isStart = true
        let component = VisualInstruction.Component.text(text: .init(text: "Primary text label", abbreviation: nil, abbreviationPriority: nil))
        let instruction = VisualInstruction(text: nil, maneuverType: .turn, maneuverDirection: .left, components: [component])
        primaryLabel.instruction = instruction
        
        distance = 100
    }
    
    // MARK: - Layout
    static let maneuverViewSize = CGSize(width: 45, height: 45)
    
    var centerYConstraints = [NSLayoutConstraint]()
    var baselineConstraints = [NSLayoutConstraint]()
    
    var containerBottomAnchor: NSLayoutConstraint!
    
    func setupViews() {
        
        addSubview(container)
        addSubview(maneuverView)
        addSubview(finalView)
        addSubview(distanceLabel)
        addSubview(primaryLabel)
        addSubview(secondaryLabel)
        addSubview(exitSymbol)
        
        container.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        containerBottomAnchor = container.heightAnchor.constraint(equalToConstant: 0)
            containerBottomAnchor.isActive = true
        
        maneuverView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 24, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: BaseInstructionsBannerView.maneuverViewSize.height, height: BaseInstructionsBannerView.maneuverViewSize.width)
        
        finalView.anchor(top: maneuverView.topAnchor, left: maneuverView.leftAnchor, bottom: maneuverView.bottomAnchor, right: maneuverView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        primaryLabel.anchor(top: nil, left: maneuverView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        primaryLabel.sizeToFit()
        baselineConstraints.append(primaryLabel.bottomAnchor.constraint(equalTo: secondaryLabel.topAnchor, constant: -4))
        centerYConstraints.append(primaryLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20))
        
        distanceLabel.anchor(top: nil, left: maneuverView.rightAnchor, bottom: primaryLabel.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 44, paddingBottom: 4, paddingRight: 40, width: 0, height: 0)
        distanceLabel.sizeToFit()

        secondaryLabel.anchor(top: nil, left: maneuverView.rightAnchor, bottom: container.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 16, width: 0, height: 0)
        secondaryLabel.sizeToFit()
        
        exitSymbol.anchor(top: distanceLabel.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: -4, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 88, height: 40)

        addSubview(lanesView)
        lanesView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        addSubview(speedLimitView)
        speedLimitView.anchor(top: container.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 78, height: 90)
        
    }
    
    // Updates the instructions banner distance info for a given `RouteStepProgress`.
    public func updateDistance(for currentStepProgress: RouteStepProgress) {
        let distanceRemaining = currentStepProgress.distanceRemaining
        distance = distanceRemaining > 5 ? distanceRemaining : 0
    }
    
    func formatDistanceString(attributedDistanceString: NSAttributedString) -> NSMutableAttributedString {
        // Create a copy of the attributed string that emphasizes the quantity.
        let emphasizedDistanceString = NSMutableAttributedString(attributedString: attributedDistanceString)
        let wholeRange = NSRange(location: 0, length: emphasizedDistanceString.length)
        var hasQuantity = false
        let foreground = Theme.WHITE
        let fonts = Fonts.SSPBoldH0
        emphasizedDistanceString.enumerateAttribute(.quantity, in: wholeRange, options: .longestEffectiveRangeNotRequired) { (value, range, stop) in
            let foregroundColor: UIColor
            let font: UIFont
            if let _ = emphasizedDistanceString.attribute(.quantity, at: range.location, effectiveRange: nil) {
                foregroundColor = foreground
                font = fonts
                hasQuantity = true
            } else {
                foregroundColor = foreground
                font = fonts
            }
            emphasizedDistanceString.addAttributes([.foregroundColor: foregroundColor, .font: font], range: range)
        }
        
        // As a failsafe, if no quantity was found, emphasize the entire string.
        if !hasQuantity {
            emphasizedDistanceString.addAttributes([.foregroundColor: foreground, .font: fonts], range: wholeRange)
        }
        
        return emphasizedDistanceString
    }
    
    // Aligns the instruction to the center Y (used for single line primary and/or secondary instructions)
    func centerYAlignInstructions() {
        baselineConstraints.forEach { $0.isActive = false }
        centerYConstraints.forEach { $0.isActive = true }
    }
    
    // Aligns primary top to the top of the maneuver view and the secondary baseline to the distance baseline (used for multiline)
    func baselineAlignInstructions() {
        centerYConstraints.forEach { $0.isActive = false }
        baselineConstraints.forEach { $0.isActive = true }
    }
    
    func showInstructionBanner() {
        containerBottomAnchor.constant = 168
        UIView.animateOut(withDuration: animationOut, animations: {
            self.maneuverView.alpha = 1
            self.primaryLabel.alpha = 1
            self.secondaryLabel.alpha = 1
            self.distanceLabel.alpha = 1
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideInstructionBanner() {
        containerBottomAnchor.constant = 0
        UIView.animateOut(withDuration: animationOut, animations: {
            self.finalView.alpha = 0
            self.maneuverView.alpha = 0
            self.primaryLabel.alpha = 0
            self.secondaryLabel.alpha = 0
            self.distanceLabel.alpha = 0
            self.speedLimitView.alpha = 0
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func setupAvailableBounds() {
        // Abbreviate if the instructions do not fit on one line
        primaryLabel.availableBounds = { [unowned self] in
            // Available width H:|-padding-maneuverView-padding-availableWidth-padding-|
            let availableWidth = self.primaryLabel.viewForAvailableBoundsCalculation?.bounds.width ?? self.bounds.width - BaseInstructionsBannerView.maneuverViewSize.width - 24
            return CGRect(x: 0, y: 0, width: availableWidth, height: self.primaryLabel.font.lineHeight)
        }

        secondaryLabel.availableBounds = { [unowned self] in
            // Available width H:|-padding-maneuverView-padding-availableWidth-padding-|
            let availableWidth = self.secondaryLabel.viewForAvailableBoundsCalculation?.bounds.width ?? self.bounds.width - BaseInstructionsBannerView.maneuverViewSize.width - 24
            return CGRect(x: 0, y: 0, width: availableWidth, height: self.secondaryLabel.font.lineHeight)
        }
    }
    
}

extension VisualInstruction {
    var laneComponents: [Component] {
        return components.filter { component -> Bool in
            if case VisualInstruction.Component.lane(indications: _, isUsable: _) = component {
                return true
            }
            return false
        }
    }
    
    func maneuverImage(side: DrivingSide, color: UIColor, size: CGSize) -> UIImage? {
        let mv = NavigationManeuverView()
        mv.frame = CGRect(origin: .zero, size: size)
        mv.primaryColor = color
        mv.backgroundColor = .clear
        mv.scale = UIScreen.main.scale
        mv.visualInstruction = self
        let image = mv.imageRepresentation
        return shouldFlipImage(side: side) ? image?.withHorizontallyFlippedOrientation() : image
    }
    
}

@IBDesignable
open class ManeuverView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    @objc public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        // Explicitly mark the view as non-opaque.
        // This is needed to obtain correct compositing since we implement our own draw function that includes transparency.
        isOpaque = false
    }

    @objc public dynamic var primaryColor: UIColor = Theme.WHITE {
        didSet {
            setNeedsDisplay()
        }
    }

    @objc public dynamic var secondaryColor: UIColor = Theme.WHITE {
        didSet {
            setNeedsDisplay()
        }
    }

    public var isStart = false {
        didSet {
            setNeedsDisplay()
        }
    }

    public var isEnd = false {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var scale: CGFloat = 1 {
        didSet {
            setNeedsDisplay()
        }
    }

    /**
     The current instruction displayed in the maneuver view.
     */
    public var visualInstruction: VisualInstruction? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /**
     This indicates the side of the road currently driven on.
     */
    public var drivingSide: DrivingSide = .right {
        didSet {
            setNeedsDisplay()
        }
    }

    override open func draw(_ rect: CGRect) {
        super.draw(rect)

        transform = .identity
        let resizing: ManeuversStyleKit.ResizingBehavior = .aspectFit

        #if TARGET_INTERFACE_BUILDER
            ManeuversStyleKit.drawFork(frame: bounds, resizing: resizing, primaryColor: primaryColor, secondaryColor: secondaryColor)
            return
        #endif

        guard let visualInstruction = visualInstruction else {
            if isStart {
                ManeuversStyleKit.drawStarting(frame: bounds, resizing: resizing, primaryColor: primaryColor)
            } else if isEnd {
                ManeuversStyleKit.drawDestination(frame: bounds, resizing: resizing, primaryColor: primaryColor)
            }
            return
        }

        var flip: Bool = false
        let maneuverType = visualInstruction.maneuverType
        let maneuverDirection = visualInstruction.maneuverDirection
        
        let type = maneuverType ?? .turn
        let direction = maneuverDirection ?? .straightAhead

        switch type {
        case .merge:
            ManeuversStyleKit.drawMerge(frame: bounds, resizing: resizing, primaryColor: primaryColor, secondaryColor: secondaryColor)
            flip = [.left, .slightLeft, .sharpLeft].contains(direction)
        case .takeOffRamp:
            ManeuversStyleKit.drawOfframp(frame: bounds, resizing: resizing, primaryColor: primaryColor, secondaryColor: secondaryColor)
            flip = [.left, .slightLeft, .sharpLeft].contains(direction)
        case .reachFork:
            ManeuversStyleKit.drawFork(frame: bounds, resizing: resizing, primaryColor: primaryColor, secondaryColor: secondaryColor)
            flip = [.left, .slightLeft, .sharpLeft].contains(direction)
        case .takeRoundabout, .turnAtRoundabout, .takeRotary:
            ManeuversStyleKit.drawRoundabout(frame: bounds, resizing: resizing, primaryColor: primaryColor, secondaryColor: secondaryColor, roundabout_angle: CGFloat(visualInstruction.finalHeading ?? 180))
            flip = drivingSide == .left
            
        case .arrive:
            switch direction {
            case .right:
                ManeuversStyleKit.drawArriveright(frame: bounds, resizing: resizing, primaryColor: primaryColor)
            case .left:
                ManeuversStyleKit.drawArriveright(frame: bounds, resizing: resizing, primaryColor: primaryColor)
                flip = true
            default:
                ManeuversStyleKit.drawArrive(frame: bounds, resizing: resizing, primaryColor: primaryColor)
            }
        default:
            switch direction {
            case .right:
                ManeuversStyleKit.drawArrowright(frame: bounds, resizing: resizing, primaryColor: primaryColor)
                flip = false
            case .slightRight:
                ManeuversStyleKit.drawArrowslightright(frame: bounds, resizing: resizing, primaryColor: primaryColor)
                flip = false
            case .sharpRight:
                ManeuversStyleKit.drawArrowsharpright(frame: bounds, resizing: resizing, primaryColor: primaryColor)
                flip = false
            case .left:
                ManeuversStyleKit.drawArrowright(frame: bounds, resizing: resizing, primaryColor: primaryColor)
                flip = true
            case .slightLeft:
                ManeuversStyleKit.drawArrowslightright(frame: bounds, resizing: resizing, primaryColor: primaryColor)
                flip = true
            case .sharpLeft:
                ManeuversStyleKit.drawArrowsharpright(frame: bounds, resizing: resizing, primaryColor: primaryColor)
                flip = true
            case .uTurn:
                ManeuversStyleKit.drawArrow180right(frame: bounds, resizing: resizing, primaryColor: primaryColor)
                flip = drivingSide == .right // 180 turn is turning clockwise so we flip it if it's right-hand rule of the road
            default:
                ManeuversStyleKit.drawArrowstraight(frame: bounds, resizing: resizing, primaryColor: primaryColor)
            }
        }

        transform = CGAffineTransform(scaleX: flip ? -1 : 1, y: 1)
    }
}

// Extensions for VisualInstruction.Component
extension Decodable {
    /// Sweeter: Create object from a dictionary
    public init?(from: Any) {
        guard let data = try? JSONSerialization.data(withJSONObject: from, options: .prettyPrinted) else { return nil }
        guard let decodedSelf = try? JSONDecoder().decode(Self.self, from: data) else { return nil }
        self = decodedSelf
    }
}

extension Encodable {
    /// Sweeter: Export object to a dictionary representation
    public var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
