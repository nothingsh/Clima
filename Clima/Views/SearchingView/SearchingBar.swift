//
//  SearchingBar.swift
//  Clima
//
//  Created by Steven Zhang on 3/14/21.
//

import SwiftUI

struct SearchingBar: View {
    @EnvironmentObject var locationModel: LocationModel

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $locationModel.inputAddress,
                      onCommit: {
                locationModel.convertCityNameToPlacemark()
            })
            .autocapitalization(.none)
            .disableAutocorrection(true)
        }
        .padding(EdgeInsets(top: 10, leading: 6, bottom: 10, trailing: 6))
        .foregroundColor(.secondary)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10.0)
    }
}

struct SearchingBar_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
    
    struct Preview: View {
        @State var searchingText = ""

        var body: some View {
            SearchingBar()
                .environmentObject(LocationModel())
        }
    }
}
