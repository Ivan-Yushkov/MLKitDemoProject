//
//  ConfiguratorMainVC.swift
//  MLKitDemoProject
//
//  Created by Иван Юшков on 17.12.2020.
//

import Foundation

class ConfiguratorMainVC {
    func configure(view: MainViewController, mlService: MLServiceProtocol) {
        let presenter = PresenterMainVC(view: view, mlService: mlService)
        view.presenter = presenter
    }
}
