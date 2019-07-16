//
//  TextField.swift
//  Wrath
//
//  Created by Thomas Loring on 7/10/19.
//  Copyright © 2019 Thomas Loring. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func addDoneToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        let done = UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        done.tintColor = UIColor.init(named: "FeriKey")
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            done
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
}
