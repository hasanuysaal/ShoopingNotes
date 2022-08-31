//
//  DetailsViewController.swift
//  ShoopingNotes
//
//  Created by Hasan Uysal on 31.08.2022.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(imageGestureRecognizer)
        
    }
    
    @objc func chooseImage(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        // info.plist -> Privacy - Media Library Usage
    
    }
    
    
    @objc func closeKeyboard(){
        
        view.endEditing(true)
        
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let shoopingNote = NSEntityDescription.insertNewObject(forEntityName: "ShopNote", into: context)
        
        shoopingNote.setValue(UUID(), forKey: "id")
        shoopingNote.setValue(nameTextField.text, forKey: "name")
        shoopingNote.setValue(brandTextField.text, forKey: "brand")
        shoopingNote.setValue(sizeTextField.text, forKey: "size")
        
        if let price = Int(priceTextField.text!) {
            shoopingNote.setValue(price, forKey: "price")
        }
        
        let data = imageView.image!.jpegData(compressionQuality: 0.5)
        
        shoopingNote.setValue(data, forKey: "image")
        
        
        do{
            try context.save()
            print("kaydedildi")
        } catch {
            print("hata")
        }
                
            
        
        
    
    }
    
}
