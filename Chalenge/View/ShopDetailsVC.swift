//
//  ShopDetailsVC.swift
//  Chalenge
//
//  Created by Moayad Al kouz on 7/25/1438 AH.
//  Copyright © 1438 Moayad Al kouz. All rights reserved.
//

import UIKit
import AlamofireImage
import ACProgressHUD_Swift
class ShopDetailsVC: UIViewController {

    lazy var shopsVM = ShopsVM()
    
    @IBOutlet weak var tblBranches: UITableView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblShopDesc: UILabel!
    
    
    let fullView: CGFloat = 100
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - 150
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblBranches.dataSource = self
        tblBranches.delegate = self
        
        

        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(ShopDetailsVC.panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        
        
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        ACProgressHUD.shared.showHUD()
        shopsVM.getShops { [weak self] (error) in
            self?.configureView()
            ACProgressHUD.shared.hideHUD()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height - 100)
        })
    }
    
    func configureView(){
        lblShopName.text = shopsVM.getShopName()
        lblShopDesc.text = shopsVM.getShopDesc()
        if let url = shopsVM.getShopImageURL(){
        imgLogo.af_setImage(withURL: URL(string: url)!)
        }
        tblBranches.reloadData()
        NotificationCenter.default.post(name: Notification.Name(rawValue: AddMarkersNotificationKey), object: nil)
    }
    
    func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        let y = self.view.frame.minY
        if (y + translation.y >= fullView) && (y + translation.y <= partialView) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
            }, completion: { [weak self] _ in
                if ( velocity.y < 0 ) {
                    self?.tblBranches.isScrollEnabled = true
                }
            })
        }
    }


}

extension ShopDetailsVC: UIGestureRecognizerDelegate {
    
    // Solution
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        
        let y = view.frame.minY
        if (y == fullView && tblBranches.contentOffset.y == 0 && direction > 0) || (y == partialView) {
            tblBranches.isScrollEnabled = false
        } else {
            tblBranches.isScrollEnabled = true
        }
        
        return false
    }
    
}

extension ShopDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopsVM.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BranchCell", for: indexPath)
        cell.textLabel?.text = shopsVM.getBranchName(forIndex: indexPath.row)
        return cell
    }
}

