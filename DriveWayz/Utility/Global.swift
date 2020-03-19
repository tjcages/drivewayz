//
//  Global.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 11/8/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import CoreLocation

// Variables that are the same throughout

let formatter = DateFormatter()
let calendar = Calendar.current

let animationIn = 0.2
let animationOut = 0.3

var gradientHeight: CGFloat = 140
var cancelBottomHeight: CGFloat = -8

var mapZoomLevel: Float = 15.5
var mapTrackingLevel: Float = 18.5

class Line: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Theme.LINE_GRAY
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIView {
    
    static func animateOut(withDuration: TimeInterval, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: withDuration, delay: 0, options: .curveEaseOut, animations: animations, completion: completion)
    }
    
    static func animateIn(withDuration: TimeInterval, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: withDuration, delay: 0, options: .curveEaseIn, animations: animations, completion: completion)
    }
    
    static func animateInOut(withDuration: TimeInterval, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: withDuration, delay: 0, options: .curveEaseInOut, animations: animations, completion: completion)
    }
    
}

let parkingValues: [CGFloat] = [0.128571428571429,
                               0.0571428571428571,
                               0,
                               0,
                               0,
                               0,
                               0.0142857142857143,
                               0.0285714285714286,
                               0.0285714285714286,
                               0.157142857142857,
                               0.271428571428571,
                               0.3,
                               0.428571428571429,
                               0.528571428571429,
                               0.785714285714286,
                               0.857142857142857,
                               1,
                               0.9,
                               0.7,
                               0.671428571428571,
                               0.614285714285714,
                               0.428571428571429,
                               0.414285714285714,
                               0.414285714285714,
                               0.385714285714286,
                               0.442857142857143,
                               0.471428571428571,
                               0.414285714285714,
                               0.385714285714286,
                               0.328571428571429,
                               0.557142857142857,
                               0.628571428571429,
                               0.714285714285714,
                               0.857142857142857,
                               0.814285714285714,
                               0.757142857142857,
                               0.528571428571429,
                               0.5,
                               0.414285714285714,
                               0.4,
                               0.357142857142857,
                               0.271428571428571,
                               0.242857142857143,
                               0.2,
                               0.1,
                               0.128571428571429,
                               0.142857142857143,
                               0.1,
                               0,
                               0,
                               0
]

let parkingDayValues: [CGFloat] = [0.7,
                                   0.6,
                                   0.4,
                                   0.3,
                                   0.4,
                                   0.5,
                                   0.8,
                                   1.0
]

let statesDictionary = ["Alabama": "AL",
                        "Alaska": "AK",
                        "Arizona": "AZ",
                        "Arkansas": "AR",
                        "California": "CA",
                        "Colorado": "CO",
                        "Connecticut": "CT",
                        "Delaware": "DE",
                        "Florida": "FL",
                        "Georgia": "GA",
                        "Hawaii": "HI",
                        "Idaho": "ID",
                        "Illinois": "IL",
                        "Indiana": "IN",
                        "Iowa": "IA",
                        "Kansas": "KS",
                        "Kentucky": "KY",
                        "Louisiana": "LA",
                        "Maine": "ME",
                        "Maryland": "MD",
                        "Massachusetts": "MA",
                        "Michigan": "MI",
                        "Minnesota": "MN",
                        "Mississippi": "MS",
                        "Missouri": "MO",
                        "Montana": "MT",
                        "Nebraska": "NE",
                        "Nevada": "NV",
                        "New Hampshire": "NH",
                        "New Jersey": "NJ",
                        "New Mexico": "NM",
                        "New York": "NY",
                        "North Carolina": "NC",
                        "North Dakota": "ND",
                        "Ohio": "OH",
                        "Oklahoma": "OK",
                        "Oregon": "OR",
                        "Pennsylvania": "PA",
                        "Rhode Island": "RI",
                        "South Carolina": "SC",
                        "South Dakota": "SD",
                        "Tennessee": "TN",
                        "Texas": "TX",
                        "Utah": "UT",
                        "Vermont": "VT",
                        "Virginia": "VA",
                        "Washington": "WA",
                        "West Virginia": "WV",
                        "Wisconsin": "WI",
                        "Wyoming": "WY",

                        "Alberta": "AB",
                        "British Columbia": "BC",
                        "Manitoba": "MB",
                        "New Brunswick": "NB",
                        "Newfoundland": "NF",
                        "Northwest Territory": "NT",
                        "Nova Scotia": "NS",
                        "Nunavut": "NU",
                        "Ontario": "ON",
                        "Prince Edward Island": "PE",
                        "Quebec": "QC",
                        "Saskatchewan": "SK",
                        "Yukon": "YT"
]
