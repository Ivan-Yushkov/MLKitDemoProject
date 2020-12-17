//
//  Presenter.swift
//  MLKitDemoProject
//
//  Created by Иван Юшков on 17.12.2020.
//

import Foundation
import Firebase
import RxSwift

protocol PresenterMainVCProtocol: class {
    func getTextFromImage(visionImage: VisionImage?)
}

class PresenterMainVC: PresenterMainVCProtocol {
    public var mlService: MLServiceProtocol
    private var view: MainViewControllerProtocol
    private let disposeBag = DisposeBag()
    
    init(view: MainViewControllerProtocol, mlService: MLServiceProtocol) {
        self.view = view
        self.mlService = mlService
    }
    
    func getTextFromImage(visionImage: VisionImage?) {
        _ = mlService.runTextRecognizer(visionImage: visionImage)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (text) in
                self.view.updateInterface(text: text)
            })
    }
}
