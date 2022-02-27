//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by Kishore P on 25/02/22.
//

import Foundation

class TagListDetails {
    var tag : String?
    var taskList =  [ToDoList]()
    
}

struct ToDoListDetails: Codable {
    let data: [ToDoList]
    let totalRecords: Int

    enum CodingKeys: String, CodingKey {
        case data
        case totalRecords = "total_records"
    }
}

// MARK: - toDoList
struct ToDoList: Codable {
    var title: String
    var author: String
    var tag: String
    var isCompleted: Bool
    var priority: Priority?
    var id: Int

    enum CodingKeys: String, CodingKey {
        case title, author, tag
        case isCompleted = "is_completed"
        case priority, id
    }
}

enum Author: String, Codable {
    case ranjith = "Ranjith"
}

enum Priority: String, Codable {
    case high   = "HIGH"
    case low    = "LOW"
    case medium = "MEDIUM"
}

