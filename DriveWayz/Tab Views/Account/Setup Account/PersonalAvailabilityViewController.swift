//
//  PersonalAvailabilityViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/24/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

class PersonalAvailabilityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Theme.WHITE
        self.navigationController?.navigationBar.isHidden = true
        
        collectAvailiability()
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(labelAvailability)
        labelAvailability.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        labelAvailability.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        labelAvailability.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        labelAvailability.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(mondayButton)
        mondayButton.leftAnchor.constraint(equalTo: labelAvailability.leftAnchor, constant: 30).isActive = true
        mondayButton.topAnchor.constraint(equalTo: labelAvailability.bottomAnchor, constant: 4).isActive = true
        mondayButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        mondayButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(mondayLabel)
        mondayLabel.leftAnchor.constraint(equalTo: mondayButton.rightAnchor, constant: 8).isActive = true
        mondayLabel.centerYAnchor.constraint(equalTo: mondayButton.centerYAnchor).isActive = true
        mondayLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mondayLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(tuesdayButton)
        tuesdayButton.leftAnchor.constraint(equalTo: labelAvailability.leftAnchor, constant: 30).isActive = true
        tuesdayButton.topAnchor.constraint(equalTo: mondayButton.bottomAnchor, constant: 2).isActive = true
        tuesdayButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        tuesdayButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(tuesdayLabel)
        tuesdayLabel.leftAnchor.constraint(equalTo: tuesdayButton.rightAnchor, constant: 8).isActive = true
        tuesdayLabel.centerYAnchor.constraint(equalTo: tuesdayButton.centerYAnchor).isActive = true
        tuesdayLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tuesdayLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(wednesdayButton)
        wednesdayButton.leftAnchor.constraint(equalTo: labelAvailability.leftAnchor, constant: 30).isActive = true
        wednesdayButton.topAnchor.constraint(equalTo: tuesdayButton.bottomAnchor, constant: 2).isActive = true
        wednesdayButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        wednesdayButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(wednesdayLabel)
        wednesdayLabel.leftAnchor.constraint(equalTo: wednesdayButton.rightAnchor, constant: 8).isActive = true
        wednesdayLabel.centerYAnchor.constraint(equalTo: wednesdayButton.centerYAnchor).isActive = true
        wednesdayLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        wednesdayLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(thursdayButton)
        thursdayButton.leftAnchor.constraint(equalTo: labelAvailability.leftAnchor, constant: 30).isActive = true
        thursdayButton.topAnchor.constraint(equalTo: wednesdayButton.bottomAnchor, constant: 2).isActive = true
        thursdayButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        thursdayButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(thursdayLabel)
        thursdayLabel.leftAnchor.constraint(equalTo: thursdayButton.rightAnchor, constant: 8).isActive = true
        thursdayLabel.centerYAnchor.constraint(equalTo: thursdayButton.centerYAnchor).isActive = true
        thursdayLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        thursdayLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(fridayButton)
        fridayButton.leftAnchor.constraint(equalTo: labelAvailability.leftAnchor, constant: 30).isActive = true
        fridayButton.topAnchor.constraint(equalTo: thursdayButton.bottomAnchor, constant: 2).isActive = true
        fridayButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        fridayButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(fridayLabel)
        fridayLabel.leftAnchor.constraint(equalTo: fridayButton.rightAnchor, constant: 8).isActive = true
        fridayLabel.centerYAnchor.constraint(equalTo: fridayButton.centerYAnchor).isActive = true
        fridayLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        fridayLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(saturdayButton)
        saturdayButton.leftAnchor.constraint(equalTo: labelAvailability.leftAnchor, constant: 30).isActive = true
        saturdayButton.topAnchor.constraint(equalTo: fridayButton.bottomAnchor, constant: 2).isActive = true
        saturdayButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        saturdayButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(saturdayLabel)
        saturdayLabel.leftAnchor.constraint(equalTo: saturdayButton.rightAnchor, constant: 8).isActive = true
        saturdayLabel.centerYAnchor.constraint(equalTo: saturdayButton.centerYAnchor).isActive = true
        saturdayLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        saturdayLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(sundayButton)
        sundayButton.leftAnchor.constraint(equalTo: labelAvailability.leftAnchor, constant: 30).isActive = true
        sundayButton.topAnchor.constraint(equalTo: saturdayButton.bottomAnchor, constant: 2).isActive = true
        sundayButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sundayButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(sundayLabel)
        sundayLabel.leftAnchor.constraint(equalTo: sundayButton.rightAnchor, constant: 8).isActive = true
        sundayLabel.centerYAnchor.constraint(equalTo: sundayButton.centerYAnchor).isActive = true
        sundayLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        sundayLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    func collectAvailiability() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                if let userParkingID = dictionary["parkingID"] as? String {
                    let ref = Database.database().reference().child("parking").child(userParkingID).child("Availability")
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        if let availability = snapshot.value as? [String: AnyObject] {
                            
                            if let mondayValues = availability["Monday"] as? [String:AnyObject] {
                                Monday = 1
                                MondayTo = mondayValues["To"] as? String
                                MondayFrom = mondayValues["From"] as? String
                                
                                if MondayTo == "All day" || MondayFrom == "All day" {
                                    self.mondayLabel.text = "All day"
                                    self.mondayButton.backgroundColor = Theme.PRIMARY_COLOR
                                    self.mondayButton.setTitleColor(Theme.WHITE, for: .normal)
                                }
                                
                                self.mondayLabel.text = "From  \(String(describing: MondayFrom!))  to  \(String(describing: MondayTo!))"
                                self.mondayButton.backgroundColor = Theme.PRIMARY_COLOR
                                self.mondayButton.setTitleColor(Theme.WHITE, for: .normal)
                                
                            } else {
                                Monday = 0
                                
                                self.mondayButton.backgroundColor = UIColor.clear
                                self.mondayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
                                self.mondayLabel.text = "N/A"
                            }
                            if let tuesdayValues = availability["Tuesday"] as? [String:AnyObject] {
                                Tuesday = 1
                                TuesdayTo = tuesdayValues["To"] as? String
                                TuesdayFrom = tuesdayValues["From"] as? String
                                
                                if TuesdayTo == "All day" || TuesdayFrom == "All day" {
                                    self.tuesdayLabel.text = "All day"
                                    self.tuesdayButton.backgroundColor = Theme.PRIMARY_COLOR
                                    self.tuesdayButton.setTitleColor(Theme.WHITE, for: .normal)
                                }
                                
                                self.tuesdayLabel.text = "From  \(String(describing: TuesdayFrom!))  to  \(String(describing: TuesdayTo!))"
                                self.tuesdayButton.backgroundColor = Theme.PRIMARY_COLOR
                                self.tuesdayButton.setTitleColor(Theme.WHITE, for: .normal)
                                
                            } else {
                                Tuesday = 0
                                
                                self.tuesdayButton.backgroundColor = UIColor.clear
                                self.tuesdayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
                                self.tuesdayLabel.text = "N/A"
                            }
                            if let wednedayValues = availability["Wednesday"] as? [String:AnyObject] {
                                Wednesday = 1
                                WednesdayTo = wednedayValues["To"] as? String
                                WednesdayFrom = wednedayValues["From"] as? String
                                
                                if WednesdayTo == "All day" || WednesdayFrom == "All day" {
                                    self.wednesdayLabel.text = "All day"
                                    self.wednesdayButton.backgroundColor = Theme.PRIMARY_COLOR
                                    self.wednesdayButton.setTitleColor(Theme.WHITE, for: .normal)
                                }
                                
                                self.wednesdayLabel.text = "From  \(String(describing: WednesdayFrom!))  to  \(String(describing: WednesdayTo!))"
                                self.wednesdayButton.backgroundColor = Theme.PRIMARY_COLOR
                                self.wednesdayButton.setTitleColor(Theme.WHITE, for: .normal)
                                
                            } else {
                                Wednesday = 0
                                
                                self.wednesdayButton.backgroundColor = UIColor.clear
                                self.wednesdayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
                                self.wednesdayLabel.text = "N/A"
                            }
                            if let thursdayValues = availability["Thursday"] as? [String:AnyObject] {
                                Thursday = 1
                                ThursdayTo = thursdayValues["To"] as? String
                                ThursdayFrom = thursdayValues["From"] as? String
                                
                                if ThursdayTo == "All day" || ThursdayFrom == "All day" {
                                    self.thursdayLabel.text = "All day"
                                    self.thursdayButton.backgroundColor = Theme.PRIMARY_COLOR
                                    self.thursdayButton.setTitleColor(Theme.WHITE, for: .normal)
                                }
                                
                                self.thursdayLabel.text = "From  \(String(describing: ThursdayFrom!))  to  \(String(describing: ThursdayTo!))"
                                self.thursdayButton.backgroundColor = Theme.PRIMARY_COLOR
                                self.thursdayButton.setTitleColor(Theme.WHITE, for: .normal)
                                
                            } else {
                                Thursday = 0
                                
                                self.thursdayButton.backgroundColor = UIColor.clear
                                self.thursdayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
                                self.thursdayLabel.text = "N/A"
                            }
                            if let fridayValues = availability["Friday"] as? [String:AnyObject] {
                                Friday = 1
                                FridayTo = fridayValues["To"] as? String
                                FridayFrom = fridayValues["From"] as? String
                                
                                if FridayTo == "All day" || FridayFrom == "All day" {
                                    self.fridayLabel.text = "All day"
                                    self.fridayButton.backgroundColor = Theme.PRIMARY_COLOR
                                    self.fridayButton.setTitleColor(Theme.WHITE, for: .normal)
                                }
                                
                                self.fridayLabel.text = "From  \(String(describing: FridayFrom!))  to  \(String(describing: FridayTo!))"
                                self.fridayButton.backgroundColor = Theme.PRIMARY_COLOR
                                self.fridayButton.setTitleColor(Theme.WHITE, for: .normal)
                                
                            } else {
                                Friday = 0
                                
                                self.fridayButton.backgroundColor = UIColor.clear
                                self.fridayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
                                self.fridayLabel.text = "N/A"
                            }
                            if let saturdayValues = availability["Saturday"] as? [String:AnyObject] {
                                Saturday = 1
                                SaturdayTo = saturdayValues["To"] as? String
                                SaturdayFrom = saturdayValues["From"] as? String
                                
                                if SaturdayTo == "All day" || SaturdayFrom == "All day" {
                                    self.saturdayLabel.text = "All day"
                                    self.saturdayButton.backgroundColor = Theme.PRIMARY_COLOR
                                    self.saturdayButton.setTitleColor(Theme.WHITE, for: .normal)
                                }
                                
                                self.saturdayLabel.text = "From  \(String(describing: SaturdayFrom!))  to  \(String(describing: SaturdayTo!))"
                                self.saturdayButton.backgroundColor = Theme.PRIMARY_COLOR
                                self.saturdayButton.setTitleColor(Theme.WHITE, for: .normal)
                                
                            } else {
                                Saturday = 0
                                
                                self.saturdayButton.backgroundColor = UIColor.clear
                                self.saturdayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
                                self.saturdayLabel.text = "N/A"
                            }
                            if let sundayValues = availability["Sunday"] as? [String:AnyObject] {
                                Sunday = 1
                                SundayTo = sundayValues["To"] as? String
                                SundayFrom = sundayValues["From"] as? String
                                
                                if SundayTo == "All day" || SundayFrom == "All day" {
                                    self.sundayLabel.text = "All day"
                                    self.sundayButton.backgroundColor = Theme.PRIMARY_COLOR
                                    self.sundayButton.setTitleColor(Theme.WHITE, for: .normal)
                                }
                                
                                self.sundayLabel.text = "From  \(String(describing: SundayFrom!))  to  \(String(describing: SundayTo!))"
                                self.sundayButton.backgroundColor = Theme.PRIMARY_COLOR
                                self.sundayButton.setTitleColor(Theme.WHITE, for: .normal)
                                
                            } else {
                                Sunday = 0
                                
                                self.sundayButton.backgroundColor = UIColor.clear
                                self.sundayButton.setTitleColor(Theme.PRIMARY_COLOR, for: .normal)
                                self.sundayLabel.text = "N/A"
                            }
                        }
                    })
                }
            }
        }, withCancel: nil)
    }
    
    let labelAvailability: UILabel = {
        let label = UILabel()
        label.text = "Availability:"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var mondayButton: UIButton = {
        let monday = UIButton()
        monday.setTitle("M", for: .normal)
        monday.setTitleColor(Theme.WHITE, for: .normal)
        monday.backgroundColor = Theme.PRIMARY_COLOR
        monday.clipsToBounds = true
        monday.layer.cornerRadius = 15
        monday.translatesAutoresizingMaskIntoConstraints = false
        monday.isUserInteractionEnabled = false
        
        return monday
    }()
    
    var mondayLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    var tuesdayButton: UIButton = {
        let tuesday = UIButton()
        tuesday.setTitle("T", for: .normal)
        tuesday.setTitleColor(Theme.WHITE, for: .normal)
        tuesday.backgroundColor = Theme.PRIMARY_COLOR
        tuesday.clipsToBounds = true
        tuesday.layer.cornerRadius = 15
        tuesday.translatesAutoresizingMaskIntoConstraints = false
        tuesday.isUserInteractionEnabled = false
        
        return tuesday
    }()
    
    var tuesdayLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    var wednesdayButton: UIButton = {
        let wednesday = UIButton()
        wednesday.setTitle("W", for: .normal)
        wednesday.setTitleColor(Theme.WHITE, for: .normal)
        wednesday.backgroundColor = Theme.PRIMARY_COLOR
        wednesday.clipsToBounds = true
        wednesday.layer.cornerRadius = 15
        wednesday.translatesAutoresizingMaskIntoConstraints = false
        wednesday.isUserInteractionEnabled = false
        
        return wednesday
    }()
    
    var wednesdayLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    var thursdayButton: UIButton = {
        let thursday = UIButton()
        thursday.setTitle("T.", for: .normal)
        thursday.setTitleColor(Theme.WHITE, for: .normal)
        thursday.backgroundColor = Theme.PRIMARY_COLOR
        thursday.clipsToBounds = true
        thursday.layer.cornerRadius = 15
        thursday.translatesAutoresizingMaskIntoConstraints = false
        thursday.isUserInteractionEnabled = false
        
        return thursday
    }()
    
    var thursdayLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    var fridayButton: UIButton = {
        let friday = UIButton()
        friday.setTitle("F", for: .normal)
        friday.setTitleColor(Theme.WHITE, for: .normal)
        friday.backgroundColor = Theme.PRIMARY_COLOR
        friday.clipsToBounds = true
        friday.layer.cornerRadius = 15
        friday.translatesAutoresizingMaskIntoConstraints = false
        friday.isUserInteractionEnabled = false
        
        return friday
    }()
    
    var fridayLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    var saturdayButton: UIButton = {
        let saturday = UIButton()
        saturday.setTitle("S", for: .normal)
        saturday.setTitleColor(Theme.WHITE, for: .normal)
        saturday.backgroundColor = Theme.PRIMARY_COLOR
        saturday.clipsToBounds = true
        saturday.layer.cornerRadius = 15
        saturday.translatesAutoresizingMaskIntoConstraints = false
        saturday.isUserInteractionEnabled = false
        
        return saturday
    }()
    
    var saturdayLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    var sundayButton: UIButton = {
        let sunday = UIButton()
        sunday.setTitle("S.", for: .normal)
        sunday.setTitleColor(Theme.WHITE, for: .normal)
        sunday.backgroundColor = Theme.PRIMARY_COLOR
        sunday.clipsToBounds = true
        sunday.layer.cornerRadius = 15
        sunday.translatesAutoresizingMaskIntoConstraints = false
        sunday.isUserInteractionEnabled = false
        
        return sunday
    }()
    
    var sundayLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Theme.DARK_GRAY
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()


}
