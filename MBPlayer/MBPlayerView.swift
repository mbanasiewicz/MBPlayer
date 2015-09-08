//
//  MBPlayerView.swift
//  MBPlayer
//
//  Created by Maciej Banasiewicz on 08/09/15.
//  Copyright (c) 2015 Maciej Banasiewicz. All rights reserved.
//

import UIKit
import AVFoundation

public class MBPlayerView: UIView {
    public override class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.blackColor()
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var playerLayer:AVPlayerLayer {
        get {
            return self.layer as! AVPlayerLayer
        }
    }
}