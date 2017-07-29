//
//  UIUtils.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 18/06/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Foundation
import SCLAlertView

class UIUtils {
    
    static func alertForCareerChoice(_ careers: Careers, completionHandler: @escaping (Void) -> Void) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false,
            showCircularIcon: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        let allCareers = careers.careers
        for career in allCareers! {
            alertView.addButton("\(career.tipoCorso!)", backgroundColor: Utils.myUnimolBlueUIColor, textColor: UIColor.white) {
                CacheManager.sharedInstance.storeCareer(career.id!)
                completionHandler()
            }
        }
        alertView.showNotice("È ora di scegliere!", subTitle: "\r\nHai intrapreso più di una carriera all'Unimol 😎! \r\n \r\nCon quale carriera vuoi utilizzare #MyUnimol?\r\n")
    }
}
