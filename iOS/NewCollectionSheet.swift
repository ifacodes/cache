//
//  NewCollectionSheet.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-03-11.
//

import SwiftUI

struct CollectionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.foregroundColor(.accentColor).frame(width: 105, height: 125).background(
            ZStack{
                RoundedRectangle(cornerRadius: 15, style: .continuous).fill(Color.accentColor.opacity(0.25)).opacity(configuration.isPressed ? 1 : 0)
                RoundedRectangle(cornerRadius: 15, style: .continuous).stroke( Color.accentColor.opacity(0.25), lineWidth: 3).frame(width:75, height: 75).offset(x: 0, y: -12)
            }
        )
    }
}

struct NewCollectionSheet: View {
    var body: some View {
        HStack {
            Spacer()
            Button {
                print("")
            } label: {
                VStack {
                    Image(systemName: "shippingbox").frame(width: 75, height:75).font(.system(size: 50).weight(.light))
                    Text("Cache")
                        .font(.subheadline)
                        .foregroundColor(Color(hue: 0.5, saturation: 0.0, brightness: 0.3))
                }
            }.frame(maxWidth: .infinity).buttonStyle(CollectionButtonStyle())
            Button {
                print("")
            } label: {
                VStack {
                    Text("📦").font(.system(size: 55)).frame(width: 75, height:75).clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    Text("Collection")
                        .font(.subheadline)
                        .foregroundColor(Color(hue: 0.5, saturation: 0.0, brightness: 0.3))
                }
            }.frame(maxWidth: .infinity).buttonStyle(CollectionButtonStyle())
            Button {
                print("")
            } label: {
                VStack {
                    Image(systemName: "plus").font(.title2.weight(.semibold)).imageScale(.large).frame(width: 75, height:75).clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    Text("New Cache")
                        .font(.subheadline)
                        .foregroundColor(Color(hue: 0.5, saturation: 0.0, brightness: 0.3))
                }
            }.frame(maxWidth: .infinity).buttonStyle(CollectionButtonStyle())
            Spacer()
        }
    }
}

struct NewCollectionSheet_Previews: PreviewProvider {
    static var previews: some View {
        NewCollectionSheet()
    }
}
