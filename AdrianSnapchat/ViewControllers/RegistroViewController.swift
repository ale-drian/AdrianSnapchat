//
//  RegistroViewController.swift
//  AdrianSnapchat
//
//  Created by Mac 14 on 6/10/21.
//  Copyright © 2021 Mac 14. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegistroViewController: UIViewController {

    @IBOutlet weak var emailRTextField: UITextField!
    @IBOutlet weak var passwordRTextField: UITextField!
    @IBOutlet weak var confirmationPasswordTextField: UITextField!
    var ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registrarTapped(_ sender: Any) {
        let email = emailRTextField.text!
        let password = passwordRTextField.text!
        let confirmation = confirmationPasswordTextField.text!
        
        if email == "" || password == "" {
            alertavalidacion("Crear nuevo usuario", "Datos proporcionados insuficientes")
        }else if password != confirmation{
            alertavalidacion("Crear nuevo usuario", "Las contraseñas no coinciden")
        }else{
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                print("Intentando crear un usuario")
                if error != nil {
                    let errCode = AuthErrorCode(rawValue: error!._code)
                    switch errCode {
                    case .invalidEmail:
                        self.alertavalidacion("Crear nuevo usuario", "Correo no valido")
                    case .emailAlreadyInUse:
                        self.alertavalidacion("Crear nuevo usuario", "El usuario ya existe")
                    case .weakPassword:
                        self.alertavalidacion("Crear nuevo usuario", "Contraseña no valida, debe tener al menos 6 digitos")
                    default:
                        self.alertavalidacion("Crear nuevo usuario", "Ocurrio un error inesperado, vuelva a intentarlo mas tarde")
                    }
                }else{
                    print("El usuario fue creado satisfactoriamente")
                self.ref.child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                    let alerta = UIAlertController(title: "Creacion de usuario", message: "\(user!.user.email!) se creo correctamente.", preferredStyle: .alert)
                    let btnOK = UIAlertAction(title: "aceptar", style: .default, handler:  { (UIAlertAction) in
                        self.performSegue(withIdentifier: "registrarSegue", sender: nil)
                    })
                    alerta.addAction(btnOK)

                    self.present(alerta, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func alertavalidacion(_ titulo: String,_ mensaje: String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alerta.addAction(btnOK)
        self.present(alerta, animated: true, completion: nil)
    }

}
