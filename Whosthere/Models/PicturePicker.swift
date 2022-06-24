//
//  PicturePicker.swift
//  Whosthere
//
//  Created by Moose on 03.04.22.
//

import SwiftUI
import AVFoundation

enum PicturePicker {
    enum Source {
        case library, camera
    }
    
    enum PickerError: Error, LocalizedError {
        case unavailable
        case restriced
        case denied
        
        var errorDescription: String? {
            switch self {
            case .unavailable:
                return NSLocalizedString("There is no available camera on the device", comment: "")
            case .restriced:
                return NSLocalizedString("You are not allowed to access media capture devices", comment: "")
            case .denied:
                return NSLocalizedString("You are have explicitly denied permission for media capture. Please open permissions/Privacy/Camera and grant access for this application", comment: "")
            }
        }
    }
    
    static func checkPermissions()throws {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch authStatus {
            case .denied:
                throw PickerError.denied
            case .restricted:
                throw PickerError.restriced
            default:
                break
            }
        } else {
            throw PickerError.unavailable
        }
    }
    
    struct CameraErrorType {
        let error: PicturePicker.PickerError
        var message: String {
            error.localizedDescription
        }
        let button = Button{ }
                        label: {
            Text("Ok")
        }
    }
    
}
