//
//  To_do_ListApp.swift
//  To do List
//
//  Created by Berkay on 14.07.2022.
//

import SwiftUI

@main
struct To_do_ListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ViewModel())
        }
    }
}
