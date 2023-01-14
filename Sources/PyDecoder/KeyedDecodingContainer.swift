import Foundation
import PythonLib
import PythonSwiftCore

extension _PyDecoder {
    final class DictContainer<Key> where Key: CodingKey {
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]
        var data: PyPointer
        
        init(data: PyPointer, codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) {
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.data = data
            Py_IncRef(data) // - PyDict_GetItemString gives a weakRef so we must make it strong
        }
        
        deinit {
            Py_DecRef(data)
        }
    }
    
    final class ClassContainer<Key> where Key: CodingKey {
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]
        var data: PyPointer
        
        init(data: PyPointer, codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) {
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.data = data
            //Py_IncRef(data) - PyObject_GetAttr gives a strongRef
        }
        
        deinit {
            Py_DecRef(data)
        }
    }
}

extension _PyDecoder.DictContainer: KeyedDecodingContainerProtocol {
    
    
    var allKeys: [Key] {
        fatalError()
    }
    
    func contains(_ key: Key) -> Bool {
        let k = key.stringValue.pyPointer
        let result = PyDict_Contains(data, k) == 1
        Py_DecRef(k)
        return result
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        key.pyDictItem(data: data) == PythonNone
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        return try PyDecoder().decode(type, from: key.pyDictItem(data: data))
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError()
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        fatalError()
    }
    
    func superDecoder() throws -> Decoder {
        fatalError()
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        fatalError()
    }
}

extension _PyDecoder.DictContainer: PyDictDecodingContainer {}



extension _PyDecoder.ClassContainer: KeyedDecodingContainerProtocol {
    var allKeys: [Key] {
        fatalError()
    }
    
    func contains(_ key: Key) -> Bool {
        fatalError()
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        fatalError()
    }
    
    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        fatalError()
    }
    
    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        fatalError()
    }
    
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        fatalError()
    }
    
    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        fatalError()
    }
    
    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        fatalError()
    }
    
    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        fatalError()
    }
    
    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        fatalError()
    }
    
    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        fatalError()
    }
    
    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        fatalError()
    }
    
    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        fatalError()
    }
    
    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        fatalError()
    }
    
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        fatalError()
    }
    
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        fatalError()
    }
    
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        fatalError()
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        fatalError()
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError()
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        fatalError()
    }
    
    func superDecoder() throws -> Decoder {
        fatalError()
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        fatalError()
    }
    
     
}
