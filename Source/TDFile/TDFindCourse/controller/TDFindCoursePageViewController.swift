//
//  TDFindCoursePageViewController.swift
//  edX
//
//  Created by Elite Edu on 2019/7/17.
//  Copyright © 2019 edX. All rights reserved.
//

import UIKit

class TDFindCoursePageViewController: UIViewController {//,UIGestureRecognizerDelegate

    typealias Environment = NetworkManagerProvider & OEXRouterProvider & OEXSessionProvider & OEXConfigProvider & OEXAnalyticsProvider
    private let environment : Environment
    
    let searchView = TDSearchCourseView()
    let segmentVC = TDSegmentedPageViewController()
    private let loadController = LoadStateViewController()
    
    init(environment : Environment) {
        self.environment = environment
        super.init(nibName: nil, bundle: nil)
        
        setSearchNav()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hexString: "#f5f5f5")
        
        loadController.setupInController(controller: self, contentView: self.view)
        loadController.state = .Initial
        
        loadTagData()
    }
    
    func loadTagData() {

//        SVProgressHUD.show()
//        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)

        let dic = NSMutableDictionary()
        dic.setValue("0", forKey: "page_index")
        dic.setValue("1000", forKey: "page_size")

        let host = OEXConfig.shared().apiHostURL()?.absoluteString
        let path = host! + APP_COURSE_TYPE_LIST_URL

        let manager = AFHTTPSessionManager()
        manager.get(path, parameters: dic, progress: nil, success: { (task, response) in

//            SVProgressHUD.dismiss()

            self.loadController.state = .Loaded
            self.loadController.view.isHidden = true

            let responseDic = response as! Dictionary<String, Any>
            let tagArray: Array<Any> = responseDic["results"] as! Array<Any>
            if tagArray.count > 0 {
                self.setTagDate(tagArray: tagArray)
            }

        }) { (task, error) in
//            SVProgressHUD.dismiss()
            self.showError(error: error as NSError)
            self.view.makeToast("加载标签失败", duration: 0.8, position: CSToastPositionCenter)
        }
    }
    
    public func showError(error : NSError?, icon : Icon? = nil, message : String? = nil) {
        let buttonInfo = MessageButtonInfo(title: Strings.reload) {[weak self] in
            self?.loadController.state = .Initial
            self?.loadTagData()
        }
        loadController.state = LoadState.failed(error: error, icon: icon, message: message, buttonInfo: buttonInfo)
    }
    
    func setTagDate(tagArray: Array<Any>) {

        var array: Array<Any> = ["全部"]
        var vcArray: Array<Any> = [TDFindCourseViewController(tagID: "", delegate: self)]

        for i in 0..<tagArray.count {

            let tagDic = tagArray[i] as? [String: Any]
            let tag: String = tagDic?["subject_name"] as! String
            array.append(tag)

            let tagiID = tagDic?["id"] as! Int
            let ocVC = TDFindCourseViewController(tagID: "\(tagiID)", delegate: self)
            vcArray.append(ocVC)
        }

        segmentVC.pageViewControllers = (vcArray as! [UIViewController])
        segmentVC.categoryView.titles = array as? [String]
        segmentVC.categoryView.originalIndex = 0
        segmentVC.categoryView.titleNormalColor = UIColor(hexString: "#2e313c")
        segmentVC.categoryView.titleSelectedColor = UIColor(hexString: "#2e313c")

        self.addChild(segmentVC)
        self.view.addSubview(segmentVC.view)

        segmentVC.didMove(toParent: self)

        segmentVC.view.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }
    
    func setSearchNav() {

        searchView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width-16, height: 44)
        searchView.searchButton.oex_addAction({[weak self] (action) in
            self?.gotoSearchCourseView()
        }, for: .touchUpInside)

        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        titleView.addSubview(searchView)
        self.navigationItem.titleView = titleView
    }
    
    func gotoSearchCourseView() {
        self.navigationController?.pushViewController(TDSearchCourseViewController(environment: self.environment), animated: true)
    }
}

extension TDFindCoursePageViewController: TDFindCourseViewControllerDelegate {
    func coursesTableChoseCourse(course : OEXCourse) {
        guard let courseID = course.course_id else {
            return
        }
        self.environment.router?.showCourseCatalogDetail(courseID: courseID, fromController:self)
    }
}
