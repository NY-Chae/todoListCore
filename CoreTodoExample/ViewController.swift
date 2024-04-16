//
//  ViewController.swift
//  CoreTodoExample
//
//  Created by woochan on 4/15/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
  
  private var context: NSManagedObjectContext {
    CoreDataManager.shared.persistentContainer.viewContext
  }
  
  private var data: [Todo] = [] {
    didSet {
      DispatchQueue.main.async { [weak self] in
        self?.tableView.reloadData()
      }
    }
  }
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.data = CoreDataManager.shared.fetchTodo()
    self.tableView.dataSource = self
  }

  @IBAction func didTapAdd(_ sender: Any) {
    
    let alert = UIAlertController(title: "할일 추가",
                                  message: nil,
                                  preferredStyle: .alert)
    
    alert.addTextField()
    
    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
    
    let addAction = UIAlertAction(title: "추가", style: .default, handler: { _ in
      
      guard let title = alert.textFields?.first?.text else { return }
      
      let todo = Todo(context: self.context)
      todo.id = .init()
      todo.title = title
      todo.isDone = false
      
      do {
        try self.context.save()
        self.data.append(todo)
      } catch {
        print(error)
      }
    })
    
    alert.addAction(cancelAction)
    alert.addAction(addAction)
    
    self.present(alert, animated: true)
  }
}

extension ViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as? TodoTableViewCell
    
    let todo = data[indexPath.row]
    
    cell?.delegate = self
    cell?.id = todo.id
    cell?.titleLabel.text = todo.title
    cell?.isDoneSwitch.isOn = todo.isDone
    
    return cell ?? UITableViewCell()
  }
  
  //MARK: 스와이프 삭제 동작
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .delete {
      let id = data[indexPath.row].id
      
      guard let todo = CoreDataManager.shared.fetchTodo(by: id).first
      else { 
        return
      }
      
      do {
        try context.delete(todo)
        self.data = CoreDataManager.shared.fetchTodo()
      } catch {
        print(error)
      }
    }
  }
}

extension ViewController: TodoTableViewCellDelegate {
  
  func didTap(id: UUID, isDone: Bool) {
    
    guard let todo = CoreDataManager.shared.fetchTodo(by: id).first else { return }
    
    todo.isDone = isDone
    
    do {
      try context.save()
      self.data = CoreDataManager.shared.fetchTodo()
    } catch {
      print(error)
    }
  }
}
