//
//  FileWriteMonitor.swift
//  
//
//  Created by 游宗諭 on 2020/4/14.
//

import Foundation


internal class FileWriteMonitor {
    private typealias Event = DispatchSource.FileSystemEvent
    typealias Worker = () -> Void
    private let fileManager: FileManager = .default
    private let monitorURL: URL
    private var actionMap: [Event.RawValue: Worker] = [:]
    
    private var fileDescriptor: Int32 = -1
    private var eventSource: DispatchSourceFileSystemObject?
    
    init?(_ url: URL, onWrite: @escaping Worker) {
        self.monitorURL = url
        
        connectDispatchSource()
        
        guard fileDescriptor != -1
            else { return nil }
        
        actionMap[Event.delete.rawValue] = connectDispatchSource
        actionMap[Event.write.rawValue] = onWrite
    }
    
    private func connectDispatchSource() {
        eventSource?.cancel()
        close(fileDescriptor)
        
        fileDescriptor = open(monitorURL.path, O_EVTONLY)
        
        guard fileDescriptor != -1 else { return }
        
        eventSource = DispatchSource
            .makeFileSystemObjectSource(
                fileDescriptor: fileDescriptor,
                eventMask: [.write, .delete],
                queue: .main)
        
        eventSource?.setEventHandler { [unowned self, unowned eventSource] in
            guard
//            let self = self,
            let eventSource = eventSource else { return }
            
            self.actionMap.keys.forEach { (event) in
                if eventSource.data & event != 0 { self.actionMap[event]?() }
            }
        }
        
        self.eventSource?.resume()
    }
}
