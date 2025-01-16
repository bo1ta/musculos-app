//
//  SoundManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.01.2025.
//

import AVFoundation

public class SoundManager {
  public enum SoundEffect: String, CaseIterable {
    case toast
    case tabSelection
    case favorite
    case xpGained
    case newLevel
    case exerciseSessionInProgress
    case exerciseSessionFinished
    case selection
  }

  private var systemSoundIDs: [SoundEffect: SystemSoundID] = [:]

  public init() {
    registerSounds()
  }

  private func registerSounds() {
    SoundEffect.allCases.forEach { effect in
      guard let url = Bundle.main.url(forResource: effect.rawValue, withExtension: "wav") else {
        return
      }
      registerURL(url, forEffect: effect)
    }
  }

  private func registerURL(_ url: URL, forEffect effect: SoundEffect) {
    var soundID: SystemSoundID = 0
    AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
    systemSoundIDs[effect] = soundID
  }

  public func playSound(_ effect: SoundEffect) {
    guard let soundID = systemSoundIDs[effect] else {
      return
    }
    AudioServicesPlaySystemSound(soundID)
  }
}
