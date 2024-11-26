
import UIKit

protocol EmployeeDetailTableViewControllerDelegate: AnyObject {
    func employeeDetailTableViewController(_ controller: EmployeeDetailTableViewController, didSave employee: Employee)
}

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate, EmployeeTypeTableViewController.EmployeeTypeTableViewControllerDelegate {
    @IBOutlet weak var dobDatePicker: UIDatePicker!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var employeeTypeLabel: UILabel!
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    var isEditingBirthday = false {
        didSet{
            dobDatePicker.isHidden = !isEditingBirthday
        }
    }
    
    weak var delegate: EmployeeDetailTableViewControllerDelegate?
    var employee: Employee?
    var selectedEmployeeType: EmployeeType?
    
    let dobDatePickerIndexPath = IndexPath(row: 2, section: 0)
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        updateSaveButtonState()
    }
    
    func updateView() {
        if let employee = employee {
            navigationItem.title = employee.name
            nameTextField.text = employee.name
            
            dobLabel.text = employee.dateOfBirth.formatted(date: .abbreviated, time: .omitted)
            dobLabel.textColor = .label
            employeeTypeLabel.text = employee.employeeType.description
            employeeTypeLabel.textColor = .label
        } else {
            navigationItem.title = "New Employee"
        }
    }
    
    private func updateSaveButtonState() {
        let shouldEnableSaveButton = nameTextField.text?.isEmpty == false
        saveBarButtonItem.isEnabled = shouldEnableSaveButton
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text else {
            return
        }
        
        let employee = Employee(name: name, dateOfBirth: Date(), employeeType: .exempt)
        delegate?.employeeDetailTableViewController(self, didSave: employee)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        employee = nil
    }

    @IBAction func nameTextFieldDidChange(_ sender: UITextField) {
        updateSaveButtonState()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath {
        case dobDatePickerIndexPath where isEditingBirthday == false:
            return 190
        default :
            return UITableView.automaticDimension
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 1{
            isEditingBirthday.toggle()
            
            dobLabel.textColor = .label
            let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dobLabel.text = dateFormatter.string(from: dobDatePicker.date)
        }
        }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dobLabel.text = dateFormatter.string(from: sender.date)
    }
    
    func employeeTypeTableViewController(_ controller: EmployeeTypeTableViewController, didSelect employeeType: EmployeeType) {
            self.selectedEmployeeType = employeeType
            
            // Update the label and its color
            employeeTypeLabel.text = employeeType.description
            employeeTypeLabel.textColor = .black
            
            // Update the save button state
            updateSaveButtonState()
        }
    
    
    @IBSegueAction func showEmployeeTypes(_ coder: NSCoder) -> EmployeeTypeTableViewController? {
        let employeeTypeVC = EmployeeTypeTableViewController(coder: coder)
                
                // Set the delegate to self
                employeeTypeVC?.delegate = self
                
                // Pass the currently selected employee type if editing
                employeeTypeVC?.employeeType = selectedEmployeeType
                
                return employeeTypeVC
    }
    
}
