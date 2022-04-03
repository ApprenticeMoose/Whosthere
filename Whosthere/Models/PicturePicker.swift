//
//  PicturePicker.swift
//  Whosthere
//
//  Created by Moose on 03.04.22.
//

import UIKit

enum PicturePicker {
    enum Source {
        case library, camera
    }
    
    static func checkPermissions() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            return true
        } else {
            return false
        }
            
    }
}
