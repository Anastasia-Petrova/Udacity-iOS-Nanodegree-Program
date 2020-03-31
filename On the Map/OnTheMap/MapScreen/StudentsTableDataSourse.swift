//
//  StudentsTableDataSourse.swift
//  OnTheMap
//
//  Created by Anastasia Petrova on 20/03/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

struct StudentsData {
    var locations: [StudentLocation]
}

final class StudentsTableDataSource: NSObject, UITableViewDataSource {
    var studentsData: StudentsData
    
    init(studentsData: StudentsData) {
        self.studentsData = studentsData
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsData.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentsTableCell.identifier, for: indexPath) as! StudentsTableCell
        let location = studentsData.locations[indexPath.row]
        cell.studentName.text = location.firstName + " " + location.lastName
        cell.studentLink.text = location.link
        return cell
    }
}
