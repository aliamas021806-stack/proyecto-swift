import Foundation
import SwiftData

/// Factory to create an AppointmentRepository for a given ModelContext.
/// This keeps View code simple: pass the current ModelContext and get a fully
/// wired repository (local store + API client).

public enum RepositoryFactory {
    public static func makeRepository(context: ModelContext) -> AppointmentRepositoryProtocol {
        let localStore = AppointmentLocalStore(context: context)
        let api = JSONPlaceholderAPI()
        return AppointmentRepository(apiClient: api, localStore: localStore)
    }
}
