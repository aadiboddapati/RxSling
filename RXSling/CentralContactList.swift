//
//  CentralContactList.swift
//  RXSling Stage
//
//  Created by chiranjeevi macharla on 22/07/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import Foundation


struct CentralContactList: Codable {
       let statusCode: String?
       let data: [ContactList]?
       let message: String?
}

struct ContactList: Codable {
     let accountId: String?
     let additionalInformation1: String?
     let city: String?
     let comments: String?
     let contactId:String?
     let country:String?
     let createdDate:String?
     let crmId:String?
     let dateOfRecordEntry:String?
     let deleteFlag:String?
     let dob:String?
     let emailId:String?
     let externalId1:String?
     let externalId2:String?
     let fbMessengerId:String?
     let firstName:String?
     let gender:String?
     let hospitalName:String?
     let landLineNo:String?
     let lastName:String?
     let lastUpdate:String?
     let lineId:String?
     let noOfYearsExperience:String?
     let officialDesignation:String?
     let orgId:String?
     let organizationId:String?
     let other:String?
     let pgDegree:String?
     let phoneNumberForSms:String?
     let postPgDegree:String?
     let privatePractice:String?
     let profession:String?
     let professionalRegistrationNumber:String?
     let professionalRegistrationState:String?
     let region:String?
     let skypeId:String?
     let specialty:String?
     let startedPracticeon:String?
     let state:String?
     let street:String?
     let type:String?
     let ugDegree:String?
     let updatedDate:String?
     let viberNumber:String?
     let weChatId:String?
     let whatsAppNumber:String?
     let zipCode:String?

}
