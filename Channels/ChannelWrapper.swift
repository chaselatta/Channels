//
//  ChannelWrapper.swift
//  Channels
//
//  Created by Chase Latta on 11/25/15.
//  Copyright © 2015 Chase Latta. All rights reserved.
//

import Foundation

public struct ChannelWrapper {
    
    public static func dispatch<T: AnyObject, Data>(queue: dispatch_queue_t, handler: (T, Data) -> ()) -> (T, Data) -> () {
        return { target, data in
            dispatch_async(queue) {
                handler(target, data)
            }
        }
    }
    
    public static func once<T: AnyObject, Data>(channel: Channel<Data>, handler: (T, Data) -> ()) -> (T, Data) -> () {
        return { target, data in
            handler(target, data)
            channel.unregisterListener(target)
        }
    }
    
    public static func counted<T: AnyObject, Data>(channel: Channel<Data>, count: Int, handler: (T, Data) -> ()) -> (T, Data) -> () {
        var counted = 0
        return { target, data in
            handler(target, data)
            counted++
            if counted >= count {
                channel.unregisterListener(target)
            }
        }
    }
    
}
