//
//  TermsViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 7/23/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

class TermsViewController: UIViewController, UIScrollViewDelegate {
    
    var delegate: setupTermsControl?
    var delegateOptions: controlsAccountViews?
    
    var termsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.OFF_WHITE
        view.clipsToBounds = true
        view.alpha = 1
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    var blurBackgroundStartup: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = false
        blurView.alpha = 0.8
        
        return blurView
    }()
    
    var textView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.WHITE
        view.clipsToBounds = true
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    var terms: UILabel = {
        let label = UILabel()
        label.textColor = Theme.DARK_GRAY
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 500
        label.text = "Terms of Service"
        
        return label
    }()
    
    var accept: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Theme.PRIMARY_DARK_COLOR, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = Theme.PRIMARY_COLOR.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(agreeToTerms(sender:)), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTerms()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTerms() {
        
        self.view.addSubview(blurBackgroundStartup)
        blurBackgroundStartup.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blurBackgroundStartup.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        blurBackgroundStartup.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        blurBackgroundStartup.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.view.addSubview(termsContainer)
        termsContainer.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        termsContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        termsContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        termsContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        
        termsContainer.addSubview(terms)
        terms.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor).isActive = true
        terms.widthAnchor.constraint(equalTo: termsContainer.widthAnchor).isActive = true
        terms.centerYAnchor.constraint(equalTo: termsContainer.topAnchor, constant: 30).isActive = true
        terms.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        if Auth.auth().currentUser != nil {
            self.accept.setTitle("Ok", for: .normal)
        } else {
            self.accept.setTitle("Agree to Terms", for: .normal)
        }
        
        termsContainer.addSubview(accept)
        accept.centerXAnchor.constraint(equalTo: termsContainer.centerXAnchor).isActive = true
        accept.widthAnchor.constraint(equalTo: termsContainer.widthAnchor, constant: -80).isActive = true
        accept.centerYAnchor.constraint(equalTo: termsContainer.bottomAnchor, constant: -30).isActive = true
        accept.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        termsContainer.addSubview(textView)
        textView.delegate = self
        textView.leftAnchor.constraint(equalTo: termsContainer.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: termsContainer.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: termsContainer.topAnchor, constant: 60).isActive = true
        textView.bottomAnchor.constraint(equalTo: termsContainer.bottomAnchor, constant: -60).isActive = true
        textView.contentSize = CGSize(width: self.view.frame.width-40, height: 10500)
        
        textView.addSubview(agreement)
        agreement.topAnchor.constraint(equalTo: textView.topAnchor, constant: 10).isActive = true
        agreement.leftAnchor.constraint(equalTo: termsContainer.leftAnchor, constant: 10).isActive = true
        agreement.rightAnchor.constraint(equalTo: termsContainer.rightAnchor, constant: -10).isActive = true
        agreement.sizeToFit()
        
        textView.addSubview(agreement2)
        agreement2.topAnchor.constraint(equalTo: agreement.bottomAnchor).isActive = true
        agreement2.leftAnchor.constraint(equalTo: termsContainer.leftAnchor, constant: 10).isActive = true
        agreement2.rightAnchor.constraint(equalTo: termsContainer.rightAnchor, constant: -10).isActive = true
        agreement2.sizeToFit()
        
    }
    
    @objc func agreeToTerms(sender: UIButton) {
        if Auth.auth().currentUser != nil {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.alpha = 0
            }) { (success) in
                self.delegateOptions?.removeOptionsFromView()
            }
        } else {
            self.delegate?.agreeToTerms()
        }
    }
    
    var agreement: UILabel = {
        let label = UILabel()
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.textAlignment = .left
        label.contentMode = .topLeft
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.numberOfLines = 620
        label.text = """
        Terms and Conditions DriveWayz LLC.
        
        DriveWayz provides and online platform which has the sole purpose of enabling vehicle owners (“Drivers”) and parking space holders (“Hosts”) to list, reserve, and rent parking space from one another.
        
        This set of DriveWayz Terms & Conditions (this “Terms & Conditions”) applies to any and all use of (1) the DriveWayz website at (_____) and all affiliated websites owned and operated solely by DriveWayz (collectively, the DriveWayz LLC.”), (2) the parking reservation services made available by DriveWayz through the DriveWayz Mobile Apps (collectively, DriveWayz Mobile App) any DriveWayz-branded application for your mobile or other device, and any other online properties of DriveWayz or third parties, as described in Part I below (the “Reservation Services”), and (3) any other services or features made available by DriveWayz through the DriveWayz Site or any DriveWayz Mobile Application. Together, the items in (1) through (3) are referred to herein as the “Services”.
        
        In this Terms & Conditions, “DriveWayz” and “we” mean DriveWayz LLC., a Colorado limited liability corporation, and/or “User” and “you” mean any user of the Services. This Terms & Conditions incorporates DriveWayz standard policies, procedures, and terms and conditions for use of the Services that are referenced by name or by links in this Terms & Conditions (collectively, the “DriveWayz Policies”).
        
        By accessing or using the Services or clicking “accept” or “agree” to this Terms & Conditions, (1) you acknowledge that you have read, understand and agree to be bound by this Terms & Conditions, and (2) you represent and warrant that you are at least eighteen (18) years old and are not prohibited by law from accessing or using the Services. THIS TERMS & CONDITIONS CONTAINS, AMONG OTHER THINGS, LIABILITY AND INDEMNITY PROVISIONS AND AN ARBITRATION PROVISION CONTAINING A CLASS ACTION WAIVER.
        
        DriveWayz may update or revise this Terms & Conditions (including any DriveWayz Policies) from time to time without ay prior notice to User. You agree that you will review this Terms & Conditions periodically. You are free to decide whether or not to accept a modified version of this Terms & Conditions, but accepting this Terms & Conditions, as modified, is required for you to continue using the Services. [You may have to click “accept” or “agree” to show you acceptance of any modified version of this Terms & Conditions.] If you do not agree to the terms of this Terms & Conditions or any modified version of this Terms & Conditions, your sole recourse is to immediately terminate your use of the Services, in which case you will no longer have access to your Account (as defined below). Except as otherwise expressly stated by DriveWayz, any use of the Services (e.g., to use the Reservation Services) is subject to the version of this Terms & Conditions in effect at the time of use.
        
        Key Definitions
        
        “User”
        Any individual who is in contact with the Services, whether registered or not. All Users are bound by these Terms and Conditions whether registered or not.
        “Registered User”
        Any individual who has contacted the Services, provided the required information and completed the steps necessary to create an account.
        
        “Driver”
        Any registered User who uses the Services to seek parking space, request to utilize parking space, or complete an exchange of funds with DriveWayz or a Host for use of property.
        
        “Listing”
        A property which has been input into the Services and offered by a Host for Drivers to utilize.
        
        “Reservation”
        An agreement between a Host and Driver to utilize a Host's offered Listing for a period of time, and the period of time during which a User’s vehicle is physically present on another User’s property as authorized by the agreement between Host and Driver.
        
        “Reservation Services”
        The Reservation Services are defined as all tools and features provided to Users for the purposes of searching for, browsing, comparing, requesting or reserving parking spaces listed by other DriveWayz  users as well as those tools/features provided for the purposes of managing, facilitating, editing and carrying out reservations, including payment processing, coupon redemption, messaging between users, archiving and tracking of past reservations and reservation activity for the purposes of granting User statuses or conducting loyalty programs, rating and reviewing of other users and their provided spaces and publishing of these ratings and reviews for use by other users, favorite listings, managing of vehicles and payment methods.
        
        “Host Services”
        The Host Services are defined as all tools and features provided to Users for the purposes of listing and offering property for rent to other DriveWayz Users for temporary vehicle parking. The Host Services includes all tools/features provided for the purposes of managing and editing listing details and listing availability as well as all tools/features provided for the purposes of managing, facilitating, editing and carrying out reservations including payment processing and payout/distribution of funds to hosts, messaging between users, archiving and tracking of past reservations and reservation requests, tracking of Host activity and Host performance for the purpose of granting Host statuses, rating of Drivers publishing of these ratings for use by other users, managing of payment methods.
        
        Part I- Driver Reservation Services
        1.    Space Reservation. DriveWayz provides the Reservation Services to the Users for the sole purposes of providing Users information on the location and apparent availability of parking and assisting them in securing parking at participating third-party parking locations, including but not limited to private driveways, private parking spaces, and private parking lots. In response to a User’s online request for a reservation through the DriveWayz Application, User communicates directly with the applicable individual holding/operating said space (the Host of the Listing) regarding said reservation request. The availability of reservations is determined at the time of the User’s query, and DriveWayz makes no representation or warranty (i) regarding the accuracy of any date (including, but not limited to, reservation availability data) received from any Host. Each Host is an independent third party and is not under the control of DriveWayz. DriveWayz is not a guarantor, agent, or otherwise affiliated with any Host. You acknowledge that each Host may have its own policies, terms, and conditions. Once a reservation request is made by a User through the DriveWayz Application, the Host with such space will provide confirmation of the Reservation to such User by pre-authorizing the Services to auto accept all reservation requests within specified hours and specified days, or by manual approval at the time of request. By using the Reservation Services, you agree to receive reservation confirmations by DriveWayz messaging after requesting a Reservation Service. You may terminate your registration at any time by selecting to do so on the DriveWayz application.
        
        In furtherance of (and not in any limitation of) the above, you hereby acknowledge and agree that notwithstanding the assistance that the Reservation Services provide to you in locating and reserving parking, the ultimate decision to utilize the parking information provided by the Reservation Services and to park at any location remains yours and yours alone, and you hereby agree to assume any risk inherent in utilizing the Reservation Services and/or deciding to actually park at any location. For the avoidance of doubt, DriveWayz does not in any way provide parking services or any kind or operate any parking locations. FURTHER, DRIVEWAYZ ASSUMES NO RESPONSIBILITY OR LIABILITY FOR 1) THE SAFETY OF ANY PERSON, PROPERTY, OR VEHICLE PARKED AT ANY LOCATION OR 2) THE ACTUAL AVAILABILITY OF PARKING AT ANY LOCATION. USE OF, OR A RESERVATION THROUGH, ANY DriveWayz APPLICATION WILL IN NO WAY BE CONSIDERED A WARRANTY, GUARANTEE, OR OTHER REPRESENTATION THAT A SPECIFIC PARKING SPACE IS AVAILABLE AT ANY LOCATION AT ANY GIVEN TIME. DriveWayz DISCLAIMS ANY AND ALL LIABILITY FOR DAMAGES, DELAYS, OR OTHER CONSEQUENCES THAT MAY ARISE IF A PARKING SPACE IS UNAVAILABLE, OR IF A DriveWayz APPLICATION OTHERWISE ERRS OR MALFUNCTIONS.
        
        2.    Calculation of Parking Rates; Payment Authorization; Taxes. You acknowledge that DriveWayz does not determine parking rates with Hosts to facilitate the booking of Reservations. The parking rate displayed on the DriveWayz Site or DriveWayz Application is determined solely by the Host and DriveWayz fees are in direct relation the price set by the Host. You agree to pay in full the price displayed on the Services for the total reservation price, which includes the parking rate plus, where applicable, service fees, and taxes at the time of your reservation request.
        
        All Reservations and other transactions consummated through the DriveWayz Site or a DriveWayz Application will be turned over to the relevant Host, and thereafter, a User may be required to enter into a separate agreement with that relevant Host. You acknowledge and confirm that you are authorized and permitted to use any credit card that you register on the DriveWayz Site or a DriveWayz Application. When you fund a transaction, you agree that DriveWayz is not in any way responsible or liable for the transaction. You acknowledge that DriveWayz does not collect taxes for remittance to applicable taxing authorities. The Hosts are solely responsible for remitting applicable taxes to the applicable taxing jurisdictions.
        
        3.    Prices. The price of a parking reservation will be determined by the Host with the legal right to reserve said private location. Prices at each private location may change from time to time and at any time, but any such changes will not affect bookings already accepted by a DriveWayz Application. Despite DriveWayz best efforts, some of the parking listed on the Services may be incorrectly priced. DriveWayz is under no obligation to fulfill a Reservation, even after you have been sent confirmation of your Reservation. We do not guarantee that pricing for Reservations will be the best available at the time of reservation or reservation request.
        4.    Privacy Policy. DriveWayz is committed to helping you safeguard your privacy online. Each User must review our DriveWayz Privacy Policy for details about how we collect and use information about the use of DriveWayz Services. The DriveWayz Privacy Policy is expressly incorporated herein by reference.
        5.    Usage Guidelines. User agrees to use the Reservation Services only to book Reservations for User’s own use. Resale or attempted resale of Reservations is grounds for, among other things, cancellation of your Reservations and termination of your access to the Services. DriveWayz expressly reserves all its rights and remedies under applicable state and federal laws. DriveWayz reserves the right, in its sole discretion, to refuse service, terminate User accounts, remove or edit content, or cancel Reservations. User also agrees not to contact or attempt to contact Hosts by means other than the Services with intent to conduct a rental transaction for a property listed with the Services. You also agree not to use the Services to solicit or offer other users goods or services of any kind beyond reserving and renting parking spaces.
        6.    Cancellations and Violations. By requesting a Reservation, you are agreeing to pay the rate published at that time for the requested period. If you later choose to cancel the Reservation, you agree to be subject to the DriveWayz Cancellation Policy which is subject to change without notice. You may also receive penalties for failure to remove your vehicle from a Host’s property by the end of the reservation period. Penalties for cancellation or failure to vacate a property at the agreed upon time may include but are not limited to, cash fines to be paid immediately, account suspensions, and negative reviews posted publicly on the Services in association with your account, which will inform and warn other Users of your cancellation or failure to vacate at the agreed upon time. By registering your payment information with the Services, you agree to allow DriveWayz to automatically charge in accordance with these policies. The fees and fines charged may vary. The DriveWayz Cancellation Policy is expressly incorporated herein by reference.
        7.    Damage to Person or Property. By consenting to this Terms & Conditions you acknowledge that when you enter into a rental agreement with a Host you are choosing enter the property offered by the Host for parking at your own discretion. By agreeing to these terms, you acknowledge that DriveWayz is not the owner or operator of any property available for rent via the Services and is not responsible for any damage or loss to property or person that may occur while you are on the Host’s property or engaged in a Reservation with the Host. All parking transactions are entered into at your own risk. We cannot and do not guarantee in any way the security of your vehicle or its contents. It is your responsibility to ensure that your vehicle is properly secured. If your vehicle is damaged while on a Host’s property, you agree to first attempt to resolve the matter with the Host. If the matter cannot be resolved through direct contact with the Host, you may contact DriveWayz customer service to record your case so that we can assess the situation and offer recourse where DriveWayz, in its sole discretion, deems such necessary. If your vehicle is stolen, contact the police and your insurance provider immediately. DriveWayz does not provide any insurance coverage to a User at any time.
        
        Part II- Host Services
        8.    Appointment as Agent. By creating a Listing in the Services and becoming a Host, you appoint DriveWayz as your agent for the purposes of connecting your offered space with Drivers in need of parking services and forming binding agreements between you and Drivers using the Services. You also appoint as your agent for the collection and distribution of your rental fees and you agree to pay a fee to DriveWayz for every rental transaction for these services.
        9.    Legal Right to Rent Property. DriveWayz provides tools and features that enable Hosts to list and rent their property for parking use. By using the Services to list an available parking space for rent, you are attesting that you are the legal owner/operator of the property being offered or have obtained the right to rent out the property. It is your responsibility to be aware of and abide by all local laws, codes, or HOA and neighborhood policies. DriveWayz is no way responsible for any repercussions stemming from your failure to make yourself aware of and abide by your local laws and regulations.
        10.    Honoring of reservations, Cancellations & Penalties. All Hosts will have the opportunity to approve or decline reservation requests from Users (whether manually at the time of request or by pre-authorizing DriveWayz to automatically approve all requests for the period of the time that the listing is available). Once you have approved a reservation request, you must honor the request. If you choose to cancel an approved request you agree to be subject to the DriveWayz Cancellation Policy which is subject to change at DriveWayz sole discretion. You also agree that DriveWayz may assess penalties for failure to deliver a reserved parking space to another User. Penalties may include but are not limited to, cash fines to be paid immediately or taken from your future earnings until paid in full, account suspensions and negative reviews posted publicly on the Services in association with your account, which will inform and warn other Users of your cancellation or failure to deliver a reserved parking space. By registering your payment information with the Services, you agree to allow DriveWayz to automatically charge you in accordance with these policies. The fees and fines charged may vary.
        11.    Host Service Fees. By listing your property with the Services you agree to pay a portion of the gross parking cost to DriveWayz as a service fee for all completed transactions. DriveWayz may change its fees or fee structure at any time without notice.
        12.    Usage Guidelines. As a Host you agree not to contact or attempt to contact Drivers with intent to conduct a rental transaction in relation to a property that you have listed with the Services by means other than the Services. You also agree not to use the Services to solicit or offer other Users goods or services of any kind beyond reservation and rental of parking spaces.
        13.    Damage to Person or Property. By consenting to this Terms & Conditions you acknowledge that when you enter into a rental agreement with a Driver you are voluntarily granting the renting party consent to enter your property or a property which you have been licensed to operate. Wherever possible DriveWayz will take steps to ensure that users and their property are safe from damage or harm, but by agreeing to these terms, you acknowledge that DriveWayz is not responsible for any damage or loss to property or person that may occur while DriveWayz users are on your property or engaged in a parking reservation with you. All parking transactions are entered into at your own risk. We cannot and do not guarantee in any way the security or safety of your property. It is your responsibility to ensure that your property is properly secured. If your property is damaged by another DriveWayz user, you agree to first attempt to resolve the matter with the user. If the matter cannot be resolved through direct contact with the user, you may contact DriveWayz Customer service to record your case so that we can assess the situation and offer recourse where possible and where we deem necessary. DriveWayz does not provide any insurance coverage to any User at any time. You are solely responsible for obtaining the required insurance coverage necessary to rent out your property for use by others.
        
        Part III- Terms for All Services
        14.    Access to the Services. At the present the Services are free to access, but in order to access a majority of the features offered in the Services, you will be required to submit basic personal information.
        15.    Your Account. You are required to create an account with DriveWayz through the DriveWayz Site or DriveWayz Application (“Account”) in order to use the Reservation Services. You are not permitted to register or maintain more than one (1) Account. We reserve the right to suspend or delete your Accounts if we believe that you are maintaining multiple Accounts or believe that you have breached this Terms & Conditions in any way. When registering an Account, you must provide true, accurate, current and complete data about yourself on the DriveWayz registration form. You agree that you will not falsify any information about your identity, or impersonate another identity, or create an account with a fictitious identity. You also agree to promptly update your Account data to keep it true, accurate, current, and complete. You are solely responsible for maintaining the confidentiality of your Account and the information in your Account, and you are solely responsible for all use of your Account. You agree to immediately notify DriveWayz of any unauthorized use of your Account or any other breach of security related to your use of the Services. DriveWayz will not be liable for any misuse or unauthorized access to any User’s Account.
        16.    Communications from DriveWayz. By accepting this Terms & Conditions you agree to receive communications from DriveWayz and the Services. The DriveWayz Applications may use GPS locator capabilities to identify your location at the time of use. DriveWayz may send you SMS text messages to provide you information regarding the Services or as otherwise described in our DriveWayz Privacy Policy. You hereby consent to receiving such SMS text messages and are responsible for any associated charges from your cellular provider. The communication standards for the Services include, but are not limited to: Email, SMS, in-app messaging, and web-based browser technology. In order to use the DriveWayz Applications, you must maintain an active account with a carrier of electronic communications through mobile devices and you may not use a prepaid cellular phone to access the Services.
        17.     User-Generated Content. The Services provide a platform for Users to create and publish content of their creation. By publishing and displaying content of any kind on the DriveWayz Site or through the DriveWayz Applications you thereby assign and transfer copyright, and all other rights to such content, to DriveWayz. For the avoidance of doubt we are permitted to use any content posted by you to the Services for any of our business purposes. This right will still apply after the termination of your registration or membership. You may not use the Services for any unlawful purpose or any purpose that violates any local policies, or to publish any content that may, at DriveWayz sole discretion, be deemed offensive, inaccurate, misleading, defamatory, fraudulent, or illegal. Users are not entitled to publish any content that could be construed as an advertisement or offer for anything other than parking spaces that fall within this set of Terms & Conditions. DriveWayz reserves the right to remove any content from the Services at any time at our sole discretion and without notice.
        18.    Promotional Uses. By accepting these Terms & Conditions you agree to allow DriveWayz to use any of your quotes, photos or videos pertaining to DriveWayz, including images and videos of you, as part of DriveWayz media and promotional outreach.
        19.    Complaints and Disputes Between Users. In the case of a dispute between you and another User, you agree that you will first attempt to resolve the matter through direct communication, through the Services, with the User. In the event that the dispute cannot be resolved through direct communication, you may file a support ticket and request that DriveWayz assist in resolving the matter. By doing so you authorize DriveWayz to deal with the dispute or complaint as we deem appropriate. You also authorize us to use any and all funds we, or our merchant partners, may be holding on your behalf to resolves the matter.
        20.    Referral programs and promotional offers. DriveWayz may choose to offer limited-time promotional offers or referral rewards programs. In order to be eligible for referral rewards, the Users referred by you must be brand new unregistered Users of the Services. They must also use the exact code given them by you to redeem an introductory offer or must sign up using the email or phone number with which you invited them. They must also complete a transaction as a Host or Driver before you can be eligible to receive rewards. The rewards offered may be changed by DriveWayz at any time without notice. All promotional offers, coupon codes, introductory offers, account credits, or rewards may be changed, revoked, denied, or cancelled at any time without any notice and at DriveWayz discretion, whether already granted to the User or not yet accrued.
        21.    DriveWayz Promo Code Terms and Conditions. Any DriveWayz promotional code or coupon in any form (the “Code”) issued by DriveWayz is subject to the following terms and conditions (“Promo Terms”). Your receipt and/or redemption of the Code constitute acceptance of and agreement with these Promo Terms. Other terms and conditions may apply to use of the DriveWayz Services. Specifically, without limitation, access to and use of the Service is subject to the DriveWayz Terms & Conditions. The Code is only redeemable on the Services. A Code can be used only once and only one Code may be used per transaction. Codes are void if not obtained through authorized, legitimate channels, or if any part of the code is altered, duplicated, forged, counterfeited, or tampered with in any way or do not contain proper security devices (a “nonconforming Code”). Any attempt to obtain or generate multiple Codes and/or nonconforming Codes and/or to use multiple names, email addresses, phone numbers, and/or any fraudulent or other non-permissible means to obtain or use Codes, as determined by DriveWayz in its sole discretion, will give DriveWayz the right to void the Code and disqualify the user. The Code has no cash value, and cannot be exchanged for cash or credit, except as required by law (in which case the value of the Code is deemed $0.001). The Code cannot be bought or sold and is void if sold or exchanged for compensation. Any unused value will be forfeited. Codes cannot be used for past purchases of Services or offers. Codes are void where prohibited by law. If a Code is used in violation of these Terms, or if your use of the Code with the Services otherwise violates the Terms & Conditions, DriveWayz reserves the right to (a) cancel any transaction on the Services; (b) void the value of the Code; and/or (c) charge your credit card for the full value of the Services ordered without the Code applied. DRIVEWAYZ AND ITS RESPECTIVE OFFICERS, DIRECTORS, EMPLOYEES, AND AGENTS MAKE NO WARRANTY, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE WITH RESPECT TO ANY CODE. YOU HEREBY RELEASE DriveWayz AND ITS RESPECTIVE OFFICERS, DIRECTORS, EMPLOYEES, AND AGENTS, FROM AND AGAINST ANY AND ALL LIABILITY RELATING TO THESE PROMO TERMS OR THE CODE.
        22.    Technical Requirements. Use of the Services requires Internet access through your computer or mobile device. You are responsible for all mobile carrier charges resulting from your use of the services, including from any notifications provided by the Services. DriveWayz does not guarantee that the Services will be compatible with all devices or will be supported by all mobile carries. The user interface and functionality may not be the same across all platforms and devices. Your access to the Services may occasionally be restricted or blocked to allow for repairs, maintenance, or the introduction of new features. In these cases, DriveWayz will attempt to restore all functions in as reasonable a time frame as possible. Any such interruptions to the Services shall not constitute a breach of these terms by DriveWayz. DriveWayz will not be responsible for any failure or inability to make good on an agreement between yourself and another User caused by a technical difficulty, connection or communication issue, or any interruption of the Services.
        23.    Modifications to Services. DriveWayz reserves the right, in its sole discretion, to modify the Services from time to time and without any prior notice to User, including, without limitation, removing, adding, or modifying portions of the DriveWayz Site, DriveWayz Applications, and/or availability of certain Listings. DriveWayz shall have no liability to you for any of the foregoing actions. If you object to any such changes, your sole recourse shall be to immediately cease using the Services. Continued use of the Services following any such changes shall indicate your acknowledgment of, and consent to, such changes and satisfaction with all the Services.
        24.     Intellectual Property Rights and Grant of Rights to User. The features, information, and materials provided and depicted through the Services and on the DriveWayz Site and DriveWayz Application are protected by copyright, trademark, patent and other intellectual property laws, and are the sole property of DriveWayz. All text, graphical content, video, data, and other content made available through the Services (collectively, the “DriveWayz Content”) are provided to User by DriveWayz or its partners or licensors solely to support User’s permitted use of the Services. The DriveWayz Content may be modified from time to time by DriveWayz in its sole discretion and without notice to User. Except as expressly set forth herein, no license, right, or interest is granted to User for any other purpose, and any other use of the Services or the DriveWayz Content by User shall constitute a material breach of this Terms & Conditions. DriveWayz and its partners or licensors retain all rights in and to the Services, DriveWayz Content, and any associated patents, trademarks, copyrights, mask work rights, trade secrets, or other intellectual property rights.
        25.    Application License. Subject explicitly to the terms and conditions of this Terms & Conditions, DriveWayz grants User a non-exclusive, non-transferable, revocable license to use the DriveWayz Applications, in object code form only, on User’s compatible devices, solely to facilitate User’s permitted use of the Services. Users grant to DriveWayz a perpetual, royalty free, worldwide license to any improvement to or created from, or derivative works based on the Services.
        26.    Use Restrictions. The Services and DriveWayz Content are offered solely for User’s personal use for the purposes described in this Terms & Conditions. Any and all other uses are prohibited. You agree not to (and not to allow any third party to): (a) use any robot, spider, scraper, or other automatic or manual device, process, or means to access the Services or copy any DriveWayz Content except as expressly authorized by DriveWayz; (b) take any action that imposes or may impose (in DriveWayz sole determination) an unreasonable or a disproportionately large load on the Services or DriveWayz infrastructure; (c) utilize any device, software, or routine that will interfere or attempt to interfere with the functionality of the Services; (d) rent, lease, copy, provide access to, or sublicense any portion of the Services or DriveWayz Content to a third party; (e) use any portion of the Services or DriveWayz Content to provide, or incorporate any portion of the Services or DriveWayz Content into, any product or service provided to a third party; (f) reverse engineer, decompile, disassemble, or otherwise seek to obtain the source code or non-public APIs to the Services, except to the extent expressly permitted by applicable law (and then only with advance notice to DriveWayz); (g) modify any Services or DriveWayz Content or create any derivative product from any of the foregoing; (h) remove or obscure any proprietary or other notices contained in the Services or DriveWayz Content; (i) use the Services or DriveWayz Content for any illegal purpose; or (j) publicly disseminate information regarding the performance of the Services or DriveWayz Content or access or use the Services or DriveWayz Content for competitive analysis or benchmarking purposes.
        27.    Do Not Use While Driving. You agree, represent, and warrant, so long as you use or access the Services YOU WILL NOT, UNDER ANY CIRCUMSTANCES, ACCESS, VIEW, OR USE THE SERVICES WHILE DRIVING OR OTHERWISE OPERATING A VEHICLE OF ANY KIND (including, without limitation, a car, truck, motorcycle, motor scooter, or bicycle) or operating any dangerous equipment or machinery. You understand that using any handheld device in these circumstances is extremely dangerous, and can result in property damage, physical injuries (including dismemberment), or death. You further agree, represent and warrant, that you will not use or access the Services in any manner that places yourself or any other person at risk of injury, and that you will abide by all traffic laws. While effort is made to assure the accuracy of the information presented to the User, the User is solely responsible for safe driving and for the consequences of decisions as to where to travel, drive, or park. Under no circumstance will any of the DriveWayz Parties (as defined below) assume any responsibility or liability for the consequences of driving decisions made by Users. You agree that no DriveWayz Party shall be liable for any driving decisions made by you or at your suggestion, or for any damages, injury, or other harm caused by your use of or accessing the Services or DriveWayz Content while driving, operating equipment or machinery, or otherwise in a dangerous and unsuitable manner, and you hereby waive any claims or causes of action you may have, now or in the future, arising from or relating to the same. IN THE EVENT THAT ANY PARTY NAMES ANY DriveWayz PARTY AS A DEFENDANT IN A CASE INVOLVING YOUR USE OF THE SERVICES WHILE OPERATING A VEHICLE, YOU AGREE TO INDEMNIFY AND HOLD ANY SUCH DriveWayz PARTY HARMLESS IN SUCH ACTION.
        28.    Export Control. You may not use, export, or re-export any of the DriveWayz Applications, DriveWayz Content, or other aspects of the Services (or any copy or adaptation of the foregoing) in violation of applicable law, including, without limitation, United States and foreign export laws and regulations. You represent and warrant that you are not located in a country that is subject to a U.S. Government embargo or that has been designated by the U.S. Government as a “terrorist supporting” country and that you are not listed on any U.S. Government list of prohibited or restricted parties.
        29.    Termination. DriveWayz may suspend your ability to use all or any element of the Services or may terminate this Terms & Conditions effective immediately, without any notice or explanation. Without limiting the foregoing, DriveWayz may suspend your access to the Services if we believe you to be in violation of any part of this Terms & Conditions (including any associated DriveWayz Policies). After any suspension or termination, you may or may not be granted permission to re-establish an Account, and you may lose access to and be unable to use any points accumulated towards any rewards program (if any) in effect at the time. You agree that DriveWayz shall not be liable to you for any termination of this Terms & Conditions or for any effects of any termination of this Terms & Conditions. You are always free to discontinue your use of the Services at any time. You understand that any termination of your Account may involve deletion of any content you stored in your Account for which DriveWayz will have no liability whatsoever.
        
        """
        
        return label
    }()
    
    var agreement2: UILabel = {
        let label = UILabel()
        label.textColor = Theme.DARK_GRAY.withAlphaComponent(0.7)
        label.textAlignment = .left
        label.contentMode = .topLeft
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.numberOfLines = 400
        label.text = """
        
        30.     Reviews, Comments, Communications and Other Content. We appreciate hearing from you. The Services may permit you to submit reviews, comments, and ratings; send emails and other communications; and submit suggestions, ideas, comments, questions, or other information for publication and distribution to Users and other third parties (“User Content”). You are solely responsible for all User Content you generate (and for your Account generally). Any such User Content must not be illegal, malicious, threatening, obscene, racist, defamatory, libelous, pornographic, infringing of intellectual property rights, promoting of illegal activity or harm to groups and/or individuals, invasive of privacy, false, inaccurate, or otherwise injurious to third parties (including, but not limited to, any content that is copyrighted or subject to third party proprietary rights, including privacy, publicity, trade secret, etc., unless you are the owner of such rights or have the appropriate permission for their rightful owner to specifically submit such content), or otherwise objectionable, and must not consist of or contain software, computer viruses, commercial solicitation, political campaigning, chain letters, mass mailings, any form of “spam” or references to illegal activity, malpractice, purposeful overcharging, false advertising, or health code violations (e.g., foreign objects in food, food poisoning, etc.). You may not use a false email address, impersonate any person or entity, or otherwise mislead as to the origin of User Content. DriveWayz reserves the right (but has no obligation) to monitor, remove, or edit User Content in DriveWayz sole discretion, including if the User Content violates this Terms & Conditions (including any associated DriveWayz Policies), but you acknowledge that DriveWayz may not regularly review submitted User Content. If you do submit User Content, please be aware that unless we indicate otherwise, you grant DriveWayz a nonexclusive, perpetual, royaltyfree, irrevocable, and fully transferable right to use, modify, reproduce, adapt, translate, publish, create derivative works from, distribute, display, and otherwise exploit such content throughout the world in any media. DriveWayz takes no responsibility and assumes no liability for any User Content submitted by you or any other User or third party. You agree to indemnify and hold any DriveWayz Party harmless in the event DriveWayz is named as a defendant in an action related to your User Content and you hereby affirm that we have the right to determine whether any of your User Content submissions are appropriate and comply with this Terms & Conditions, to remove any and/or all of your submissions, and to terminate your Account with or without prior notice. You understand and agree that any liability, loss, or damage that occurs as a result of any of the use of any User Content that you make available or access through your use of the Services is solely your responsibility. DriveWayz is not responsible for any public display or misuse of any User Content. DriveWayz does not, and cannot, pre-screen or monitor all User Content; however, at our discretion, we, or technology or agents we employ, may monitor and/or record your interactions with the Services and your submission(s) of User Content.
        31.    Liability Limitations. TO THE MAXIMUM EXTENT PERMITTED BY LAW, EXCEPT AS EXPRESSLY SPECIFIED BELOW WITH RESPECT TO DRIVEWAYZ GIFT CARDS AND MERCHANT GIFT CARDS, IN NO EVENT SHALL THE DriveWayz PARTIES BE LIABLE FOR ANY INJURIES, LOSSES, CLAIMS, OR DIRECT DAMAGES OR ANY SPECIAL, EXEMPLARY, PUNITIVE, INCIDENTAL, OR CONSEQUENTIAL DAMAGES OF ANY KIND, WHETHER BASED IN CONTRACT, TORT, OR OTHERWISE, AND EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES, WHICH ARISE OUT OF OR ARE ANY WAY CONNECTED WITH (A) THIS TERMS & CONDITIONS; (B) ANY USE OF THE SERVICES, THE DRIVEWAYZ CONTENT OR THE USER CONTENT; (C) ANY FAILURE OR DELAY (INCLUDING, BUT NOT LIMITED TO, THE USE OR INABILITY TO USE ANY COMPONENT OF THE RESERVATION SERVICES); OR (D) YOUR VISIT TO ANY PARKING LOCATION OR THE PERFORMANCE, NON-PERFORMANCE, CONDUCT, OR POLICIES OF ANY HOLDER OR MERCHANT IN CONNECTION WITH THE SERVICES. IN ADDITION, YOU SPECIFICALLY UNDERSTAND AND AGREE THAT ANY THIRD PARTY DIRECTING YOU TO THE DRIVEWAYZ SITE OR PACEMINT APPLICATIONS BY REFERRAL, LINK, OR ANY OTHER MEANS IS NOT LIABLE TO USER FOR ANY REASON WHATSOEVER, INCLUDING, BUT NOT LIMITED TO, DAMAGES OR LOSS ASSOCIATED WITH THE USE OF THE SERVICES OR THE DRIVEWAYZ CONTENT. DRIVEWAYZ IS NEITHER AN AGENT OF NOR OTHERWISE ASSOCIATED WITH ANY HOST FOR WHICH A USER HAS MADE A RESERVATION OR UTILIZES ANY COUPON.
        32.     Disclaimer of Warranties. THE SERVICES, ALL DRIVEWAYZ CONTENT, AND ANY OTHER INFORMATION, PRODUCTS, AND MATERIALS CONTAINED IN OR ACCESSED THROUGH THE SERVICES, ARE PROVIDED TO USER ON AN “AS IS” BASIS AND WITHOUT WARRANTY OF ANY KIND. DRIVEWAYZ EXPRESSLY DISCLAIMS ALL REPRESENTATIONS, WARRANTIES, CONDITIONS, OR INDEMNITIES, EXPRESS OR IMPLIED, INCLUDING, WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, OR NON-INFRINGEMENT, OR ANY WARRANTY ARISING FROM A COURSE OF DEALING, PERFORMANCE OR TRADE USAGE. DRIVEWAYZ DOES NOT WARRANT THAT YOUR USE OF THE SERVICES WILL BE UNINTERRUPTED OR ERROR-FREE, THAT DRIVEWAYZ WILL REVIEW THE INFORMATION OR MATERIALS MADE AVAILABLE THROUGH THE SERVICES FOR ACCURACY, THAT IT WILL PRESERVE OR MAINTAIN ANY SUCH INFORMATION OR MATERIALS WITHOUT LOSS, OR THAT DRIVEWAYZ WILL REVIEW AND POLICE THE USER CONTENT. DRIVEWAYZ SHALL NOT BE LIABLE FOR DELAYS, INTERRUPTIONS, VIRUSES CONTAINED IN ANY USER CONTENT, THE DRIVEWAYZ SITE, DRIVEWAYZ APPLICATION OR ANY DRIVEWAYZ COMMUNICATION, SERVICE FAILURES OR OTHER PROBLEMS INHERENT IN USE OF THE INTERNET AND ELECTRONIC COMMUNICATIONS OR OTHER SYSTEMS OUTSIDE THE REASONABLE CONTROL OF DRIVEWAYZ.
        
        THE FOREGOING DISCLAIMERS APPLY TO THE MAXIMUM EXTENT PERMITTED BY LAW. YOU MAY HAVE OTHER STATUTORY RIGHTS. HOWEVER, THE DURATION OF STATUTORILY REQUIRED WARRANTIES, IF ANY, SHALL BE LIMITED TO THE MAXIMUM EXTENT PERMITTED BY LAW.
        
        33.    Release. Hosts are solely responsible for their interactions with you and any and all claims, injuries, illnesses, damages, liabilities and costs (“Claims”) suffered by you or any third party as a result of your interaction with or visit to any Host. YOU HEREBY RELEASE THE DRIVEWAYZ  PARTIES FROM ANY AND ALL SUCH CLAIMS. IN CONNECTION WITH THE FOREGOING, YOU HEREBY WAIVE ANY CIVIL CODE WHICH STATES DIRECTLY OR INDIRECTLY: “A GENERAL RELEASE DOES NOT EXTEND TO CLAIMS WHICH THE CREDITOR DOES NOT KNOW OR SUSPECT TO EXIST IN HIS OR HER FAVOR AT THE TIME OF EXECUTING THE RELEASE, WHICH, IF KNOWN BY HIM OR HER MUST HAVE MATERIALLY AFFECTED HIS OR HER SETTLEMENT WITH THE DEBTOR.” You hereby expressly waive and relinquish all rights and benefits under this section and any law of any jurisdiction of similar effect with respect to the release of any unknown or unsuspected claims you may have against the DriveWayz Parties pertaining to the subject matter of this Section 32.
        34.    Severability. If any part of this Terms & Conditions is determined to be invalid or unenforceable pursuant to applicable law including, but not limited to, the warranty disclaimers and liability limitations set forth above, then the invalid or unenforceable provision will be deemed superseded by a valid, enforceable provision that most closely matches the intent of the original provision and Agreement shall continue in effect
        35.    Assignment. This Terms & Conditions, and the rights granted and obligations undertaken hereunder, may not be transferred, assigned or delegated in any manner by a User, but may be freely transferred, assigned, or delegated by DriveWayz.
        36.    Waiver. Any waiver of any provision of this Terms & Conditions, or a delay by any party in the enforcement of any right hereunder, shall neither be construed as a continuing waiver nor create an expectation of non-enforcement of that or any other provision or right.
        37.    Arbitration and Venue. Any and all controversies, disputes, demands, counts, claims, or causes of action (including the interpretation and scope of this clause) between you and the DriveWayz Parties or their successors or assigns shall exclusively be settled through binding and confidential arbitration in Boulder County, Colorado.
        
        Arbitration shall be subject to the Federal Arbitration Act and not any state arbitration law. The arbitration shall be conducted before one commercial arbitrator, certified by the American Arbitration Association (“AAA”), with substantial experience in resolving commercial contract disputes. As modified by this Terms & Conditions, and unless otherwise agreed upon by the parties in writing, the arbitration will be governed by the AAA’s Commercial Arbitration Rules and, if the arbitrator deems them applicable, the Supplementary Procedures for Consumer Related Disputes (collectively, the “Rules and Procedures”).
        
        You and DriveWayz must abide by the following rules: (a) ANY CLAIMS BROUGHT BY YOU OR DRIVEWAYZ MUST BE BROUGHT IN THE {'PARTY\'S'} INDIVIDUAL CAPACITY, AND NOT AS A PLAINTIFF OR CLASS MEMBER IN ANY PURPORTED CLASS OR REPRESENTATIVE PROCEEDING; (b) THE ARBITRATOR MAY NOT CONSOLIDATE MORE THAN ONE PERSON’S CLAIMS, MAY NOT OTHERWISE PRESIDE OVER ANY FORM OF A REPRESENTATIVE OR CLASS PROCEEDING, AND MAY NOT AWARD CLASS-WIDE RELIEF; (c) the arbitrator shall honor claims of privilege and privacy recognized at law; (d) the arbitration shall be confidential, and neither you nor we may disclose the existence, content or results of any arbitration, except as may be required by law or for purposes of enforcement of the arbitration award; (e) the arbitrator may award any individual relief or individual remedies that are permitted by applicable law; and (f) each side pays its own attorneys’ fees and expenses unless there is a statutory provision that requires the prevailing party to be paid its fees and litigation expenses, and, in such instance, the fees and costs awarded shall be determined by the applicable law.
        
        Notwithstanding the foregoing, either you or DriveWayz may bring an individual action in small claims court. Further, claims of defamation, violation of the Computer Fraud and Abuse Act, and infringement or misappropriation of the other party’s patent, copyright, trademark, or trade secret shall not be subject to this arbitration agreement. Such claims shall be exclusively brought in the state or federal courts located in Boulder County, Colorado. Additionally, notwithstanding this agreement to arbitrate, either party may seek emergency equitable relief before the state or federal courts located in Boulder County, Colorado, in order to maintain the status quo pending arbitration, and hereby agree to submit to the exclusive personal jurisdiction of the courts located within Boulder County, Colorado, for such purpose. A request for interim measures shall not be deemed a waiver of the right to arbitrate.
        
        With the exception of subparts (a) and (b) in this Section (prohibiting arbitration on a class or collective basis), if any part of this arbitration provision is deemed to be invalid, unenforceable or illegal, or otherwise conflicts with the Rules and Procedures, then the balance of this arbitration provision shall remain in effect and shall be construed in accordance with its terms as if the invalid, unenforceable, illegal or conflicting part was not contained herein. If, however, either subpart (a) or (b) is found to be invalid, unenforceable or illegal, then the entirety of this arbitration provision shall be null and void, and neither you nor DriveWayz shall be entitled to arbitration. If for any reason a claim proceeds in court rather than in arbitration, the dispute shall be exclusively brought in state or federal court located in Boulder County, Colorado.
        
        For more information on AAA, the Rules and Procedures, or the process for filing an arbitration claim, you may call AAA at 800-778-7879 or visit the AAA website at http://www.adr.org.
        
        38.    Choice of Law. The Services are operated by a U.S. entity, and this Terms & Conditions is made under and shall be governed by and construed in accordance with the laws of the State of Colorado, consistent with the Federal Arbitration Act, without giving effect to any principles that provide for the application of the law of another jurisdiction.
        
        39.    General Terms. You agree that no joint venture, partnership, or employment relationship exists between you and any of the DriveWayz Parties as a result of agreeing to this Terms & Conditions or use of the Services. Further, no joint venture, partnership, or employment relationship exists between any of the DriveWayz Parties and any Host. Our performance of this Terms & Conditions is subject to existing laws and legal process, and nothing contained in this Terms & Conditions limits our right to comply with law enforcement or other governmental or legal requests or requirements relating to your use of the Services or information provided to or gathered by us with respect to such use. A printed version of this Terms & Conditions and of any notice given in electronic form shall be admissible in judicial or administrative proceedings based upon or relating to this Terms & Conditions to the same extent and subject to the same conditions as other business documents and records originally generated and maintained in printed form. Fictitious names of companies, products, people, characters, and/or data mentioned within the Services are not intended to represent any real individual, company, product, or event. Any rights not expressly granted herein are expressly reserved.
        40.    ACKNOWLEDGEMENT. BY USING THE SERVICE OR ACCESSING THE DriveWayz SITE OR APPLICATION, YOU ACKNOWLEDGE THAT YOU HAVE READ THESE TERMS OF USE AND AGREE TO BE BOUND BY THEM.
        41.    Entire Agreement. Notwithstanding any agreements or terms expressly incorporated by reference in this Terms & Conditions, this Terms & Conditions constitutes the entire agreement between the parties. This Terms & Conditions (as it may from time to time be amended, restated, or otherwise modified) supersedes any prior agreements, understandings, or negotiations, whether written or oral.
        
        REVISION DATE: June, 27, 2018
        
        
        
        """
        
        
        return label
    }()


}