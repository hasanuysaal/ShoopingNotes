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
    @IBOutlet weak var saveButton: UIButton!
    
    var receiveName = ""
    var recieveUUID: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if receiveName != "" {
            
            saveButton.isHidden = true
            
            if let uuidString = recieveUUID?.uuidString {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShopNote")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    let results = try context.fetch(fetchRequest)
                    
                    if results.count > 0 {
                        
                        for result in results as! [NSManagedObject]{
                            
                            if let name = result.value(forKey: "name") as? String {
                                nameTextField.text = name
                            }
                            if let brand = result.value(forKey: "brand") as? String {
                                brandTextField.text = brand
                            }
                            if let size = result.value(forKey: "size") as? String {
                                sizeTextField.text = size
                            }
                            if let price = result.value(forKey: "price") as? Int {
                                priceTextField.text = String(price)
                            }
                            if let imageData = result.value(forKey: "image") as? Data {
                                let image = UIImage(data: imageData)
                                imageView.image = image
                            }
                        }
                    }
                } catch {
                
                }
            }
            
        } else {
            
            saveButton.isHidden = false
            saveButton.isEnabled = false
            nameTextField.text = ""
            brandTextField.text = ""
            sizeTextField.text = ""
            priceTextField.text = ""
            
        }
        
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
        saveButton.isEnabled = true
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
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clickedSaveBtn"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}
