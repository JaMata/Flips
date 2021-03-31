//
//  Feedback.swift
//  Flips
//
//  Created by Jordan Foster on 3/28/21.
//

import Foundation

struct Feedback: Codable {
	
	public var id: UUID = UUID()
	public var timestamp: Date = Date()
	let body: String
	
	func convertToManagedObject() -> FeedbackEntity {
		
		let feedbackEntity = FeedbackEntity(context: PersistenceController.shared.container.viewContext)
		
		feedbackEntity.id = self.id
		feedbackEntity.timestamp = self.timestamp
		feedbackEntity.body = self.body
		
		return feedbackEntity
	}
	
	init(feedbackEntity: FeedbackEntity) {
		
		self.id = feedbackEntity.id!
		self.timestamp = feedbackEntity.timestamp!
		self.body = feedbackEntity.body!
		
	}
}
