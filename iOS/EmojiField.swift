//
//  EmojiField.swift
//  cache (iOS)
//
//  Created by Aoife Bradley on 2022-04-20.
//

import SwiftUI

// MARK: - EmojiInput View

class UIEmojiField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setEmoji() {
        _ = self.textInputMode
    }
    
    override var textInputContextIdentifier: String? {
        ""
    }
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                self.keyboardType = .default
                return mode
            }
        }
        return nil
    }
    
    func addToolBar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func doneAction() {
        self.endEditing(true)
    }
    
}

struct EmojiField: UIViewRepresentable {
    
    @Binding var text: String
    var placeholder: String
    
    init(_ placeholder: String = "", text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    func makeUIView(context: Context) -> UIEmojiField {
        let emojiTextField = UIEmojiField()
        emojiTextField.placeholder = placeholder
        emojiTextField.text = text
        emojiTextField.delegate = context.coordinator
        emojiTextField.addToolBar()
        return emojiTextField
    }
    
    func updateUIView(_ uiView: UIEmojiField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiField
        
        init(_ parent: EmojiField) {
            self.parent = parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                self?.parent.text = textField.text ?? ""
            }
        }
    
    }
    
}
