//
//  App.swift
//  FinalProject
//
//  Created by Bien Le Q. on 8/26/19.
//  Copyright © 2019 Asiantech. All rights reserved.
//
import Foundation

extension App {

    /**
     This file defines all localizable strings which are used in this application.
     Please localize defined strings in `Resources/Localizable.strings`.
     */

    struct String { }
}

extension App.String {
    struct Tittle {
        static var appName: String { return "theCollectors".localized() }
    }

    struct Alert {
        static var saving: String { return "Saving picture ... ".localized() }
        static var saveSuccessfully: String { return "Save successfully".localized() }
        static var uploading: String { return "Uploading picture ... ".localized() }
        static var uploadSuccessfully: String { return "Upload successfully".localized() }
    }

    struct Error {
        static var errorSomeThingWrong: String { return "Something was wrong".localized() }
    }
}
