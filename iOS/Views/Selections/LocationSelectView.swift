//
//  LocationSelectView.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-02-28.
//

import SwiftUI

struct LocationSelectView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var location: Location
    var body: some View {
        List {
            ForEach(Location.allCases, id: \.self) {l in
                Section {
                    Button(String(describing: l)) {
                        location = l
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

private struct LocationSelectViewPreviewView: View {
    @State var location: Location = .onPerson
    var body: some View {
        LocationSelectView(location: $location)
    }
}

struct LocationSelectView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSelectViewPreviewView()
    }
}
