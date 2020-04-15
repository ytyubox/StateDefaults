//
//  DiceView.swift
//  DiceRolling
//
//  Created by 游宗諭 on 2020/4/14.
//  Copyright © 2020 游宗諭. All rights reserved.
//

import SwiftUI
struct DiceView:View {
  @State private var dragAmount = CGSize.zero
  var body: some View {
      ZStack {
        DiceFaceView("2")
          .modifier(FlipEffect(angle: self.dragAmount))
      }
    .gesture(
      DragGesture()
        .onChanged({ (amount) in
          self.dragAmount = amount.translation
        })
      //        .onEnded({_ inself.dragAmount = .zero})
    )
  }
  
}





struct FlipEffect: GeometryEffect {
  internal init(angle: CGSize
    //    , axis: (x: CGFloat, y: CGFloat)
  ) {
    self.angle = (Double(angle.width),Double(angle.height))
    //    self.axis = axis
  }
  
  
  var animatableData: (x: Double, y: Double) {
    get { angle }
    set { angle = newValue }
  }
  
  //    @Binding var flipped: Bool
  var angle: (x: Double, y: Double)
  //  let axis: (x: CGFloat, y: CGFloat)
  
  func effectValue(size: CGSize) -> ProjectionTransform {
    
    // We schedule the change to be done after the view has finished drawing,
    // otherwise, we would receive a runtime error, indicating we are changing
    // the state while the view is being drawn.
    //        DispatchQueue.main.async {
    //            self.flipped = self.angle >= 90 && self.angle < 270
    //        }
    //
    let ax = CGFloat(Angle(degrees: angle.x).radians)
    let ay = CGFloat(Angle(degrees: angle.y).radians)
    
    var transform3d = CATransform3DIdentity
    transform3d.m34 = -1/500
    
    print(ax,ay)
//    transform3d = CATransfrom3DR
    transform3d = CATransform3DRotate(transform3d, ax, 0, 1, 0)
    transform3d = CATransform3DRotate(transform3d, ay, 1, 0, 0)
    
    //        transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
    //        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
    
        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))
    
    return ProjectionTransform(transform3d).concatenating(affineTransform)
  }
}
