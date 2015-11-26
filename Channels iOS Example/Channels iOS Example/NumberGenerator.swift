//
//  NumberGenerator.swift
//  Channels iOS Example
//
//  Created by Chase Latta on 11/25/15.
//  Copyright © 2015 Chase Latta. All rights reserved.
//

import Foundation
import Channels

class NumberGenerator {
    
    private var _timer: dispatch_source_t?
    private let _sink = ChannelSink()
    let channel: Channel<Int>
    
    init() {
        channel = Channel<Int>(sink: _sink)
    }
    
    func startGenerating() {
        if _timer != nil { return }
        
        let timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        
        let interval = UInt64(2) * NSEC_PER_SEC
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(interval))
        dispatch_source_set_timer(timer, time, interval, interval)
        dispatch_source_set_event_handler(timer) {
            let rand = Int(arc4random_uniform(100))
            self._sink.send(rand)
        }
        
        dispatch_resume(timer)
        _timer = timer
    }
}