//
//  AnswerEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.07.2023.
//
//

import Foundation
import CoreData

extension AnswerEntity {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<AnswerEntity> {
    return NSFetchRequest<AnswerEntity>(entityName: "AnswerEntity")
  }

  @NSManaged public var content: String
  @NSManaged public var answerId: Int
  @NSManaged public var questionId: Int

  func toModel() -> Answer {
    return Answer(id: self.answerId, content: self.content, questionId: self.questionId)
  }
}

extension AnswerEntity: Identifiable {

}
