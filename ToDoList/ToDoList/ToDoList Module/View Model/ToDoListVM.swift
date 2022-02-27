//
//  ToDoListVM.swift
//  ToDoList
//
//  Created by Kishore P on 25/02/22.
//

import UIKit

class ToDoListVM: NSObject {

    var toDoListDetail      = [ToDoList]()
    var totalRecord         = 0
    var tagListViewDetails  = [ToDoList]()
    var tagHeaderList       = [String]()
    var filteredTagList     = [TagListDetails]()
    var segmentArray        = ["Low","Medium","High"]
    var pageCount           = 1
    var selectedTabBar      = 0
    var reloadMainTableView :    (() -> Void)?
    var reloadTagTableView :    (() -> Void)?
    var isKeyBoardPresented = false
    
    override init() {
        super.init()
    }
     // Setting to do list details for loading main screen
    func setTodoListDetails(_ completionHandler: @escaping (_ complete: Bool) -> Void) {
        fetchToDoList(url: "http://167.71.235.242:3000/todo?_page=\(pageCount)&_limit=15&author=Kishore") { list in
            self.toDoListDetail.append(contentsOf: list.data)
            self.totalRecord    = list.totalRecords
            self.filterMainListBasedOnPriority()
            completionHandler(self.toDoListDetail.count != 0)
        }
    }
    
    //Setting tag list details data
    func setTagListDetails(_ completionHandler: @escaping (_ complete: Bool) -> Void) {
        fetchToDoList(url: "http://167.71.235.242:3000/todo?_page=1&_limit=1000&author=Kishore") { list in
            self.tagListViewDetails = list.data
            self.filterTagListBasedOnPriority()
            self.setHeaderTitles(self.tagListViewDetails)
            self.filterTaskListByTag()
            completionHandler(self.tagListViewDetails.count != 0)
        }
    }
    
    // filter main screen data by search
    func toDoListFilterBySearch(searchText: String,_ completionHandler: @escaping (_ complete: Bool) -> Void) {
        fetchToDoList(url: "http://167.71.235.242:3000/todo?_page=1&_limit=1500&author=Kishore&tag=\(searchText)") { list in
            self.toDoListDetail = list.data
            self.filterMainListBasedOnPriority()
            completionHandler(self.toDoListDetail.count != 0)
        }
    }
    
    // filter tag list data by search
    func tagListFilterBySearch(searchText: String,_ completionHandler: @escaping (_ complete: Bool) -> Void) {
        fetchToDoList(url: "http://167.71.235.242:3000/todo?_page=1&_limit=1500&author=Kishore&tag=\(searchText)") { list in
            self.tagListViewDetails = list.data
            self.setHeaderTitles(self.tagListViewDetails)
            self.filterTaskListByTag()
            completionHandler(self.tagListViewDetails.count != 0)
        }
    }
    
