//
//  ObservableObject+Extensions.swift
//  CogSmart
//
//  Created by longnh on 2023/04/19.
//

import SwiftUI

extension ObservableObject {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
        )
    }
}
