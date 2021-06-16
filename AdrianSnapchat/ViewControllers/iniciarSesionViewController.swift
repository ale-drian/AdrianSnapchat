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
import FirebaseDatabase
import GoogleSignIn

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    var ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
         /*ref.child("usuarios").setValue("hola"){ (err, resp) in
            print(err)
            print(resp)
            print("ejecucion")
        }*/
        
        // Auth con google
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
            print("Intentando iniciar sesion")
            if error != nil {
                print("Usuario no encontrado: \(String(describing: error))")
                let alerta = UIAlertController(title: "Credenciales incorrectas", message: "Usuario no encontrado", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler:  { (UIAlertAction) in
                    self.performSegue(withIdentifier: "iniciarsesionSegue", sender: nil)
                })
                let btnRegister = UIAlertAction(title: "Registrase", style: .default, handler:  { (UIAlertAction) in
                    self.performSegue(withIdentifier: "SignInToRegisterSegue", sender: nil)
                })
                alerta.addAction(btnOK)
                alerta.addAction(btnRegister)
                self.present(alerta, animated: true, completion: nil)
                
            }else{
                print("Inicio de sesion exitoso")
                self.performSegue(withIdentifier: "iniciarsesionSegue", sender: nil)
            }
        }
    }
}

