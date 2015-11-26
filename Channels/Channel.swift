//
//  Channel.swift
//  Channels
//
//  Created by Chase Latta on 11/23/15.
//  Copyright © 2015 Chase Latta. All rights reserved.
//

public struct Channel<Data> {
    
    private let sink: ChannelSink

    public init(sink: ChannelSink) {
        self.sink = sink
    }
    
    public func registerListener<T: AnyObject>(listener: T, handler: (T, Data) -> ()) {
        
        sink.registerListener(listener) { target, data in
            if let typedData = data as? Data, let typedTarget = target as? T {
                handler(typedTarget, typedData)
            }
        }
    }
    
    public func unregisterListener(listener: AnyObject?) {
        guard let listener = listener else { return }
        sink.unregisterListener(listener)
    }
}
