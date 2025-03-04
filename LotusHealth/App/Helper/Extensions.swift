//
//  Extensions.swift
//  LotusHealth
//
//  Created by Akshay Kalucha on 2/28/25.
//

// extensions for app
import Foundation
import SwiftyJSON
import SwiftUI


// a protocol which can be extended
protocol InforForKey {
    func infoForKey(_ key: String)
}

// view and NSObject can subscribe to same protocol instead of writing function again n again
extension View {
    func infoForKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
    }
}


// Print json data
public func getDataFrom(JSON json: JSON) -> Data? {
    do {
        return try json.rawData(options: .prettyPrinted)
    } catch _ {
        return nil
    }
}


// Get sensetive info from config
public func infoForKey(_ key: String) -> String? {
    return (Bundle.main.infoDictionary?[key] as? String)?
        .replacingOccurrences(of: "\\", with: "")
}



// Global Color Themes
enum Constants {
    static let backgroundColor = Color(red: 0.96, green: 0.91, blue: 0.85) // Sand white
    static let accentColor = Color(red: 0.76, green: 0.65, blue: 0.52) // Light brown
    static let textColor = Color(red: 0.35, green: 0.28, blue: 0.20) // Dark brown
}


// Trim Leading Spaces in a string
extension String {
    func trim() -> String {
    return self.trimmingCharacters(in: .whitespaces)
   }
}


extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }

    // To make it works also with ScrollView
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
