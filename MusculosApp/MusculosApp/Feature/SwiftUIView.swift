//
//  SwiftUIView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.06.2024.
//

import SwiftUI

class ViewModelA: ObservableObject {
  @Published var isInSelectMode: Bool = false
  func toggleSelectMode() {
    isInSelectMode.toggle()
  }
}

struct ViewA: View {
  @StateObject var viewModel = ViewModelA()
  
  var body: some View {
    VStack {
      Text("isInSelectMode A: \(viewModel.isInSelectMode.description)")
      
      ViewB(viewModel: ViewModelB(isInSelectMode: $viewModel.isInSelectMode))

      if !viewModel.isInSelectMode {
        Button("Select A") { viewModel.toggleSelectMode() }
      } else {
        Button("Deselect A") { viewModel.toggleSelectMode() }
      }
    }
  }
}

class ViewModelB: ObservableObject {
  @Published var isInSelectMode: Binding<Bool>
  @Published var anotherBool = false
  
  init(isInSelectMode: Binding<Bool>) {
    self.isInSelectMode = isInSelectMode
  }
  
  func toggleSelectMode() {
    isInSelectMode.wrappedValue.toggle()
  }
  func toggleAnotherBool(){
    anotherBool.toggle()
  }
}

struct ViewB: View {
  @StateObject var viewModel: ViewModelB
  
  var body: some View {
    VStack {
      Button("anotherBool: \(viewModel.anotherBool)"){viewModel.anotherBool.toggle()}
      if !viewModel.isInSelectMode.wrappedValue {
        Button("Select B") { viewModel.toggleSelectMode() }
      } else {
        Button("Deselect B") { viewModel.toggleSelectMode() }
      }
      Text("isInSelectMode B: \(viewModel.isInSelectMode.wrappedValue.description)")
    }
  }
}
