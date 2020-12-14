//
//  ViewController.swift
//  MLKitDemoProject
//
//  Created by Иван Юшков on 14.12.2020.
//

import UIKit
import SnapKit
import Firebase

class ViewController: UIViewController {

    private var imageView = UIImageView()
   
    private var scanButton = UIButton()
    
    var textRecognizer: VisionTextRecognizer!
    var label = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        let vision = Vision.vision()
        textRecognizer = vision.onDeviceTextRecognizer()
        setupButton()
        setupLable()
        
    }

    //MARK: - create image view and tap gesture with action
    private func setupImageView() {
        guard let image = UIImage(named: "StandartPhoto") else { return }
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        view.addSubview(imageView)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(createTapGesture())
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(250)
        }
    }
    
    private func createTapGesture() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        return tap
    }
    
    @objc func tapAction() {
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")
        
        let alerSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alerSheet.addAction(camera)
        alerSheet.addAction(photo)
        alerSheet.addAction(cancel)
        present(alerSheet, animated: true, completion: nil)
    }
    
    //MARK: - Create button and action for button
    
    private func setupButton() {
        scanButton.setTitle("Scan image", for: .normal)
        scanButton.setTitleColor(.brown, for: .normal)
        view.addSubview(scanButton)
        
        scanButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(70)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
        scanButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc func buttonAction() {
        runTextRecognizer(image: imageView.image!)
    }
    
    //MARK: - create Lable
    func setupLable() {
        label.textAlignment = .center
        label.backgroundColor = .clear
        view.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(100)
            make.top.equalToSuperview().offset(70)
        }
    }
    
    //MARK: - text recognize methods
    private func runTextRecognizer(image: UIImage) {
        let visionImage = VisionImage(image: image)
        textRecognizer.process(visionImage) { (visionText, error) in
            self.processResult(text: visionText, error: error)
        }
    }
    
    private func processResult(text: VisionText?, error: Error?) {
        guard let features = text, let image = imageView.image else { return }
        for block in features.blocks {
            for line in block.lines {
                for element in line.elements {
                    self.label.text = element.text
                }
            }
        }
    }
    
}

//MARK: - Work with image
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    fileprivate func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.editedImage] as? UIImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}
