//
//  SparkTransition.swift
//  morphspirit
//
//  Created by Sergey Gonchar on 26/09/2023.
//

import SwiftUI

struct SparkleTransitionModifier: ViewModifier {
  var effectValue: CGFloat = 0
  var direction:CGFloat = 1.0
  let start = Date()
  
  func body(content: Content) -> some View {
    content
      .layerEffect(ShaderLibrary.default.sparkTransitionShader(
        .boundingRect,
        .float(self.effectValue),
        .float(self.direction),
        .image(Image(.particles6)),
        .float(self.effectValue * 2)
      ), maxSampleOffset: .zero)
  }
}

class SparkTransition {
  private static let insertionColorTransition: AnyTransition = .modifier(
    active: SparkleTransitionModifier(effectValue: -0.2, direction: 1.0),
    identity: SparkleTransitionModifier(effectValue: 1.2, direction: 1.0)
  )
  
  private static let removalColorTransition: AnyTransition = .modifier(
    active: SparkleTransitionModifier(effectValue: -0.2, direction: -1.0),
    identity: SparkleTransitionModifier(effectValue: 1.2, direction: -1.0)
  )
  
  static let sparkTransitionColor: AnyTransition = .asymmetric(insertion: insertionColorTransition, removal: removalColorTransition)
}
