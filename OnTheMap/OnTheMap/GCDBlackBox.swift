//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Geek on 2/22/19.
//  Copyright © 2019 Geek. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
