//
//  VerSnapViewController.swift
//  AdrianSnapchat
//
//  Created by Mac 14 on 6/16/21.
//  Copyright © 2021 Mac 14. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseDatabase
import FirebaseAuth

class VerSnapViewController: UIViewController {

    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var lblMensaje: UILabel!
    var snap = Snap()
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Valores del snap en la vista
        lblMensaje.text = snap.descrip
        imagenView.sd_setImage(with: URL(string: snap.imagenURL), completed: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    ref.child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
    Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete{ (error) in
            print("Se elimino correctamente")
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

}
