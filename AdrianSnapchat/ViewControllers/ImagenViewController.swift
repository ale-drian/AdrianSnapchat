//
//  ImagenViewController.swift
//  AdrianSnapchat
//
//  Created by Mac 14 on 6/7/21.
//  Copyright © 2021 Mac 14. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    var audioID = NSUUID().uuidString
    var grabarAudio:AVAudioRecorder?
    var audioStorageURL:String?
    var audioURL:URL?
    var timer = Timer()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    @IBOutlet weak var tiempoGrabacion: UILabel!
    @IBOutlet weak var grabarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false
        configurarGrabacion()
    }
    
    @objc func duracionAudio(){
       tiempoGrabacion.text = grabarAudio?.currentTime.stringFromTimeInterval()
    }
    
    @IBAction func grabarAudioTaped(_ sender: Any) {
        if grabarAudio!.isRecording{
            //detener la grabacion
            grabarAudio?.stop()
            //cambiar el icono del boton grabar
            grabarButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
            timer.invalidate()
        }else{
            //empezar la grabacion
            grabarAudio?.record()
            //cambiar el icono del boton grabar a detener
            grabarButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 0.001, target:self, selector: #selector(ImagenViewController.duracionAudio), userInfo: nil, repeats: true)
        }
    }
    
    func configurarGrabacion(){
            do{
                //creando sesion de audio
                let session = AVAudioSession.sharedInstance()
                try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [])
                try session.overrideOutputAudioPort(.speaker)
                try session.setActive(true)
                
                //creando direcciones para el archivo de audio
                let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let pathComponets = [basePath,"audio.m4a"]
                audioURL = NSURL.fileURL(withPathComponents: pathComponets)!
            
                //crear opciones para el grabador de audio
                var settings: [String:AnyObject] = [:]
                settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
                settings[AVSampleRateKey] = 44100.0 as AnyObject?
                settings[AVNumberOfChannelsKey] = 2 as AnyObject?
                
                //Crear el objeto de grabacion de audio
                grabarAudio = try AVAudioRecorder(url: audioURL!, settings: settings)
                grabarAudio!.prepareToRecord()
                
            }catch let error as NSError{
                print(error)
            }
    }
    
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func mediaTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        self.elegirContactoBoton.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
            cargarImagen.putData(imagenData!, metadata: nil) { (metadata, error) in
            if error != nil{
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vulva a intentarlo", accion: "Aceptar")
                self.elegirContactoBoton.isEnabled = true
                print("Ocurrio un error al subir imagen \(error)")
            }else{
                cargarImagen.downloadURL(completion: {(url, error) in
                    guard let enlaceURL = url else{
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion de imagen", accion: "Cancelar")
                        self.elegirContactoBoton.isEnabled = true
                        print("Ocurrio un error al obtener informacion de la imagen \(error)")
                        return
                    }
                    let audioFolder = Storage.storage().reference().child("audios")
                    let audioData = NSData(contentsOf: self.audioURL!)! as Data
                    let cargarAudio = audioFolder.child("\(self.audioID).m4a")
                        cargarAudio.putData(audioData, metadata: nil) { (metadata, error) in
                        if error != nil{
                            self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir el audio. Verifique su conexion a internet y vulva a intentarlo", accion: "Aceptar")
                            self.elegirContactoBoton.isEnabled = true
                            print("Ocurrio un error al subir audio \(error)")
                        }else{
                            cargarAudio.downloadURL(completion: {(urlA, error) in
                                guard let audioURL = urlA else{
                                    self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion de audio", accion: "Cancelar")
                                    self.elegirContactoBoton.isEnabled = true
                                    print("Ocurrio un error al obtener informacion del audio \(error)")
                                    return
                                }
                                self.audioStorageURL = urlA?.absoluteString
                                self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url?.absoluteString)
                            })
                        }
                    }
                })
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirContactoBoton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.descrip = descripcionTextField.text!
        siguienteVC.imagenID = imagenID
        siguienteVC.audioID = audioID
        siguienteVC.audioURL = audioStorageURL!
        /*
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        imagenesFolder.child("imagenes.jpg").putData(imagenData!, metadata: nil) { (metadata, error) in
            if error != nil{
                print("Ocurrio un error al subir imagen")
            }
        }
         */
    }
    
    
    
    func mostrarAlerta(titulo: String, mensaje: String, accion:String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }

}

extension TimeInterval{

    func stringFromTimeInterval() -> String {

        let time = NSInteger(self)

        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)

        return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)

    }
}
