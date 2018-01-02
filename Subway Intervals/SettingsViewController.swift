//
//  SettingsViewController.swift
//  Subway Intervals
//
//  Created by Joel Davis on 6/10/15.
//  Copyright (c) 2015 Joel Davis. All rights reserved.
//

import UIKit
import SnapKit
import ChameleonFramework

class SettingsViewController: UIViewController
{
    lazy var presetsLabel = UILabel()
    
//     lazy var presetsCollection : UICollectionView = UICollectionView()
    
    override func viewDidLoad()
    {
        presetsLabel.text = "Presets"
        //presetsLabel.textColor = UIColor.flatYellow
        presetsLabel.textColor = UIColor.flatYellow
        self.view.addSubview( presetsLabel )
        
        self.view.setNeedsUpdateConstraints();
    }
    
    override func updateViewConstraints()
    {
        presetsLabel.snp.remakeConstraints{ (make) -> Void in
            make.top.equalTo( view.safeAreaLayoutGuide.snp.top )
            make.left.equalTo( view )
            make.right.equalTo( view )
            make.height.equalTo( 44.0 )
        }
        
        super.updateViewConstraints()
    }
}
