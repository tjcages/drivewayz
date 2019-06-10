//
//  DayStyle.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 1/4/19.
//  Copyright © 2019 COAD. All rights reserved.
//

import Foundation
import Mapbox
import MapboxNavigation
import MapboxCoreNavigation

extension UIColor {
    class var defaultRouteCasing: UIColor { get { return .defaultTintStroke } }
    class var defaultRouteLayer: UIColor { get { return #colorLiteral(red: 0.337254902, green: 0.6588235294, blue: 0.9843137255, alpha: 1) } }
    class var defaultAlternateLine: UIColor { get { return #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1) } }
    class var defaultAlternateLineCasing: UIColor { get { return #colorLiteral(red: 0.5019607843, green: 0.4980392157, blue: 0.5019607843, alpha: 1) } }
    class var defaultManeuverArrowStroke: UIColor { get { return .defaultRouteLayer } }
    class var defaultManeuverArrow: UIColor { get { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) } }
    
    class var defaultTurnArrowPrimary: UIColor { get { return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) } }
    class var defaultTurnArrowSecondary: UIColor { get { return #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1) } }
    
    class var defaultLaneArrowPrimary: UIColor { get { return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) } }
    class var defaultLaneArrowSecondary: UIColor { get { return #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1) } }
    
    class var trafficUnknown: UIColor { get { return defaultRouteLayer } }
    class var trafficLow: UIColor { get { return defaultRouteLayer } }
    class var trafficModerate: UIColor { get { return #colorLiteral(red: 0.9529411765, green: 0.6509803922, blue: 0.3098039216, alpha: 1) } }
    class var trafficHeavy: UIColor { get { return #colorLiteral(red: 0.9137254902, green: 0.2, blue: 0.2509803922, alpha: 1) } }
    class var trafficSevere: UIColor { get { return #colorLiteral(red: 0.5411764706, green: 0.05882352941, blue: 0.2196078431, alpha: 1) } }
    class var trafficAlternateLow: UIColor { get { return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) } }
}

extension UIColor {
    // General styling
    fileprivate class var defaultTint: UIColor { get { return #colorLiteral(red: 0.1843137255, green: 0.4784313725, blue: 0.7764705882, alpha: 1) } }
    fileprivate class var defaultTintStroke: UIColor { get { return #colorLiteral(red: 0.1843137255, green: 0.4784313725, blue: 0.7764705882, alpha: 1) } }
    fileprivate class var defaultPrimaryText: UIColor { get { return #colorLiteral(red: 45.0/255.0, green: 45.0/255.0, blue: 45.0/255.0, alpha: 1) } }
    fileprivate class var defaultSecondaryText: UIColor { get { return #colorLiteral(red: 0.4509803922, green: 0.4509803922, blue: 0.4509803922, alpha: 1) } }
}

extension UIFont {
    // General styling
    fileprivate class var defaultPrimaryText: UIFont { get { return UIFont.systemFont(ofSize: 26) } }
    fileprivate class var defaultSecondaryText: UIFont { get { return UIFont.systemFont(ofSize: 16) } }
}



@objc(MBDayStyle)
open class CustomDayStyle: Style, InstructionsBannerViewDelegate {
    
    public required init() {
        super.init()
        mapStyleURL = URL(string: "mapbox://styles/tcagle717/cjqiqnvzj2m8p2spmrdqhw82m")!
        styleType = .day
        statusBarStyle = .lightContent
    }
    
    open override func apply() {
        super.apply()
        
        // General styling
        if let color = UIApplication.shared.delegate?.window??.tintColor {
            tintColor = color
        } else {
            tintColor = .defaultTint
        }
        
        ArrivalTimeLabel.appearance().font = UIFont.systemFont(ofSize: 18, weight: .medium).adjustedFont
        ArrivalTimeLabel.appearance().normalTextColor = Theme.WHITE
        
        BottomBannerContainerView.appearance().backgroundColor = Theme.BLACK
        BottomBannerView.appearance().backgroundColor = Theme.BLACK
        Button.appearance().textColor = Theme.WHITE
        CancelButton.appearance().tintColor = Theme.WHITE
        
        DismissButton.appearance().backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        DismissButton.appearance().textColor = Theme.BLACK
        DismissButton.appearance().textFont = UIFont.systemFont(ofSize: 20, weight: .medium).adjustedFont
        
        DistanceLabel.appearance().unitFont = UIFont.systemFont(ofSize: 14, weight: .medium).adjustedFont
        DistanceLabel.appearance().valueFont = UIFont.systemFont(ofSize: 22, weight: .medium).adjustedFont
        DistanceLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).unitTextColor = Theme.WHITE
        DistanceLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).valueTextColor = Theme.OFF_WHITE
        DistanceLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).unitTextColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        DistanceLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).valueTextColor = Theme.DARK_GRAY
        DistanceRemainingLabel.appearance().font = UIFont.systemFont(ofSize: 18, weight: .medium).adjustedFont
        DistanceRemainingLabel.appearance().normalTextColor = #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1)
        
        EndOfRouteButton.appearance().textColor = .darkGray
        EndOfRouteButton.appearance().textFont = .systemFont(ofSize: 15)
        EndOfRouteContentView.appearance().backgroundColor = .white
        EndOfRouteStaticLabel.appearance().normalFont = .systemFont(ofSize: 14.0)
        EndOfRouteStaticLabel.appearance().normalTextColor = #colorLiteral(red: 0.217173934, green: 0.3645851612, blue: 0.489295125, alpha: 1)
        EndOfRouteTitleLabel.appearance().normalFont = .systemFont(ofSize: 36.0)
        EndOfRouteTitleLabel.appearance().normalTextColor = .black
        ExitView.appearance().backgroundColor = .clear
        
        ExitView.appearance().layer.borderWidth = 1.0
        ExitView.appearance().layer.cornerRadius = 5.0
        ExitView.appearance().foregroundColor = Theme.WHITE
        ExitView.appearance(for: UITraitCollection(userInterfaceIdiom: .carPlay)).foregroundColor = .white
        FloatingButton.appearance().backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        FloatingButton.appearance().tintColor = tintColor
        GenericRouteShield.appearance().backgroundColor = .clear
        GenericRouteShield.appearance().layer.borderWidth = 1.0
        GenericRouteShield.appearance().layer.cornerRadius = 5.0
        GenericRouteShield.appearance().foregroundColor = .black
        GenericRouteShield.appearance(for: UITraitCollection(userInterfaceIdiom: .carPlay)).foregroundColor = .white
        
        InstructionsBannerContentView.appearance().backgroundColor = Theme.BLACK
        InstructionsBannerView.appearance().backgroundColor = Theme.BLACK
        
        LaneView.appearance().primaryColor = .defaultLaneArrowPrimary
        LaneView.appearance().secondaryColor = .defaultLaneArrowSecondary
        LanesView.appearance().backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        LineView.appearance().lineColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        ManeuverView.appearance().backgroundColor = .clear
        ManeuverView.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).primaryColor = Theme.WHITE
        ManeuverView.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).secondaryColor = Theme.OFF_WHITE
        ManeuverView.appearance(whenContainedInInstancesOf: [NextBannerView.self]).primaryColor = Theme.WHITE
        ManeuverView.appearance(whenContainedInInstancesOf: [NextBannerView.self]).secondaryColor = Theme.OFF_WHITE
        ManeuverView.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).primaryColor = Theme.BLACK
        ManeuverView.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).secondaryColor = Theme.DARK_GRAY

        NavigationMapView.appearance().maneuverArrowColor       = .defaultManeuverArrow
        NavigationMapView.appearance().maneuverArrowStrokeColor = .defaultManeuverArrowStroke
        NavigationMapView.appearance().routeAlternateColor      = .defaultAlternateLine
        NavigationMapView.appearance().routeCasingColor         = .defaultRouteCasing
        NavigationMapView.appearance().trafficHeavyColor        = .trafficHeavy
        NavigationMapView.appearance().trafficLowColor          = .trafficLow
        NavigationMapView.appearance().trafficModerateColor     = .trafficModerate
        NavigationMapView.appearance().trafficSevereColor       = .trafficSevere
        NavigationMapView.appearance().trafficUnknownColor      = .trafficUnknown
        
        NavigationView.appearance().backgroundColor = Theme.BLACK.withAlphaComponent(0.1)
        NextBannerView.appearance().backgroundColor = Theme.BLACK.withAlphaComponent(0.9)
        NextInstructionLabel.appearance().font = UIFont.systemFont(ofSize: 20, weight: .medium).adjustedFont
        NextInstructionLabel.appearance().normalTextColor = Theme.WHITE
        PrimaryLabel.appearance().normalFont = UIFont.systemFont(ofSize: 30, weight: .medium).adjustedFont
        PrimaryLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).normalTextColor = Theme.WHITE
        PrimaryLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).normalTextColor = Theme.BLACK
        ProgressBar.appearance().barColor = Theme.PURPLE
        
