import Foundation
import PythonLib
import PythonSwiftCore



extension _PyDecoder {
    final class SingleValueContainer {
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]
        var data: PyPointer

        init(data: PyPointer,codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) {
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.data = data
            Py_IncRef(data)
        }
        
        deinit {
            Py_DecRef(data)
        }
    }
}

extension _PyDecoder.SingleValueContainer: SingleValueDecodingContainer {
    func decodeNil() -> Bool {
        fatalError()
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        if data == PythonNone { return false }
        if data == PythonFalse { return false }
        return true
    }
    
    func decode(_ type: String.Type) throws -> String {
        
        //pyPrint(data.xINCREF)
        guard PythonUnicode_Check(data) else { throw PythonError.unicode }
        return .init(cString: PyUnicode_AsUTF8(data))
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        if PythonFloat_Check(data){
            return PyFloat_AsDouble(data)
        } else if PythonLong_Check(data) {
            return PyLong_AsDouble(data)
        }
        else { throw PythonError.float }
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        fatalError()
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        guard PythonLong_Check(data) else { throw PythonError.long }
        return PyLong_AsLong(data)
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
        fatalError()
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
        fatalError()
    }

    func decode(_ type: Int32.Type) throws -> Int32 {
        fatalError()
    }

    func decode(_ type: Int64.Type) throws -> Int64 {
        fatalError()
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        fatalError()
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        guard PythonLong_Check(data) else { throw PythonError.long }
        return .init(clamping: PyLong_AsLong(data))
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        fatalError()
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        fatalError()
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        fatalError()
    }
  
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        fatalError()
    }
}

extension _PyDecoder.SingleValueContainer: PyDictDecodingContainer {}
