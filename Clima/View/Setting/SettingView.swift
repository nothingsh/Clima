//
//  SettingView.swift
//  Clima
//
//  Created by Steven Zhang on 3/24/21.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject var settings = AppSetting()
    
    var body: some View {
        Form {
            // sound and vibration effect when alerting
            Section {
                Toggle(isOn: $settings.content.sound, label: {
                    Text("Sound")
                })
                Toggle(isOn: $settings.content.vibration, label: {
                    Text("Vibration")
                })
            }
            
            Section {
                Picker(selection: $settings.content.language, label: Text("Language"), content: {
                    Text("Chinese").tag(Language.Chinese)
                    Text("English").tag(Language.English)
                })
                
                Picker(selection: $settings.content.units, label: Text("Units"), content: {
                    Text("(km ,m2)").tag(Units.metric)
                    Text("(miles, ft2)").tag(Units.imperial)
                })
                
                Picker(selection: $settings.content.temperature_type, label: Text("Temperature Scale"), content: {
                    Text("Faherenheit (°F)").tag(TemperatureScale.fahrenheit)
                    Text("Celsius (°C)").tag(TemperatureScale.celsius)
                })
            }

            Section {
                NavigationLink(
                    destination: Text("Terms and Conditions"),
                    label: {
                        Text("Terms and Conditions")
                    })
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                }
            }
        }.navigationBarTitle("Settings", displayMode: .inline)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
