//
//  Constants.swift
//  RXSling
//
//  Created by Manish Ranjan on 24/04/20.
//  Copyright © 2020 Divakara Y N. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Previously used Apis

struct Constants {
    
    struct Api {
        static let base = "http://demo.rxprism.com/Parrotnote/ParrotnoteService.svc/" // Stagging
        //"https://sling.rxprism.com/Service/ParrotnoteService.svc/" // Production
        static let dashboard = base + "LoadSNT"
        static let validateDoctorInfo = base + "ValidatedoctorandRep"
        static let shortenUrl = base + "AddShortenURL"
        static let profileUrl = base + "GetDetails"
        static let updateProfilePic = base + "ProfileUpdate?isForAdd=true"
        static let resetPin = base + "SetPin"
        static let removeProfilePic = base + "ProfileUpdate?isForAdd=false"
        static let loginUrl = base + "Login"
        static let registrationUrl = base + "ProfileRegistration?isForReg=true"
        static let validateMobileNumberUrl = base + "Validatemobilenumber"
        static let getUserPhoneNumberUrl = base + "ValidateUser"
        static let forgotPasswordUrl = base + "SetPin"
        static let updateProfileInfoUrl = base + "ProfileRegistration?isForReg=false"
        static let faqsUrl = "https://myshowandtell.app/rxsling/faqs.json"
        static let termsAndConditionsUrl = "https://myshowandtell.app/rxsling/terms.html"
        static let reportListUrl = base + "ViewSNTReport"
        static let sntReportDetailUrl = base + "ViewSNTReportDetails"
        static let logout = "Logout"
    }
    
    struct TableCell{

        static let dashboard = "DashboardTableCell"
       
    }
    
    struct StoryboadId {
        static let profilevc = "ProfileVC"
        static let playsntvc = "PlaySntViewController"
        static let sharesntvc = "ShareSntViewController"
        static let sharevc = "ShareViewController"
        static let reportvc = "ReportViewController"
        static let reportdetailvc = "ReportDetailViewController"
        static let teamreportvc = "TeamReportViewController"
        static let clusterreportvc = "ClusterReportViewController"
    }
    
  
    struct Alert{
        
        static let title = "RXSling"
        static let internetNotFound = "Please check your internet connection"
        static let tokenExpired = "Your session has expired please login to continue."
        static let openSettings = "Allow Contacts acess in Settings"
        static let restrictShareingSnt = "As per current account plan, you have exceeded the forwarding limit for this content, Please upgrade your account plan."
        static let contentExpired = "Link Expired.You cannot preview this Show & Tell Content."
        static let contentResent = "Link Expired.You cannot resend this Show & Tell Content."

    }
    
    struct Loader {
        
        static let loadingContacts = "Loading contacts. Please wait."
        static let logginIn = "Logging in. Please wait."
        static let loadingShowNtell = "Loading Show & Tell. Please wait."
        static let sureToLogout = "Are you sure you want to logout of the app?"
        static let loggingOut = "Logging out. Please wait."
        static let validating = "Validating. Please wait."
        static let processing = "Processing. Please wait."
        static let removeCustomer = "Are you sure you want to remove this customer?"
        static let reportDetails = "Fetching report details. Please wait."
        

    }
    
}

   
