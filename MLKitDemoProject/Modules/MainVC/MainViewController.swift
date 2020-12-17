//
//  ViewController.swift
//  MLKitDemoProject
//
//  Created by Иван Юшков on 14.12.2020.
//

import UIKit
import SnapKit
import Firebase


protocol MainViewControllerProtocol: class {
    func updateInterface(text: String?)
}

class MainViewController: UIViewController, MainViewControllerProtocol {

    private var imageView = UIImageView()
    public var presenter: PresenterMainVCProtocol?
    private var scanTextButton = UIButton()
    private var scanImageButton = UIButton()
    private var visionImage: VisionImage!
    
    
    var label = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfiguratorMainVC().configure(view: self, mlService: DI.resolve())
        setupImageView()
        //initializeMLModel()
        setupScanTextButton()
        setupScanImageButton()
        setupLable()
        
    }

    //MARK: - create image view and tap gesture with action
    private func setupImageView() {
        guard let image = UIImage(named: "textNewYork") else { return }
        imageView.image = image
        visionImage = VisionImage(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .brown
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
    
    //MARK: - Create buttons and action for buttons
    
    private func setupScanTextButton() {
        scanTextButton.setTitle("Scan text", for: .normal)
        scanTextButton.setTitleColor(.brown, for: .normal)
        scanTextButton.layer.borderWidth = 0.4
        scanTextButton.layer.borderColor = UIColor.brown.cgColor
        scanTextButton.layer.cornerRadius = 7
        view.addSubview(scanTextButton)
        
        scanTextButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(70)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
        scanTextButton.addTarget(self, action: #selector(buttonActionText), for: .touchUpInside)
    }
    
    @objc func buttonActionText() {
        presenter?.getTextFromImage(visionImage: visionImage)
    }
    
    private func setupScanImageButton() {
        scanImageButton.setTitle("Scan image", for: .normal)
        scanImageButton.setTitleColor(.brown, for: .normal)
        scanImageButton.layer.borderWidth = 0.4
        scanImageButton.layer.borderColor = UIColor.brown.cgColor
        scanImageButton.layer.cornerRadius = 7
        view.addSubview(scanImageButton)
        
        scanImageButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(scanTextButton.snp.bottom).offset(70)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        scanImageButton.addTarget(self, action: #selector(buttonActionImage), for: .touchUpInside)
    }
    
    @objc func buttonActionImage() {
      
    }
    
    //MARK: - create Lable
    func setupLable() {
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.numberOfLines = 0
        view.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(100)
            make.top.equalToSuperview().offset(70)
        }
        
    }
    
    public func updateInterface(text: String?) {
        label.text = text
    }
    

    
    
    
}
//MARK: - Work with image
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        guard let image = info[.editedImage] as? UIImage else { return }
        imageView.image = image
        visionImage = VisionImage(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}
