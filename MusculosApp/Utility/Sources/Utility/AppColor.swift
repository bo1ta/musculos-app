//
//  Color+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation
import SwiftUI

public extension Color {
  public struct AppColor {
    public static let blue100 = Color("Blue100")
    public static let blue200 = Color("Blue200")
    public static let blue300 = Color("Blue300")
    public static let blue400 = Color("Blue400")
    public static let blue500 = Color("Blue500")
    public static let blue600 = Color("Blue600")
    public static let blue700 = Color("Blue700")
    public static let blue800 = Color("Blue800")
    public static let blue900 = Color("Blue900")
    
    public static let green100 = Color("Green100")
    public static let green200 = Color("Green200")
    public static let green300 = Color("Green300")
    public static let green400 = Color("Green400")
    public static let green500 = Color("Green500")
    public static let green600 = Color("Green600")
    public static let green700 = Color("Green700")
    public static let green800 = Color("Green800")
    public static let darkPurple = Color("DarkPurple")
  }
}

public struct AppColor {
  public static let brightOrange = Color(hex: "FBC12E")
  public static let lightBrown = Color(hex: "F18184")
  public static let navyBlue = Color(hex: "0E2250")

  public static let orangeGradient = LinearGradient(
    gradient: Gradient(colors: [.orange, .red]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
}
