import Foundation
import PythonLib
import PythonSwiftCore


extension _PyDecoder {
    final class UnkeyedContainer {
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]
        var data: PyPointer
        
        var count: Int?
        var currentIndex: Int = 0
        
        let buffer: UnsafeBufferPointer<PythonPointer>
        //let iter:
        private var iter: UnsafeBufferPointer<PythonPointer>.Iterator
       
        init(data: PyPointer,codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) {
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.data = data
            self.buffer = data.getBuffer()
            self.count = buffer.count
            self.iter = buffer.makeIterator()
            Py_IncRef(data)
        }
        
        deinit {
            Py_DecRef(data)
        }
        
        
        //@inlinable
        func next() -> PythonPointer { iter.next() ?? nil }
    }
}

extension _PyDecoder.UnkeyedContainer: UnkeyedDecodingContainer {
 
    
    var isAtEnd: Bool {
        currentIndex == count
    }
  
    
    func decodeNil() throws -> Bool {
        fatalError()
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        currentIndex += 1
        return try PyDecoder().decode(type, from: next())
    }
    

    
    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError()
    }

    func superDecoder() throws -> Decoder {
        fatalError()
    }
}

extension _PyDecoder.UnkeyedContainer: PyDictDecodingContainer {}
