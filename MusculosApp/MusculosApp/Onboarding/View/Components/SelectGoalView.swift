//
//  SelectGoalView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.02.2024.
//

import SwiftUI

struct SelectGoalView: View {
  @Binding var selectedGoal: Goal?
  
  var body: some View {
    VStack(spacing: 15) {
      createGoalCard(.loseWeight)
      createGoalCard(.getFitter)
      createGoalCard(.gainMuscles)
    }
    .padding(20)
  }
  
  private func createGoalCard(_ goal: Goal) -> some View {
    let isSelected = selectedGoal == goal
    let color: Color = isSelected ? Color.AppColor.blue500 : .black
    
    return Button {
      selectedGoal = goal
    } label: {
      
      RoundedRectangle(cornerRadius: 25)
        .frame(maxWidth: .infinity)
        .frame(height: 130)
        .foregroundStyle(.white)
        .shadow(color: isSelected ? Color.AppColor.blue500 : .gray, radius: 3)
        .overlay {
          HStack {
            VStack(alignment: .leading, spacing: 5) {
              Text(goal.title)
                .font(.custom("Roboto-Bold", size: 20))
                .foregroundStyle(color)
              Text(goal.description)
                .font(.custom("Roboto-Regular", size: 15))
                .foregroundStyle(color)
            }
            Spacer()
            
            if !isSelected {
              goal.image
                .font(.system(size: 25))
                .foregroundStyle(color)
            } else {
              Circle()
                .frame(width: 35, height: 35)
                .foregroundStyle(Color.AppColor.blue500)
                .overlay {
                  Image(systemName: "checkmark")
                    .foregroundStyle(.white)
                }
            }
          }
          .padding([.leading, .trailing], 20)
        }
    }
    .scaleEffect(isSelected ? 0.98 : 1.0)
  }
}

#Preview {
  SelectGoalView(selectedGoal: .constant(nil))
}
