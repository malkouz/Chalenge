//
//  ShopsVC.swift
//  Chalenge
//
//  Created by Moayad Al kouz on 7/25/1438 AH.
//  Copyright © 1438 Moayad Al kouz. All rights reserved.
//

import UIKit
import GoogleMaps

let AddMarkersNotificationKey = "AddMarkersNotificationKey"

class ShopsVC: UIViewController, GMSMapViewDelegate {

    lazy var detailsVC: ShopDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShopDetailsVC") as! ShopDetailsVC
    
    @IBOutlet weak var mapView:GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let camera = GMSCameraPosition.camera(withLatitude: 24.66080796834796, longitude: 46.74393475055695, zoom: 11.0)
        mapView.camera = camera
        mapView.delegate = self
        // Creates a marker in the center of the map.
        NotificationCenter.default.addObserver(self, selector: #selector(ShopsVC.addBranchesMarkers), name: Notification.Name(rawValue: AddMarkersNotificationKey), object: nil)

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addShopDetailsView()
    }
    

    func addShopDetailsView() {
        // 1- Init bottomSheetVC
        
        
        // 2- Add bottomSheetVC as a child view
        self.addChildViewController(detailsVC)
        self.view.addSubview(detailsVC.view)
        detailsVC.didMove(toParentViewController: self)
        
        // 3- Adjust bottomSheet frame and initial position.
        let height = view.frame.height
        let width  = view.frame.width
        detailsVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
    
    
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    
        detailsVC.view.isHidden = !(detailsVC.view.isHidden)
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func addBranchesMarkers(){
        for branch in detailsVC.shopsVM.branches{
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: branch.latitude, longitude: branch.longitude)
            marker.title = branch.address
            marker.map = mapView
        }
    }
}
