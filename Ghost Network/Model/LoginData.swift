//
//  LoginData.swift
//  Ghost Network
//
//  Created by MacBook on 06.07.2021.
//

import Foundation

struct LoginData: Codable {
    let access_token: String
}

struct UserData: Codable {
    let firstName: String?
    let lastName: String?
    let gender: String?
    let dateOfBirth : String?

}


