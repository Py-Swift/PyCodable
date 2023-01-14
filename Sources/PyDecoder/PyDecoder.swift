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
        let rtn = self.stringValue.withCString {key in PyObject_GetAttrString(data, key)}
        defer { Py_DecRef(rtn) }
        return rtn
    }
}



final public class PyDecoder {
    public func decode<T>(_ type: T.Type, from data: PyPointer) throws -> T where T : Decodable {
        let decoder = _PyDecoder(data: data)
        return try T(from: decoder)
    }
    
    public init() {
        
    }
}

final class _PyDecoder {
    var codingPath: [CodingKey] = []
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    var container: PyDecodingContainer?

    var data: PyPointer
    
    init(data: PyPointer) {
        self.data = data
        Py_IncRef(data)
    }
    
    deinit {
        Py_DecRef(data)
    }
}

extension _PyDecoder: Decoder {
    fileprivate func assertCanCreateContainer() {
        precondition(self.container == nil)
    }
        
    func container<Key>(keyedBy type: Key.Type) -> KeyedDecodingContainer<Key> where Key : CodingKey {
        //assertCanCreateContainer()
        if PythonDict_Check(data) {
            let container = DictContainer<Key>(data: data, codingPath: self.codingPath, userInfo: self.userInfo)
            self.container = container
            
            return KeyedDecodingContainer(container)
        }
        let container = ClassContainer<Key>(data: data, codingPath: self.codingPath, userInfo: self.userInfo)
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

protocol PyDecodingContainer: AnyObject {
    
}
