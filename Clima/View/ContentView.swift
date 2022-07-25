//
//  ContentView.swift
//  Clima
//
//  Created by Steven Zhang on 3/6/21.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var viewModel: RegionWeatherViewModel
    @State var searchingView = false
    
    // Navigation Links
    @State var activiteMap = false
    
    var body: some View {
        ZStack {
            AppSetting.shared.colorStyle.backgroundColor
                .edgesIgnoringSafeArea(.all)
            NavigationLink(
                destination: MapViewPage().environmentObject(viewModel),
                isActive: $activiteMap,
                label: { EmptyView() }
            )
            VStack(spacing: 0) {
                ContentHeaderView(seachingBar: $searchingView, floatingMenu: $activiteMap)
                WeatherContentView(searchingBar: $searchingView)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $searchingView, content: {
            SearchingView(isShow: $searchingView)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(RegionWeatherViewModel())
    }
}
