//
//  ElegirUsuarioViewController.swift
//  AdrianSnapchat
//
//  Created by Mac 14 on 6/8/21.
//  Copyright © 2021 Mac 14. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ElegirUsuarioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var listaUsuarios: UITableView!
    
    var usuarios:[Usuario] = []
    var imagenURL = ""
    var descrip = ""
    var imagenID = ""
    
    var ref = Database.database().reference()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        listaUsuarios.delegate = self
        listaUsuarios.dataSource = self
        ref.child("usuarios").observe(DataEventType.childAdded, with: { (snapshot) in
            print(snapshot)
            //Setear los usuarios
            let usuario = Usuario()
            usuario.email = (snapshot.value as! NSDictionary)["email"] as! String
            usuario.uid = snapshot.key
            self.usuarios.append(usuario)
            self.listaUsuarios.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = UITableViewCell()
         let usuario = usuarios[indexPath.row]
         print("\(usuario)")
         cell.textLabel?.text = usuario.email
         return cell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usuario = usuarios[indexPath.row]
        let snap = ["from": Auth.auth().currentUser?.email, "descripcion": descrip, "imagenURL": imagenURL, "imagenID": imagenID]
        ref.child("usuarios").child(usuario.uid).child("snaps").childByAutoId().setValue(snap)
        navigationController?.popViewController(animated: true)
    }

    /*
     override func viewDidLoad() {
         super.viewDidLoad()
         listaUsuarios.delegate = self
         listaUsuarios.dataSource = self
         ref.child("usuario").observe(DataEventType.childAdded, with: { (snapshot) in
             print(snapshot)
             //106
             let usuario = Usuario()
             usuario.email = (snapshot.value as! NSDictionary)["email"] as! String
             usuario.uid = snapshot.key
             self.usuarios.append(usuario)
             self.listaUsuarios.reloadData()
             print("cargando")
         })
     }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
