//
//  TabBarViewController.swift
//  Ghost Network
//
//  Created by MacBook on 17.07.2021.
//

import UIKit

class TabBarViewController: UITabBarController{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}
