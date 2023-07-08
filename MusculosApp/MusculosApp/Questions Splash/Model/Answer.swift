//
//  Answer.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.06.2023.
//

import Foundation
import CoreData

struct Answer: Codable {
    var id: Int
    var content: String
    var questionId: Int
}

extension Answer: Hashable {
    static func == (lhs: Answer, rhs: Answer) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Answer {
    init(answerEntity: AnswerEntity) {
        self.id = answerEntity.answerId
        self.content = answerEntity.content
        self.questionId = answerEntity.questionId
    }
    
    func toEntity(in context: NSManagedObjectContext) -> AnswerEntity {
        let answerEntity = AnswerEntity(context: context)
        answerEntity.answerId = self.id
        answerEntity.content = self.content
        answerEntity.questionId = self.questionId
        return answerEntity
    }
}
