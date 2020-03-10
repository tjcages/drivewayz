//
//  Theme.swift
//
//
//  Created by Tyler J. Cagle on 29/3/17.
//  Copyright © 2017 Tyler J. Cagle. All rights reserved.
//

import UIKit

class Theme {
    
    //BRAND COLORS
    static let WHITE = UIColor(red: 254/255, green: 255/255, blue: 255/255, alpha: 1)
    static let BLACK = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    
    //GRAYS
    static let BACKGROUND_GRAY = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    static let STANDARD_GRAY = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
    static let LINE_GRAY = UIColor(red: 235/255, green: 238/255, blue: 244/255, alpha: 1)
    
    static let GRAY_WHITE = UIColor(red: 72/255, green: 72/255, blue: 74/255, alpha: 1)
    static let GRAY_WHITE_1 = UIColor(red: 174/255, green: 174/255, blue: 178/255, alpha: 1)
    static let GRAY_WHITE_2 = UIColor(red: 199/255, green: 199/255, blue: 204/255, alpha: 1)
    static let GRAY_WHITE_3 = UIColor(red: 209/255, green: 209/255, blue: 214/255, alpha: 1)
    static let GRAY_WHITE_4 = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1)
    static let GRAY_WHITE_5 = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    
    static let GRAY_BLACK = UIColor(red: 199/255, green: 199/255, blue: 204/255, alpha: 1)
    static let GRAY_BLACK_1 = UIColor(red: 99/255, green: 99/255, blue: 102/255, alpha: 1)
    static let GRAY_BLACK_2 = UIColor(red: 72/255, green: 72/255, blue: 74/255, alpha: 1)
    static let GRAY_BLACK_3 = UIColor(red: 58/255, green: 58/255, blue: 60/255, alpha: 1)
    static let GRAY_BLACK_4 = UIColor(red: 44/255, green: 44/255, blue: 46/255, alpha: 1)
    static let GRAY_BLACK_5 = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1)
    
    //OUR BLUE
    static let BLUE = UIColor(red: 20/255, green: 119/255, blue: 251/255, alpha: 1)
    static let BLUE_LIGHT = UIColor(red: 207/255, green: 218/255, blue: 255/255, alpha: 1)
    static let BLUE_MED = UIColor(red: 159/255, green: 190/255, blue: 255/255, alpha: 1)
    static let BLUE_DARK = UIColor(red: 119/255, green: 161/255, blue: 255/255, alpha: 1)
    static let GOOGLE_BLUE = UIColor(red: 81/255, green: 134/255, blue: 236/255, alpha: 1)
    
    //SECONDARY COLORS
    static let GREEN = UIColor(red: 14/255, green: 197/255, blue: 84/255, alpha: 1)
    static let YELLOW = UIColor(red: 254/255, green: 198/255, blue: 46/255, alpha: 1)
    static let MAYA = UIColor(red: 92/255, green: 160/255, blue: 252/255, alpha: 1)
    static let FLOWER = UIColor(red: 66/255, green: 67/255, blue: 106/255, alpha: 1)
    static let SALMON = UIColor(red: 248/255, green: 107/255, blue: 106/255, alpha: 1)
    static let PINK = UIColor(red: 251/255, green: 204/255, blue: 219/255, alpha: 1)
    static let DOWNY = UIColor(red: 107/255, green: 206/255, blue: 207/255, alpha: 1)
    static let FOG = UIColor(red: 203/255, green: 196/255, blue: 231/255, alpha: 1)
    
    //COLOR PALETTES - WARM
    static let WARM_1_LIGHT = UIColor(red: 251/255, green: 163/255, blue: 163/255, alpha: 1) //RED
    static let WARM_1_MED = UIColor(red: 249/255, green: 103/255, blue: 102/255, alpha: 1)
    static let WARM_1_DARK = UIColor(red: 237/255, green: 82/255, blue: 57/255, alpha: 1)
    
    static let WARM_2_LIGHT = UIColor(red: 255/255, green: 225/255, blue: 169/255, alpha: 1) //ORANGE
    static let WARM_2_MED = UIColor(red: 255/255, green: 192/255, blue: 67/255, alpha: 1)
    static let WARM_2_DARK = UIColor(red: 255/255, green: 156/255, blue: 33/255, alpha: 1)
    
    //COLOR PALETTES - COOL
    static let COOL_1_LIGHT = UIColor(red: 195/255, green: 222/255, blue: 226/255, alpha: 1) //TEAL
    static let COOL_1_MED = UIColor(red: 140/255, green: 197/255, blue: 204/255, alpha: 1)
    static let COOL_1_DARK = UIColor(red: 108/255, green: 161/255, blue: 172/255, alpha: 1)
    
    static let COOL_2_LIGHT = UIColor(red: 238/255, green: 223/255, blue: 255/255, alpha: 1) //PURPLE
    static let COOL_2_MED = UIColor(red: 176/255, green: 149/255, blue: 255/255, alpha: 1)
    static let COOL_2_DARK = UIColor(red: 117/255, green: 72/255, blue: 198/255, alpha: 1)
    
    //HOST COLOR PALETTE
    static let HOST_BLUE = UIColor(red: 209/255, green: 228/255, blue: 254/255, alpha: 1)
    static let HOST_DARK_BLUE = UIColor(red: 185/255, green: 203/255, blue: 229/255, alpha: 1)
    static let HOST_GREEN = UIColor(red: 206/255, green: 232/255, blue: 214/255, alpha: 1)
    static let HOST_RED = UIColor(red: 253/255, green: 210/255, blue: 211/255, alpha: 1)
    static let HOST_PURPLE = UIColor(red: 211/255, green: 211/255, blue: 253/255, alpha: 1)

    //OLD PALETTES -- DO NOT USE
    static let EasternBlue = UIColor(red: 26/255, green: 145/255, blue: 161/255, alpha: 1)
    static let LightOrange = UIColor(red: 255/255, green: 195/255, blue: 135/255, alpha: 1)
    static let DarkOrange = UIColor(red: 255/255, green: 106/255, blue: 97/255, alpha: 1)
    static let LightPink = UIColor(red: 254/255, green: 155/255, blue: 134/255, alpha: 1)
    static let DarkPink = UIColor(red: 241/255, green: 88/255, blue: 135/255, alpha: 1)
    static let LightGreen = UIColor(red: 157/255, green: 230/255, blue: 134/255, alpha: 1)
    static let DarkGreen = UIColor(red: 10/255, green: 131/255, blue: 51/255, alpha: 1)
    static let LightRed = UIColor(red: 250/255, green: 123/255, blue: 126/255, alpha: 1)
    static let DarkRed = UIColor(red: 239/255, green: 96/255, blue: 102/255, alpha: 1)
    static let LightPurple = UIColor(red: 156/255, green: 163/255, blue: 249/255, alpha: 1)
    static let DarkPurple = UIColor(red: 70/255, green: 85/255, blue: 217/255, alpha: 1)
    static let LightTeal = UIColor(red: 2/255, green: 210/255, blue: 184/255, alpha: 1)
    static let DarkTeal = UIColor(red: 45/255, green: 201/255, blue: 235/255, alpha: 1)
    static let LightYellow = UIColor(red: 248/255, green: 200/255, blue: 94/255, alpha: 1)
    static let DarkYellow = UIColor(red: 238/255, green: 185/255, blue: 71/255, alpha: 1)
    static let LightBlue = UIColor(red: 70/255, green: 210/255, blue: 253/255, alpha: 1)
    static let DarkBlue = UIColor(red: 83/255, green: 81/255, blue: 240/255, alpha: 1)
    static let LIGHT_PINK = UIColor(red: 253/255, green: 210/255, blue: 211/255, alpha: 1)
    
}
