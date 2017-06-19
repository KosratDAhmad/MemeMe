//
//  ViewController.swift
//  MemeMe
//
//  Created by Kosrat D. Ahmad on 4/20/17.
//  Copyright © 2017 Kosrat D. Ahmad. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    // MARK: Outlets
    
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
        
        // Configure top and buttom text field.
        configure(textField: topText, withText: "TOP")
        configure(textField: bottomText, withText: "BOTTOM")
        
        // Check user's phone's camera for avalabilty to enable or disable camera funcationality.
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Disable share button at start up time because image is not ready to share.
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
    
    /// Configure a text field with a style.
    ///
    /// - Parameters:
    ///   - textField: UITextField
    ///   - withText: Default text field string.
    func configure(textField: UITextField, withText: String) {
        
        // Initialize top and bottom text field attributes.
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white ,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -4.0]
        
        // Apply attributes to the top text field.
        textField.text = withText
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    //MARK: Keyboard Notification
    
    /// Subscribe to keyboard notification to know when keyboard will appear or disappear to adapt the layout.
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    /// Unsubscribe from keyboard notification to no longer recieve this notification when view controller disappeared.
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    /// Adapt the layout when keyboard appeared to the screen specially when you whant to edit bottom text it will adapt the layout to
    /// show button text field.
    ///
    /// - Parameter notification: Notification instance
    func keyboardWillShow(_ notification:Notification) {
        
        if isBottom {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    /// Restore the adapted layout when the keyboard disappeared from the screen.
    ///
    /// - Parameter notification: Notification instance.
    func keyboardWillHide(_ notification: Notification){
        self.view.frame.origin.y = 0
    }
    
    /// Get height of the phone's keyboard from keyboard notification.
    ///
    /// - Parameter notification: Notification instance.
    /// - Returns: CGFloat instance which is indicated the height of the keyboard.
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //MARK: Actions
    
    /// Pick an image from phone's ablums.
    ///
    /// - Parameter sender: UIView.
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
       chooseSourceType(sourceType: .photoLibrary)
    }
    
    /// Capture an image from phone's camera if available.
    ///
    /// - Parameter sender: UIView
    @IBAction func pickAnImageFromCamera(_ sender: Any){
        chooseSourceType(sourceType: .camera)
    }
    
    /// Bring a model to choose image from library or take it from camera
    ///
    /// - Parameter sourceType: UIImagePickerControllerSourceType
    func chooseSourceType(sourceType: UIImagePickerControllerSourceType) {
        
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = sourceType
        
        present(controller, animated: true, completion: nil)
    }
    
    /// Share memed image with activity conroller which will can save it to phone's album.
    ///
    /// - Parameter sender: UIView
    @IBAction func shareMeme(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        let viewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        viewController.completionWithItemsHandler = {(activityType, complete, returnedItems, activityError ) in
            
            if complete {
                self.save(memedImage)
                self.dismissPicker()
            }
        }
        
        present(viewController, animated: true, completion: nil)
    }
    
    /// Save meme object.
    func save(_ memedImage: UIImage) {
        
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    /// Generate memed image by taking a screenshot but without toolbars and navigations.
    ///
    /// - Returns: Memed UIImage
    func generateMemedImage() -> UIImage {
        
        // Hiden toolbars
        hideToolbar(isHidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbars
        hideToolbar(isHidden: false)
        
        return memedImage
    }
    
    /// Helper method to show or hide app toolbar
    ///
    /// - Parameter isHidden: Boolean to indicate hide or not the toolbar
    func hideToolbar(isHidden: Bool) {
        bottomToolbar.isHidden = isHidden
        topToolbar.isHidden = isHidden
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismissPicker()
    }
    
    // MARK: Delegates
    
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
    
    
    /// Dismiss models.
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
        
        // If the text field is bottom will make the isBottom property to true which will adapt the layout.
        if textField.tag == 0 {
            isBottom = false
        } else {
            isBottom = true
        }
    }
}
