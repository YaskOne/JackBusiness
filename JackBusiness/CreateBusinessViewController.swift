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

    @IBOutlet weak var emailLabel: AUFormLabeledField!
    @IBOutlet weak var passwordLabel: AUFormLabeledField!
    
    @IBOutlet weak var nameLabel: AUFormLabeledField!
    @IBOutlet weak var typeLabel: AUFormLabeledField!
    @IBOutlet weak var addressLabel: AUFormLabeledField!

    @IBOutlet weak var urlLabel: AUFormLabeledField!
    @IBOutlet weak var descriptionLabel: AUFormLabeledField!
    
//    @IBOutlet weak var cguButton: AUButton!
    
    var formFields: [RegisterBusinessFormField: AUFormLabeledField] = [:]
    
    var validateButton: UIBarButtonItem?
    
    var modifing: Bool {
        return JKSession.shared.business != nil
    }
    @IBOutlet weak var navigationBar: AUNavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.rightAction = {
            self.validateTapped()
        }
        
        handleKeyboardVisibility()
        createFormFields()
        setUpFormFields()
    }
    
    @IBOutlet weak var passwordHeightConstrain: NSLayoutConstraint!
    
    func setUpFormFields() {
//        passwordHeightConstrain.constant = modifing ? 0 : 80
//        cguButton.isHidden = modifing
        
        guard let business = JKSession.shared.business else {
            return
        }
        
        nameLabel.text = business.name
        addressLabel.text = business.address
        typeLabel.text = business.type
        descriptionLabel.text = business.description
        urlLabel.text = business.url
        emailLabel.text = business.email
        
        for field in formFields {
            field.value.checkFieldStatus()
        }
        
//        formFields[.password]?.formStatus = .valid
    }
    
    func createFormFields() {
        nameLabel.initialize() {
            return self.nameLabel.text != "" ? FormStatus.valid : FormStatus.invalid
        }
        passwordLabel.initialize() {
            return self.passwordLabel.text != "" ? FormStatus.valid : FormStatus.invalid
        }
        addressLabel.initialize() {
            return self.addressLabel.text != "" ? FormStatus.valid : FormStatus.invalid
        }
        emailLabel.initialize() {
            return self.emailLabel.text != "" ? FormStatus.valid : FormStatus.invalid
        }
        typeLabel.initialize() {
            return self.typeLabel.text != "" ? FormStatus.valid : FormStatus.invalid
        }
        urlLabel.initialize(mandatory: false)
        descriptionLabel.initialize(mandatory: false)
        
        formFields[.name] = nameLabel
        formFields[.password] = passwordLabel
        formFields[.address] = addressLabel
        formFields[.email] = emailLabel
        formFields[.type] = typeLabel
        formFields[.url] = urlLabel
        formFields[.description] = descriptionLabel
    }

    @IBAction func addressTapped(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        let filter = GMSAutocompleteFilter()
        
        filter.country = "FR"

        autocompleteController.autocompleteFilter = filter
        autocompleteController.delegate = self

        present(autocompleteController, animated: true, completion: nil)
    }
    
//    @IBAction func acceptCguTapped(_ sender: Any) {
//        cguButton.isSelected = !cguButton.isSelected
//    }
    
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
//        if !modifing && !cguButton.isSelected {
//            return
//        }
        
        validateButton?.isEnabled = false
        
        if !modifing {
            JKMediator.createBusiness(email: emailLabel.text!, name: nameLabel.text!, password: passwordLabel.text!, address: addressLabel.text!, type: typeLabel.text!, description: descriptionLabel.text!, url: urlLabel.text!, success: { (id) in
                self.navigationController?.popViewController(animated: true)
                self.validateButton?.isEnabled = true
            }, failure: {
                self.validateButton?.isEnabled = true
            })
        }
        else {
            JKMediator.updateBusiness(id: JKSession.shared.businessId, email: emailLabel.text, name: nameLabel.text, password: passwordLabel.text, address: addressLabel.text, type: typeLabel.text, description: descriptionLabel.text, url: urlLabel.text, success: {
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
        addressLabel.text = place.formattedAddress
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
