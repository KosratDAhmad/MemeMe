//
//  ViewController.swift
//  MemeMe
//
//  Created by Kosrat D. Ahmad on 4/20/17.
//  Copyright © 2017 Kosrat D. Ahmad. All rights reserved.
//

import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var isBottom = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white ,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -4.0]
        
        topText.text = "TOP"
        topText.delegate = self
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .center
        
        bottomText.text = "BOTTOM"
        bottomText.delegate = self
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = .center
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        
        if isBottom {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification){
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any){
        
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .camera
        
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        
        print("Share Meme")
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        let viewController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        
        present(viewController, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hiden toolbars
        bottomToolbar.isHidden = true
        topToolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbars
        bottomToolbar.isHidden = false
        topToolbar.isHidden = false
        
        return memedImage
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
        
        dismissPicker()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismissPicker()
    }
    
    func dismissPicker() {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
        
        if textField.tag == 0 {
            isBottom = false
        } else {
            isBottom = true
        }
    }
}

