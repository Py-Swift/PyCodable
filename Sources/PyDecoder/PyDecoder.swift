import Foundation
import PythonSwiftCore
import PythonLib
/**
 
 */

extension CodingKey {
    
    func pyDictItem(data: PyPointer) -> PyPointer {
        self.stringValue.withCString {key in PyDict_GetItemString(data, key)}
    }
    func pyClassItem(data: PyPointer) -> PyPointer {
        self.stringValue.withCString {key in PyObject_GetAttrString(data, key)}
    }
}



final public class PyDecoder {
    func decode<T>(_ type: T.Type, from data: PyPointer) throws -> T where T : Decodable {
        //print(type, data)
        let decoder = _PyDecoder(data: data)
        return try T(from: decoder)
    }
}

final class _PyDecoder {
    var codingPath: [CodingKey] = []
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    var container: PyDictDecodingContainer?
    var data: PyPointer
    
    init(data: PyPointer) {
        self.data = data
    }
}

extension _PyDecoder: Decoder {
    fileprivate func assertCanCreateContainer() {
        precondition(self.container == nil)
    }
        
    func container<Key>(keyedBy type: Key.Type) -> KeyedDecodingContainer<Key> where Key : CodingKey {
        //assertCanCreateContainer()

        let container = DictContainer<Key>(data: data, codingPath: self.codingPath, userInfo: self.userInfo)
        self.container = container

        return KeyedDecodingContainer(container)
    }

    func unkeyedContainer() -> UnkeyedDecodingContainer {
        //assertCanCreateContainer()
        
        let container = UnkeyedContainer(data: data, codingPath: self.codingPath, userInfo: self.userInfo)
        self.container = container
        return container
    }
    
    func singleValueContainer() -> SingleValueDecodingContainer {
        //assertCanCreateContainer()
        
        let container = SingleValueContainer(data: data, codingPath: self.codingPath, userInfo: self.userInfo)
        self.container = container
        
        return container
    }
}

protocol PyDictDecodingContainer: AnyObject {
    
}
