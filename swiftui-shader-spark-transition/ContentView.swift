//
//  ContentView.swift
//  swiftui-shader-spark-transition
//
//  Created by Sergey Gonchar on 24/10/2023.
//

import SwiftUI

struct ContentView: View {
  
  @State var trigger:Bool = false
  
  var body: some View {
    VStack {
      if trigger {
        Image(uiImage: .first)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .transition(SparkTransition.sparkTransitionColor)
      } else {
        Image(uiImage: .second)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .transition(SparkTransition.sparkTransitionColor)
      }
      Button("Do transition") {
        withAnimation {
          trigger.toggle()
        }
        
      }
    }
    .animation(.linear(duration: 2.0), value: trigger)
    .padding()
  }
}

#Preview {
  ContentView()
}
