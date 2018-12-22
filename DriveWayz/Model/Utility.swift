//
//  Utility.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/1/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import Foundation


class Utility {
    
    /// Logs all available fonts from iOS SDK and installed custom font
    class func logAllAvailableFonts() {
        for family in UIFont.familyNames {
            print("\(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }
}

struct Font {

    // SourceSansPro
    //    SourceSansPro-BlackItalic
    //    SourceSansPro-SemiBoldItalic
    //    SourceSansPro-Regular
    //    SourceSansPro-Bold
    //    SourceSansPro-LightItalic
    //    SourceSansPro-Light
    //    SourceSansPro-Black
    //    SourceSansPro-ExtraLight
    //    SourceSansPro-BoldItalic
    //    SourceSansPro-SemiBold
    //    SourceSansPro-UltraLightItalic
    
    
    enum FontName: String {
        case SSPBlackItalic         = "SourceSansPro-BlackItalic"
        case SSPSemiBoldItalic      = "SourceSansPro-SemiBoldItalic"
        case SSPRegular             = "SourceSansPro-Regular"
        case SSPBold                = "SourceSansPro-Bold"
        case SSPLightItalic         = "SourceSansPro-LightItalic"
        case SSPLight               = "SourceSansPro-Light"
        case SSPBlack               = "SourceSansPro-Black"
        case SSPExtraLight          = "SourceSansPro-ExtraLight"
        case SSPBoldItalic          = "SourceSansPro-BoldItalic"
        case SSPSemiBold            = "SourceSansPro-SemiBold"
        case SSPUltraLightItalic    = "SourceSansPro-UltraLightItalic"
    }
    
    enum StandardSize: Double {
        case h0 = 32.0
        case h1 = 28.0
        case h2 = 24.0
        case h3 = 20.0
        case h4 = 18.0
        case h5 = 16.0
        case h6 = 14.0
    }
    
    enum FontType {
        case installed(FontName)
        case custom(String)
        case system
        case systemBold
        case systemItatic
        case systemWeighted(weight: Double)
        case monoSpacedDigit(size: Double, weight: Double)
    }
    
    enum FontSize {
        case standard(StandardSize)
        case custom(Double)
        var value: Double {
            switch self {
            case .standard(let size):
                return size.rawValue
            case .custom(let customSize):
                return customSize
            }
        }
    }
    
    // 1
    var type: FontType
    var size: FontSize
    // 2
    init(_ type: FontType, size: FontSize) {
        self.type = type
        self.size = size
    }

}

extension Font {
    var instance: UIFont {
        var instanceFont: UIFont!
        switch type {
        case .custom(let fontName):
            guard let font =  UIFont(name: fontName, size: CGFloat(size.value)) else {
                fatalError("\(fontName) font is not installed, make sure it is added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        case .installed(let fontName):
            guard let font =  UIFont(name: fontName.rawValue, size: CGFloat(size.value)) else {
                fatalError("\(fontName.rawValue) font is not installed, make sure it is added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        case .system:
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value))
        case .systemBold:
            instanceFont = UIFont.boldSystemFont(ofSize: CGFloat(size.value))
        case .systemItatic:
            instanceFont = UIFont.italicSystemFont(ofSize: CGFloat(size.value))
        case .systemWeighted(let weight):
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value),
                                             weight: UIFont.Weight(rawValue: CGFloat(weight)))
        case .monoSpacedDigit(let size, let weight):
            instanceFont = UIFont.monospacedDigitSystemFont(ofSize: CGFloat(size),
                                                            weight: UIFont.Weight(rawValue: CGFloat(weight)))
        }
        return instanceFont
    }
}


class Fonts {
    
    //////FONTS
    //Regular
    static let SSPRegularH0 = Font(Font.FontType.installed(Font.FontName.SSPRegular), size: Font.FontSize.standard(Font.StandardSize.h0)).instance
    static let SSPRegularH1 = Font(Font.FontType.installed(Font.FontName.SSPRegular), size: Font.FontSize.standard(Font.StandardSize.h1)).instance
    static let SSPRegularH2 = Font(Font.FontType.installed(Font.FontName.SSPRegular), size: Font.FontSize.standard(Font.StandardSize.h2)).instance
    static let SSPRegularH3 = Font(Font.FontType.installed(Font.FontName.SSPRegular), size: Font.FontSize.standard(Font.StandardSize.h3)).instance
    static let SSPRegularH4 = Font(Font.FontType.installed(Font.FontName.SSPRegular), size: Font.FontSize.standard(Font.StandardSize.h4)).instance
    static let SSPRegularH5 = Font(Font.FontType.installed(Font.FontName.SSPRegular), size: Font.FontSize.standard(Font.StandardSize.h5)).instance
    static let SSPRegularH6 = Font(Font.FontType.installed(Font.FontName.SSPRegular), size: Font.FontSize.standard(Font.StandardSize.h6)).instance
    
    //Bold
    static let SSPBoldH0 = Font(Font.FontType.installed(Font.FontName.SSPBold), size: Font.FontSize.standard(Font.StandardSize.h0)).instance
    static let SSPBoldH1 = Font(Font.FontType.installed(Font.FontName.SSPBold), size: Font.FontSize.standard(Font.StandardSize.h1)).instance
    static let SSPBoldH2 = Font(Font.FontType.installed(Font.FontName.SSPBold), size: Font.FontSize.standard(Font.StandardSize.h2)).instance
    static let SSPBoldH3 = Font(Font.FontType.installed(Font.FontName.SSPBold), size: Font.FontSize.standard(Font.StandardSize.h3)).instance
    static let SSPBoldH4 = Font(Font.FontType.installed(Font.FontName.SSPBold), size: Font.FontSize.standard(Font.StandardSize.h4)).instance
    static let SSPBoldH5 = Font(Font.FontType.installed(Font.FontName.SSPBold), size: Font.FontSize.standard(Font.StandardSize.h5)).instance
    static let SSPBoldH6 = Font(Font.FontType.installed(Font.FontName.SSPBold), size: Font.FontSize.standard(Font.StandardSize.h6)).instance
    
    //Light
    static let SSPLightH0 = Font(Font.FontType.installed(Font.FontName.SSPLight), size: Font.FontSize.standard(Font.StandardSize.h0)).instance
    static let SSPLightH1 = Font(Font.FontType.installed(Font.FontName.SSPLight), size: Font.FontSize.standard(Font.StandardSize.h1)).instance
    static let SSPLightH2 = Font(Font.FontType.installed(Font.FontName.SSPLight), size: Font.FontSize.standard(Font.StandardSize.h2)).instance
    static let SSPLightH3 = Font(Font.FontType.installed(Font.FontName.SSPLight), size: Font.FontSize.standard(Font.StandardSize.h3)).instance
    static let SSPLightH4 = Font(Font.FontType.installed(Font.FontName.SSPLight), size: Font.FontSize.standard(Font.StandardSize.h4)).instance
    static let SSPLightH5 = Font(Font.FontType.installed(Font.FontName.SSPLight), size: Font.FontSize.standard(Font.StandardSize.h5)).instance
    static let SSPLightH6 = Font(Font.FontType.installed(Font.FontName.SSPLight), size: Font.FontSize.standard(Font.StandardSize.h6)).instance
    
    //Extra Light
    static let SSPExtraLightH0 = Font(Font.FontType.installed(Font.FontName.SSPExtraLight), size: Font.FontSize.standard(Font.StandardSize.h0)).instance
    static let SSPExtraLightH1 = Font(Font.FontType.installed(Font.FontName.SSPExtraLight), size: Font.FontSize.standard(Font.StandardSize.h1)).instance
    static let SSPExtraLightH2 = Font(Font.FontType.installed(Font.FontName.SSPExtraLight), size: Font.FontSize.standard(Font.StandardSize.h2)).instance
    static let SSPExtraLightH3 = Font(Font.FontType.installed(Font.FontName.SSPExtraLight), size: Font.FontSize.standard(Font.StandardSize.h3)).instance
    static let SSPExtraLightH4 = Font(Font.FontType.installed(Font.FontName.SSPExtraLight), size: Font.FontSize.standard(Font.StandardSize.h4)).instance
    static let SSPExtraLightH5 = Font(Font.FontType.installed(Font.FontName.SSPExtraLight), size: Font.FontSize.standard(Font.StandardSize.h5)).instance
    static let SSPExtraLightH6 = Font(Font.FontType.installed(Font.FontName.SSPExtraLight), size: Font.FontSize.standard(Font.StandardSize.h6)).instance
    
    //Black
    static let SSPBlackH0 = Font(Font.FontType.installed(Font.FontName.SSPBlack), size: Font.FontSize.standard(Font.StandardSize.h0)).instance
    static let SSPBlackH1 = Font(Font.FontType.installed(Font.FontName.SSPBlack), size: Font.FontSize.standard(Font.StandardSize.h1)).instance
    static let SSPBlackH2 = Font(Font.FontType.installed(Font.FontName.SSPBlack), size: Font.FontSize.standard(Font.StandardSize.h2)).instance
    static let SSPBlackH3 = Font(Font.FontType.installed(Font.FontName.SSPBlack), size: Font.FontSize.standard(Font.StandardSize.h3)).instance
    static let SSPBlackH4 = Font(Font.FontType.installed(Font.FontName.SSPBlack), size: Font.FontSize.standard(Font.StandardSize.h4)).instance
    static let SSPBlackH5 = Font(Font.FontType.installed(Font.FontName.SSPBlack), size: Font.FontSize.standard(Font.StandardSize.h5)).instance
    static let SSPBlackH6 = Font(Font.FontType.installed(Font.FontName.SSPBlack), size: Font.FontSize.standard(Font.StandardSize.h6)).instance
    
    //SemiBold
    static let SSPSemiBoldH0 = Font(Font.FontType.installed(Font.FontName.SSPSemiBold), size: Font.FontSize.standard(Font.StandardSize.h0)).instance
    static let SSPSemiBoldH1 = Font(Font.FontType.installed(Font.FontName.SSPSemiBold), size: Font.FontSize.standard(Font.StandardSize.h1)).instance
    static let SSPSemiBoldH2 = Font(Font.FontType.installed(Font.FontName.SSPSemiBold), size: Font.FontSize.standard(Font.StandardSize.h2)).instance
    static let SSPSemiBoldH3 = Font(Font.FontType.installed(Font.FontName.SSPSemiBold), size: Font.FontSize.standard(Font.StandardSize.h3)).instance
    static let SSPSemiBoldH4 = Font(Font.FontType.installed(Font.FontName.SSPSemiBold), size: Font.FontSize.standard(Font.StandardSize.h4)).instance
    static let SSPSemiBoldH5 = Font(Font.FontType.installed(Font.FontName.SSPSemiBold), size: Font.FontSize.standard(Font.StandardSize.h5)).instance
    static let SSPSemiBoldH6 = Font(Font.FontType.installed(Font.FontName.SSPSemiBold), size: Font.FontSize.standard(Font.StandardSize.h6)).instance
    
}
