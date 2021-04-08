//
//  Feedback.swift
//  Flips
//
//  Created by Jordan Foster on 3/28/21.
//

import Foundation

struct Feedback: Codable {
	
	let id: UUID
	let timestamp: Date
	let body: String
	
	init(id: UUID? = UUID(), timestamp: Date? = Date(), body: String) {
		
		self.id = id!
		self.timestamp = timestamp!
		self.body = body
		
	}
	
	init(feedbackEntity: FeedbackEntity) {
		
		self.id = feedbackEntity.id!
		self.timestamp = feedbackEntity.timestamp!
		self.body = feedbackEntity.body!
		
	}
	
	func convertToManagedObject() -> FeedbackEntity {
		
		let feedbackEntity = FeedbackEntity(context: PersistenceController.shared.container.viewContext)
		
		feedbackEntity.id = self.id
		feedbackEntity.timestamp = self.timestamp
		feedbackEntity.body = self.body
		
		return feedbackEntity
		
	}
}