        ReportButton.appearance().alpha = 1
        ReportButton.appearance().backgroundColor = Theme.WHITE.withAlphaComponent(0.9)
        ReportButton.appearance().textColor = Theme.BLACK
        
        ResumeButton.appearance().backgroundColor = Theme.WHITE
        ResumeButton.appearance().tintColor = Theme.BLACK
        
        SecondaryLabel.appearance().normalFont = UIFont.systemFont(ofSize: 26, weight: .medium).adjustedFont
        SecondaryLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).normalTextColor = Theme.WHITE
        SecondaryLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).normalTextColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        SeparatorView.appearance().backgroundColor = Theme.WHITE
        StatusView.appearance().backgroundColor = Theme.DARK_GRAY
        StepInstructionsView.appearance().backgroundColor = #colorLiteral(red: 0.9675388083, green: 0.9675388083, blue: 0.9675388083, alpha: 1)
        StepListIndicatorView.appearance().gradientColors = [#colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1), #colorLiteral(red: 0.6274509804, green: 0.6274509804, blue: 0.6274509804, alpha: 1), #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1)]
        StepTableViewCell.appearance().backgroundColor = #colorLiteral(red: 0.9675388083, green: 0.9675388083, blue: 0.9675388083, alpha: 1)
        StepsBackgroundView.appearance().backgroundColor = #colorLiteral(red: 0.9675388083, green: 0.9675388083, blue: 0.9675388083, alpha: 1)
        
        TimeRemainingLabel.appearance().font = UIFont.systemFont(ofSize: 28, weight: .medium).adjustedFont
        TimeRemainingLabel.appearance().normalTextColor = Theme.WHITE
        TimeRemainingLabel.appearance().trafficHeavyColor = #colorLiteral(red:0.91, green:0.20, blue:0.25, alpha:1.0)
        TimeRemainingLabel.appearance().trafficLowColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        TimeRemainingLabel.appearance().trafficModerateColor = #colorLiteral(red:0.95, green:0.65, blue:0.31, alpha:1.0)
        TimeRemainingLabel.appearance().trafficSevereColor = #colorLiteral(red: 0.7705719471, green: 0.1753477752, blue: 0.1177056804, alpha: 1)
        TimeRemainingLabel.appearance().trafficUnknownColor = Theme.WHITE
        
        UserPuckCourseView.appearance().puckColor = Theme.BLUE
        WayNameLabel.appearance().normalFont = UIFont.systemFont(ofSize:20, weight: .medium).adjustedFont
        WayNameLabel.appearance().normalTextColor = Theme.WHITE
        WayNameView.appearance().backgroundColor = UIColor.defaultRouteLayer.withAlphaComponent(0.85)
        WayNameView.appearance().borderColor = UIColor.defaultRouteCasing.withAlphaComponent(0.8)
    }
}


@objc(MBNightStyle)
open class CustomNightStyle: CustomDayStyle {
    
