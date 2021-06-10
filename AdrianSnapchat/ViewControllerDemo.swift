//
//  ViewControllerDemo.swift
//  AdrianSnapchat
//
//  Created by Mac 14 on 6/9/21.
//  Copyright © 2021 Mac 14. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewControllerDemo: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var ref = Database.database().reference()

                ref.child("usuarios").setValue("hola"){ (err, resp) in
                   print(err)
                   print(resp)
                   print("ejecucion")
                   
                   
               }
        // Do any additional setup after loading the view.
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
