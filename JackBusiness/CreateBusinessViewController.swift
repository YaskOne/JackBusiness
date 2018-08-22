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

enum RegisterBusinessFormField: Int {
    case name
    case address
    case type
    case description
    case url
}

class CreateBusinessViewController: UIViewController {

    @IBOutlet weak var nameLabel: AFormLabel!
    @IBOutlet weak var addressLabel: AFormLabel!
    @IBOutlet weak var typeLabel: AFormLabel!
    @IBOutlet weak var descriptionLabel: AFormLabel!
    @IBOutlet weak var urlLabel: AFormLabel!
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var addressInput: UITextField!
    @IBOutlet weak var typeInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextField!
    @IBOutlet weak var urlInput: UITextField!
    
    var formFields: [RegisterBusinessFormField: AFormField] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Validate", style: .plain, target: self, action: #selector(validateTapped))
        
        formFields[.name] = AFormField(input: nameInput, label: nameLabel, defaultValue: "") {
            return self.nameInput.text != "" ? FormStatus.valid : FormStatus.invalid
        }
        formFields[.address] = AFormField(input: addressInput, label: addressLabel, defaultValue: "") {
            return self.addressInput.text != "" ? FormStatus.valid : FormStatus.invalid
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
    
    @objc func validateTapped() {
        for field in formFields {
            if field.value.formStatus == .invalid
                || (field.value.formStatus == .none && field.value.mandatory) {
                return
            }
        }
        
        JKMediator.createBusiness(name: nameInput.text!, address: addressInput.text!, type: typeInput.text!, description: descriptionInput.text!, url: urlInput.text!, success: { (id) in
            self.navigationController?.popViewController(animated: true)
        }, failure: {
            
        })
        
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
