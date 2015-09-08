//
//  MBPlayer.swift
//  MBPlayer
//
//  Created by Maciej Banasiewicz on 08/09/15.
//  Copyright (c) 2015 Maciej Banasiewicz. All rights reserved.
//

import Foundation
import AVFoundation

struct MBPlayerMediaInfo {
    var streamURL:NSURL
    init(streamURL:NSURL) {
        self.streamURL = streamURL
    }
}

enum MPPlayerState:Int {
    case Initial
    case ReadyToPlay
    case Playing
    case Failed
}

class MBPlayer:NSObject {
    var view:MBPlayerView = MBPlayerView()
    var currentState:MPPlayerState = .Initial
    var currentMediaInfo:MBPlayerMediaInfo? {
        willSet {
            switch newValue {
                case .Some(let mediaInfo):
                    self.prepareForPlayback(mediaInfo)
                case .None:
                    self.reset()
            }
        }
    }
    private var internalPlayer:AVPlayer? {
        willSet {
            internalPlayer?.removeObserver(self, forKeyPath: "status")
        }
    }
    private var currentPlayerItem:AVPlayerItem? {
        willSet {
            currentPlayerItem?.removeObserver(self, forKeyPath: "status")
        }
    }
    
    var playing:Bool = false
    
    private func prepareForPlayback(mediaInfo:MBPlayerMediaInfo) {
        if let internalPlayer:AVPlayer = internalPlayer {
            internalPlayer.pause()
        }
        currentPlayerItem = nil
        internalPlayer = nil
        currentPlayerItem = AVPlayerItem(URL: mediaInfo.streamURL)
        currentPlayerItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        internalPlayer = AVPlayer(playerItem: currentPlayerItem)
        internalPlayer!.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        internalPlayer!.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.New, context: nil)
        view.playerLayer.player = internalPlayer!
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "rate" {
            playing = internalPlayer?.rate == 1.0
        }
        
        let playerReady = currentPlayerItem?.status == AVPlayerItemStatus.ReadyToPlay
        let playerItemReady = internalPlayer?.status == AVPlayerStatus.ReadyToPlay
        let playerItemFailed = internalPlayer?.status == AVPlayerStatus.Failed
        if playerReady && playerItemReady {
            if playing {
                currentState = .Playing
            } else {
                currentState = .ReadyToPlay
            }
        } else if playerReady && playerItemFailed {
            currentState = .Failed
            // TODO: Handle failure - stop playback
        }
    }

    func play() {
        internalPlayer?.play()
    }
    
    override init() {
        super.init()
        
    }
    
    func reset() {
        // Reset whole player, stop EVERYTHING!
        
    }
    
    func playVideoAtURL(url:NSURL) {
        currentMediaInfo = nil
        currentMediaInfo = MBPlayerMediaInfo(streamURL: url)
    }
    
}