//
//  ViewExtensions.swift
//  Giphy
//
//  Created by Aivis Vigo Reimarts on 14/01/2025.
//

import SwiftUI

extension View {
    func alert(isPresented: Binding<Bool>, withError error: GifError?) -> some View {
        return alert(
            "Ups! :(",
            isPresented: isPresented,
            actions: {
                Button("Ok") {}
            },
            message: {
                Text("\(error?.localizedDescription ?? "-") \n\n \(error?.recoverySuggestion ?? "-")")
            }
        )
    }
}
