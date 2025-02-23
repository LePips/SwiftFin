//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2025 Jellyfin & Jellyfin Contributors
//

import Defaults
import Factory
import Get
import SwiftUI

// TODO: should use environment refresh instead?
struct ErrorView<ErrorType: Error>: View {

    private let error: ErrorType
    private var onRetry: (() -> Void)?
    private let title: String?

    private var is401APIError: Bool {
        guard let error = error as? Get.APIError,
              case let Get.APIError.unacceptableStatusCode(code) = error,
              code == 401
        else {
            return false
        }
        return true
    }

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 72))
                .foregroundColor(Color.red)

            if let title {
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }

            Text(error.localizedDescription)
                .frame(minWidth: 50, maxWidth: 240)
                .multilineTextAlignment(.center)

            if let onRetry {
                PrimaryButton(title: L10n.retry)
                    .onSelect(onRetry)
                    .frame(maxWidth: 300)
                    .frame(height: 50)
            }

            if is401APIError {
                PrimaryButton(title: L10n.switchUser, role: .destructive)
                    .onSelect {
                        Defaults[.lastSignedInUserID] = .signedOut
                        Container.shared.currentUserSession.reset()
                        Notifications[.didSignOut].post()
                    }
                    .frame(maxWidth: 300)
                    .frame(height: 50)
            }
        }
    }
}

extension ErrorView {

    init(_ title: String? = nil, error: ErrorType) {
        self.init(
            error: error,
            onRetry: nil,
            title: title
        )
    }

    func onRetry(_ action: @escaping () -> Void) -> Self {
        copy(modifying: \.onRetry, with: action)
    }
}
