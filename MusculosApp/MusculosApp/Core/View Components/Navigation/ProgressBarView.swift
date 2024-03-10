//
//  ProgressBarView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 12.06.2023.
//

import SwiftUI

struct ProgressBarView: View {
  let progressCount: Int
  var currentProgress: Int

  init(progressCount: Int, currentProgress: Int) {
    self.progressCount = progressCount
    self.currentProgress = currentProgress
  }

  var body: some View {
    HStack {
      Spacer()
      ForEach(0..<self.progressCount) { index in
        if index == currentProgress {
          Image(systemName: "circle.fill")
            .font(.system(size: 11))
            .foregroundColor(Color.AppColor.green500)
        } else {
          Image(systemName: "circle.fill")
            .font(.system(size: 10))
            .foregroundColor(.gray)
        }
      }
      Spacer()
    }
    .padding()
    .background(Capsule().fill(.gray).frame(maxWidth: .infinity).opacity(0.5))
  }
}

struct ProgressBarView_Preview: PreviewProvider {
  static var previews: some View {
    ProgressBarView(progressCount: 5, currentProgress: 2)
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
