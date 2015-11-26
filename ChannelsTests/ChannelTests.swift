//
//  ChannelTests.swift
//  ChannelTests
//
//  Created by Chase Latta on 11/23/15.
//  Copyright © 2015 Chase Latta. All rights reserved.
//

import XCTest
@testable import Channels

class ChannelTests: XCTestCase {
    
    let sink = ChannelSink()
    var intChannel: Channel<Int>!
    var stringChannel: Channel<String>!
    
    override func setUp() {
        super.setUp()
        intChannel = Channel(sink: sink)
        stringChannel = Channel(sink: sink)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testListenInvokesBlockImmediate() {

        var didInvoke = false
        intChannel.registerListener(self) { _, _ in didInvoke = true }
        
        sink.send(1)
        XCTAssert(didInvoke == true, "Should have received a message")
    }
    
    func testListenOnlySendsTypedData() {
        let sentInt = 100
        let sentStr = "hello"
        var didReceiveInt = false
        var didReceiveStr = false
        
        intChannel.registerListener(self) { _, d in didReceiveInt = (d == sentInt) }
        stringChannel.registerListener(self) { _, d in didReceiveStr = (d == sentStr) }
        
        sink.send(sentInt)
        sink.send(sentStr)
        
        XCTAssert(didReceiveInt == true)
        XCTAssert(didReceiveStr == true)
    }
    
    func testListenInvokedOnSameQueueAsSend() {
        var value = "value"
        var key = "key"
        let queue = dispatch_queue_create("my-queue", DISPATCH_QUEUE_SERIAL)
        dispatch_queue_set_specific(queue, &key, &value, nil)
        
        intChannel.registerListener(self) { _, _ in
            let queueValue = dispatch_get_specific(&key)
            XCTAssertTrue(queueValue == &value)
        }
        
        dispatch_sync(queue) {
            self.sink.send(1)
        }
    }
    
    func testListenerRemovedWhenSetToNil() {
        var receiveCount = 0
        var listener: AnyObject? = _EmptyClass()
        intChannel.registerListener(listener!) { _, _ in
            receiveCount++
        }
        
        sink.send(1)
        listener = nil
        sink.send(1)
        
        XCTAssertEqual(receiveCount, 1)
    }

    func testRemoveListener() {
        var receiveCount = 0
        intChannel.registerListener(self) { _, _ in
            receiveCount++
        }
        
        sink.send(1)
        intChannel.unregisterListener(self)
        sink.send(1)
        
        XCTAssertEqual(receiveCount, 1)
    }
}

private class _EmptyClass {}
