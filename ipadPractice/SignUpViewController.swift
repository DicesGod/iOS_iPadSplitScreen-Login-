import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class SignUpViewController: UIViewController {
    
    var usersList = [User]()
    var willbesentuserName = ""
    
    @IBOutlet weak var userTableView: UITableView!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
    
    
    
    @IBAction func signup(_ sender: Any) {
        storeUsers{
            (done) in
            if done{
                navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
            else{
                //Try to save again using new data
            }
        }
        userTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        userTableView.delegate = self
        userTableView.dataSource = self
        print(usersList.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUsers()
        userTableView.reloadData()
    }
    
    func createAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true,completion: nil)
    }

    func storeUsers(completion: (_ done:Bool) ->()) {
            guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
                let user =  User(context: managedContext)
                user.firstname = firstName.text
                user.lastname = lastName.text
                user.username = userName.text
                user.password = passWord.text
                do{
                    try managedContext.save()
                    self.createAlert(title: "Done", message: "You have been register successfully")
                    completion(true)
                } catch{
                    self.createAlert(title: "Not Done", message: "Fail to save the user!")
                    completion(false)
                }
        }
    }

//Loading users
extension SignUpViewController{
    func fetchUsers(completion: (_ done: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        //managedContext.fetch(request)
        do{
            usersList = try managedContext.fetch(request) as! [User]
            completion(true)
        }catch{
            print("Failed to fetech user: ", error.localizedDescription)
            completion(false)
        }
    }
    
    func  fetchUsers(){
        fetchUsers(){
            (done) in
            if done{
                if usersList.count > 0 {
                    print("Data loaded! xD")
                }
            } else{
                print("Failed to load data! xD")
            }
        }
    }
}

extension SignUpViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ userTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.count
    }
    
    
    func tableView(_ userTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! TableViewCell
        let user = usersList[indexPath.row]
        cell.userFullName.text = String(user.firstname!)+" "+String(user.lastname!)
        return cell
    }
    
    func tableView(_ userTableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ userTableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ userTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = usersList[indexPath.row]
        willbesentuserName = user.username!
        //print(willbesentuserName)
        self.performSegue(withIdentifier: "showNextViewController", sender: self)
    }
}

//send data to nextViewController
extension SignUpViewController: SendDelegate{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNextViewController" {
            guard let viewController = segue.destination as? ViewController else {
                return
            }
            viewController.sendDelegate = self
            viewController.userName = willbesentuserName
            //print(willbesentuserName)
        }
    }
    
    func userDidSend(username: String) {
        userName.text = "hahaha"
    }
}
