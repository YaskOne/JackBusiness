//
//  CreateBusinessViewController.swift
//  JackBusiness
//
//  Created by Arthur Ngo Van on 7/6/18.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities
import GooglePlaces
import JackModel

enum RegisterBusinessFormField: Int {
    case name
    case password
    case address
    case type
    case description
    case url
    case email
}

class CreateBusinessViewController: UIViewController {

    @IBOutlet weak var nameLabel: AFormLabel!
    @IBOutlet weak var passwordLabel: AFormLabel!
    @IBOutlet weak var addressLabel: AFormLabel!
    @IBOutlet weak var typeLabel: AFormLabel!
    @IBOutlet weak var descriptionLabel: AFormLabel!
    @IBOutlet weak var urlLabel: AFormLabel!
    @IBOutlet weak var emailLabel: AFormLabel!
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var addressInput: UITextField!
    @IBOutlet weak var typeInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextField!
    @IBOutlet weak var urlInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    
    @IBOutlet weak var cguButton: AUButton!
    
    var formFields: [RegisterBusinessFormField: AFormField] = [:]
    
    var validateButton: UIBarButtonItem?
    
    var modifing: Bool {
        return JKSession.shared.business != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        validateButton = UIBarButtonItem(title: AULocalized.string("validate_action"), style: .plain, target: self, action: #selector(validateTapped))
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = validateButton
        
        handleKeyboardVisibility()
        createFormFields()
        setUpFormFields()
    }
    
    @IBOutlet weak var passwordHeightConstrain: NSLayoutConstraint!
    
    func setUpFormFields() {
//        passwordHeightConstrain.constant = modifing ? 0 : 80
        cguButton.isHidden = modifing
        
        guard let business = JKSession.shared.business else {
            return
        }
        
        nameInput.text = business.name
        addressInput.text = business.address
        typeInput.text = business.type
        descriptionInput.text = business.description
        urlInput.text = business.url
        emailInput.text = business.email
        
        for field in formFields {
            field.value.checkFieldStatus()
        }
        
        formFields[.password]?.formStatus = .valid
    }
    
    func createFormFields() {
        formFields[.name] = AFormField(input: nameInput, label: nameLabel, defaultValue: "") {
            return self.nameInput.text != "" ? FormStatus.valid : FormStatus.invalid
        }
        formFields[.password] = AFormField(input: passwordInput, label: passwordLabel, defaultValue: "") {
            return self.passwordInput.text != "" ? FormStatus.valid : FormStatus.invalid
        }
        formFields[.address] = AFormField(input: addressInput, label: addressLabel, defaultValue: "") {
            return self.addressInput.text != "" ? FormStatus.valid : FormStatus.invalid
        }
        formFields[.email] = AFormField(input: emailInput, label: emailLabel, defaultValue: "") {
            return self.emailInput.text != "" ? FormStatus.valid : FormStatus.invalid
        }
        formFields[.type] = AFormField(input: typeInput, label: typeLabel, defaultValue: "") {
            return self.typeInput.text != "" ? FormStatus.valid : FormStatus.invalid
        }
        formFields[.url] = AFormField(input: urlInput, label: urlLabel, defaultValue: "", mandatory: false)
        formFields[.description] = AFormField(input: descriptionInput, label: descriptionLabel, defaultValue: "", mandatory: false)
    }

    @IBAction func addressTapped(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        let filter = GMSAutocompleteFilter()
        
        filter.country = "FR"

        autocompleteController.autocompleteFilter = filter
        autocompleteController.delegate = self

        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func acceptCguTapped(_ sender: Any) {
        cguButton.isSelected = !cguButton.isSelected
        cguButton.borderColor = cguButton.isSelected ? UIColor.green : UIColor.darkGray
        cguButton.titleLabel?.textColor = cguButton.isSelected ? UIColor.green : UIColor.darkGray
    }
    
    @IBAction func cguTapped(_ sender: Any) {
        navigationController?.pushViewController(homeStoryboard.instantiateViewController(withIdentifier: "CGU"), animated: true)
    }
    
    @objc func validateTapped() {
        for field in formFields {
            if field.value.formStatus == .invalid
                || (field.value.formStatus == .none && field.value.mandatory) {
                return
            }
        }
        if !modifing && !cguButton.isSelected {
            return
        }
        
        validateButton?.isEnabled = false
        
        if !modifing {
            JKMediator.createBusiness(email: emailInput.text!, name: nameInput.text!, password: passwordInput.text!, address: addressInput.text!, type: typeInput.text!, description: descriptionInput.text!, url: urlInput.text!, success: { (id) in
                self.navigationController?.popViewController(animated: true)
                self.validateButton?.isEnabled = true
            }, failure: {
                self.validateButton?.isEnabled = true
            })
        }
        else {
            JKMediator.updateBusiness(id: JKSession.shared.businessId, email: emailInput.text, name: nameInput.text, password: passwordInput.text, address: addressInput.text, type: typeInput.text, description: descriptionInput.text, url: urlInput.text, success: {
                self.navigationController?.popViewController(animated: true)
                self.validateButton?.isEnabled = true
            }, failure: {
                self.validateButton?.isEnabled = true
            })
        }
        
    }
}


extension CreateBusinessViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        addressInput.text = place.formattedAddress
        formFields[.address]?.checkFieldStatus()
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
