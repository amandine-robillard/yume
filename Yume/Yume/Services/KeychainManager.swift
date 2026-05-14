import Foundation
import Security

struct KeychainManager {
    static let shared = KeychainManager()
    
    private let serviceName = "yume"
    
    enum KeychainError: Error {
        case saveFailed
        case retrieveFailed
        case deleteFailed
        case itemNotFound
    }
    
    // MARK: - Save
    func save(_ value: String, for key: String) throws {
        let keyWithNamespace = "\(serviceName).\(key)"
        let data = value.data(using: .utf8) ?? Data()
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyWithNamespace,
            kSecValueData as String: data
        ]
        
        // Delete existing if present
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed
        }
    }
    
    // MARK: - Retrieve
    func retrieve(for key: String) throws -> String {
        let keyWithNamespace = "\(serviceName).\(key)"
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyWithNamespace,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess, let data = result as? Data else {
            throw KeychainError.itemNotFound
        }
        
        guard let value = String(data: data, encoding: .utf8) else {
            throw KeychainError.retrieveFailed
        }
        
        return value
    }
    
    // MARK: - Delete
    func delete(for key: String) throws {
        let keyWithNamespace = "\(serviceName).\(key)"
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyWithNamespace
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            throw KeychainError.deleteFailed
        }
    }
    
    // MARK: - Check existence
    func exists(for key: String) -> Bool {
        let keyWithNamespace = "\(serviceName).\(key)"
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyWithNamespace
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
}
