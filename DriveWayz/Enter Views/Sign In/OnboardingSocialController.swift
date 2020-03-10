//
//  OnboardingSocialController.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 1/29/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import GoogleSignIn
import AuthenticationServices
import SwiftyJSON
import CoreLocation
import CryptoKit

class OnboardingSocialController: UIViewController, NameDelegate {
    
    var socials: [String] = ["Facebook", "Google", "Apple"]
    var socialsImage: [UIImage?] = [UIImage(named: "Facebook"), UIImage(named: "Google"), UIImage(named: "Apple")]
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Theme.STANDARD_GRAY
        let image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.BLACK
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choose an account"
        label.textColor = Theme.BLACK
        label.font = Fonts.SSPRegularH25
        
        return label
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(SocialOptionsCell.self, forCellReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        view.decelerationRate = .fast
        view.separatorStyle = .none
        view.separatorInset = UIEdgeInsets(top: 0, left: phoneWidth, bottom: 0, right: 0)
        view.backgroundColor = Theme.WHITE
        
        return view
    }()
    
    var dimmingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.BLACK
        view.alpha = 0
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.WHITE
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        setupViews()
    }

    func setupViews() {
        
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        tableView.addSubview(backButton)
        tableView.addSubview(mainLabel)
        
        backButton.anchor(top: tableView.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        mainLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 32).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        view.addSubview(dimmingView)
        dimmingView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func successfulSignIn() {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.dimmingView.alpha = 1
        }) { (success) in
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
            
            delayWithSeconds(animationOut) {
                let controller = LaunchMainController()
                controller.modalPresentationStyle = .overFullScreen
                controller.modalTransitionStyle = .crossDissolve
                self.present(controller, animated: true, completion: nil)
            }
        }
    }

    func nextButtonPressed(uid: String) {
        let controller = OnboardingNameController()
//        controller.delegate = self
        controller.uid = uid
        controller.phoneNumber = nil
        controller.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToLocationServices() {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.dimmingView.alpha = 0.8
        }) { (success) in
            self.view.endEditing(true)
            let controller = OnboardingLocationServices()
            controller.delegate = self
            controller.modalPresentationStyle = .overFullScreen
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func checkSignIn(userID: String) {
        let ref = Database.database().reference().child("users").child(userID)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                if let name = dictionary["name"] as? String {
                    self.login(uid: userID, name: name)
                } else {
                    self.nextButtonPressed(uid: userID)
                }
            } else {
                self.nextButtonPressed(uid: userID)
            }
        }
    }
    
    func login(uid: String, name: String) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                self.moveToLocationServices()
            case .authorizedAlways, .authorizedWhenInUse:
                let ref = Database.database().reference().child("users").child(uid)
                ref.updateChildValues(["DeviceID": AppDelegate.DEVICEID])
                UserDefaults.standard.set(name, forKey: "userName")
                UserDefaults.standard.synchronize()
                
                self.successfulSignIn()
            default:
                print("Verify Number Failed to login")
            }
        } else {
            self.moveToLocationServices()
        }
    }
    
    func appleSignIn() {
        if #available(iOS 13.0, *) {
            startSignInWithAppleFlow()
        } else {
            print("wrong version idiot") // Need an alert
        }
    }
    
    func closeBackground() {
        UIView.animateOut(withDuration: animationOut, animations: {
            self.dimmingView.alpha = 0
        }) { (success) in
            //
        }
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

}

// Handle the Facebook Sign in methods with Firebase
extension OnboardingSocialController {
    
    @objc func loginButtonDidCompleteLogin() {
        let loginManager = LoginManager()
//        loginManager.loginBehavior = LoginBehavior.systemAccount
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .success(_, _, _):
                let access = AccessToken.current
                guard let accessTok = access?.tokenString else { return }

                let credentials = FacebookAuthProvider.credential(withAccessToken: accessTok)
                Auth.auth().signIn(with: credentials, completion: { (user, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let uid = user.uid
                        var values: [String: Any] = ["id": uid, "DeviceID": AppDelegate.DEVICEID]
                        
                        if let name = user.displayName {
                            values["name"] = name
                        }
                        if let email = user.email {
                            values["email"] = email
                        }
                        if let photoURL = user.photoURL {
                            values["picture"] = photoURL.absoluteString
                        }
                        
                        let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
                        let usersReference = ref.child("users").child(uid)
                        usersReference.updateChildValues(values) { (err, ref) in
                            if err != nil {
                                print(err!)
                                return
                            }
                            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                            UserDefaults.standard.synchronize()

                            self.checkSignIn(userID: uid)
                        }
                    }
                })
            case .cancelled:
                print("User canceled Facebook Login")
            }
        }
    }
    
}

