import Foundation

extension _PyEncoder {
    final class UnkeyedContainer {
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]
        
        init(codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) {
            self.codingPath = codingPath
            self.userInfo = userInfo
        }
    }
}

extension _PyEncoder.UnkeyedContainer: UnkeyedEncodingContainer {
    var count: Int {
        0
    }
    
    func encodeNil() throws {
        fatalError()
    }
    
    func encode<T>(_ value: T) throws where T : Encodable {
        fatalError()
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError()
    }
    
    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError()
    }
    
    func superEncoder() -> Encoder {
        fatalError()
    }
}

extension _PyEncoder.UnkeyedContainer: PyEncodingContainer {}
