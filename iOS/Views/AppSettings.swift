//
//  AppSettings.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-04-19.
//

import SwiftUI

extension Bundle {
    var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
           let primary = icons["CFBundlePrimaryIcon"] as? [String: Any],
           let files = primary["CFBundleIconFiles"] as? [String],
           let icon = files.last {
            return UIImage(named: icon)
        }
        return nil
    }
}

struct AppSettings: View {
    
    @State private var deleteAlertToggle: Bool = false
    @State private var iCloudSyncIsOff: Bool = false
    @State private var error: Error?
    @AppStorage("custom_box_name") var customBoxNameToggle: Bool = true
    
    var body: some View {
        ZStack {
            List {
                Section {
                    NavigationLink("About") {
                        ZStack{
                            Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
                            VStack {
                                // App Icon
                                Image(uiImage: Bundle.main.icon ?? UIImage()).clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous)).padding(.top, 40)
                                VStack {
                                    Text("Magpie 0.12.6").padding(.bottom, 0.1)
                                    Text("ifacodes")
                                }.padding()
                                Text("iOS 15.4.1")
                                Spacer()
                            }
                        }.navigationTitle("About")
                    }
                }
                Section {
                    Toggle(isOn: $customBoxNameToggle) {
                        Label{ Text("Custom Box Name")} icon: {
                            Image(systemName: "rectangle.and.pencil.and.ellipsis"
                            ).symbolRenderingMode(.palette).foregroundStyle(.primary, .tint)
                        }.foregroundColor(.primary)
                    }
                } footer: {
                    Text("Toggles custom name dialog for boxes.")
                }
//                Section {
//                    Toggle(isOn: $iCloudSyncIsOff) {
//                        Label("iCloud Sync", systemImage: "icloud.fill").imageScale(.large).symbolRenderingMode(.multicolor)
//                    }
//                    .tint(.red)
//                    .onChange(of: iCloudSyncIsOff) { newValue in
//                        newValue ? deleteAlertToggle.toggle() : NSUbiquitousKeyValueStore.default.set(true, forKey: "icloud_sync")
//                    }
//                    .alert("Are you sure?", isPresented: $deleteAlertToggle) {
//                        if iCloudSyncIsOff {
//                            Button("Delete", role: .destructive) {
//                                NSUbiquitousKeyValueStore.default.set(false, forKey: "icloud_sync")
//    //                            Task{ @MainActor in
//    //                                do {
//    //                                    try await PersistenceController.shared.purgeUserData()
//    //                                } catch {
//    //                                    print("Purge Error \(error)")
//    //                                    self.error = error
//    //                                }
//    //                            }
//                            }
//                            Button("Cancel", role: .cancel) {
//                                withAnimation {
//                                    iCloudSyncIsOff = false
//                                }
//                            }
//                        }
//                    } message: {
//                        Text("This will delete all your data stored on iCloud.")
//                    }.errorAlert(error: $error)
//                } header: {
//                    Text("User Data")
//                } footer: {
//                    Text("Use iCloud to sync between iOS devices.")
//                }
            }.listStyle(.insetGrouped)
        }.navigationTitle("Settings").navigationBarTitleDisplayMode(.inline)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppSettings()
        }
    }
}
