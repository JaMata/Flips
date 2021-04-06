//
//  FlipsModel.swift
//  Flips
//
//  Created by Jordan Foster on 3/30/21.
//

import Foundation

protocol FlipsModel {
	var users: [User] { get }
	var flips: [Flip] { get }
	var feedbacks: [Feedback] { get }
}
