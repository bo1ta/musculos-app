//
//  SoundManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.01.2025.
//

import AVFoundation

public class SoundManager {
  public enum SoundEffect: String, CaseIterable {
    case errorToast = "error_toast"
    case tabSelection = "tab_selection"
    case levelUp = "level_up"
    case gainedExperience = "gained_experience"
    case favoriteExercise = "favorite_exercise"
    case unfavoriteExercise = "unfavorite_exercise"
    case exerciseSessionInProgress = "exercise_session_in_progress"
    case selection
  }

  private var audioPlayer: AVAudioPlayer?

  public func playSound(_ effect: SoundEffect) {
    guard let url = Bundle.main.url(forResource: effect.rawValue, withExtension: "mp3") else {
      print("Sound file for \(effect.rawValue) not found")
      return
    }

    guard audioPlayer?.url != url else {
      audioPlayer?.play()
      return
    }

    do {
      audioPlayer?.stop()

      audioPlayer = try AVAudioPlayer(contentsOf: url)
      audioPlayer?.prepareToPlay()
      audioPlayer?.play()
    } catch {
      print("Error initializing AVAudioPlayer for \(effect.rawValue): \(error)")
    }
  }

  public func stopSound() {
    audioPlayer?.stop()
  }
}
