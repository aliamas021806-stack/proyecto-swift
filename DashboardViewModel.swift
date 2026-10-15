import Foundation
import SwiftUI
import SwiftData

@MainActor
public final class DashboardViewModel: ObservableObject {
    @Published public private(set) var appointments: [AppointmentModel] = []
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var errorMessage: String? = nil

    private var repository: AppointmentRepositoryProtocol?
    private var configured = false

    public init(repository: AppointmentRepositoryProtocol? = nil) {
        self.repository = repository
    }

    /// Configure with a ModelContext (lazy) — safe to call multiple times.
    public func configure(context: ModelContext) async {
        guard !configured else { return }
        configured = true
        if repository == nil {
            repository = RepositoryFactory.makeRepository(context: context)
        }
        await load()
    }

    @MainActor
    public func load() async {
        isLoading = true
        errorMessage = nil
        do {
            guard let repo = repository else { throw NSError(domain: "DashboardViewModel", code: 1) }
            let items = try await repo.fetchAll()
            appointments = items
        } catch {
            errorMessage = String(describing: error)
        }
        isLoading = false
    }
}
