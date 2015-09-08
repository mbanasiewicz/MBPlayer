//
//  MBPlayerViewTests.swift
//  MBPlayer
//
//  Created by Maciej Banasiewicz on 08/09/15.
//  Copyright (c) 2015 Maciej Banasiewicz. All rights reserved.
//

import UIKit
import XCTest
import AVFoundation
import MBPlayer

class MBPlayerViewTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLayerClass() {
        XCTAssert(MBPlayerView.layerClass().self === AVPlayerLayer.self , "Player view has wrong layer class")
    }

}
