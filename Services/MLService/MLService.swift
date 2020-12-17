//
//  MLService.swift
//  MLKitDemoProject
//
//  Created by Иван Юшков on 17.12.2020.
//

import Foundation
import Firebase
import RxSwift

protocol MLServiceProtocol: class {
    func runTextRecognizer(visionImage: VisionImage?) -> Observable<String?>
}

class MLService: MLServiceProtocol {
    
    var textRecognizer: VisionTextRecognizer!
    var text = PublishSubject<String?>()
    private var imageLabeler: VisionImageLabeler?
    
    init() {
        let vision = Vision.vision()
        textRecognizer = vision.onDeviceTextRecognizer()
    }
    
    public func runTextRecognizer(visionImage: VisionImage?) -> Observable<String?> {
        guard let visionImage = visionImage else { return Observable.empty() }
        textRecognizer.process(visionImage) { (visionText, error) in
            guard let features = visionText else { return }
            var recognizedText = ""
            for block in features.blocks {
                for line in block.lines {
                    for element in line.elements {
                        recognizedText += " \(element.text)"
                    }
                }
            }
            self.text.onNext(recognizedText)
        }
        return text.debounce(.seconds(0), scheduler: MainScheduler.instance)
    }
    
    //MARK: - Work with ML Model
    private func initializeMLModel() {
       
        let manifestPath = Bundle.main.path(forResource: "manifest",
                                                   ofType: "json",
                                                   inDirectory: "rpsModel")
        let myLocalModel = AutoMLLocalModel(manifestPath: manifestPath!)
        let labelerOption = VisionOnDeviceAutoMLImageLabelerOptions(localModel: myLocalModel)
        labelerOption.confidenceThreshold = 0.5
        imageLabeler = Vision.vision().onDeviceAutoMLImageLabeler(options: labelerOption)
    }
    
    private func performVisionImage(visionImage: VisionImage?) {
        guard let visionImage = visionImage else { return }
        imageLabeler?.process(visionImage, completion: { (labels, error) in
            if let error = error {
                print(error)
            }
            guard let labels = labels else { return }
            if labels.count == 0 {
                
            }
            for visionLabel in labels {
                let confidenceString = String(visionLabel.confidence?.doubleValue ?? 0 * 100)
                let resultString = "\(visionLabel.text) ---- \(confidenceString)% точности"
                print(resultString)
                
            }
        })
    }
}
