//
//  Globals.swift
//  Dylan
//
//  Created by Henry Cooper on 26/06/2022.
//
import Foundation
import CloudKit
import OSLog

// swiftlint:disable identifier_name
let DylanContainer = CKContainer(identifier: "iCloud.Dylan")
let DylanDatabase = DylanContainer.publicCloudDatabase
