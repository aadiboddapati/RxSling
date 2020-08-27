//
//  SNTModel.swift
//  RXSling
//
//  Created by Manish Ranjan on 24/04/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import Foundation

//SNT Data model

struct reportModel: Codable {
    let statusCode: String
    let data: [Report]?
    let message: String
}

struct Report: Codable{
    let token: String? 
    let DoctorToken: String?
    var DoctorMobNo: String?
    let ContentViewed: Int?
    let CreatedDate: Int?
    var CustomerName: String?
    var displayByNumber: Bool?
   
}

struct MobileData: Codable{
    let name : String
    let Mobileno: Int
}

struct reportDetailModel: Codable {
    let statusCode: String
    let data: ReportDetail?
    let message: String
}

struct ReportDetail: Codable{
    let deleteStatus: Bool?
    let expiryDate: Int?
    let expiryStatus: Bool?
    let longUrl: String?
    let mobileNumber: String?
    let sentTimeStamp: Int?
    let shortUrl: String?
    let viewStatus: Bool?
    let viewTimeStamp: Int?
    let welcomeMessage: String?
}

struct SNTModel: Codable {
    let message: String
    let statusCode: String
    let data: [SNTData]?
}

struct SNTData: Codable{
    let accessKey: String
    let approvalNo: String
    var availableShareCount: Int
    let createdBy: String
    let createdDate: Double
    let ctaLabel: String?
    let ctaValue: String?
    let customMessageText: String?
    let instructionMsg: String?
    let desc: String
    let hideShareBtn: Bool
    let hideViewCountBtn: Bool
    let lockCTA: Bool
    let lockProfilePic: Bool
    let lockWelcomeMsg: Bool
    let noOfViews: Int
    let selectedLanguage: SelectedLanguage
    let sntType: Int
    let sntURL: String
    let sntVersion:String?
    let targetGender:Int
    let thumbnailURL: String
    let title: String
    let totalShareCount: Int
    let usedShareCount: Int
    let voiceType: Int
    let showReport: Bool
    let mediaOverlayHide: Bool
    let mediaOverlayPosition: String?
 
    
    public func canSendSnt() -> Bool{
        return self.availableShareCount != 0
    }
}

struct SelectedLanguage:Codable {
    let id: Int
    let languageCode: String?
    let name: String?
}

//Validate Doctor Info
struct ValidateModel: Codable {
    let message: String
    let statusCode: String
    let data: Doctor?
}


struct Doctor: Codable{
    let consentflag: Int
    let doctorAccountId: String
    let isAuthorised: Bool
    let isDoctorAvailable: Bool
    let isOrgLevelAuthorised: Bool
    let isRepLevelAuthorised: Bool
    let isSentToDoctor: Bool
    let lastSentDate: String
}


 
//Shorten Url Model
struct ShortenModel: Codable {
    let data: ShortenData?
    let message: String
    let statusCode: String
}

struct ShortenData: Codable {
    let shortenURL: String
    let longURL: String
}


struct logoutModel:Codable{
    let data: String?
    let message: String?
    let statusCode: String

}