    public required init() {
        super.init()
        mapStyleURL = URL(string: "mapbox://styles/tcagle717/cjqisendcn3652smyhjglrrtk")!
        previewMapStyleURL = MGLStyle.navigationPreviewNightStyleURL
        styleType = .night
        statusBarStyle = .lightContent
    }
    
    open override func apply() {
        super.apply()
        
        ArrivalTimeLabel.appearance().font = UIFont.systemFont(ofSize: 18, weight: .medium).adjustedFont
        ArrivalTimeLabel.appearance().normalTextColor = Theme.BLACK
        
        BottomBannerContainerView.appearance().backgroundColor = Theme.OFF_WHITE
        BottomBannerView.appearance().backgroundColor = Theme.OFF_WHITE
        Button.appearance().textColor = Theme.BLACK.withAlphaComponent(0.9)
        CancelButton.appearance().tintColor = Theme.BLACK
        
        DismissButton.appearance().backgroundColor = Theme.OFF_WHITE
        DismissButton.appearance().textColor = Theme.BLACK
        DismissButton.appearance().textFont = UIFont.systemFont(ofSize: 20, weight: .medium).adjustedFont
        
        DistanceLabel.appearance().unitFont = UIFont.systemFont(ofSize: 14, weight: .medium).adjustedFont
        DistanceLabel.appearance().valueFont = UIFont.systemFont(ofSize: 22, weight: .medium).adjustedFont
        DistanceLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).unitTextColor = Theme.BLACK
        DistanceLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).valueTextColor = Theme.DARK_GRAY
        DistanceLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).unitTextColor = Theme.OFF_WHITE.withAlphaComponent(0.7)
        DistanceLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).valueTextColor = Theme.WHITE
        DistanceRemainingLabel.appearance().font = UIFont.systemFont(ofSize: 18, weight: .medium).adjustedFont
        DistanceRemainingLabel.appearance().normalTextColor = #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1)
        
