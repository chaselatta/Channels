//
//  Channel.swift
//  Channels
//
//  Created by Chase Latta on 11/23/15.
//  Copyright © 2015 Chase Latta. All rights reserved.
//

import Foundation

public class ChannelSink {
    
    private typealias HandlerType = Any -> ()
    
    private var handlers = [String: HandlerType]()
    private let syncQueue = dispatch_queue_create("com.channel-sink.sync-queue", DISPATCH_QUEUE_SERIAL)
    
    public func send(data: Any) {
        var handlersCopy: [String: HandlerType]! = nil
        
        dispatch_sync(syncQueue) {
            handlersCopy = self.handlers
        }
        
        for (_, handler) in handlersCopy {
            handler(data)
        }
    }
    
    private func registerHandler(handler: HandlerType) -> String {
        let id = NSUUID().UUIDString
        dispatch_sync(syncQueue) {
            self.handlers[id] = handler
        }
        return id
    }
    
    private func unregisterHandler(id: String) {
        dispatch_sync(syncQueue) {
            self.handlers.removeValueForKey(id)
        }
    }
}

public class Channel<Data> {
    
    private let sink: ChannelSink

    public init(sink: ChannelSink) {
        self.sink = sink
    }
    
    func listen(handler: Data -> ()) -> String {
        return sink.registerHandler { data in
            if let typedData = data as? Data {
                handler(typedData)
            }
        }
    }
    
    func removeListener(id: String) {
        sink.unregisterHandler(id)
    }
}
