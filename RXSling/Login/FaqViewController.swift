//
//  FaqViewController.swift
//  ParrotNote
//
//  Created by Vinod Kumar on 25/02/19.
//  Copyright © 2019 Vinod Kumar. All rights reserved.
//
//struct cellData{
//    var opened = Bool()
//    var title = String()
//    var sectionData = String()
//}
struct faqList: Codable {
    var responseCode, message: String?
    var data: [cellData]

    enum CodingKeys: String, CodingKey {
        case responseCode = "code"
        case message = "details"
        case data
    }
    struct cellData: Codable {
        var id: Int?
        var opened:Bool? = false
        var question, answer: String?
    }
}


import UIKit

class FaqViewController: UIViewController,UIGestureRecognizerDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableViewTopConstrain: NSLayoutConstraint!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var faqTableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var slingImage: UIImageView!
    var FilteredData = [faqList.cellData]()
    var tableViewData = [faqList.cellData]()
    var index = Int()
    var isLinked:Bool = true
    var backButton : UIBarButtonItem!
    var attributedString = NSMutableAttributedString()
    var section: IndexPath = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "FAQ's"

        faqTableView.tableFooterView = UIView()
        self.tableViewTopConstrain.constant = 0
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Bg_3_320X480.png")!)
        
        self.faqTableView.rowHeight = UITableView.automaticDimension
        if FilteredData.count == 0
        {
            FilteredData = tableViewData
        }
        searchBar.delegate = self
        searchBar.layer.borderWidth = 0.5

        let searchTextField:UITextField = (searchBar.value(forKey: "searchField") as? UITextField)!

        searchTextField.tintColor = UIColor.white
        searchTextField.backgroundColor = UIColor(red:28/255, green: 45/255, blue: 29/255, alpha: 1.0)
        searchTextField.rightViewMode = UITextField.ViewMode.always
        searchTextField.layer.borderColor = UIColor.white.cgColor
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.masksToBounds = true
        searchTextField.textColor = UIColor.white
        searchBar.barTintColor = UIColor(red:28/255, green: 45/255, blue: 29/255, alpha: 1.0)
        searchBar.tintColor = UIColor.white
        let image = UIImage()
        searchBar.layer.borderColor = UIColor.clear.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.setBackgroundImage(image, for: .any, barMetrics: .default)

        self.navigationItem.rightBarButtonItem?.tintColor = GREENCOLOUR
        self.navigationItem.backBarButtonItem?.tintColor = GREENCOLOUR
        self.addDoneButtonOnKeyboard(textField: searchTextField)
        let image1 = UIImageView(image: UIImage(named: "Bg_3_320X480.png"))
        image1.contentMode = .scaleToFill
        if((USERDEFAULTS.value(forKey: "FAQDATA")) != nil){
            let jsonData = USERDEFAULTS.value(forKey: "FAQDATA") as! Data
            let faqData = [try! JSONDecoder().decode(faqList.self, from: jsonData)]
            self.tableViewData.removeAll()
            self.tableViewData = faqData[0].data
            self.loadTableView()
        }else{
            self.getFAQList()
        }
        //faqTableView.backgroundView = image1
        self.cancelBtn.setTitle("CANCEL", for: .normal)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.topItem?.hidesBackButton = true
        self.backButton = UIBarButtonItem(image: UIImage(named:"Back-22x22"), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.backBarButtonItem?.tintColor = GREENCOLOUR
        self.navigationController?.navigationBar.isExclusiveTouch = true
        self.navigationController?.navigationBar.isMultipleTouchEnabled = false
    }
    
    @objc func backButtonTapped(){
        self.navigationItem.leftBarButtonItem = self.backButton
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "FAQ's"
        self.faqTableView.estimatedRowHeight = 100
        searchButton.layer.cornerRadius = searchButton.frame.width/2
       
        if UIDevice.current.userInterfaceIdiom == .pad {
//            self.view.backgroundColor = UIColor(red: 0.45, green: 0.67, blue: 0.30, alpha: 0.5)
             self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Bg_4_1024x1366.png")!)
        } else {
               self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Bg_4_1024x1366.png")!)
        }
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
    }

    @IBAction func seacrhButtonTapped(_ sender: Any) {
        searchBar.returnKeyType = .default
        self.tableViewTopConstrain.constant = 76
        self.searchView.isHidden = false
        self.searchButton.isHidden = true
        showBarButtonItem()
        searchBar.becomeFirstResponder()
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.tableViewTopConstrain.constant = 0
        FilteredData.removeAll()
        FilteredData = tableViewData
        self.faqTableView.reloadData()
        self.searchView.isHidden = true
        self.searchButton.isHidden = false
        view.endEditing(true)
    }
    func addDoneButtonOnKeyboard(textField:UITextField){

        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        doneToolbar.barTintColor = UIColor.white
        doneToolbar.tintColor = GREENCOLOUR
        textField.inputAccessoryView = doneToolbar
        showBarButtonItem()

    }
    @objc func doneButtonAction(){
        hideBarBUttomItem()
        searchBar.endEditing(true)

       // otpTextField.resignFirstResponder()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideBarBUttomItem()
    }
    func getFAQList(){
        let networkConnection = try! Reachability.init()?.isConnectedToNetwork
        if (!networkConnection!)
        {
            if((USERDEFAULTS.value(forKey: "FAQDATA")) != nil){
                let jsonData = USERDEFAULTS.value(forKey: "FAQDATA") as! Data
                 let faqData = [try! JSONDecoder().decode(faqList.self, from: jsonData)]
                self.tableViewData.removeAll()
                self.tableViewData = faqData[0].data
                self.loadTableView()
            }else{
                self.popupAlert(title: "RXSling", message: "Please check your internet connection.", actionTitles: ["Ok"], actions:[{action1 in
                    }, nil])
            }
        }else{
            DispatchQueue.main.async {
                showActivityIndicator(View: self.view, "Loading FAQ's. Please wait...")
            }
            var request = URLRequest(url: URL(string:  Constants.Api.faqsUrl)!)
            request.httpMethod = "GET"
            //request.httpBody = try? JSONSerialization.data(withJSONObject: [], options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    print("FAQ -> \(json)")
                    if(json["statusCode"] as! String == "100"){
                        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
                        let faqData = [try! JSONDecoder().decode(faqList.self, from: jsonData)]
                        print("FAQ -> \(faqData)")
                        USERDEFAULTS.set(jsonData, forKey: "FAQDATA")
                        self.tableViewData.removeAll()
                        self.tableViewData = faqData[0].data
                        self.loadTableView()
                    }else{
                        DispatchQueue.main.async {
                            hideActivityIndicator(View: self.view)
                        }
                        self.popupAlert(title: "RXSling", message: "\(json["Message"]!)", actionTitles: ["Ok"], actions:[{action1 in
                            }, nil])
                    }
                } catch {
                    DispatchQueue.main.async {
                        hideActivityIndicator(View: self.view)
                    }
                    print("error")
                }
            })
            task.resume()
        }
    }
    func loadTableView(){

        for (index, element) in self.tableViewData.enumerated(){
            self.tableViewData[index].opened = false
            self.tableViewData[index].question = element.question!
        }
        self.FilteredData.removeAll()
        self.FilteredData = self.tableViewData

        DispatchQueue.main.async {
            self.faqTableView.delegate = self
            self.faqTableView.dataSource = self
            self.faqTableView.reloadData()
            hideActivityIndicator(View: self.view)
        }
    }
}
extension FaqViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
         return FilteredData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(FilteredData[section].opened!){
            return 2
        }else{
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as? FAQTitleTableViewCell else {return UITableViewCell()}
            cell.titleLabel?.text = FilteredData[indexPath.section].question
            //            if(index == indexPath.section){
            //                FilteredData[indexPath.section].opened = true
            //            }
            cell.titleLabel.sizeToFit()
            if(FilteredData[indexPath.section].opened!){
                cell.arrowImageView?.image = UIImage(named: "Drop-down-1")
            }else{
                cell.arrowImageView?.image = UIImage(named: "Drop-down")
            }
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CELLDATA") as? FAQDataTableViewCell else {return UITableViewCell()}
            //cell.delegate = self
            cell.descritionLabel.textColor = UIColor.white
            cell.descritionLabel.font = UIFont.systemFont(ofSize: 17)

            cell.descritionLabel.foregroundColor = { (linkResult) in
                switch linkResult.detectionType {
                case .userHandle:
                    return .red
                case .hashtag:
                    return .blue
                case .url:
                    return .gray
                case .textLink:
                    return .black
                case .email:
                    return GREENCOLOUR
                default:
                    return .black
                }
            }
            cell.descritionLabel.underlineStyle = { (linkResult) in
                switch linkResult.detectionType {
                case .userHandle, .hashtag:
                    return .double
                case .url:
                    return .single
                case .textLink:
                    return .single
                case .email:
                    return .double
                default:
                    return []
                }
            }
            cell.descritionLabel.didTouch = { (touchResult) in
                if touchResult.state == .ended {
                    if let type = touchResult.linkResult?.detectionType{
                        switch type{
                        case .email:
                            print("Email Found")
                            if let linkResult = touchResult.linkResult {
                                if let url = URL(string: "mailto:\(linkResult.text)") {
                                    if #available(iOS 10.0, *) {
                                        UIApplication.shared.open(url)
                                    } else {
                                        UIApplication.shared.openURL(url)
                                    }
                                }
                            }
                        case .url:
                            print("URL Found")
                        default:
                            break
                        }
                    }
                }

            }
            cell.descritionLabel.linkDetectionTypes = [.email, .url]
            let textLinks: [TextLink] = []
            cell.config(with: FilteredData[indexPath.section].answer!, textLinks: textLinks)
            return cell
        }
    }
    @objc func didTapLabel(sender:UITapGestureRecognizer? = nil){
        print("tapped")
        // if(isLinked){
        if let url = URL(string: "mailto:hello@myshowandtell.app") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        // }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 15))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            //            self.index = indexPath.section
            //            var i = 0
            //            for _ in FilteredData{
            //                FilteredData[i].opened = false
            //                i += 1
            //            }
            //             FilteredData[self.index].opened = true

            if(FilteredData[indexPath.section].opened!){
                FilteredData[indexPath.section].opened! = false
                FilteredData[self.index].opened! = false
                self.faqTableView.reloadData()
                //                let sections = IndexSet.init(integer: indexPath.section)
                //                tableView.reloadSections(sections, with: .none)
            }else{
                FilteredData[self.index].opened! = false
                FilteredData[indexPath.section].opened! = true


                self.faqTableView.reloadData()
                //                let sections = IndexSet.init(integer: indexPath.section)
                //                tableView.reloadSections(sections, with: .none)
            }
            self.index = indexPath.section
        }else{

        }
    }


}
extension FaqViewController:UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text! == "" {
            FilteredData = tableViewData
            faqTableView.reloadData()
        } else {
            FilteredData.removeAll()
            self.index = 0
            FilteredData = tableViewData.filter { $0.answer!.lowercased().contains(searchBar.text!.lowercased()) || $0.question!.lowercased().contains(searchBar.text!.lowercased()) }
            self.faqTableView.reloadData();
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


extension String {
    static func format(strings: [String],
                       boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                       boldColor: UIColor = UIColor.blue,
                       inString string: String,
                       font: UIFont = UIFont.systemFont(ofSize: 14),
                       color: UIColor = UIColor.black) -> NSAttributedString {
        let attributedString =
            NSMutableAttributedString(string: string,
                                      attributes: [
                                        NSAttributedString.Key.font: font,
                                        NSAttributedString.Key.foregroundColor: color])
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: boldColor]
        for bold in strings {
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
        }
        return attributedString
    }
}
