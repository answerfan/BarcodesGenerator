//
//  ViewController.swift
//  Barcodes
//
//  Created by Александр Борискин on 28.10.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var barcodeImage: UIImageView!
    @IBOutlet weak var widthLabel: UITextField!
    @IBOutlet weak var heightLabel: UITextField!
    @IBOutlet weak var codeLabel: UITextField!

    private var selectedType: Descriptor = .qr

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        picker.dataSource = self
        picker.delegate = self
    }

    @IBAction func generateBarcode(_ sender: Any) {

        guard let width = widthLabel.text,
              let height = heightLabel.text,
              let intWidth = Int(width),
              let intHeight = Int(height),
              let codeString = codeLabel.text,
              codeString.count > 0
        else {
            showAlert()
            return
        }

        if let ciImage = BarcodeGenerator.generate(
            from: codeString,
            descriptor: selectedType,
            size: CGSize(width: intWidth, height: intHeight)
        ) {
            let image = UIImage(ciImage: ciImage)
            DispatchQueue.main.async {
                self.barcodeImage.image = nil
                self.barcodeImage.image = image
            }
        } else {
            showAlert()
        }
    }

    private func showAlert() {
        let alert = UIAlertController(
            title: "Error",
            message: "Data not set",
            preferredStyle: .alert
        )

        let action = UIAlertAction(
            title: "OK",
            style: .default) { (_) in
            alert.dismiss(animated: true)
        }

        alert.addAction(action)

        navigationController?.present(
            alert,
            animated: true
        )
    }
}

extension ViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Descriptor.allCases.count
    }
}

extension ViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let set = Descriptor.allCases
        return set[row].displayName()
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = Descriptor.allCases[row]
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
