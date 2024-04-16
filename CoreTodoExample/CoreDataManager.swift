//
//  CoreDataManager.swift
//  CoreTodoExample
//
//  Created by woochan on 4/15/24.
//

import Foundation
import CoreData

class CoreDataManager {
  
  static let shared = CoreDataManager()
  
  lazy var persistentContainer: NSPersistentContainer = {

      let container = NSPersistentContainer(name: "Todo")
      
      container.loadPersistentStores { _, error in
          if let error {
              fatalError("Failed to load persistent stores: \(error.localizedDescription)")
          }
      }
      return container
  }()
  
  private init() { }
  
  /// 저장소에 저장되어있는 Todo 를 반환한다.
  /// id 가 전달되면 id 와 일치하는 Todo 를 반환한다.
  func fetchTodo(by id: UUID? = nil) -> [Todo] {
    
    let request = Todo.fetchRequest()
    
    if let id = id {
      request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
    }
    
    do {
      return try self.persistentContainer.viewContext.fetch(request)
    } catch {
      print(error)
      return []
    }
  }
}
