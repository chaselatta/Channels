//
//  ChannelWrapperTests.swift
//  Channels
//
//  Created by Chase Latta on 11/25/15.
//  Copyright © 2015 Chase Latta. All rights reserved.
//

import XCTest
@testable import Channels

class ChannelWrapperTests: XCTestCase {
    
    let sink = ChannelSink()
    var channel: Channel<String>!
    
    override func setUp() {
        super.setUp()
        channel = Channel(sink: sink)
    }
    
    override func tearDown() {
        channel = nil
        super.tearDown()
    }
    
    func testDispatchDispatchedToSpecifiedQueue() {
        var value = "value"
        var key = "key"
        let queue = dispatch_get_global_queue(0, 0)
        dispatch_queue_set_specific(queue, &key, &value, nil)
        
        let expectation = expectationWithDescription("Waiting on send")
        
        let handler: (AnyObject, String) -> () = ChannelWrapper.dispatch(queue) { (_, _) in
            let queueValue = dispatch_get_specific(&key)
            XCTAssertTrue(queueValue == &value)
            expectation.fulfill()
        }
        
        channel.registerListener(self, handler: handler)
        self.sink.send("Hello")
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    func testOnceOnlyInvokedOnce() {
        var count = 0
        
        let handler: (AnyObject, String) -> () = ChannelWrapper.once(channel) { (_, _) in
            count++
        }
        
        channel.registerListener(self, handler: handler)
        sink.send("hello")
        sink.send("world")
        
        XCTAssertEqual(count, 1)
    }
    
    func testCountedOnlyInvokedWithCount() {
        var count = 0
        let expected = 2
        
        let handler: (AnyObject, String) -> () = ChannelWrapper.counted(channel, count: expected) { _, _ in
            count++
        }
        
        channel.registerListener(self, handler: handler)
        
        for _ in 0...expected {
            sink.send("hello")
        }
        
        XCTAssertEqual(count, expected)
    }
    
}
