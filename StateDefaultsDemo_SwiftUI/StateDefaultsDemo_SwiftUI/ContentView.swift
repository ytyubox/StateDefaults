//
//  ContentView.swift
//  StateDefaultsDemo_SwiftUI
//
//  Created by 游宗諭 on 2020/6/16.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import SwiftUI
import StateDefaults

struct ContentView: View {
    
    @StateDefaults(defaultValue: 1)
    var clickCount:Int
    var body: some View {
        VStack {
            
        Button(action: {
            self.clickCount = (0...10).randomElement()!
        }) {
            Text("\(self.clickCount)")
        }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
