import Foundation

// APIClient protocol que define las operaciones necesarias contra JSONPlaceholder.
// Implementación concreta (JSONPlaceholderAPI) usará URLSession y async/await.

public protocol APIClient {
    func fetchPosts() async throws -> [PostDTO]
    func fetchPost(id: Int) async throws -> PostDTO
    func fetchPosts(userId: Int) async throws -> [PostDTO]
    func createPost(_ post: PostDTO) async throws -> PostDTO
    func updatePost(_ post: PostDTO) async throws -> PostDTO
    func patchPost(id: Int, partial: [String: Any]) async throws -> PostDTO
    func deletePost(id: Int) async throws -> Void

    func fetchUsers() async throws -> [UserDTO]
    func fetchUser(id: Int) async throws -> UserDTO
}

// MARK: - JSONPlaceholder implementation

public final class JSONPlaceholderAPI: APIClient {
    private let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    private func request<T: Decodable>(_ url: URL, method: String = "GET", body: Data? = nil) async throws -> T {
        var req = URLRequest(url: url)
        req.httpMethod = method
        if let body = body {
            req.httpBody = body
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let (data, response) = try await session.data(for: req)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw NSError(domain: "JSONPlaceholderAPI", code: 1, userInfo: ["response": response])
        }
        return try JSONDecoder().decode(T.self, from: data)
    }

    public func fetchPosts() async throws -> [PostDTO] {
        let url = baseURL.appendingPathComponent("/posts")
        return try await request(url)
    }

    public func fetchPost(id: Int) async throws -> PostDTO {
        let url = baseURL.appendingPathComponent("/posts/\(id)")
        return try await request(url)
    }

    public func fetchPosts(userId: Int) async throws -> [PostDTO] {
        var comp = URLComponents(url: baseURL.appendingPathComponent("/posts"), resolvingAgainstBaseURL: false)!
        comp.queryItems = [URLQueryItem(name: "userId", value: String(userId))]
        return try await request(comp.url!)
    }

    public func createPost(_ post: PostDTO) async throws -> PostDTO {
        let url = baseURL.appendingPathComponent("/posts")
        let body = try JSONEncoder().encode(post)
        return try await request(url, method: "POST", body: body)
    }

    public func updatePost(_ post: PostDTO) async throws -> PostDTO {
        let url = baseURL.appendingPathComponent("/posts/\(post.id ?? 0)")
        let body = try JSONEncoder().encode(post)
        return try await request(url, method: "PUT", body: body)
    }

    public func patchPost(id: Int, partial: [String: Any]) async throws -> PostDTO {
        let url = baseURL.appendingPathComponent("/posts/\(id)")
        let body = try JSONSerialization.data(withJSONObject: partial)
        return try await request(url, method: "PATCH", body: body)
    }

    public func deletePost(id: Int) async throws {
        let url = baseURL.appendingPathComponent("/posts/\(id)")
        // JSONPlaceholder may return an empty object; decode to EmptyResponse to validate success.
        let _: EmptyResponse = try await request(url, method: "DELETE")
    }

    public func fetchUsers() async throws -> [UserDTO] {
        let url = baseURL.appendingPathComponent("/users")
        return try await request(url)
    }

    public func fetchUser(id: Int) async throws -> UserDTO {
        let url = baseURL.appendingPathComponent("/users/\(id)")
        return try await request(url)
    }
}

// JSONPlaceholder returns an empty object for some delete responses; use this to decode.
private struct EmptyResponse: Decodable {}
