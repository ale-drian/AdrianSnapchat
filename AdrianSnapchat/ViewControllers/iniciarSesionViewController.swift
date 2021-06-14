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
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "iniciarsesionSegue", sender: nil)
        }
        
    }

    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
            print("Intentando iniciar sesion")
            if error != nil {
                print("Se presento el siguiente error: \(String(describing: error))")
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                    print("Intentando crear un usuario")
                    if error != nil {
                        print("Se presento el siguiente error al crear usuario: \(String(describing: error))")
                    }else{
                        print("El usuario fue creado satisfactoriamente")
                    self.ref.child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                        let alerta = UIAlertController(title: "Creacion de usuario", message: "\(user!.user.email!) se creo correctamente.", preferredStyle: .alert)
                        let btnOK = UIAlertAction(title: "aceptar", style: .default, handler:  { (UIAlertAction) in
                            self.performSegue(withIdentifier: "iniciarsesionSegue", sender: nil)
                        })
                        alerta.addAction(btnOK)
                        self.present(alerta, animated: true, completion: nil)
                    }
                }
            }else{
                print("Inicio de sesion exitoso")
                self.performSegue(withIdentifier: "iniciarsesionSegue", sender: nil)
            }
        }
    }
}

