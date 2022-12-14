//
//  UserService.swift
//  mist-ios
//
//  Created by Adam Novak on 2022/03/06.
//

import Foundation
import FirebaseAnalytics

class UserService: NSObject {
    
    //MARK: - Properties
    
    static var singleton = UserService()
    
    private var user: User?
    private var authedUser: User { //a wrapper for the real underlying frontendCompleteUser. if for some unknown reason, frontendCompleteUser is nil, instead of the app crashing with a force unwrap, we kick them to the home screen and log them out
        get {
            guard let authedUser = user else {
                if isLoggedIntoApp { //another potential check: if the visible view controller belongs to Main storyboard
                    kickUserToHomeScreenAndLogOut()
                }
                return User.NilUser
            }
            return authedUser
        }
        set {
            user = newValue
        }
    }

    //add a local device storage object
    private let LOCAL_FILE_APPENDING_PATH = "myaccount.json"
    private var localFileLocation: URL!
    
    private var SLEEP_INTERVAL:UInt32 = 30
    
    // Called on startup so that the singleton is created and isLoggedIn is properly initialized
    var isLoggedIntoAnAccount: Bool { //"is there a frontendCompleteUser which represents them?"
        return user != nil
    }
    private var isLoggedIntoApp = false //"have they passed beyond the auth process?" becomes true after login or signup or loading a user from the documents directory
    
    
    //MARK: - Initializer
    
    //private initializer because there will only ever be one instance of UserService, the singleton
    private override init() {
        super.init()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        localFileLocation = documentsDirectory.appendingPathComponent(LOCAL_FILE_APPENDING_PATH)
                
        if FileManager.default.fileExists(atPath: localFileLocation.path) {
            self.loadUserFromFilesystem()
            setupFirebaseAnalyticsProperties()
            isLoggedIntoApp = true
        }
    }
    
    //MARK: - Getters
    
    //Properties
    func getId() -> String { return authedUser.id }
    func getUsername() -> String { return authedUser.username }
    func getFirstName() -> String { return authedUser.firstName }
    func getLastName() -> String { return authedUser.lastName }

    //MARK: - Login and create user
    
    // No need to return new user from createAccount() bc new user is globally updated within this function
    func createUser(username: String,
                    firstName: String,
                    lastName: String,
                    profilePic: UIImage,
                    phoneNumber: String,
                    accessCode: String?,
                    email: String) async throws {
//        let newProfilePicWrapper = ProfilePicWrapper(image: profilePic, withCompresssion: true)
//        let compressedProfilePic = newProfilePicWrapper.image
//        let token = try await AuthAPI.createUser(username: username,
//                                            first_name: firstName,
//                                            last_name: lastName,
//                                            picture: compressedProfilePic,
//                                            phone_number: phoneNumber,
//                                            email: email)
//        setGlobalAuthToken(token: token)
//        if let accessCode = AuthContext.accessCode {
//            await UserService.singleton.tryToEnterAccessCode(accessCode)
//        }
//        let completeUser = try await UserAPI.fetchAuthedUserByToken(token: token)
//        frontendCompleteUser = FrontendCompleteUser(completeUser: completeUser,
//                                                    profilePicWrapper: newProfilePicWrapper,
//                                                    token: token)
//        authedUser = frontendCompleteUser!
//        await self.saveUserToFilesystem()
//        Task { await waitAndRegisterDeviceToken(id: completeUser.id) }
//        Task {
//            setupFirebaseAnalyticsProperties() //must come later at the end of this process so that we dont access authedUser while it's null and kick the user to the home screen
//        }
//        isLoggedIntoApp = true
    }
    
    func logInWith(authToken token: String) async throws {
//        setGlobalAuthToken(token: token)
//        let completeUser = try await UserAPI.fetchAuthedUserByToken(token: getGlobalAuthToken())
//        Task { await waitAndRegisterDeviceToken(id: completeUser.id) }
//        let profilePicUIImage = try await UserAPI.UIImageFromURLString(url: completeUser.picture)
//        frontendCompleteUser = FrontendCompleteUser(completeUser: completeUser,
//                                                    profilePicWrapper: ProfilePicWrapper(image: profilePicUIImage,withCompresssion: false),
//                                                    token: token)
//        setupFirebaseAnalyticsProperties()
//        await self.saveUserToFilesystem()
//        isLoggedIntoApp = true
    }
    
    //MARK: - Update user
    
    // No need to return new profilePic bc it is updated globally
    func updateUsername(to newUsername: String) async throws {
//        guard let frontendCompleteUser = frontendCompleteUser else { return }
//
//        let updatedCompleteUser = try await UserAPI.patchUsername(username: newUsername, id: frontendCompleteUser.id)
//        self.authedUser.username = updatedCompleteUser.username
//        Task {
//            await self.saveUserToFilesystem()
//            await UsersService.singleton.updateCachedUser(updatedUser: self.getUserAsFrontendReadOnlyUser())
//        }
    }
    
    func updateFirstName(to newFirstName: String) async throws {
//        guard let frontendCompleteUser = frontendCompleteUser else { return }
//
//        let updatedCompleteUser = try await UserAPI.patchFirstName(firstName: newFirstName, id: frontendCompleteUser.id)
//        self.authedUser.first_name = updatedCompleteUser.first_name
//        Task {
//            await self.saveUserToFilesystem()
//            await UsersService.singleton.updateCachedUser(updatedUser: self.getUserAsFrontendReadOnlyUser())
//        }
    }
    
