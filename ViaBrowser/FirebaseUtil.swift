//
//  FirebaseUtil.swift
//  ViaBrowser
//
//  Created by yangjian on 2022/12/29.
//

import Foundation
import Firebase

class AnalyticsHelper: NSObject {
    static func log(event: AnaEvent, params: [String: Any]? = nil) {
        
        if event.first {
            if UserDefaults.standard.bool(forKey: event.rawValue) == true {
                return
            } else {
                UserDefaults.standard.set(true, forKey: event.rawValue)
            }
        }
        
        if event == .homeShow, BrowserUtil.shared.webItem.isNavigation {
            log(event: .navigaShow)
        }
        
        #if DEBUG
        #else
        Analytics.logEvent(event.rawValue, parameters: params)
        #endif
        
        NSLog("[Event] \(event.rawValue) \(params ?? [:])")
    }
    
    static func log(property: AnaProperty, value: String? = nil) {
        
        var value = value
        
        if property.first {
            if UserDefaults.standard.string(forKey: property.rawValue) != nil {
                value = UserDefaults.standard.string(forKey: property.rawValue)!
            } else {
                UserDefaults.standard.set(Locale.current.regionCode ?? "us", forKey: property.rawValue)
            }
        }
#if DEBUG
#else
        Analytics.setUserProperty(value, forName: property.rawValue)
#endif
        NSLog("[Property] \(property.rawValue) \(value ?? "")")
    }
}

enum AnaProperty: String {
    /// 設備
    case local = "w"
    
    var first: Bool {
        switch self {
        case .local:
            return true
        }
    }
}

enum AnaEvent: String {
    
    var first: Bool {
        switch self {
        case .open:
            return true
        default:
            return false
        }
    }
    
    case open = "e_45"
    case openCold = "r_45"
    case openHot = "h_45"
    case homeShow = "u_45"
    case navigaShow = "i_45"
    case navigaClick = "o_45"
    case navigaSearch = "p_45"
    case cleanClick = "z_45"
    case cleanSuccess = "x_45"
    case cleanAlert = "c_45"
    case tabShow = "b_45"
    case tabNew = "v_45"
    case shareClick = "n_45"
    case copyClick = "m_45"
    case webStart = "k_45"
    case webSuccess = "ll_45"
}
