//
//  ViewController.swift
//  AdrianSnapchat
//
//  Created by Mac 14 on 5/29/21.
//  Copyright © 2021 Mac 14. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Auth con google
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
            print("Intentando iniciar sesion")
            if error != nil {
                print("Se presento el siguiente error: \(String(describing: error))")
            }else{
                print("Inicio de sesion exitoso")
            }
        }
    }
}

