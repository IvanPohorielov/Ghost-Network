//
//  LoginData.swift
//  Ghost Network
//
//  Created by MacBook on 06.07.2021.
//

import Foundation

//MARK: - LoginPageData

struct LoginData: Codable {
    let access_token: String
}

//MARK: - UserPageInfo

struct UserData: Codable {
    let firstName: String?
    let lastName: String?
    let gender: String?
    let dateOfBirth : String?

}
//MARK: - PostData

struct PostData: Codable {
    //let id: String?
    let content: String?
    let author: Author?
}

struct Author: Codable {
      //let id: String?
      let fullName: String?
      //let avatarUrl: String?
}

//MARK: - NewPostRequest

struct NewPost: Codable {
    let content: String
}
   
