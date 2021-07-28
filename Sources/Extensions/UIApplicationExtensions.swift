//
//  File.swift
//  
//
//  Created by Stephen Hayes on 7/28/21.
//

import UIKit

extension UIApplication {
    
    var firstKeyWindow: UIWindow? {
        return connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }.first
    }
}
