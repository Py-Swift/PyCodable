import Foundation
import PySwiftKit
import PythonCore
/**
 
 */
public struct PyEncoder {
    
    public init() {
        
    }
    public func encode(_ value: Encodable) throws -> PyPointer {
//        let encoder = _PyEncoder()
//        try value.encode(to: encoder)
//        return encoder.data
		fatalError()
    }
}
extension PyEncoder {
    final class _Encoder_ {
        
        typealias KeyedContainer = PyEncoder.KeyedContainer
        typealias UnkeyedContainer = PyEncoder.UnkeyedContainer
        typealias SingleValueContainer = PyEncoder.SingleValueContainer
        
        
        var codingPath: [CodingKey] = []
        
        var userInfo: [CodingUserInfoKey : Any] = [:]
        
        fileprivate var container: PyEncodingContainer?
        
        var data: PyPointer? = nil
        
        init() {
            
        }
    }
}
extension PyEncoder._Encoder_: Encoder {
    fileprivate func assertCanCreateContainer() {
        precondition(self.container == nil)
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        assertCanCreateContainer()
        
        let container = KeyedContainer<Key>(codingPath: self.codingPath, userInfo: self.userInfo, target: PyDict_New()!)
        self.container = container
        
        return KeyedEncodingContainer(container)
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        assertCanCreateContainer()
        
        let container = UnkeyedContainer(codingPath: self.codingPath, userInfo: self.userInfo)
        self.container = container
        
        return container
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        assertCanCreateContainer()
        
        let container = SingleValueContainer(codingPath: self.codingPath, userInfo: self.userInfo)
        self.container = container
        
        return container
    }
}

protocol PyEncodingContainer: AnyObject {
    
}
