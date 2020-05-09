//
//  AppContext.swift
//  Pawsome
//
//  Created by Marentilo on 07.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import Foundation

typealias AppContextProtocol = NetworkServiceHolder &
                                FileManagerServiceHolder &
                                UserDefaultServiceHolder

struct AppContext : AppContextProtocol {
    let networkService : NetworkService
    let fileManagerService: FileManagerService
    let userDefaultService: UserDefaultService
    
    static func context () -> AppContext {
        let networkService = NetworkServiceImplementation()
        let fileManagerService = FileManagerServiceImplementation()
        let userDefaultService = UserDefaultServiceImpementation()
        
        return AppContext(networkService: networkService,
                          fileManagerService: fileManagerService,
                          userDefaultService: userDefaultService)
    }
}
