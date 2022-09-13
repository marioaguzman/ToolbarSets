//
//  Definitions.swift
//  ToolbarSets
//
//  Created by Mario Guzman on 7/18/22.
//

import Foundation
import Cocoa 

extension NSToolbar.Identifier {
    static let listenNow = NSToolbar.Identifier("MainWindowListenNowToolbar")
    static let browse    = NSToolbar.Identifier("MainWindowBrowseToolbar")
    static let radio     = NSToolbar.Identifier("MainWindowRadioToolbar")
}

extension NSToolbarItem.Identifier {
    /// Example of `NSToolbarItemGroup`
    static let toolbarMainWindowTabsItem = NSToolbarItem.Identifier(rawValue: "ToolbarMainWindowTabsItem")
    static let toolbarMainWindowTrackPlaybackItem = NSToolbarItem.Identifier(rawValue: "ToolbarMainWindowTrackPlaybackItem")
    static let toolbarMainWindowRadioPlaybackItem = NSToolbarItem.Identifier(rawValue: "ToolbarMainWindowRadioPlaybackItem")
    /// Example of `NSSharingServicePickerToolbarItem`
    static let toolbarShareButtonItem = NSToolbarItem.Identifier(rawValue: "ToolbarShareButtonItem")
    /// Example of `NSSearchToolbarItem`
    static let toolbarSearchItem = NSToolbarItem.Identifier("ToolbarSearchItem")
}

enum MainWindowTabs: Int, CaseIterable {
    case ListenNow = 0
    case Browse    = 1
    case Radio     = 2
}
