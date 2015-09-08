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

enum MPPlayerState:Int, Printable {
    case Initial
    case ReadyToPlay
    case Playing
    case Failed
    case Buffering
    
    var description: String {
        get {
            switch self {
            case .Initial: return "Initial"
            case .ReadyToPlay: return "ReadyToPlay"
            case .Playing: return "Playing"
            case .Failed: return "Failed"
            case .Buffering: return "Buffering"
            default:return "Unknown"
        }
        }
    }
}

enum MPPlayerMediaDuration: Printable {
    case Valid(Double)
    case Invalid
    
    init(duration:CMTime) {
        if (duration.flags.rawValue & CMTimeFlags.Valid.rawValue) != 0 {
            self = .Valid(CMTimeGetSeconds(duration))
        } else {
            self = .Invalid
        }
    }
    
    var description: String {
        get {
            switch self {
            case .Valid(let duration): return "\(duration)s"
            case .Invalid: return "Invalid"
            }
        }
    }
}

class MBPlayer:NSObject {
    var view:MBPlayerView = MBPlayerView()
    var currentState:MPPlayerState = .Initial
    var currentMediaDuration:MPPlayerMediaDuration = .Invalid
    var currentPlayheadTime:Double = 0.0
    var currentMediaInfo:MBPlayerMediaInfo? {
        willSet {
            switch newValue {
                case .Some(let mediaInfo):
                    prepareForPlayback(mediaInfo)
                case .None:
                    reset()
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
        currentPlayerItem?.addObserver(self, forKeyPath: "duration", options: NSKeyValueObservingOptions.New, context: nil)
        // TODO: Unregister this stuff later on
        internalPlayer = AVPlayer(playerItem: currentPlayerItem)
        internalPlayer!.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        internalPlayer!.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.New, context: nil)
        view.playerLayer.player = internalPlayer!
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "rate" {
            playing = internalPlayer?.rate == 1.0
        }
        
        if keyPath == "duration" {
            if let currentDuration = currentPlayerItem?.duration {
                currentMediaDuration = MPPlayerMediaDuration(duration: currentDuration)
                println("Duration: \(currentMediaDuration)")
            } else {
                currentMediaDuration = .Invalid
            }
        }
        
        let playerReady = currentPlayerItem?.status == AVPlayerItemStatus.ReadyToPlay
        let playerItemReady = internalPlayer?.status == AVPlayerStatus.ReadyToPlay
        let playerItemFailed = internalPlayer?.status == AVPlayerStatus.Failed
        let playerItemNotReady = internalPlayer?.status == AVPlayerStatus.Unknown
        if playerReady && playerItemReady {
            if playing {
                currentState = .Playing
            } else {
                currentState = .ReadyToPlay
            }
        } else if playerReady && playerItemFailed {
            currentState = .Failed
            // TODO: Handle failure - stop playback
        } else if playerReady && playerItemNotReady {
            currentState = .Buffering
        }
        
        println("Current player state is: \(currentState)")
    }

    func play() {
        internalPlayer?.play()
    }
    
    func pause() {
        internalPlayer?.pause()
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