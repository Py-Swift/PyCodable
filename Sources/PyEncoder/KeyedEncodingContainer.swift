import Foundation
import PySwiftKit


extension PyEncoder {
    final class KeyedContainer<Key> where Key: CodingKey {
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]
        var target: PyPointer
        
        init(codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any], target: PyPointer) {
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.target = target
        }
    }
}

extension PyEncoder.KeyedContainer: KeyedEncodingContainerProtocol {
    func encodeNil(forKey key: Key) throws {
        fatalError()
    }
    
    func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
        fatalError()
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        fatalError()
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError()
    }
    
    func superEncoder() -> Encoder {
        fatalError()
    }
    
    func superEncoder(forKey key: Key) -> Encoder {
        fatalError()
    }
}

extension PyEncoder.KeyedContainer: PyEncodingContainer {}