        EndOfRouteButton.appearance().textColor = Theme.OFF_WHITE
        EndOfRouteButton.appearance().textFont = .systemFont(ofSize: 15)
        EndOfRouteContentView.appearance().backgroundColor = Theme.BLACK
        EndOfRouteStaticLabel.appearance().normalFont = .systemFont(ofSize: 14.0)
        EndOfRouteStaticLabel.appearance().normalTextColor = Theme.OFF_WHITE
        EndOfRouteTitleLabel.appearance().normalFont = .systemFont(ofSize: 36.0)
        EndOfRouteTitleLabel.appearance().normalTextColor = Theme.WHITE
        ExitView.appearance().backgroundColor = .clear
        
        ExitView.appearance().layer.borderWidth = 1.0
        ExitView.appearance().layer.cornerRadius = 5.0
        ExitView.appearance().foregroundColor = Theme.OFF_WHITE
        ExitView.appearance(for: UITraitCollection(userInterfaceIdiom: .carPlay)).foregroundColor = Theme.BLACK
        FloatingButton.appearance().backgroundColor = Theme.WHITE.withAlphaComponent(0.9)
        FloatingButton.appearance().tintColor = tintColor
        GenericRouteShield.appearance().backgroundColor = .clear
        GenericRouteShield.appearance().layer.borderWidth = 1.0
        GenericRouteShield.appearance().layer.cornerRadius = 5.0
        GenericRouteShield.appearance().foregroundColor = Theme.WHITE
        GenericRouteShield.appearance(for: UITraitCollection(userInterfaceIdiom: .carPlay)).foregroundColor = Theme.BLACK
        
        InstructionsBannerContentView.appearance().backgroundColor = Theme.OFF_WHITE.withAlphaComponent(0.9)
        InstructionsBannerView.appearance().backgroundColor = Theme.OFF_WHITE.withAlphaComponent(0.9)
        
        LaneView.appearance().primaryColor = .defaultLaneArrowPrimary
        LaneView.appearance().secondaryColor = .defaultLaneArrowSecondary
        LanesView.appearance().backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        LineView.appearance().lineColor = Theme.PURPLE
        
        ManeuverView.appearance().backgroundColor = .clear
        ManeuverView.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).primaryColor = Theme.BLACK
        ManeuverView.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).secondaryColor = Theme.DARK_GRAY
        ManeuverView.appearance(whenContainedInInstancesOf: [NextBannerView.self]).primaryColor = Theme.BLACK
        ManeuverView.appearance(whenContainedInInstancesOf: [NextBannerView.self]).secondaryColor = Theme.DARK_GRAY
        ManeuverView.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).primaryColor = Theme.WHITE
        ManeuverView.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).secondaryColor = Theme.OFF_WHITE
        
