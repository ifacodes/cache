//
//  Alert.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-03-21.
//

import SwiftUI

// MARK: The SwiftUI alert sucks rn and I can't have text entry, so back to UIKit we go.

/// Defines the properties of `UIAlertController`
@available(iOS 15.0, *)
public struct UIKitAlertPreferences {
    /// Set the title of the alert
    public var title: String
    /// Set the message of the alert
    /// Default: `""`
    public var message: String = ""
    /// Set the placeholder of the `TextField`
    /// Default: `""`
    public var placeholder: String = ""
    /// Set the title of the left `UIAlertAction`
    /// Default: `"OK`
    public var accept: String = "OK"
    /// Set the title of the right `UIAlertAction`
    /// Default: `"OK`
    public var cancel: String? = "Cancel"
    /// The `UIKeyboardType` of the sheet for user entry into the `TextField` when presented.
    /// Default: `.default`
    public var keyboardType: UIKeyboardType = .default
}

extension UIAlertController {
    convenience init(preferences: UIKitAlertPreferences, action: @escaping (String?) -> Void, dismiss: @escaping () -> Void) {
        self.init(title: preferences.title, message: preferences.message, preferredStyle: .alert)
        
        /// 2.  Create the action to be assigned to the confirmation button.
        let confirmAction = UIAlertAction(title: preferences.accept, style: .default) { _ in
            if let textField = self.textFields?.first, let text = textField.text {
                action(text)
            }
            self.dismiss(animated: true) {
                dismiss()
            }
        }
        
        /// 3.  Create the action to be assigned to the cancel button.
        let cancelAction = UIAlertAction(title: preferences.cancel, style: .cancel) { _ in
            self.dismiss(animated: true) {
                dismiss()
            }
        }
        
        /// 4.  Add the `TextField` using the passed `UIKitAlertPreferences` struct
        addTextField {
            $0.placeholder = preferences.placeholder
            $0.keyboardType = preferences.keyboardType
            $0.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        /// 5. Assign created `UIAlertAction`'s to the `UIAlertController`
        confirmAction.isEnabled = false
        addAction(confirmAction)
        addAction(cancelAction)
        
    }
    
    @objc func alertTextFieldDidChange(_ sender: UITextField) {
        self.actions.first!.isEnabled = sender.text!.count > 0
    }
}

struct UIKitAlertControllerRepresentable: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    let preferences: UIKitAlertPreferences
    let action: (String?) -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        guard context.coordinator.alert == nil else { return }
        
        if isPresented {
            let alert = UIAlertController(preferences: preferences, action: action) {
                isPresented = false
            }
            context.coordinator.alert = alert
            
            Task { @MainActor in
                uiViewController.present(alert, animated: true, completion: {
                    isPresented = false
                    context.coordinator.alert = nil
                })
            }
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator {
        
        var alert: UIAlertController?
        
        var parent: UIKitAlertControllerRepresentable
        init(_ parent: UIKitAlertControllerRepresentable) {
            self.parent = parent
        }
        
    }
    
}

struct AlertModifier: ViewModifier {
    
    let isPresented: Binding<Bool>
    let preferences: UIKitAlertPreferences
    let content: (String?) -> Void
    
    func body(content: Content) -> some View {
        content.background(UIKitAlertControllerRepresentable(isPresented: isPresented, preferences: preferences, action: self.content))
    }
}

extension View {
    /// Presents an alert when the binding to a `Bool` you provide is `true`
    ///
    /// Use this method when you want to present an alert view using an `@State` of type `Bool`
    /// to conditonally display a modal.
    ///  - Parameters
    ///   - isPresented:
    ///   - preferences: the `UIKitAlertPreferences` used to configure the presented alert.
    public func alert(isPresented: Binding<Bool>, preferences: UIKitAlertPreferences, content: @escaping (String?) -> Void) -> some View {
        self.modifier(AlertModifier(isPresented: isPresented, preferences: preferences, content: content))
    }
}

extension UIHostingController {
    convenience public init(rootView: Content, ignoreSafeArea: Bool) {
        self.init(rootView: rootView)
        
        if ignoreSafeArea {
            guard let viewClass = object_getClass(view) else {return}
            let viewSubclassName = String(cString: class_getName(viewClass)).appending("_IgnoreSafeArea")
            if let viewSubclass = NSClassFromString(viewSubclassName) {
                object_setClass(view, viewSubclass)
            } else {
                guard let viewClassNameUtf8 = (viewSubclassName as NSString).utf8String else {return}
                guard let viewSubclass = objc_allocateClassPair(viewClass, viewClassNameUtf8, 0) else {return}
                if let method = class_getInstanceMethod(UIView.self, #selector(getter: UIView.safeAreaInsets)) {
                    let safeAreaInsets: @convention(block) (AnyObject) -> UIEdgeInsets = { _ in
                        return .zero
                    }
                    class_addMethod(viewSubclass, #selector(getter: UIView.safeAreaInsets), imp_implementationWithBlock(safeAreaInsets), method_getTypeEncoding(method))
                }
            }
        }
    }
}

struct AlertPreview: View {
    @State private var isPresented: Bool = false
    var body: some View {
        Button(isPresented ? "Presented!" : "Present!") {
            isPresented = true
        }.alert(isPresented: $isPresented, preferences: UIKitAlertPreferences(title: "title", message: "message")) { result in
            if let text = result {
                print("Submitted Text: \(text)")
            } else {
                print("Cancelled")
            }
        }
    }
}

struct Alert_Previews: PreviewProvider {
    static var previews: some View {
        AlertPreview()
    }
}
