//
//  Menubar.swift
//  TheDangersOfSitting
//
//  Created by IcedOtaku on 2022/3/17.
//

import Foundation
import AppKit
import SwiftUI

class Menubar: ObservableObject {
    static let shared: Menubar = Menubar()
    
    @Published var running = false
    @Published var hours: Int = 0
    @Published var minutes: Int = 0
    @Published var seconds: Int = 0
    @Published var percentage: Double = 0
    @Published var shouldActivePopover: Bool = false
    
    @AppStorage("info.fakecoder.StartWorkingTimeStamp")
    var __startWorkingTimeStamp: Double = 0
    @AppStorage("info.fakecoder.FinishWorkingTimeStamp")
    var __finishWorkingTimeStamp: Double = 0
    @AppStorage("info.fakecoder.StandUpInterval")
    var __standUpInterval: Int = 30
    @AppStorage("info.fakecoder.HasLunchBreak")
    var __hasLunchBreak: Bool = false
    
    private var timer: Timer
    private var popover: NSPopover
    private var statusItem: NSStatusItem
    
    init() {
        timer = Timer(timeInterval: 1, repeats: true) { _ in
            Menubar.shared.updateStatusBar()
        }
        RunLoop.current.add(timer, forMode: .common)
        
        popover = NSPopover()
        popover.contentViewController = NSHostingController(rootView: MenubarView())

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown], handler: mouseEventHandler)
    }
    
    func updateStatusBar() {
        guard running else {
            return
        }
        
        let totalSeconds: Double = __finishWorkingTimeStamp - __startWorkingTimeStamp
        let passedSeconds: Double = Date().timeIntervalSince1970 - __startWorkingTimeStamp
        
        // not working yet
        if passedSeconds < 0 {
            percentage = 0
            if let button = statusItem.button {
                button.title = "🙋🏻"
            }
            return
        }
        
        // should be offwork
        if passedSeconds > totalSeconds {
            percentage = 1
            if let button = statusItem.button {
                button.title = "🙅🏻"
            }
            return
        }
        
        hours = Int(passedSeconds / 60 / 60)
        minutes = Int(passedSeconds / 60) % 60
        seconds = Int(passedSeconds) % 60
        
        percentage = passedSeconds / totalSeconds
        
        if (minutes % __standUpInterval == 0) && (seconds % 60 == 0) {
            if !popover.isShown {
                showPopover()
            }
            shouldActivePopover = true
            debugPrint("[show popover] minutes: \(minutes), seconds: \(seconds)")
        }
    }
    
    func run() {
        assert(Thread.isMainThread)
        guard !running else {
            return
        }
        
        running = true
        
        // not sure why we have to rebuild statusItem even though it's memory has not been deallocated
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.target = self
            button.action = #selector(togglePopover)
            button.title = "🧑🏻‍💻"
        }
    }
    
    func stop() {
        assert(Thread.isMainThread)
        guard running else {
            return
        }
        
        running = false
        
        NSStatusBar.system.removeStatusItem(statusItem)
    }
    
    @objc
    func togglePopover() {
        if popover.isShown && !shouldActivePopover {
            hidePopover()
        } else {
            showPopover()
        }
    }
    
    func showPopover() {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.maxY)
        }
    }
    
    func hidePopover() {
        popover.close()
    }
    
    func mouseEventHandler(event: NSEvent) {
        if popover.isShown && !shouldActivePopover {
            hidePopover()
        }
    }
}
