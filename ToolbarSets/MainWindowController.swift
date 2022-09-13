//
//  MainWindowController.swift
//  ToolbarSets
//
//  Created by Mario Guzman on 7/18/22.
//

import Cocoa

class MainWindowController: NSWindowController
{
    private var tabViewController: NSTabViewController!
    
    private var listenNowToolbar: NSToolbar = {
        let newToolbar = NSToolbar(identifier: NSToolbar.Identifier.listenNow)
        newToolbar.allowsUserCustomization = true
        newToolbar.autosavesConfiguration = true
        newToolbar.displayMode = .default
        newToolbar.centeredItemIdentifier = NSToolbarItem.Identifier.toolbarMainWindowTabsItem
        newToolbar.sizeMode = .default
        return newToolbar
    }()
    
    private var browseToolbar: NSToolbar = {
        let newToolbar = NSToolbar(identifier: NSToolbar.Identifier.browse)
        newToolbar.allowsUserCustomization = true
        newToolbar.autosavesConfiguration = true
        newToolbar.displayMode = .default
        newToolbar.centeredItemIdentifier = NSToolbarItem.Identifier.toolbarMainWindowTabsItem
        newToolbar.sizeMode = .default
        return newToolbar
    }()
    
    private var radioToolbar: NSToolbar = {
        let newToolbar = NSToolbar(identifier: NSToolbar.Identifier.radio)
        newToolbar.allowsUserCustomization = true
        newToolbar.autosavesConfiguration = true
        newToolbar.displayMode = .default
        newToolbar.centeredItemIdentifier = NSToolbarItem.Identifier.toolbarMainWindowTabsItem
        newToolbar.sizeMode = .default
        return newToolbar
    }()
    
