//
//  ExploreExerciseContentView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.02.2024.
//

// import SwiftUI
// import Utility
//
// struct ExploreCategorySectionView: View {
//  var currentSection: ExploreCategorySection
//  var onChangeSection: ((ExploreCategorySection) -> Void)?
//
//  @Namespace private var animationNamespace
//
//  var body: some View {
//    HStack(spacing: 0) {
//      ForEach(ExploreCategorySection.allCases, id: \.title) { section in
//        Button(action: {
//          withAnimation(.easeInOut(duration: UIConstant.mediumAnimationDuration)) {
//            onChangeSection?(section)
//          }
//        }, label: {
//          VStack(spacing: 0) {
//            Text(section.title)
//              .font(AppFont.poppins(section == currentSection ? .semibold : .regular, size: 16))
//              .foregroundColor(section == currentSection ? .red : .gray)
//              .padding(.horizontal, 16)
//              .padding(.vertical, 8)
//
//            if section == currentSection {
//              Rectangle()
//                .fill(Color.red)
//                .frame(height: 2)
//                .matchedGeometryEffect(id: "underline", in: animationNamespace)  // Matching the animation effect
//            } else {
//              Color.gray
//                .opacity(0.2)
//                .frame(height: 2)
//            }
//          }
//        })
//      }
//    }
//  }
// }
//
// #Preview {
//  ExploreCategorySectionView(currentSection: .discover, onChangeSection: { _ in })
// }
