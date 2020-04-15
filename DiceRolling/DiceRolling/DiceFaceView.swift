//
//  DiceFaceView.swift
//  DiceRolling
//
//  Created by 游宗諭 on 2020/4/15.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import SwiftUI

struct DiceFaceView:View {
  internal init(_ text: String) {
    self.text = text
  }
  
  let text: String
  var body: some View {
    Text(text)
      .frame(width: 100, height: 100)
      .font(.system(size: 80))
      .border(Color.black, width: 1)
  }
  
  
}
