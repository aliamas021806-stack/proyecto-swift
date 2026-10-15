import Foundation

// DTOs que representan /posts y /users de JSONPlaceholder

public struct PostDTO: Codable, Sendable {
    public var userId: Int?
    public var id: Int?
    public var title: String
    public var body: String

    public init(userId: Int? = nil, id: Int? = nil, title: String = "", body: String = "") {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
}

public struct UserDTO: Codable, Sendable {
    public var id: Int?
    public var name: String
    public var username: String?
    public var email: String?

    public init(id: Int? = nil, name: String = "", username: String? = nil, email: String? = nil) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
    }
}