// Handle the Google Sign in methods with Firebase
extension OnboardingSocialController: GIDSignInDelegate {
    
    func googleSignIn() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print(error.localizedDescription)
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let userID = user?.user.uid else { return }
            if let additionalInfo = user?.additionalUserInfo?.profile {
                if let name = additionalInfo["name"] as? String, let email = additionalInfo["email"] as? String, let picture = additionalInfo["picture"] as? String {
                    let ref = Database.database().reference(fromURL: "https://drivewayz-e20b9.firebaseio.com")
                    let usersReference = ref.child("users").child(userID)
                    let values = ["name": name,
                                  "email": email,
                                  "picture": picture,
                                  "DeviceID": AppDelegate.DEVICEID]
                    usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if err != nil {
                            print(err!)
                            return
                        }
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        UserDefaults.standard.synchronize()
                        
                        self.checkSignIn(userID: userID)
                    })
                }
            }
        })
    }
    
}

// Handle the Apple Sign in methods with Firebase
@available(iOS 13.0, *)
extension OnboardingSocialController: ASAuthorizationControllerDelegate {
    
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was  sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription as Any)
                    return
                }
                
                guard let userID = authResult?.user.uid else { return }
                if let additionalInfo = authResult?.additionalUserInfo?.profile {
                    if let email = additionalInfo["email"] as? String {
                        let ref = Database.database().reference().child("users").child(userID)
                        var values = ["email": email,
                                      "DeviceID": AppDelegate.DEVICEID]
                        if let name = authResult?.additionalUserInfo?.username {
                            values["name"] = name
                        }
                        ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
                            if err != nil {
                                print(err!)
                                return
                            }
                            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                            UserDefaults.standard.synchronize()
                            
                            self.checkSignIn(userID: userID)
                        })
                    }
                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }

    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
    
}


extension OnboardingSocialController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.contentOffset.y
        if translation <= -120 {
            backButtonPressed()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socials.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 144
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.isUserInteractionEnabled = false
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SocialOptionsCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 0)
        cell.selectionStyle = .none
        
        if indexPath.row >= socials.count {
            cell.separatorInset = UIEdgeInsets(top: 0, left: phoneWidth, bottom: 0, right: 0)
            tableView.separatorStyle = .none
        } else {
            tableView.separatorStyle = .singleLine
        }
        
        if socials.count > indexPath.row {
            cell.mainLabel.text = socials[indexPath.row]
            let image = socialsImage[indexPath.row]
            cell.iconButton.setImage(image, for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SocialOptionsCell
        guard let account = cell.mainLabel.text else { return }
        if account == "Facebook" {
            loginButtonDidCompleteLogin()
        } else if account == "Google" {
            googleSignIn()
        } else if account == "Apple" {
            appleSignIn()
        }
    }
    
}

class SocialOptionsCell: UITableViewCell {
    
    var iconButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.SSPRegularH4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Theme.BLACK
        
        return view
    }()
    
    var arrowButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "Expand")?.rotated(by: Measurement(value: 90, unit: .degrees))
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = Theme.BLACK
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Theme.WHITE
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(iconButton)
        addSubview(mainLabel)
        addSubview(arrowButton)
        
        iconButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        iconButton.heightAnchor.constraint(equalTo: iconButton.widthAnchor).isActive = true
        iconButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        mainLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainLabel.leftAnchor.constraint(equalTo: iconButton.rightAnchor, constant: 20).isActive = true
        mainLabel.sizeToFit()
        
        arrowButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        arrowButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        arrowButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        arrowButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

