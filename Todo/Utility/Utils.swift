//
//  Utils.swift
//  Todo
//
//  Created by Dayal, Utkarsh on 26/05/21.
//

import SwiftUI

let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
