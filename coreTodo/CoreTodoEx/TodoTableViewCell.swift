//
//  TodoTableViewCell.swift
//  CoreTodoExample
//
//  Created by woochan on 4/15/24.
//

import UIKit

protocol TodoTableViewCellDelegate: AnyObject {
  func didTap(id: UUID, isDone: Bool)
}

class TodoTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var isDoneSwitch: UISwitch!
  
  var id: UUID?
  
  weak var delegate: TodoTableViewCellDelegate?
  
  @IBAction func didTapSwitch(_ sender: UISwitch) {
    
    guard let id = self.id else { return }
    
    self.delegate?.didTap(id: id, isDone: sender.isOn)
  }
}
