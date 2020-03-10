//
//  NavigationStyling.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/20/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation

/**
 `Style` is a convenient wrapper for styling the appearance of various interface components throughout the Navigation UI.
 
 Styles are applied globally using `UIAppearance`. You should call `Style.apply()` to apply the style to the `NavigationViewController`.
 */
@objc(MBStyle)
open class NavigationStyling: NSObject {
    // MARK: General styling
    
    /**
     Sets the tint color for guidance arrow, highlighted text, progress bar and more.
     */
    @objc public var tintColor: UIColor?
    
    /**
     Describes the situations in which the style should be used. By default, the style will be used during the daytime.
     */
    @objc public var styleType: StyleType = .day
    
    /**
     URL of the style to display on the map during turn-by-turn navigation.
     */
    @objc open var mapStyleURL: URL = URL(string: "mapbox://styles/tcagle717/ck6vnkczo0pn51ip7upnynxka") ?? MGLStyle.navigationGuidanceDayStyleURL
    
    /**
     URL of the style to display on the map when previewing a route, for example on CarPlay or your own route preview map.
     */
    @objc open var previewMapStyleURL = URL(string: "mapbox://styles/tcagle717/ck6vnkczo0pn51ip7upnynxka") ?? MGLStyle.navigationGuidanceDayStyleURL
    
    /**
     Applies the style for all changed properties.
     */
    @objc open func apply() { }
    
    @objc public required override init() { }
}

/// :nodoc:
//@objc(MBStylableLabel)
open class NavigationStylableLabel: UILabel {
    // Workaround the fact that UILabel properties are not marked with UI_APPEARANCE_SELECTOR
    @objc dynamic open var normalTextColor: UIColor = Theme.WHITE {
        didSet {
            textColor = normalTextColor
        }
    }
    
    @objc dynamic open var normalFont: UIFont = Fonts.SSPRegularH0 {
        didSet {
            font = Fonts.SSPRegularH0
        }
    }
}

open class NavigationDistanceLabel: NavigationStylableLabel {
    @objc dynamic public var valueTextColor: UIColor = Theme.WHITE {
        didSet { update() }
    }
    @objc dynamic public var unitTextColor: UIColor = Theme.WHITE {
        didSet { update() }
    }
    @objc dynamic public var valueFont: UIFont = Fonts.SSPBoldH00 {
        didSet { update() }
    }
    @objc dynamic public var unitFont: UIFont = Fonts.SSPBoldH00 {
        didSet { update() }
    }
    
    /**
     An attributed string indicating the distance along with a unit.
     
     - precondition: `NSAttributedStringKey.quantity` should be applied to the
        numeric quantity.
     */
    var attributedDistanceString: NSAttributedString? {
        didSet {
            update()
        }
    }
    
    fileprivate func update() {
        guard let attributedDistanceString = attributedDistanceString else {
            return
        }
        
        // Create a copy of the attributed string that emphasizes the quantity.
        let emphasizedDistanceString = NSMutableAttributedString(attributedString: attributedDistanceString)
        let wholeRange = NSRange(location: 0, length: emphasizedDistanceString.length)
        var hasQuantity = false
        emphasizedDistanceString.enumerateAttribute(.quantity, in: wholeRange, options: .longestEffectiveRangeNotRequired) { (value, range, stop) in
            let foregroundColor: UIColor
            let font: UIFont
            if let _ = emphasizedDistanceString.attribute(.quantity, at: range.location, effectiveRange: nil) {
                foregroundColor = valueTextColor
                font = valueFont
                hasQuantity = true
            } else {
                foregroundColor = unitTextColor
                font = unitFont
            }
            emphasizedDistanceString.addAttributes([.foregroundColor: foregroundColor, .font: font], range: range)
        }
        
        // As a failsafe, if no quantity was found, emphasize the entire string.
        if !hasQuantity {
            emphasizedDistanceString.addAttributes([.foregroundColor: valueTextColor, .font: valueFont], range: wholeRange)
        }
        
        // Replace spaces with hair spaces to economize on horizontal screen
        // real estate. Formatting the distance with a short style would remove
        // spaces, but in English it would also denote feet with a prime
        // mark (′), which is typically used for heights, not distances.
//        emphasizedDistanceString.mutableString.replaceOccurrences(of: " ", with: "\u{200A}", options: [], range: wholeRange)
        
        attributedText = emphasizedDistanceString
    }
}

/// :nodoc:
//@objc(MBTimeRemainingLabel)
open class NavigationTimeRemainingLabel: NavigationStylableLabel { // USE FOR BOTTOM CONTROLLER
    // Sets the text color for no or unknown traffic
    @objc dynamic public var trafficUnknownColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet {
            textColor = trafficUnknownColor
        }
    }
    // Sets the text color for low traffic
    @objc dynamic public var trafficLowColor: UIColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    // Sets the text color for moderate traffic
    @objc dynamic public var trafficModerateColor: UIColor = #colorLiteral(red:0.95, green:0.65, blue:0.31, alpha:1.0)
    // Sets the text color for heavy traffic
    @objc dynamic public var trafficHeavyColor: UIColor = #colorLiteral(red:0.91, green:0.20, blue:0.25, alpha:1.0)
    // Sets the text color for severe traffic
    @objc dynamic public var trafficSevereColor: UIColor = #colorLiteral(red:0.54, green:0.06, blue:0.22, alpha:1.0)
}

@IBDesignable
open class NavigationManeuverView: UIView {

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

    @objc public dynamic var secondaryColor: UIColor = Theme.GRAY_BLACK {
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
    
    var imageRepresentation: UIImage? {
        let size = CGSize(width: frame.size.width, height: frame.size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in:currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

/// :nodoc:
//@objc(MBBannerContainerView)
open class NavigationBannerContainerView: UIView { }

/// :nodoc:
//@objc(MBTopBannerView)
open class NavigationTopBannerView: UIView { }

/// :nodoc:
//@objc(MBBottomBannerView)
open class NavigationBottomBannerView: UIView { }

open class NavigationBottomPaddingView: BottomBannerView { }

/// :nodoc:
class NavigationAnnotation: MGLPointAnnotation { }

/// :nodoc:
//@objc(MBMarkerView)
public class NavigationMarkerView: UIView {
    // Sets the inner color on the pin.
    @objc public dynamic var innerColor: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Sets the shadow color under the marker view.
    @objc public dynamic var shadowColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Sets the color on the marker view.
    @objc public dynamic var pinColor: UIColor = #colorLiteral(red: 0.1493228376, green: 0.2374534607, blue: 0.333029449, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Sets the stroke color on the marker view.
    @objc public dynamic var strokeColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 39, height: 51)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        StyleKitMarker.drawMarker(innerColor: innerColor, shadowColor: shadowColor, pinColor: pinColor, strokeColor: strokeColor)
    }
}
