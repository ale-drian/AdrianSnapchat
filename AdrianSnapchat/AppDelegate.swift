//
//  AppDelegate.swift
//  AdrianSnapchat
//
//  Created by Mac 14 on 5/29/21.
//  Copyright © 2021 Mac 14. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
final var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //Firebase
        FirebaseApp.configure()
        //Firebase- Auth con Google
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    //Para iOS 9 o superior
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    //Para iOs 8 o inferior
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
      if let error = error {
        // ...
        return
      }
    
      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
      // Autenticar
        Auth.auth().signIn(with: credential) { (authResult, err) in
            if err != nil {
                print((err?.localizedDescription)!)
            } else {
                print("Google")
                print(authResult?.user.email)
           print(Database.database().reference().child("usuarios"))
                Database.database().reference().child("usuarios").child((authResult?.user.uid)!).observe(DataEventType.value, with: { (snapshot) in
                    print("Usuario Google--")
                    if !snapshot.exists() {
                       print("Usuario Google")
                        Database.database().reference().child("usuarios").child((authResult?.user.uid)!).child("email").setValue((authResult?.user.email)!)
                    }
                }){ (error) in
                    print("error.localizedDescription")
                    print(error)
                }
                DispatchQueue.main.async {
                    let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let home = mainStoryboardIpad.instantiateViewController(identifier: "SnapsViewController") as!
                            SnapsViewController
                
                        let window = UIApplication.shared.delegate!.window!!
                        window.rootViewController = nil
                        window.rootViewController = home
                        
                        UIView.transition(with: window, duration: 0.4, options: [.transitionCrossDissolve], animations: nil, completion: nil)
                    }
                /*
                let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "Circles") as UIViewController
                            self.window = UIWindow(frame: UIScreen.main.bounds)
                            self.window?.rootViewController = initialViewControlleripad
                            self.window?.makeKeyAndVisible()
                 */
                return
                
            }
            return
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

