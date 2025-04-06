//
//  ConfigBase.swift
//  o-mate
//
//  Created by m1 on 06/04/2025.
//

import Foundation

protocol ConfigBase {
    /// Start page
    static var startURL: String { get }

    /// Domains that will always be opened inside the app
    static var internalDomains: [String] { get }
}
