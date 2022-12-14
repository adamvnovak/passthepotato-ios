////
////  UserAPI.swift
////  mist-ios
////
////  Created by Kevin Sun on 3/14/22.
////
//
//import Foundation
//import UIKit
//import Alamofire
//
//extension NSMutableData {
//  func appendString(_ string: String) {
//    if let data = string.data(using: .utf8) {
//      self.append(data)
//    }
//  }
//}
//
//struct IntermediateReadOnlyUser: Codable {
//    var badges: [String]
//    var id: Int
//    var username: String
//    var first_name: String
//    var last_name: String
//    var picture: String?
//    var thumbnail: String?
//}
//
////https://github.com/kean/Nuke
//
//typealias PhoneNumber = String;
//
//struct UserError: Codable {
//    let email: [String]?
//    let username: [String]?
//    let password: [String]?
//    let first_name: [String]?
//    let last_name: [String]?
//    let date_of_birth: [String]?
//    let sex: [String]?
//    let latitude: [String]?
//    let longitude: [String]?
//    let picture: [String]?
//    let confirm_picture: [String]?
//    let code: [String]?
//
//    let non_field_errors: [String]?
//    let detail: String?
//}
//
//struct UserPopulation: Codable {
//    let population: Int
//}
//
//struct AccessCode: Codable {
//    let code_string: String
//    let claimed_user: Int?
//}
//
//class UserAPI {
//    static let PATH_TO_USER_MODEL = "api/users/"
//    static let PATH_TO_MATCHING_PHONE_NUMBERS = "api/matching-phone-numbers/"
//    static let PATH_TO_MATCHES = "api/matches/"
//    static let PATH_TO_FRIENDSHIPS = "api/friendships/"
//    static let PATH_TO_NEARBY_USERS = "api/nearby-users/"
//    static let PATH_TO_VERIFY_PROFILE_PICTURE = "api-verify-profile-picture/"
//    static let PATH_TO_USER_POPULATION = "api/user-population/"
//    static let PATH_TO_ACCESS_CODES = "api/access-codes/"
//    static let PATH_TO_COLLECTIBLES = "api/collectibles/"
//
//    static let EMAIL_PARAM = "email"
//    static let USERNAME_PARAM = "username"
//    static let PASSWORD_PARAM = "password"
//    static let FIRST_NAME_PARAM = "first_name"
//    static let LAST_NAME_PARAM = "last_name"
//    static let DATE_OF_BIRTH_PARAM = "date_of_birth"
//    static let SEX_PARAM = "sex"
//    static let KEYWORDS_PARAM = "keywords"
//    static let WORDS_PARAM = "words"
//    static let PHONE_NUMBER_PARAM = "phone_number"
//    static let PHONE_NUMBERS_PARAM = "phone_numbers"
//    static let TOKEN_PARAM = "token"
//    static let LATITUDE_PARAM = "latitude"
//    static let LONGITUDE_PARAM = "longitude"
//    static let CODE_PARAM = "code"
//    static let COLLECTIBLE_PARAM = "collectible_type"
//
//    static let USER_RECOVERY_MESSAGE = "try again later"
//
//    static func throwAPIError(error: UserError) throws {
//        if let emailErrors = error.email,
//            let emailError = emailErrors.first {
//            throw APIError.ClientError(emailError, USER_RECOVERY_MESSAGE)
//        }
//        if let usernameErrors = error.username,
//            let usernameError = usernameErrors.first {
//            throw APIError.ClientError(usernameError, USER_RECOVERY_MESSAGE)
//        }
//        if let passwordErrors = error.password,
//            let passwordError = passwordErrors.first {
//            throw APIError.ClientError(passwordError, USER_RECOVERY_MESSAGE)
//        }
//        if let firstNameErrors = error.first_name,
//           let firstNameError = firstNameErrors.first {
//            throw APIError.ClientError(firstNameError, USER_RECOVERY_MESSAGE)
//        }
//        if let lastNameErrors = error.last_name,
//           let lastNameError = lastNameErrors.first {
//            throw APIError.ClientError(lastNameError, USER_RECOVERY_MESSAGE)
//        }
//        if let dobErrors = error.date_of_birth,
//           let dobError = dobErrors.first {
//            throw APIError.ClientError(dobError, USER_RECOVERY_MESSAGE)
//        }
//        if let sexErrors = error.sex,
//           let sexError = sexErrors.first {
//            throw APIError.ClientError(sexError, USER_RECOVERY_MESSAGE)
//        }
//        if let latitudeErrors = error.latitude,
//           let latitudeError = latitudeErrors.first{
//            throw APIError.ClientError(latitudeError, USER_RECOVERY_MESSAGE)
//        }
//        if let longitudeErrors = error.longitude,
//           let longitudeError = longitudeErrors.first{
//            throw APIError.ClientError(longitudeError, USER_RECOVERY_MESSAGE)
//        }
//        if let pictureErrors = error.picture,
//           let pictureError = pictureErrors.first{
//            throw APIError.ClientError(pictureError, USER_RECOVERY_MESSAGE)
//        }
//        if let confirmPictureErrors = error.confirm_picture,
//           let confirmPictureError = confirmPictureErrors.first{
//            throw APIError.ClientError(confirmPictureError, USER_RECOVERY_MESSAGE)
//        }
//        if let codeErrors = error.code,
//           let codeError = codeErrors.first{
//            throw APIError.ClientError(codeError, USER_RECOVERY_MESSAGE)
//        }
//        if let detailError = error.detail {
//            throw APIError.ClientError(detailError, USER_RECOVERY_MESSAGE)
//        }
//    }
//
//    static func filterUserErrors(data:Data, response:HTTPURLResponse) throws {
//        let statusCode = response.statusCode
//
//        if isSuccess(statusCode: statusCode) { return }
//        if isClientError(statusCode: statusCode) {
//            let error = try JSONDecoder().decode(UserError.self, from: data)
//            try throwAPIError(error: error)
//        }
//        throw APIError.Unknown
//    }
//
//    static func fetchNearbyUsers() async throws -> [ReadOnlyUser] {
//        let url = "\(Env.BASE_URL)\(PATH_TO_NEARBY_USERS)"
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: Data(), method: HTTPMethods.GET.rawValue)
//        try filterUserErrors(data: data, response: response)
//        return try JSONDecoder().decode([ReadOnlyUser].self, from: data)
//    }
//
//    static func fetchFriends() async throws -> [ReadOnlyUser] {
//        let url = "\(Env.BASE_URL)\(PATH_TO_FRIENDSHIPS)"
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: Data(), method: HTTPMethods.GET.rawValue)
//        try filterUserErrors(data: data, response: response)
//        return try JSONDecoder().decode([ReadOnlyUser].self, from: data)
//    }
//
//    static func fetchMatches() async throws -> [ReadOnlyUser] {
//        let url = "\(Env.BASE_URL)\(PATH_TO_MATCHES)"
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: Data(), method: HTTPMethods.GET.rawValue)
//        try filterUserErrors(data: data, response: response)
//        return try JSONDecoder().decode([ReadOnlyUser].self, from: data)
//    }
//
//    static func fetchUsers() async throws -> [ReadOnlyUser] {
//        let url = "\(Env.BASE_URL)\(PATH_TO_USER_MODEL)"
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: Data(), method: HTTPMethods.GET.rawValue)
//        try filterUserErrors(data: data, response: response)
//        return try JSONDecoder().decode([ReadOnlyUser].self, from: data)
//    }
//
//    static func fetchUserByUserId(userId:Int) async throws -> ReadOnlyUser {
//        let url = "\(Env.BASE_URL)\(PATH_TO_USER_MODEL)\(userId)/"
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: Data(), method: HTTPMethods.GET.rawValue)
//        try filterUserErrors(data: data, response: response)
//        return try JSONDecoder().decode(ReadOnlyUser.self, from: data)
//    }
//
//    static func fetchUsersByUsername(username:String) async throws -> [ReadOnlyUser] {
//        let url = "\(Env.BASE_URL)\(PATH_TO_USER_MODEL)?\(USERNAME_PARAM)=\(username)"
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: Data(), method: HTTPMethods.GET.rawValue)
//        try filterUserErrors(data: data, response: response)
//        return try JSONDecoder().decode([ReadOnlyUser].self, from: data)
//    }
//
//    static func fetchUsersByFirstName(firstName:String) async throws -> [ReadOnlyUser] {
//        let url = "\(Env.BASE_URL)\(PATH_TO_USER_MODEL)?\(FIRST_NAME_PARAM)=\(firstName)"
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: Data(), method: HTTPMethods.GET.rawValue)
//        try filterUserErrors(data: data, response: response)
//        return try JSONDecoder().decode([ReadOnlyUser].self, from: data)
//    }
//
//    static func fetchUsersByLastName(lastName:String) async throws -> [ReadOnlyUser] {
//        let url = "\(Env.BASE_URL)\(PATH_TO_USER_MODEL)?\(LAST_NAME_PARAM)=\(lastName)"
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: Data(), method: HTTPMethods.GET.rawValue)
//        try filterUserErrors(data: data, response: response)
//        return try JSONDecoder().decode([ReadOnlyUser].self, from: data)
//    }
//
//    static func fetchUsersByWords(words:[String]) async throws -> [ReadOnlyUser] {
//        var url = "\(Env.BASE_URL)\(PATH_TO_USER_MODEL)?"
//        if words.isEmpty {
//            return []
//        }
//        for word in words {
//            url += "\(WORDS_PARAM)=\(word)&"
//        }
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: Data(), method: HTTPMethods.GET.rawValue)
//        try filterUserErrors(data: data, response: response)
//        return try JSONDecoder().decode([ReadOnlyUser].self, from: data)
//    }
//
//    static func fetchUsersByPhoneNumbers(phoneNumbers:[PhoneNumber]) async throws -> [PhoneNumber: ReadOnlyUser] {
//        let url = "\(Env.BASE_URL)\(PATH_TO_MATCHING_PHONE_NUMBERS)"
//        if phoneNumbers.isEmpty {
//            return [:]
//        }
//        let params:[String:[String]] = [
//            PHONE_NUMBERS_PARAM: phoneNumbers
//        ]
//        let json = try JSONEncoder().encode(params)
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: json, method: HTTPMethods.POST.rawValue)
//        try filterUserErrors(data: data, response: response)
//        return try JSONDecoder().decode([PhoneNumber: ReadOnlyUser].self, from: data)
//    }
//
//    static func fetchAuthedUserByToken(token:String) async throws -> CompleteUser {
//        let url = "\(Env.BASE_URL)\(PATH_TO_USER_MODEL)?\(TOKEN_PARAM)=\(token)"
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: Data(), method: HTTPMethods.GET.rawValue)
//        try filterUserErrors(data: data, response: response)
//        let queriedUsers = try JSONDecoder().decode([CompleteUser].self, from: data)
//        let tokenUser = queriedUsers[0]
//        return tokenUser
//    }
//
//    static func fetchUserCount() async throws -> Int {
//        let url = "\(Env.BASE_URL)\(PATH_TO_USER_POPULATION)"
//        let (data, _) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: Data(), method: HTTPMethods.GET.rawValue)
//        let userPopulation = try JSONDecoder().decode(UserPopulation.self, from: data)
//        return userPopulation.population
//    }
//
//    static func postAccessCode(code:String) async throws {
//        let url = "\(Env.BASE_URL)\(PATH_TO_ACCESS_CODES)"
//        let params:[String:String] = [
//            CODE_PARAM: code
//        ]
//        let json = try JSONEncoder().encode(params)
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData:json, method: HTTPMethods.POST.rawValue)
//        try filterUserErrors(data: data, response: response)
//    }
//
//    static func isAccessCodeAvailable(code:String) async throws -> Bool {
//        let url = "\(Env.BASE_URL)\(PATH_TO_ACCESS_CODES)?code=\(code)"
//        let (data, response) = try await BasicAPI.basicHTTPCallWithoutToken(url: url, jsonData:Data(), method: HTTPMethods.GET.rawValue)
//        try filterUserErrors(data: data, response: response)
//        let accessCodes = try JSONDecoder().decode([AccessCode].self, from: data)
//        return !accessCodes.isEmpty
//    }
//
//    static func verifyProfilePic(profilePicture:UIImage, confirmPicture: UIImage) async throws {
//        if let profilePictureData = profilePicture.pngData(),
//           let confirmPictureData = confirmPicture.pngData() {
//
//            let AUTH_HEADERS:HTTPHeaders = [
//                "Authorization": "Token \(getGlobalAuthToken())"
//            ]
//
//            let request = AF.upload(
//                multipartFormData:
//                    { multipartFormData in
//                        multipartFormData.append(profilePictureData, withName: "picture", fileName: "picture.png", mimeType: "image/png");
//                        multipartFormData.append(confirmPictureData, withName: "confirm_picture", fileName: "confirm_picture.png", mimeType: "image/png")
//                    },
//                to: "\(Env.AI_URL)\(PATH_TO_VERIFY_PROFILE_PICTURE)",
//                method: .patch,
//                headers: AUTH_HEADERS
//            )
//
//            let response = await request.serializingDecodable(UserError.self).response
//
//            if let httpData = response.data, let httpResponse = response.response {
//                try BasicAPI.filterBasicErrors(data: httpData, response: httpResponse)
//                try filterUserErrors(data: httpData, response: httpResponse)
//            } else {
//                throw APIError.NoResponse
//            }
//
//        }
//    }
//
//    static func patchProfilePic(image:UIImage, id:Int, username:String) async throws -> CompleteUser {
//        let imgData = image.pngData()
//
//        let AUTH_HEADERS:HTTPHeaders = [
//            "Authorization": "Token \(getGlobalAuthToken())"
//        ]
//
//        let request = AF.upload(
//            multipartFormData:
//                { multipartFormData in
//                    multipartFormData.append(imgData!, withName: "picture", fileName: "\(username).png", mimeType: "image/png")
//                },
//            to: "\(Env.BASE_URL)\(PATH_TO_USER_MODEL)\(id)/",
//            method: .patch,
//            headers: AUTH_HEADERS
//        )
//
//        let response = await request.serializingDecodable(UserError.self).response
//
//        if let httpData = response.data, let httpResponse = response.response {
//            try BasicAPI.filterBasicErrors(data: httpData, response: httpResponse)
//            try filterUserErrors(data: httpData, response: httpResponse)
//        } else {
//            throw APIError.NoResponse
//        }
//
//        let authedUser = try await request.serializingDecodable(CompleteUser.self).value
//        return authedUser
//    }
//
//    static func patchConfirmProfilePic(image:UIImage, id:Int, username:String) async throws -> CompleteUser {
//        let imgData = image.pngData()
//
//        let AUTH_HEADERS:HTTPHeaders = [
//            "Authorization": "Token \(getGlobalAuthToken())"
//        ]
//
//        let request = AF.upload(
//            multipartFormData:
//                { multipartFormData in
//                    multipartFormData.append(imgData!, withName: "confirm_picture", fileName: "\(username).png", mimeType: "image/png")
//                },
//            to: "\(Env.BASE_URL)\(PATH_TO_USER_MODEL)\(id)/",
//            method: .patch,
//            headers: AUTH_HEADERS
//        )
//
//        let response = await request.serializingDecodable(UserError.self).response
//
//        if let httpData = response.data, let httpResponse = response.response {
//            try BasicAPI.filterBasicErrors(data: httpData, response: httpResponse)
//            try filterUserErrors(data: httpData, response: httpResponse)
//        } else {
//            throw APIError.NoResponse
//        }
//
//        let authedUser = try await request.serializingDecodable(CompleteUser.self).value
//        return authedUser
//    }
//
//    static func patchUsername(username:String, id:Int) async throws -> CompleteUser {
//        let url =  "\(Env.BASE_URL)\(PATH_TO_USER_MODEL)\(id)/"
//        let params:[String:String] = [USERNAME_PARAM: username]
//        let json = try JSONEncoder().encode(params)
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: json, method: HTTPMethods.PATCH.rawValue)
//        try filterUserErrors(data: data, response: response)
//        return try JSONDecoder().decode(CompleteUser.self, from: data)
//    }
//
//    static func patchPassword(password:String, id:Int) async throws -> CompleteUser {
//        let url =  "\(Env.BASE_URL)\(PATH_TO_USER_MODEL)\(id)/"
//        let params:[String:String] = [PASSWORD_PARAM: password]
//        let json = try JSONEncoder().encode(params)
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: json, method: HTTPMethods.PATCH.rawValue)
//        try filterUserErrors(data: data, response: response)
//        return try JSONDecoder().decode(CompleteUser.self, from: data)
//    }
//
//    static func patchFirstName(firstName:String, id:Int) async throws -> CompleteUser {
//        let url =  "\(Env.BASE_URL)\(PATH_TO_USER_MODEL)\(id)/"
//        let params:[String:String] = [FIRST_NAME_PARAM: firstName]
//        let json = try JSONEncoder().encode(params)
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: json, method: HTTPMethods.PATCH.rawValue)
//        try filterUserErrors(data: data, response: response)
//        return try JSONDecoder().decode(CompleteUser.self, from: data)
//    }
//
//    static func patchLastName(lastName:String, id:Int) async throws -> CompleteUser {
//        let url =  "\(Env.BASE_URL)\(PATH_TO_USER_MODEL)\(id)/"
//        let params:[String:String] = [LAST_NAME_PARAM: lastName]
//        let json = try JSONEncoder().encode(params)
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: json, method: HTTPMethods.PATCH.rawValue)
//        try filterUserErrors(data: data, response: response)
//        return try JSONDecoder().decode(CompleteUser.self, from: data)
//    }
//
//    static func patchLatitudeLongitude(latitude:Double, longitude:Double, id:Int) async throws -> CompleteUser {
//        let url =  "\(Env.BASE_URL)\(PATH_TO_USER_MODEL)\(id)/"
//        let params:[String:Double] = [
//            LATITUDE_PARAM: latitude,
//            LONGITUDE_PARAM: longitude,
//        ]
//        let json = try JSONEncoder().encode(params)
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: json, method: HTTPMethods.PATCH.rawValue)
//        try filterUserErrors(data: data, response: response)
//        return try JSONDecoder().decode(CompleteUser.self, from: data)
//    }
//
//    static func patchKeywords(keywords:[String], id:Int) async throws -> CompleteUser {
//        let url =  "\(Env.BASE_URL)\(PATH_TO_USER_MODEL)\(id)/"
//        let params:[String:[String]] = [
//            KEYWORDS_PARAM: keywords,
//        ]
//        let json = try JSONEncoder().encode(params)
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: json, method: HTTPMethods.PATCH.rawValue)
//        try filterUserErrors(data: data, response: response)
//        return try JSONDecoder().decode(CompleteUser.self, from: data)
//    }
//
//    static func deleteUser(user_id:Int) async throws {
//        let url =  "\(Env.BASE_URL)\(PATH_TO_USER_MODEL)\(user_id)/"
//        let (data, response) = try await BasicAPI.basicHTTPCallWithToken(url: url, jsonData: Data(), method: HTTPMethods.DELETE.rawValue)
//        try filterUserErrors(data: data, response: response)
//    }
//
//    static func UIImageFromURLString(url:String?) async throws -> UIImage {
//        guard let url = url else {
//            return Constants.defaultProfilePic
//        }
//
//        let (data, response) = try await BasicAPI.basicHTTPCallWithoutToken(url: url, jsonData: Data(), method: HTTPMethods.GET.rawValue)
//        try filterUserErrors(data: data, response: response)
//        return UIImage(data: data) ?? Constants.defaultProfilePic
//    }
//
//    //MARK: - Batch Calls
//
//    static func batchFetchUsersFromUserIds(_ userIds: Set<Int>) async throws -> [Int: ReadOnlyUser] {
//        guard userIds.count > 0 else { return [:] }
//      var users: [Int: ReadOnlyUser] = [:]
//      try await withThrowingTaskGroup(of: (Int, ReadOnlyUser).self) { group in
//        for userId in userIds {
//          group.addTask {
//              return (userId, try await UserAPI.fetchUserByUserId(userId: userId))
//          }
//        }
//        // Obtain results from the child tasks, sequentially, in order of completion
//        for try await (userId, user) in group {
//          users[userId] = user
//        }
//      }
//      return users
//    }
//
//    static func turnUserIntoFrontendUser(_ user: ReadOnlyUser) async throws -> ThumbnailReadOnlyUser {
//        return ThumbnailReadOnlyUser(readOnlyUser: user,
//                                    thumbnailPic: try await UIImageFromURLString(url: user.thumbnail),
//                                    profilePic: nil)
//    }
//
//    static func batchTurnUsersIntoFrontendUsers(_ users: [ReadOnlyUser]) async throws -> [Int: ThumbnailReadOnlyUser] {
//        guard users.count > 0 else { return [:] }
//        var frontendUsers: [Int: ThumbnailReadOnlyUser] = [:]
//        try await withThrowingTaskGroup(of: (Int, ThumbnailReadOnlyUser).self) { group in
//          for user in users {
//            group.addTask {
//                return (user.id, ThumbnailReadOnlyUser(readOnlyUser: user, thumbnailPic: try await UIImageFromURLString(url: user.thumbnail), profilePic: nil))
//            }
//          }
//          // Obtain results from the child tasks, sequentially, in order of completion
//          for try await (userId, frontendUser) in group {
//            frontendUsers[userId] = frontendUser
//          }
//        }
//        return frontendUsers
//    }
//
//    static func batchFetchProfilePics(_ users: [ReadOnlyUserType]) async throws -> [Int: UIImage] {
//        guard users.count > 0 else { return [:] }
//        var thumbnails: [Int: UIImage] = [:]
//      try await withThrowingTaskGroup(of: (Int, UIImage).self) { group in
//          for user in users {
//              group.addTask {
//                  return (user.id, try await UserAPI.UIImageFromURLString(url: user.picture))
//              }
//          }
//         // Obtain results from the child tasks, sequentially, in order of completion
//         for try await (id, thumbnail) in group {
//            thumbnails[id] = thumbnail
//         }
//      }
//      return thumbnails
//    }
//
////    static func batchFetchPicPaths(_ picPaths: [Int: String]) async throws -> [Int: UIImage] {
////        guard picPaths.count > 0 else { return [:] }
////        var thumbnails: [Int: UIImage] = [:]
////      try await withThrowingTaskGroup(of: (Int, UIImage).self) { group in
////          for (userId, picPath) in picPaths {
////              group.addTask {
////                  return (userId, try await UserAPI.UIImageFromURLString(url: picPath))
////              }
////          }
////         // Obtain results from the child tasks, sequentially, in order of completion
////         for try await (id, thumbnail) in group {
////            thumbnails[id] = thumbnail
////         }
////      }
////      return thumbnails
////    }
//}
