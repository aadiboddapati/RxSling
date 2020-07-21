//
//  TeamReportModel.swift
//  RXSling Stage
//
//  Created by chiranjeevi macharla on 07/07/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import Foundation
import UIKit


struct TeamReportModel: Codable {
       let statusCode: String
       var data: [TeamData]?
       let message: String
}

struct TeamData: Codable {
    let dateOfFirstShare: Int?
    let dateOfLastShare: Int?
    let viewedCount:Int?
    let repEmailId:String?
    let sentCount: Int?
    let sntId: String?
    var userData: UserData?
    var successRate: Double?
    
}

struct ClusterReportModel: Codable {
    
    let statusCode: String
    var data: ClusterData?
    let message: String
}

struct ClusterData: Codable {
    let asonDate:Double?
    var clusterReport:[ClusterReportData]?
}

struct ClusterReportData: Codable {
       let managerId: String?
       let viewedCount:Int?
       let sentCount: Int?
       var userData: UserData?
       var successRate: Double?
}

struct UserInfo: Codable {
    
     let statusCode: String
        let data: UserData?
        let message: String
    }
struct UserData: Codable {
    
    let emailId: String?
    let firstName: String?
    let lastName: String?
    let gender: Int?
    let mobileNo: String?
    var isShownEmail :Bool?
}


