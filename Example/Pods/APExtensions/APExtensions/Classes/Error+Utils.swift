//
//  Error+Utils.swift
//  APExtensions
//
//  Created by Anton Plebanovich on 6/28/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import Foundation


extension Error {
    var isConnectError: Bool {
        guard _domain == NSURLErrorDomain else { return false }
        
        return _code == NSURLErrorNotConnectedToInternet
            || _code == NSURLErrorCannotFindHost
            || _code == NSURLErrorCannotConnectToHost
            || _code == NSURLErrorInternationalRoamingOff
            || _code == NSURLErrorNetworkConnectionLost
            || _code == NSURLErrorDNSLookupFailed
            || _code == NSURLErrorTimedOut
    }
}
