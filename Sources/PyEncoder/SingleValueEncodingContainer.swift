import Foundation
import PySwiftKit

extension PyEncoder {
    final class SingleValueContainer {
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]
        
        init(codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) {
            self.codingPath = codingPath
            self.userInfo = userInfo
        }
    }
}

extension PyEncoder.SingleValueContainer: SingleValueEncodingContainer {
    func encodeNil() throws {
        fatalError()
    }
    
    func encode(_ value: Bool) throws {
        fatalError()
    }
    
    func encode(_ value: String) throws {
        fatalError()
    }
    
    func encode(_ value: Double) throws {
        fatalError()
    }
    
    func encode(_ value: Float) throws {
        fatalError()
    }
    
    func encode(_ value: Int) throws {
        fatalError()
    }
    
    func encode(_ value: Int8) throws {
        fatalError()
    }
    
    func encode(_ value: Int16) throws {
        fatalError()
    }
    
    func encode(_ value: Int32) throws {
        fatalError()
    }
    
    func encode(_ value: Int64) throws {
        fatalError()
    }
    
    func encode(_ value: UInt) throws {
        fatalError()
    }
    
    func encode(_ value: UInt8) throws {
        fatalError()
    }
    
    func encode(_ value: UInt16) throws {
        fatalError()
    }
    
    func encode(_ value: UInt32) throws {
        fatalError()
    }
    
    func encode(_ value: UInt64) throws {
        fatalError()
    }
    
    func encode<T>(_ value: T) throws where T : Encodable {
        fatalError()
    }
}

extension PyEncoder.SingleValueContainer: PyEncodingContainer {

}
