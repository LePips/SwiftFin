//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2023 Jellyfin & Jellyfin Contributors
//

import AlwaysPopover
import SwiftUI

struct LongPressResetModifier<Value>: ViewModifier {
    
    @State
    private var flashing = false
    @State
    private var isPresentingPopover = false
    
    let binding: Binding<Value>
    let toValue: Value
    
    func body(content: Content) -> some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onLongPressGesture {
                    isPresentingPopover = true
                }
            
            content
        }
        .alwaysPopover(isPresented: $isPresentingPopover) {
            Button {
                binding.wrappedValue = toValue
                isPresentingPopover = false
                flashing = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.flashing = false
                }
            } label: {
                Text("Reset")
                    .padding()
                    .background(Color.secondary)
            }
        }
    }
}
