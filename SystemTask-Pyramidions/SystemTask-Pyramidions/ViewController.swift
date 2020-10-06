//
//  ViewController.swift
//  SystemTask-Pyramidions
//
//  Created by Santhosh on 03/10/20.
//  Copyright © 2020 Contus. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {

    // This outlet to display the uploaded profile image
    @IBOutlet weak var profileImageView : UIImageView!
    // This outlet/view holds the profile imageview
    @IBOutlet weak var profileView : UIView!
    // This textfield allows to enter the email id
    @IBOutlet weak var usernameTextfield : UITextField!
    // This textfield outlet allows to enter the password
    @IBOutlet weak var passwordTextField : UITextField!
    // Boolean variable to set and validate if profile image is uploaded
    var isImageUploaded : Bool = false
    
    // MARK: View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickPhoto))
        self.profileView.addGestureRecognizer(tap)
        self.profileView.layer.cornerRadius = self.profileView.frame.size.width / 2
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: Image Picker controller methods
    /// Method to present image picker controller
    @objc func pickPhoto() {

        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.allowsEditing = true
        DispatchQueue.main.async {
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: Imagepicker controller Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Error in fetching image")
            return
        }
        self.dismiss(animated: true) {
            self.profileImageView?.image = selectedImage
            self.isImageUploaded = true
        }
        
    }
    
    // MARK: Alert controller methods
    func showAlertMessage(_ message : String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    // MARK: TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}

// MARK: Field validations
extension ViewController {
    // Email validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // Password validation
    func isValidPassword(_ password: String) -> Bool {
        var lowerCaseLetter: Bool = false
        var upperCaseLetter: Bool = false
        var digit: Bool = false
        var specialCharacter: Bool = false
        
        if password.count  >= 8 {
             for char in password.unicodeScalars {
                if (!lowerCaseLetter) {
                 lowerCaseLetter = CharacterSet.lowercaseLetters.contains(char)
                }
                if (!upperCaseLetter) {
                 upperCaseLetter = CharacterSet.uppercaseLetters.contains(char)
                }
                if (!digit) {
                 digit = CharacterSet.decimalDigits.contains(char)
                }
                if(!specialCharacter) {
                    specialCharacter = CharacterSet.symbols.contains(char) || CharacterSet.punctuationCharacters.contains(char)
                }
             }
            
            if (!lowerCaseLetter) {
                showAlertMessage("Password should contain atleast one lowercase character")
                return false
            } else if (!upperCaseLetter) {
                showAlertMessage("Password should contain atleast one uppercase character")
                return false
            } else if (!digit) {
                showAlertMessage("Password should contain atleast one numeric value")
                return false
            } else if (!specialCharacter) {
                showAlertMessage("Password should contain one special character")
                return false
            } else {
                return true
            }
        }
        showAlertMessage("Password should contain atleast 8 characters")
        return false
    }
    
    // MARK: UIEvent Method
    // UIEvent callback to dismiss keyboard on touch in view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // To cancel segue action based on field validations
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

       if ((usernameTextfield?.text?.trimmingCharacters(in: .whitespaces).count) == 0 || (passwordTextField?.text?.trimmingCharacters(in: .whitespaces).count) == 0) {
           showAlertMessage("Email or password is empty")
           return false
       }
       if (!isValidEmail(usernameTextfield.text!)) {
           showAlertMessage("Please enter a valid email")
           return false
       } else if (!isValidPassword(passwordTextField.text!)) {
           return false
       }
       if (!isImageUploaded) {
          showAlertMessage("Please upload profile picture")
          return false
       }
       return true
    }
}
