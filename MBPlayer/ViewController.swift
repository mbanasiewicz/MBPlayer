//
//  ViewController.swift
//  MBPlayer
//
//  Created by Maciej Banasiewicz on 08/09/15.
//  Copyright (c) 2015 Maciej Banasiewicz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    let player:MBPlayer = MBPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(player.view)
        player.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        let views = ["playerView":player.view]
        let xConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|[playerView]|", options: .AlignAllTop, metrics: nil, views: views)
        let yConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(20)-[playerView(200)]", options: .AlignAllTop, metrics: nil, views: views)
        view.addConstraints(xConstraints)
        view.addConstraints(yConstraints)
        player.playVideoAtURL(NSURL(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")!)
        player.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("handlePlayerViewTap")))

    }
    
    func handlePlayerViewTap() {
        if player.playing {
            player.pause()
        } else {
            player.play()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

