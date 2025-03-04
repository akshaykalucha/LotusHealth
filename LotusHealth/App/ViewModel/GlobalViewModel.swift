//
//  ContentViewModel.swift
//  LotusHealth
//
//  Created by Akshay Kalucha on 2/28/25.
//


import Foundation
import SwiftUI
import UIKit



class GlobalViewModel: ObservableObject {
    
    //MARK: AlertButton()
    func alertButton(passedText : String) {
        let alert = UIAlertController(title: "Warning", message:  passedText, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            alert.isModalInPresentation = true
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
}
