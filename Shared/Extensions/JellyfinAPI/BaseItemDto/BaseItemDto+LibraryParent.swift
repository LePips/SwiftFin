//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2025 Jellyfin & Jellyfin Contributors
//

import JellyfinAPI

struct LibraryGrouping: Identifiable, Storable {
    let id: String
}

extension BaseItemDto: LibraryParent {

    var groupings: [LibraryGrouping]? {
        guard collectionType == .tvshows else { return nil }
        return [
            .init(id: "Shows"),
            .init(id: "Episodes"),
        ]
    }

    var libraryType: BaseItemKind? {
        type
    }

    func AsupportedItemTypes(for grouping: LibraryGrouping?) -> [BaseItemKind] {
        guard let collectionType else { return [] }

        switch (collectionType, libraryType) {
        case (_, .folder):
            return BaseItemKind.supportedCases
                .appending([.folder, .collectionFolder])
        case (.movies, _):
            return [.movie]
        case (.tvshows, _):
            if let grouping, grouping.id == "Episodes" {
                return [.episode]
            } else {
                return [.series]
            }
        case (.boxsets, _):
            return BaseItemKind.supportedCases
        default:
            return BaseItemKind.supportedCases
        }
    }

    func AisRecursiveCollection(for grouping: LibraryGrouping?) -> Bool {
        guard let collectionType, libraryType != .userView else { return true }

        if let grouping, grouping.id == "Episodes" {
            return true
        }

        return ![.tvshows, .boxsets].contains(collectionType)
    }

    var supportedItemTypes: [BaseItemKind] {
        guard let collectionType else { return [] }

        switch (collectionType, libraryType) {
        case (_, .folder):
            return BaseItemKind.supportedCases
                .appending([.folder, .collectionFolder])
        case (.movies, _):
            return [.movie]
        case (.tvshows, _):
            return [.series]
        case (.boxsets, _):
            return BaseItemKind.supportedCases
        default:
            return BaseItemKind.supportedCases
        }
    }

    var isRecursiveCollection: Bool {
        guard let collectionType, libraryType != .userView else { return true }

        return ![.tvshows, .boxsets].contains(collectionType)
    }
}
