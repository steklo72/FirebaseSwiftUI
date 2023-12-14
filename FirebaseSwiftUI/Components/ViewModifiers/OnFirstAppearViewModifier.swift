//
//  OnFirstAppearViewModifier.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 11.12.2023.
//

import Foundation
import SwiftUI

struct OnFirstAppearViewModifier: ViewModifier {
    @State private var didAppear: Bool = false
    let perfom: (() -> Void)?
    func body(content: Content) -> some View {
        
        content
            .onAppear {
                if !didAppear {
                    perfom?()
                    didAppear = true
                }
            }
    }
}

extension View {
    func onFirstAppear(perform: (() -> Void)?) -> some View {
        modifier(OnFirstAppearViewModifier(perfom: perform))
    }
}