    weak var toolbarItemGroup: NSToolbarItemGroup? {
        didSet {
            if  toolbarItemGroup != nil {
                self.toolbarItemGroup?.bind(NSBindingName.selectedIndex, to: self.tabViewController!, withKeyPath: "selectedTabViewItemIndex")
            }
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        let tabViewController = self.contentViewController as! NSTabViewController
        self.tabViewController = tabViewController
        
        self.listenNowToolbar.delegate = self
        self.browseToolbar.delegate = self
        self.radioToolbar.delegate = self
        
        self.updateToolbar()
        self.window!.titleVisibility = .visible
        self.window!.titlebarSeparatorStyle = .automatic
        self.window!.toolbarStyle = .unified
        self.window!.titleVisibility = .hidden
    }
    
    private func updateToolbar() {
        let selectedToolbarItem = MainWindowTabs(rawValue: self.tabViewController.selectedTabViewItemIndex)!
        switch selectedToolbarItem {
        case .ListenNow:
            self.window!.toolbar = self.listenNowToolbar
        case .Browse:
            self.window!.toolbar = self.browseToolbar
        case .Radio:
            self.window!.toolbar = self.radioToolbar
        }
    }
    
    @IBAction func didChangeSelection(_ sender: Any) {
        self.tabViewController.selectedTabViewItemIndex = (sender as! NSToolbarItemGroup).selectedIndex
        self.updateToolbar()
    }
    
    @IBAction func didChangePlayback(_ sender: Any) {
        print(#function)
    }
}

// MARK: - NSToolbar & Toolbar Validation Delegates

extension MainWindowController: NSToolbarDelegate, NSToolbarItemValidation
{
    func validateToolbarItem(_ item: NSToolbarItem) -> Bool {
        return true
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        if  itemIdentifier == .toolbarMainWindowTabsItem {
            let item = NSToolbarItemGroup(itemIdentifier: NSToolbarItem.Identifier.toolbarMainWindowTabsItem,
                                          titles: ["Listen Now", "Browse", "Radio"],
                                          selectionMode: .selectOne,
                                          labels: ["Listen Now", "Browse", "Radio"],
                                          target: self,
                                          action: #selector(didChangeSelection(_:)))
            item.label = "Navigator"
            item.paletteLabel = "Navigator"
            item.toolTip = "Switch between your source of music."
            item.isBordered = true
            item.visibilityPriority = .high
            item.selectionMode = .selectOne
            item.controlRepresentation = .automatic
            item.setSelected(true, at: MainWindowTabs.ListenNow.rawValue)
            return item
        }
        
        if  itemIdentifier == .toolbarMainWindowTrackPlaybackItem {
            let images = [NSImage(systemSymbolName: "backward.fill", accessibilityDescription: "")!,
                          NSImage(systemSymbolName: "pause.fill", accessibilityDescription: "")!,
                          NSImage(systemSymbolName: "forward.fill", accessibilityDescription: "")!]
            let labels = ["Previous", "Pause", "Next"]
            let item = NSToolbarItemGroup(itemIdentifier: itemIdentifier,
                                          images: images,
                                          selectionMode: .momentary,
                                          labels: labels,
                                          target: self,
                                          action: #selector(didChangePlayback(_:)))
            item.label = "Playback"
            item.paletteLabel = "Playback"
            item.toolTip = "Playback controls for selected media"
            item.isBordered = true
            item.visibilityPriority = .high
            item.controlRepresentation = .expanded
            return item
        }
        
        if  itemIdentifier == .toolbarMainWindowRadioPlaybackItem {
            let images = [NSImage(systemSymbolName: "backward.fill", accessibilityDescription: "")!,
                          NSImage(systemSymbolName: "stop.fill", accessibilityDescription: "")!,
                          NSImage(systemSymbolName: "forward.fill", accessibilityDescription: "")!]
            let labels = ["Previous", "Stop", "Next"]
            let item = NSToolbarItemGroup(itemIdentifier: itemIdentifier,
                                          images: images,
                                          selectionMode: .momentary,
                                          labels: labels,
                                          target: self,
                                          action: #selector(didChangePlayback(_:)))
            item.label = "Playback"
            item.paletteLabel = "Playback"
            item.toolTip = "Playback controls for selected media"
            item.isBordered = true
            item.visibilityPriority = .high
            item.controlRepresentation = .expanded
            return item
        }
        
        if  itemIdentifier == NSToolbarItem.Identifier.toolbarShareButtonItem {
            let shareItem = NSSharingServicePickerToolbarItem(itemIdentifier: itemIdentifier)
            shareItem.toolTip = "Share"
            shareItem.delegate = self
            return shareItem
        }
        
        if  itemIdentifier == NSToolbarItem.Identifier.toolbarSearchItem {
            let searchItem = NSSearchToolbarItem(itemIdentifier: itemIdentifier)
            searchItem.resignsFirstResponderWithCancel = true
            searchItem.searchField.delegate = self
            searchItem.toolTip = "Search"
            return searchItem
        }
        
        return nil
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        
        if  toolbar.identifier == .listenNow {
            return [
                NSToolbarItem.Identifier.flexibleSpace,
                NSToolbarItem.Identifier.toolbarMainWindowTrackPlaybackItem,
                NSToolbarItem.Identifier.flexibleSpace,
                NSToolbarItem.Identifier.toolbarMainWindowTabsItem,
                NSToolbarItem.Identifier.flexibleSpace,
                NSToolbarItem.Identifier.toolbarShareButtonItem
            ]
        } else if toolbar.identifier == .browse {
            return [
                NSToolbarItem.Identifier.flexibleSpace,
                NSToolbarItem.Identifier.toolbarMainWindowTrackPlaybackItem,
                NSToolbarItem.Identifier.flexibleSpace,
                NSToolbarItem.Identifier.toolbarMainWindowTabsItem,
                NSToolbarItem.Identifier.flexibleSpace,
                NSToolbarItem.Identifier.toolbarSearchItem
            ]
        } else if toolbar.identifier == .radio {
            return [
                NSToolbarItem.Identifier.flexibleSpace,
                NSToolbarItem.Identifier.toolbarMainWindowRadioPlaybackItem,
                NSToolbarItem.Identifier.flexibleSpace,
                NSToolbarItem.Identifier.toolbarMainWindowTabsItem,
                NSToolbarItem.Identifier.flexibleSpace
            ]
        }
        
        return []
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        
        if  toolbar.identifier == .listenNow {
            return [
                NSToolbarItem.Identifier.toolbarMainWindowTrackPlaybackItem,
                NSToolbarItem.Identifier.toolbarMainWindowTabsItem,
                NSToolbarItem.Identifier.toolbarShareButtonItem,
                NSToolbarItem.Identifier.flexibleSpace
            ]
        } else if toolbar.identifier == .browse {
            return [
                NSToolbarItem.Identifier.toolbarMainWindowTrackPlaybackItem,
                NSToolbarItem.Identifier.toolbarMainWindowTabsItem,
                NSToolbarItem.Identifier.toolbarSearchItem,
                NSToolbarItem.Identifier.flexibleSpace
            ]
        } else if toolbar.identifier == .radio {
            return [
                NSToolbarItem.Identifier.toolbarMainWindowRadioPlaybackItem,
                NSToolbarItem.Identifier.toolbarMainWindowTabsItem,
                NSToolbarItem.Identifier.flexibleSpace
            ]
        }
        
        return []
    }
    
    func toolbarWillAddItem(_ notification: Notification) {
        if  let toolbarItem = notification.userInfo?["item"] as? NSToolbarItemGroup,
            toolbarItem.itemIdentifier == .toolbarMainWindowTabsItem {
            self.toolbarItemGroup = toolbarItem
        }
    }
    
    func toolbarDidRemoveItem(_ notification: Notification) {
        if  let toolbarItem = notification.userInfo?["item"] as? NSToolbarItemGroup,
            toolbarItem.itemIdentifier == .toolbarMainWindowTabsItem {
            self.toolbarItemGroup = nil
        }
    }
}

// MARK: - Sharing Service Picker Toolbar Item Delegate

extension MainWindowController: NSSharingServicePickerToolbarItemDelegate
{
    func items(for pickerToolbarItem: NSSharingServicePickerToolbarItem) -> [Any] {
        // Compose an array of items that are sharable such as text, URLs, etc.
        // depending on the context of your application (i.e. what the user
        // current has selected in the app and/or they tab they're in).
        let sharableItems = [URL(string: "https://www.apple.com/")!]
        return sharableItems
    }
}

// MARK: - Search Field Delegate

extension MainWindowController: NSSearchFieldDelegate
{
    func searchFieldDidStartSearching(_ sender: NSSearchField) {
        print("Search field did start receiving input")
    }
    
    func searchFieldDidEndSearching(_ sender: NSSearchField) {
        print("Search field did end receiving input")
        sender.resignFirstResponder()
    }
}