    // fetching data from API call
    func fetchToDoList(url: String,_ completionHandler: @escaping (_ list: ToDoListDetails) -> Void) {  //http://167.71.235.242:3000/todo?_page=1&_limit=15&author=Ranjith
        var request = URLRequest(url: URL(string: String(format: url))!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(ToDoListDetails.self, from: data!)
                completionHandler(responseModel)
            } catch {
                print(error.localizedDescription)
            }
        }).resume()
        
    }
    
    // Upload data through API call
    func uploadCreatedTask(list: ToDoList, urlString: String, hhtpMethod: String) {
        var taskData = Data()
        var bodyDictionary              = [String:Any]()
        bodyDictionary["title"]         = list.title
        bodyDictionary["author"]        = list.author
        bodyDictionary["tag"]           = list.tag
        bodyDictionary["is_completed"]  = list.isCompleted
        bodyDictionary["id"]            = list.id
        bodyDictionary["priority"]      = list.priority?.rawValue
        var request = URLRequest(url: URL(string: String(format: urlString))!)
        request.httpMethod = hhtpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            taskData = try JSONSerialization.data(withJSONObject: bodyDictionary, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        request.httpBody = taskData
        URLSession.shared.dataTask(with: request) { data, response, error -> Void in
            print(response ?? "")
        }.resume()
        
    }
    
    // getting colors based on priority type
    ///  Red  :  Low
    /// Yellow :  Medium
    /// Green :  High
    func getPriorityColor(priority: Priority) -> UIColor {
        switch priority {
        case .high:
            return .systemGreen
        case .medium:
            return .yellow
        default:
            return .red
        }
    }
    
    // Setting header values
    func setHeaderTitles(_ taskList : [ToDoList]) {
        tagHeaderList.removeAll()
        for tagList in taskList {
            if !tagHeaderList.contains(tagList.tag) {
                tagHeaderList.append(tagList.tag)
            }
        }
    }
    
    // filter task by tags
    func filterTaskListByTag()  {
        filteredTagList.removeAll()
        for each in tagHeaderList {
            let tagListDetails = TagListDetails()
            let filteredData = tagListViewDetails.filter({$0.tag == each})
            if filteredData.count > 0 {
                tagListDetails.tag = each
                tagListDetails.taskList = filteredData
                filteredTagList.append(tagListDetails)
            }
        }
    }
    
    
    // changing completed values
    func changeCompletedValue(index: Int) {
        toDoListDetail[index].isCompleted = !toDoListDetail[index].isCompleted
        uploadCreatedTask(list: toDoListDetail[index], urlString: "http://167.71.235.242:3000/todo/\(toDoListDetail[index].id)", hhtpMethod: "PUT")
    }
    
    // added new values updated in api as well as model
    func setCreatedvalues(list: ToDoList) {
        uploadCreatedTask(list: list, urlString: "http://167.71.235.242:3000/todo", hhtpMethod: "POST")
        toDoListDetail.append(list)
        if !tagHeaderList.contains(list.tag) {
            tagHeaderList.append(list.tag)
        }
        if filteredTagList.filter({$0.tag == list.tag}).count > 0 {
            var newList =  TagListDetails().taskList
            newList.append(list)
            filteredTagList.filter({$0.tag == list.tag}).first?.taskList.append(contentsOf: newList)
        } else {
            let newList =  TagListDetails()
            newList.tag = list.tag
            newList.taskList.append(list)
            filteredTagList.append(newList)
        }
        if selectedTabBar == 0 {
            self.filterMainListBasedOnPriority()
            reloadMainTableView?()
        } else {
            filterNewlyAddedTagList(list: list)
            reloadTagTableView?()
        }
    }
    
    // getiing priority values
    func getPriorityValue(index: Int) -> Priority {
        switch segmentArray[index] {
        case "High":
            return Priority.high
        case "Medium":
            return Priority.medium
        default:
            return Priority.low
        }
    }
    
    //creating unique id for new task
    func createUniqueId() -> Int {
        let someDate = Date()
        let timeInterval = someDate.timeIntervalSince1970
        let myInt = Int(timeInterval)
        return myInt
    }
    
    // increment paging count
    func incrementPageCount() {
        pageCount = pageCount + 1
    }
    
    // filter main list based on priority for showing list
    func filterMainListBasedOnPriority() {
        let highPeriorityValues     = toDoListDetail.filter({$0.priority == .high})
        let mediumPeriorityValues   = toDoListDetail.filter({$0.priority == .medium})
        let lowPeriorityValues      = toDoListDetail.filter({$0.priority == .low})
        toDoListDetail = highPeriorityValues + mediumPeriorityValues + lowPeriorityValues
    }
    
    // filter tag list based on priority for showing list
    func filterTagListBasedOnPriority() {
        let highPeriorityValues     = tagListViewDetails.filter({$0.priority == .high})
        let mediumPeriorityValues   = tagListViewDetails.filter({$0.priority == .medium})
        let lowPeriorityValues      = tagListViewDetails.filter({$0.priority == .low})
        tagListViewDetails = highPeriorityValues + mediumPeriorityValues + lowPeriorityValues
    }
    
    func filterNewlyAddedTagList(list: ToDoList) {
        let taskList = filteredTagList.filter({$0.tag == list.tag}).first?.taskList ?? []
        let highPeriorityValues     = taskList.filter({$0.priority == .high})
        let mediumPeriorityValues   = taskList.filter({$0.priority == .medium})
        let lowPeriorityValues      = taskList.filter({$0.priority == .low})
        filteredTagList.filter({$0.tag == list.tag}).first?.taskList = highPeriorityValues + mediumPeriorityValues + lowPeriorityValues
    }
}

// untextfield extension
extension UITextField {
    func setBoarder(){
        self.layer.borderWidth = 1
        self.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
        self.draw(self.frame)
    }
}

extension UIView {
    func addShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = 10
    }
}