        NavigationMapView.appearance().maneuverArrowColor       = .defaultManeuverArrow
        NavigationMapView.appearance().maneuverArrowStrokeColor = .defaultManeuverArrowStroke
        NavigationMapView.appearance().routeAlternateColor      = .defaultAlternateLine
        NavigationMapView.appearance().routeCasingColor         = .defaultRouteCasing
        NavigationMapView.appearance().trafficHeavyColor        = .trafficHeavy
        NavigationMapView.appearance().trafficLowColor          = .trafficLow
        NavigationMapView.appearance().trafficModerateColor     = .trafficModerate
        NavigationMapView.appearance().trafficSevereColor       = .trafficSevere
        NavigationMapView.appearance().trafficUnknownColor      = .trafficUnknown
        
        NavigationView.appearance().backgroundColor = Theme.WHITE.withAlphaComponent(0.9)
        NextBannerView.appearance().backgroundColor = Theme.OFF_WHITE.withAlphaComponent(0.9)
        NextInstructionLabel.appearance().font = UIFont.systemFont(ofSize: 20, weight: .medium).adjustedFont
        NextInstructionLabel.appearance().normalTextColor = Theme.BLACK
        PrimaryLabel.appearance().normalFont = UIFont.systemFont(ofSize: 30, weight: .medium).adjustedFont
        PrimaryLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).normalTextColor = Theme.BLACK
        PrimaryLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).normalTextColor = Theme.WHITE
        ProgressBar.appearance().barColor = Theme.PURPLE
        
        ReportButton.appearance().alpha = 1
        ReportButton.appearance().backgroundColor = Theme.WHITE.withAlphaComponent(0.9)
        ReportButton.appearance().textColor = Theme.BLACK
        
        ResumeButton.appearance().backgroundColor = Theme.WHITE
        ResumeButton.appearance().tintColor = Theme.BLACK
        
        SecondaryLabel.appearance().normalFont = UIFont.systemFont(ofSize: 26, weight: .medium).adjustedFont
        SecondaryLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).normalTextColor = Theme.BLACK
        SecondaryLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).normalTextColor = Theme.OFF_WHITE.withAlphaComponent(0.7)
        SeparatorView.appearance().backgroundColor = Theme.BLACK
        StatusView.appearance().backgroundColor = Theme.DARK_GRAY.withAlphaComponent(0.9)
        StepInstructionsView.appearance().backgroundColor = Theme.DARK_GRAY
        StepListIndicatorView.appearance().gradientColors = [#colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1), #colorLiteral(red: 0.6274509804, green: 0.6274509804, blue: 0.6274509804, alpha: 1), #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1)]
        StepTableViewCell.appearance().backgroundColor = Theme.DARK_GRAY
        StepsBackgroundView.appearance().backgroundColor = Theme.DARK_GRAY
        
        TimeRemainingLabel.appearance().font = UIFont.systemFont(ofSize: 28, weight: .medium).adjustedFont
        TimeRemainingLabel.appearance().normalTextColor = Theme.BLACK
        TimeRemainingLabel.appearance().trafficHeavyColor = #colorLiteral(red:0.91, green:0.20, blue:0.25, alpha:1.0)
        TimeRemainingLabel.appearance().trafficLowColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        TimeRemainingLabel.appearance().trafficModerateColor = #colorLiteral(red:0.95, green:0.65, blue:0.31, alpha:1.0)
        TimeRemainingLabel.appearance().trafficSevereColor = #colorLiteral(red: 0.7705719471, green: 0.1753477752, blue: 0.1177056804, alpha: 1)
        TimeRemainingLabel.appearance().trafficUnknownColor = Theme.BLACK
        
        UserPuckCourseView.appearance().puckColor = Theme.SEA_BLUE
        WayNameLabel.appearance().normalFont = UIFont.systemFont(ofSize:20, weight: .medium).adjustedFont
        WayNameLabel.appearance().normalTextColor = Theme.WHITE
        WayNameView.appearance().backgroundColor = UIColor.defaultRouteLayer.withAlphaComponent(0.85)
        WayNameView.appearance().borderColor = UIColor.defaultRouteCasing.withAlphaComponent(0.8)
    }
}


