//
//  AppSetting.swift
//  Clima
//
//  Created by Steven Zhang on 3/22/22.
//

import SwiftUI

class AppSetting: ObservableObject {
    
    static var shared = AppSetting()
    
    // MARK: App Settings
    @Published var content: Setting {
        didSet {
            do {
                let data = try JSONEncoder().encode(content)
                UserDefaults.standard.setValue(data, forKey: "AppSetting")
            } catch {
                print("Tag: \(error)")
            }
        }
    }
    
    init() {
        let data = UserDefaults.standard.object(forKey: "AppSetting") as? Data
        if let data = data {
            do {
                self.content = try JSONDecoder().decode(Setting.self, from: data)
            } catch {
                self.content = Setting()
                print("Tag: \(error)")
            }
        } else {
            self.content = Setting()
        }
    }
    
    /// App Style
    let backgroundOpacity = 1.0
}

extension AppSetting {
    var colorStyle: AppColorStyle {
        content.appColorStyle
    }
}
