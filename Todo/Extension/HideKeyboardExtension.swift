//
//  HideKeyboardExtension.swift
//  Todo
//
//  Created by Dayal, Utkarsh on 26/05/21.
//

import SwiftUI

#if canImport(UIKit)
extension View{
    func hideKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
