//
//  ChannelSink.swift
//  Channels
//
//  Created by Chase Latta on 11/25/15.
//  Copyright © 2015 Chase Latta. All rights reserved.
//

import Foundation

typealias ListenerAction = (AnyObject, Any) -> ()

private struct ListenerWrapper {
    private weak var target: AnyObject?
    private let action: (AnyObject, Any) -> ()
    private let id = NSUUID().UUIDString
    
    init(target: AnyObject, action: ListenerAction) {
        self.target = target
        self.action = action
    }
    
    func invoke(data: Any) -> Bool {
        guard let target = target else { return false }
        
        action(target, data)
        return true
    }
}

extension ListenerWrapper: Equatable {}
private func ==(lhs: ListenerWrapper, rhs: ListenerWrapper) -> Bool {
    return lhs.id == rhs.id
}

public class ChannelSink {
    
    private let _serialQueue = dispatch_queue_create("com.channels.channel-sink.serial-queue", DISPATCH_QUEUE_SERIAL)
    private var _wrappers = [ListenerWrapper]()
    
    internal func registerListener(listener: AnyObject, action: ListenerAction) {
        
        let wrapper = ListenerWrapper(target: listener, action: action)
        
        dispatch_sync(_serialQueue) {
            self._wrappers.append(wrapper)
        }
    }
    
    internal func unregisterListener(listener: AnyObject) {
        dispatch_sync(_serialQueue) {
            let index = self._wrappers.indexOf { $0.target === listener }
            if let index = index {
                self._wrappers.removeAtIndex(index)
            }
        }
    }
    
    public func send(data: Any) {
        _safeIterateWrappers(_wrappers, data: data)
    }
}

//MARK: Helper methods
extension ChannelSink {
    
    private func _safeIterateWrappers(wrappers: [ListenerWrapper], data: Any) {
        
        for wrapper in wrappers {
            if !wrapper.invoke(data) {
                _removeWrapper(wrapper)
            }
        }
    }
    
    private func _removeWrapper(wrapper: ListenerWrapper) {
        dispatch_sync(_serialQueue) {
            if let index = self._wrappers.indexOf(wrapper) {
                self._wrappers.removeAtIndex(index)
            }
        }
    }
    
}