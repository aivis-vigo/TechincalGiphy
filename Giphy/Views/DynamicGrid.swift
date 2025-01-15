//
//  DynamicGrid.swift
//  Giphy
//
//  Created by Aivis Vigo Reimarts on 14/01/2025.
//

import SwiftUI

struct DynamicGrid<Content: View>: View {
    let content: () -> Content
    
    var body: some View {
        NavigationStack {
            Grid {
                ScrollView {
                    LazyVStack {
                        content()
                    }
                }
            }
        }
    }
}