@objc(MBDayStyle)
open class CustomHiddenStyle: Style, InstructionsBannerViewDelegate {
    
    public required init() {
        super.init()
        mapStyleURL = URL(string: "mapbox://styles/tcagle717/cjqiqnvzj2m8p2spmrdqhw82m")!
        styleType = .day
        statusBarStyle = .lightContent
    }
    
    open override func apply() {
        super.apply()
        
        // General styling
        if let color = UIApplication.shared.delegate?.window??.tintColor {
            tintColor = color
        } else {
            tintColor = .defaultTint
        }
        
        ArrivalTimeLabel.appearance().font = UIFont.systemFont(ofSize: 18, weight: .medium).adjustedFont
        ArrivalTimeLabel.appearance().normalTextColor = UIColor.clear
        
        BottomBannerContainerView.appearance().backgroundColor = UIColor.clear
        BottomBannerView.appearance().backgroundColor = UIColor.clear
        Button.appearance().textColor = UIColor.clear
        CancelButton.appearance().tintColor = UIColor.clear
        
        DismissButton.appearance().backgroundColor = UIColor.clear
        DismissButton.appearance().textColor = UIColor.clear
        DismissButton.appearance().textFont = UIFont.systemFont(ofSize: 20, weight: .medium).adjustedFont
        
        DistanceLabel.appearance().unitFont = UIFont.systemFont(ofSize: 14, weight: .medium).adjustedFont
        DistanceLabel.appearance().valueFont = UIFont.systemFont(ofSize: 22, weight: .medium).adjustedFont
        DistanceLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).unitTextColor = UIColor.clear
        DistanceLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).valueTextColor = UIColor.clear
        DistanceLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).unitTextColor = UIColor.clear
        DistanceLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).valueTextColor = UIColor.clear
        DistanceRemainingLabel.appearance().font = UIFont.systemFont(ofSize: 18, weight: .medium).adjustedFont
        DistanceRemainingLabel.appearance().normalTextColor = UIColor.clear
        
        EndOfRouteButton.appearance().textColor = UIColor.clear
        EndOfRouteButton.appearance().textFont = .systemFont(ofSize: 15)
        EndOfRouteContentView.appearance().backgroundColor = UIColor.clear
        EndOfRouteStaticLabel.appearance().normalFont = .systemFont(ofSize: 14.0)
        EndOfRouteStaticLabel.appearance().normalTextColor = UIColor.clear
        EndOfRouteTitleLabel.appearance().normalFont = .systemFont(ofSize: 36.0)
        EndOfRouteTitleLabel.appearance().normalTextColor = UIColor.clear
        ExitView.appearance().backgroundColor = .clear
        
        ExitView.appearance().layer.borderWidth = 1.0
        ExitView.appearance().layer.cornerRadius = 5.0
        ExitView.appearance().foregroundColor = UIColor.clear
        ExitView.appearance(for: UITraitCollection(userInterfaceIdiom: .carPlay)).foregroundColor = UIColor.clear
        FloatingButton.appearance().backgroundColor = UIColor.clear
        FloatingButton.appearance().tintColor = tintColor
        GenericRouteShield.appearance().backgroundColor = UIColor.clear
        GenericRouteShield.appearance().layer.borderWidth = 1.0
        GenericRouteShield.appearance().layer.cornerRadius = 5.0
        GenericRouteShield.appearance().foregroundColor = UIColor.clear
        GenericRouteShield.appearance(for: UITraitCollection(userInterfaceIdiom: .carPlay)).foregroundColor = UIColor.clear
        
        InstructionsBannerContentView.appearance().backgroundColor = UIColor.clear
        InstructionsBannerView.appearance().backgroundColor = UIColor.clear
        
        LaneView.appearance().primaryColor = .defaultLaneArrowPrimary
        LaneView.appearance().secondaryColor = .defaultLaneArrowSecondary
        LanesView.appearance().backgroundColor = UIColor.clear
        LineView.appearance().lineColor = UIColor.clear
        
        ManeuverView.appearance().backgroundColor = .clear
        ManeuverView.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).primaryColor = UIColor.clear
        ManeuverView.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).secondaryColor = UIColor.clear
        ManeuverView.appearance(whenContainedInInstancesOf: [NextBannerView.self]).primaryColor = UIColor.clear
        ManeuverView.appearance(whenContainedInInstancesOf: [NextBannerView.self]).secondaryColor = UIColor.clear
        ManeuverView.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).primaryColor = UIColor.clear
        ManeuverView.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).secondaryColor = UIColor.clear
        
        NavigationMapView.appearance().maneuverArrowColor       = .defaultManeuverArrow
        NavigationMapView.appearance().maneuverArrowStrokeColor = .defaultManeuverArrowStroke
        NavigationMapView.appearance().routeAlternateColor      = .defaultAlternateLine
        NavigationMapView.appearance().routeCasingColor         = .defaultRouteCasing
        NavigationMapView.appearance().trafficHeavyColor        = .trafficHeavy
        NavigationMapView.appearance().trafficLowColor          = .trafficLow
        NavigationMapView.appearance().trafficModerateColor     = .trafficModerate
        NavigationMapView.appearance().trafficSevereColor       = .trafficSevere
        NavigationMapView.appearance().trafficUnknownColor      = .trafficUnknown
        
        NavigationView.appearance().backgroundColor = UIColor.clear
        NextBannerView.appearance().backgroundColor = UIColor.clear
        NextInstructionLabel.appearance().font = UIFont.systemFont(ofSize: 20, weight: .medium).adjustedFont
        NextInstructionLabel.appearance().normalTextColor = UIColor.clear
        PrimaryLabel.appearance().normalFont = UIFont.systemFont(ofSize: 30, weight: .medium).adjustedFont
        PrimaryLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).normalTextColor = UIColor.clear
        PrimaryLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).normalTextColor = UIColor.clear
        ProgressBar.appearance().barColor = UIColor.clear
        
        ReportButton.appearance().alpha = 1
        ReportButton.appearance().backgroundColor = UIColor.clear
        ReportButton.appearance().textColor = UIColor.clear
        
        ResumeButton.appearance().backgroundColor = UIColor.clear
        ResumeButton.appearance().tintColor = UIColor.clear
        
        SecondaryLabel.appearance().normalFont = UIFont.systemFont(ofSize: 26, weight: .medium).adjustedFont
        SecondaryLabel.appearance(whenContainedInInstancesOf: [InstructionsBannerView.self]).normalTextColor = UIColor.clear
        SecondaryLabel.appearance(whenContainedInInstancesOf: [StepInstructionsView.self]).normalTextColor = UIColor.clear
        SeparatorView.appearance().backgroundColor = UIColor.clear
        StatusView.appearance().backgroundColor = UIColor.clear
        StepInstructionsView.appearance().backgroundColor = UIColor.clear
        StepListIndicatorView.appearance().gradientColors = [#colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1), #colorLiteral(red: 0.6274509804, green: 0.6274509804, blue: 0.6274509804, alpha: 1), #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1)]
        StepTableViewCell.appearance().backgroundColor = UIColor.clear
        StepsBackgroundView.appearance().backgroundColor = UIColor.clear
        
        TimeRemainingLabel.appearance().font = UIFont.systemFont(ofSize: 28, weight: .medium).adjustedFont
        TimeRemainingLabel.appearance().normalTextColor = UIColor.clear
        TimeRemainingLabel.appearance().trafficHeavyColor = UIColor.clear
        TimeRemainingLabel.appearance().trafficLowColor = UIColor.clear
        TimeRemainingLabel.appearance().trafficModerateColor = UIColor.clear
        TimeRemainingLabel.appearance().trafficSevereColor = UIColor.clear
        TimeRemainingLabel.appearance().trafficUnknownColor = UIColor.clear
        
        UserPuckCourseView.appearance().puckColor = Theme.BLUE
        WayNameLabel.appearance().normalFont = UIFont.systemFont(ofSize:20, weight: .medium).adjustedFont
        WayNameLabel.appearance().normalTextColor = UIColor.clear
        WayNameView.appearance().backgroundColor = UIColor.clear
        WayNameView.appearance().borderColor = UIColor.clear
    }
}