    func updateLastName(to newLastName: String) async throws {
//        guard let frontendCompleteUser = frontendCompleteUser else { return }
//
//        let updatedCompleteUser = try await UserAPI.patchLastName(lastName: newLastName, id: frontendCompleteUser.id)
//        self.authedUser.last_name = updatedCompleteUser.last_name
//        Task {
//            await self.saveUserToFilesystem()
//            await UsersService.singleton.updateCachedUser(updatedUser: self.getUserAsFrontendReadOnlyUser())
//        }
    }
    
    // No need to return new profilePic bc it is updated globally
    func updateProfilePic(to newProfilePic: UIImage) async throws {
//        guard let frontendCompleteUser = frontendCompleteUser else { return }
//
//        let newProfilePicWrapper = ProfilePicWrapper(image: newProfilePic, withCompresssion: true)
//        let compressedNewProfilePic = newProfilePicWrapper.image
//        let updatedCompleteUser = try await UserAPI.patchProfilePic(image: compressedNewProfilePic,
//                                                                    id: frontendCompleteUser.id,
//                                                                    username: frontendCompleteUser.username)
//        self.authedUser.profilePicWrapper = newProfilePicWrapper
//        self.authedUser.picture = updatedCompleteUser.picture
//
//        Task {
//            await self.saveUserToFilesystem()
//            await UsersService.singleton.updateCachedUser(updatedUser: self.getUserAsFrontendReadOnlyUser())
//        }
    }
    
    //MARK: - Logout and delete user
    
    func logOutFromDevice()  {
//        guard isLoggedIntoAnAccount else { return } //prevents infinite loop on authedUser didSet
//        if getGlobalDeviceToken() != "" {
//            Task {
//                try await DeviceAPI.disableCurrentDeviceNotificationsForUser(user: authedUser.id)
//            }
//        }
//        PostService.singleton.resetEverything()
//        ConversationService.singleton.clearLocalData()
////        MistboxManager.shared.reset()
//        setGlobalAuthToken(token: "")
//        eraseUserFromFilesystem()
//        frontendCompleteUser = nil
//        isLoggedIntoApp = false
    }
    
    func kickUserToHomeScreenAndLogOut() {
        //they might already be logged out, so don't try and logout again. this will cause an infinite loop for checkingAuthedUser :(
        if isLoggedIntoAnAccount {
            logOutFromDevice()
        }
        DispatchQueue.main.async {
            transitionToAuth()
        }
    }
    
    func deleteMyAccount() async throws {
        do {
//            try await UserAPI.deleteUser(user_id: authedUser.id)
            logOutFromDevice()
        } catch {
            print(error)
            throw(error)
        }
    }
    
    //MARK: - Firebase
    
    func setupFirebaseAnalyticsProperties() {
        //if we decide to use firebase ad support framework in the future, gender, age, and interest will automatically be set
//        guard let age = frontendCompleteUser?.age else { return }
//        var ageBracket = ""
//        if age < 25 {
//            ageBracket = "18-24"
//        } else if age < 35 {
//            ageBracket = "25-35"
//        } else if age < 45 {
//            ageBracket = "35-45"
//        } else if age < 55 {
//            ageBracket = "45-55"
//        } else if age < 65 {
//            ageBracket = "55-65"
//        } else {
//            ageBracket = "65+"
//        }
//        Analytics.setUserProperty(authedUser.sex, forName: "sex")
//        Analytics.setUserProperty(ageBracket, forName: "age")
    }
    
    //MARK: - Filesystem
    
    func saveUserToFilesystem() async {
        do {
            guard let user = user else { return }
            let encoder = JSONEncoder()
            let data: Data = try encoder.encode(user)
            let jsonString = String(data: data, encoding: .utf8)!
            try jsonString.write(to: self.localFileLocation, atomically: true, encoding: .utf8)
        } catch {
            print("COULD NOT SAVE: \(error)")
        }
    }
    
    func loadUserFromFilesystem() {
        do {
            let data = try Data(contentsOf: self.localFileLocation)
            user = try JSONDecoder().decode(User.self, from: data)
//            guard let user = user else { return }
//            Task { await waitAndRegisterDeviceToken(id: user.id) }
        } catch {
            print("COULD NOT LOAD: \(error)")
        }
    }
    
    func eraseUserFromFilesystem() {
        do {
            try FileManager.default.removeItem(at: self.localFileLocation)
        } catch {
            print("\(error)")
        }
    }
    
    // MARK: - Device Notifications
    
//    func waitAndRegisterDeviceToken(id:Int) async {
//        do {
//            while true {
//                if getGlobalDeviceToken() != "" && getGlobalAuthToken() != "" {
//                    try await DeviceAPI.registerCurrentDeviceWithUser(user: id)
//                }
//                try await Task.sleep(nanoseconds: NSEC_PER_SEC * UInt64(SLEEP_INTERVAL))
//            }
//        } catch {
//            print("ERROR WAITING TO REGISTER DEVICE TOKEN")
//        }
//    }
}
