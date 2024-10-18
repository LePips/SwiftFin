//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2024 Jellyfin & Jellyfin Contributors
//

import Combine
import Defaults
import Foundation
import JellyfinAPI

// TODO: how to get seconds for current item

class MediaProgressListener: ViewModel, MediaPlayerListener {
    
    @CurrentDate(interval: 5)
    private var currentDate

    weak var manager: MediaPlayerManager? {
        didSet {
            if let manager = manager {
                setup(with: manager)
            }
        }
    }
    
    private var hasSentStart = false
    private weak var item: MediaPlayerItem?
    
    init(manager: MediaPlayerManager?, item: MediaPlayerItem) {
        self.item = item
        self.manager = manager
        super.init()
    }
    
    private func setup(with manager: MediaPlayerManager) {
        cancellables = []
        
//        manager.$playbackItem.sink(receiveValue: playbackItemDidChange).store(in: &cancellables)
        manager.$seconds.sink(receiveValue: secondsDidChange).store(in: &cancellables)
        manager.$state.sink(receiveValue: stateDidChange).store(in: &cancellables)
    }
    
    private func playbackItemDidChange(newItem: MediaPlayerItem?) {
        
        if let item, let seconds = manager?.seconds {
            sendStopReport(for: item, seconds: seconds)
        }
    }
    
    private func stateDidChange(newState: MediaPlayerManager.State) {
        guard let item else { return }
        
        switch newState {
        case .initial, .loadingItem: ()
        case .error, .stopped:
            sendStopReport(for: item, seconds: 0)
        case .playing:
            sendStartReport(for: item, seconds: manager?.seconds ?? 0)
        case .paused:
            sendProgressReport(for: item, seconds: manager?.seconds ?? 0, isPaused: true)
        case .buffering:
            sendProgressReport(for: item, seconds: manager?.seconds ?? 0)
        }
    }
    
    private func secondsDidChange(newSeconds: TimeInterval) {
        
    }
    
    private func sendStartReport(for item: MediaPlayerItem, seconds: TimeInterval) {
        
        hasSentStart = true
        
        #if DEBUG
        guard Defaults[.sendProgressReports] else { return }
        #endif

        Task {
            var info = PlaybackStartInfo()
            info.audioStreamIndex = item.selectedAudioStreamIndex
            info.itemID = item.baseItem.id
            info.mediaSourceID = item.mediaSource.id
            info.playSessionID = item.playSessionID
            info.positionTicks = Int(seconds * 10_000_000)
            info.sessionID = item.playSessionID
            info.subtitleStreamIndex = item.selectedSubtitleStreamIndex
            
            let request = Paths.reportPlaybackStart(info)
            let _ = try await userSession.client.send(request)
        }
    }
    
    private func sendStopReport(for item: MediaPlayerItem, seconds: TimeInterval) {
        
        #if DEBUG
        guard Defaults[.sendProgressReports] else { return }
        #endif
        
        Task {
            var info = PlaybackStopInfo()
            info.itemID = item.baseItem.id
            info.mediaSourceID = item.mediaSource.id
            info.positionTicks = Int(seconds * 10_000_000)
            info.sessionID = item.playSessionID
            
            let request = Paths.reportPlaybackStopped(info)
            let _ = try await userSession.client.send(request)
        }
    }
    
    private func sendProgressReport(for item: MediaPlayerItem, seconds: TimeInterval, isPaused: Bool = false) {
        
        #if DEBUG
        guard Defaults[.sendProgressReports] else { return }
        #endif
        
        Task {
            var info = PlaybackProgressInfo()
            info.audioStreamIndex = item.selectedAudioStreamIndex
            info.isPaused = isPaused
            info.itemID = item.baseItem.id
            info.mediaSourceID = item.mediaSource.id
            info.playSessionID = item.playSessionID
            info.positionTicks = Int(seconds * 10_000_000)
            info.sessionID = item.playSessionID
            info.subtitleStreamIndex = item.selectedSubtitleStreamIndex
            
            let request = Paths.reportPlaybackProgress(info)
            let _ = try await userSession.client.send(request)
        }
    }

    //    func onStateUpdated(newState: VLCVideoPlayer.State) {
    //        guard state != newState else { return }
    //        state = newState

    //        nowPlayable.handleNowPlayableItemChange(
    //            metadata: currentViewModel.nowPlayingMetadata
    //        )
    //
    //        if !hasSentStart, newState == .playing {
    //            hasSentStart = true
    //            sendStartReport()
    //        }
    //
    //        if hasSentStart, newState == .paused {
    //            hasSentStart = false
    //            sendPauseReport()
    //        }
    //
    //        if newState == .stopped || newState == .ended {
    //            sendStopReport()
    //        }
    //    }
}