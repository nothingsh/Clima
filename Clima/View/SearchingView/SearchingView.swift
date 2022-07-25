//
//  SearchingView.swift
//  Clima
//
//  Created by Steven Zhang on 3/14/21.
//

import SwiftUI

struct SearchingView: View {
    @EnvironmentObject var viewModel: RegionWeatherViewModel
    @ObservedObject var locationModel = LocationModel()
    @Binding var isShow: Bool
    
    var body: some View {
        VStack {
            SearchingBar()
                .environmentObject(locationModel)
                .padding()
            List {
                if locationModel.inputAddress.isEmpty {
                    ForEach(locationModel.favoriatePlacemark, id: \.self) { item in
                        LocationTextRow(location: item.name, action: {
                            viewModel.updateRegion(city: item.name, coordinate: item.coordinate)
                        }, tap_action: { check in
                            if check {
                                locationModel.addItemToFavorite(item: item)
                            } else {
                                locationModel.removeFromFavorite(item: item)
                            }
                        }, isShow: $isShow, tapped: true)
                    }
                } else {
                    ForEach(locationModel.cities, id: \.self) { item in
                        let entry = FavoritePlacemark(name: item.name!, coordinate: item.location!.coordinate.local)
                        LocationTextRow(location: item.placeName, action: {
                            viewModel.updateRegion(city: item.regionName, coordinate: item.location?.coordinate.local)
                        }, tap_action: { check in
                            if check {
                                locationModel.addItemToFavorite(item: entry)
                            } else {
                                locationModel.removeFromFavorite(item: entry)
                            }
                        }, isShow: $isShow, tapped: locationModel.checkItemInFovorite(item: entry))
                    }
                }
            }
        }
    }
}

struct LocationTextRow: View {
    let location: String
    let action: () -> Void
    let tap_action: (Bool) -> Void
    @Binding var isShow: Bool
    
    @State var tapped = false
    var isCurrent = false
    
    var body: some View {
        HStack {
            Button(action: {
                isShow = false
                action()
            }, label: {
                VStack {
                    Text(location)
                        .font(isCurrent ? .headline : .body)
                    if isCurrent {
                        Text("Current Location")
                            .font(.caption)
                    }
                }
            })
            Spacer()
            Image(systemName: "heart.fill")
                .foregroundColor(tapped ? Color.red : Color.gray)
                .onTapGesture(perform: {
                    tapped.toggle()
                    tap_action(tapped)
                })
        }
    }
}

struct SearchingView_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
    
    struct Preview: View {
        @State var isShowing = true
        
        var body: some View {
            SearchingView(isShow: $isShowing)
        }
    }
}
