//
//  MGAuthenticator.swift
//  MGAuthenticator
//
//  Created by Meng Li on 07/20/2018.
//  Copyright (c) 2018 fczm.pw. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import LocalAuthentication

public enum MGBiometricsType {
    
    case notSupported
    case touchID
    case faceID
    
    public var name: String {
        switch self {
        case .notSupported:
            return "Not Supported"
        case .touchID:
            return "Touch ID"
        case .faceID:
            return "Face ID"
        }
    }
    
}

public enum MGAuthenticatorError {
    
    case failed
    case canceledByUser
    case fallback
    case canceledBySystem
    case passcodeNotSet
    case biometryNotAvailable
    case biometryNotEnrolled
    case biometryLockedout
    case unknown
    case none
    
    init(error: LAError) {
        switch Int32(error.errorCode) {
        case kLAErrorAuthenticationFailed:
            self = .failed
        case kLAErrorUserCancel:
            self = .canceledByUser
        case kLAErrorUserFallback:
            self = .fallback
        case kLAErrorSystemCancel:
            self = .canceledBySystem
        case kLAErrorPasscodeNotSet:
            self = .passcodeNotSet
        case kLAErrorBiometryNotAvailable:
            self = .biometryNotAvailable
        case kLAErrorBiometryNotEnrolled:
            self = .biometryNotEnrolled
        case kLAErrorBiometryLockout:
            self = .biometryLockedout
        default:
            self = .unknown
        }
    }
    
    public var message: String {
        let biometricsName = MGAuthenticator.shared.biometricsType.name
        switch self {
        case .canceledByUser:
            return "Authentication is canceled by user."
        case .passcodeNotSet:
            return "Please set device passcode to use \(biometricsName) for authentication."
        case .biometryNotAvailable:
            return "This device does not support \(biometricsName)"
        case .biometryNotEnrolled:
            return "\(biometricsName) has not been set. Please go to Settings -> \(biometricsName) & Passcode."
        case .biometryLockedout:
            return "\(biometricsName) is locked now, because of too many failed attempts. Enter passcode to unlock \(biometricsName)."
        default:
            return "Unknown reason, try again later."
        }
    }
    
}

open class MGAuthenticator {
    
    public static let shared = MGAuthenticator()
    
    private let context = LAContext()
    
    public var biometricsType: MGBiometricsType {
        if !context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            return .notSupported
        }
        if #available(iOS 11.0, *) {
            switch context.biometryType {
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            case .none:
                return .notSupported
            }
        } else {
            return .touchID
        }
    }

    public func authenticateWithBiometrics(completion: @escaping ((Bool, MGAuthenticatorError) -> Void)) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "MGAuth") { (success, error) in
            if let laError = error as? LAError {
                print("Biometrics failed with error: " + laError.localizedDescription)
                let error = MGAuthenticatorError(error: laError)
                completion(false, error)
            }
            completion(success, .none)
        }
    }
    
    public func authenticateWithPasscode() {
        
    }
    
}
