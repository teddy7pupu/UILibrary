//
//  PermissionDirector.swift
//  iOS-UILib
//
//  Created by Teddy on 2020/3/19.
//  Copyright © 2020 GOONS. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import UserNotifications
import NotificationCenter

struct PermissionDirector {
    
    private init() { }
    
    private static func permissionFactory(for type: PermissionType) -> PermissionSettable {
    
        switch type {
        case .photo:
            return PhotoPermission()
        case .camera:
            return CameraPermission()
        case .location(let locationType):
            return LocationPermission(type: locationType)
        case .notification:
            return NotificationPermission()
        }
    }
    
    public static func isAuthorized(for type: PermissionType) -> Bool {
        
        return permissionFactory(for: type).status == .authorized
    }
    
    static func requestAuthorization(for type: PermissionType, completionHandler: @escaping Handler) {
        
        permissionFactory(for: type).requestAuthorization(completionHandler: completionHandler)
    }
}

// MARK: - Camera Permission

struct CameraPermission: PermissionSettable {
    
    var status: PermissionStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        case .notDetermined:
            return .notDetermined
        case .authorized:
            return .authorized
        default:
            return .denied
        }
    }

    func requestAuthorization(completionHandler: @escaping Handler) {
        
        switch status {
        case .authorized:
            completionHandler(.authorized)
        case .denied, .restricted:
            completionHandler(.unknow)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted { completionHandler(.authorized) }
            }
        }
    }
}

// MARK: - Photo Permission

struct PhotoPermission: PermissionSettable {
    
    var status: PermissionStatus {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        default:
            return .denied
        }
    }
  
    func requestAuthorization(completionHandler: @escaping Handler) {
        
        switch status {
        case .authorized:
            completionHandler(.authorized)
        case .denied, .restricted:
            completionHandler(.unknow)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized { completionHandler(.authorized) }
            }
        }
    }
}

// MARK: - Location Permission

private let locationManager = CLLocationManager()

struct LocationPermission: PermissionSettable {
    
    private let type: PermissionType.LocationType
    
    init(type: PermissionType.LocationType) {
        
        self.type = type
    }

    var status: PermissionStatus {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        case .authorizedAlways:
            return (type == .always || type == .both) ? .authorized : .denied
        case .authorizedWhenInUse:
            return (type == .always || type == .whenInUse || type == .both) ? .authorized : .denied
        case .restricted:
            return .restricted
        default:
            return .denied
        }
    }
  
    func requestAuthorization(completionHandler: @escaping Handler) {
        
        switch status {
        case .authorized:
            completionHandler(.authorized)
        case .denied, .restricted:
            completionHandler(.unknow)
        case .notDetermined:
            type == .always ? locationManager.requestAlwaysAuthorization() : locationManager.requestWhenInUseAuthorization()
        }
    }
}

// MARK: - Notification Permission

struct NotificationPermission: PermissionSettable {
    
    var status: PermissionStatus {
        if #available(iOS 10.0, *) {
            var status = UNAuthorizationStatus.denied
            let sm = DispatchSemaphore(value: 0)
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                status = settings.authorizationStatus
                sm.signal()
            }
            _ = sm.wait(timeout: .now() + 10)

            switch status {
            case .authorized:
                return .authorized
            case .denied, .provisional:
                return .denied
            case .notDetermined:
                return .notDetermined
            default:
                return .denied
            }
        } else {
            return .notDetermined
        }
    }
  
    func requestAuthorization(completionHandler: @escaping Handler) {
        
        switch status {
        case .authorized:
            completionHandler(.authorized)
        case .denied, .restricted:
            completionHandler(.unknow)
        case .notDetermined:
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (granted, _) in
                    granted ? completionHandler(.authorized) : completionHandler(.denied)
                }
            } else {
                let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

// MARK: - protocol

typealias Handler = (PermissionResult) -> ()

enum PermissionType {

  public enum LocationType {
    
    case whenInUse, always, both
  }

  case photo, camera, notification
    
  case location(LocationType)
}

enum PermissionResult {
    
  case authorized, denied, unknow
}

enum PermissionStatus {
    
  case notDetermined, restricted, denied, authorized
}

protocol PermissionSettable {
    
  var status: PermissionStatus { get }
    
  func requestAuthorization(completionHandler: @escaping Handler)
}
