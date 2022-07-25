//
//  ContentHeaderView.swift
//  Clima
//
//  Created by Steven Zhang on 6/18/21.
//

import Foundation
import SwiftUI

struct ContentHeaderView: View {
    @EnvironmentObject var viewModel: RegionWeatherViewModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @Binding var seachingBar: Bool
    @Binding var floatingMenu: Bool
    let height: CGFloat = 60
    
    var body: some View {
        HStack {
            Button(action: {
                seachingBar = true
            }, label: {
                HStack {
                    Image(systemName: "line.horizontal.3.decrease")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    Text(viewModel.region.name ?? "World")
                        .font(.headline)
                }
            })
            Spacer()
            
            Spacer()
            Button(action: {
                floatingMenu = true
            }, label: {
                Image(systemName: "map")
                    .font(.title2)
            })
        }
        .padding(.horizontal)
        .frame(height: height)
    }
}

struct ContentHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ContentHeaderView(seachingBar: .constant(true), floatingMenu: .constant(true))
            .environmentObject(RegionWeatherViewModel())
    }
}
