import Foundation
//import PythonLib
import PySwiftKit
import PythonCore


extension PyDecoder {
    struct SingleValueContainer {
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]
        var data: PyPointer

        init(data: PyPointer,codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) {
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.data = data
		
            //Py_IncRef(data)
        }
        
//        deinit {
//            Py_DecRef(data)
//        }
    }
}

extension PyDecoder.SingleValueContainer: SingleValueDecodingContainer {
	
	
    func decodeNil() -> Bool {
		Py_IsNone(data) == 1
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        if data == PyNone { return false }
        if data == PyFalse { return false }
        return true
    }
    
//	func decode<T: Decodable>(_ type: T.Type) throws -> T where T == String {
//        if PythonUnicode_Check(data) {
//            return .init(cString: PyUnicode_AsUTF8(data))
//        }
//        if let str = PyObject_Str(data) {
//            defer {Py_DecRef(str)}
//            return .init(cString: PyUnicode_AsUTF8(str))
//        }
//        
//        throw PythonError.unicode
//    }
	
	func decode(_ type: String.Type) throws -> String {
		if PyUnicode_Check(data) {
			return .init(cString: PyUnicode_AsUTF8(data))
		}
		let str = PyObject_Str(data)
		defer { str?.decref()}
		return .init(cString: PyUnicode_AsUTF8(str))
	}
    
    func decode(_ type: Double.Type) throws -> Double {
        if PyFloat_Check(data){
            return PyFloat_AsDouble(data)
        } else if PyLong_Check(data) {
            return PyLong_AsDouble(data)
        }
        else { throw PythonError.float }
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        if PyFloat_Check(data){
            return .init(PyFloat_AsDouble(data))
        } else if PyLong_Check(data) {
            return .init(PyFloat_AsDouble(data))
        }
        else { throw PythonError.float }
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        guard PyLong_Check(data) else { throw PythonError.long }
        return PyLong_AsLong(data)
    }

    func decode(_ type: Int8.Type) throws -> Int8 {
        guard PyLong_Check(data) else { throw PythonError.long }
        return .init(clamping: PyLong_AsLong(data))
    }

    func decode(_ type: Int16.Type) throws -> Int16 {
        guard PyLong_Check(data) else { throw PythonError.long }
        return .init(clamping: PyLong_AsLong(data))
    }

    func decode(_ type: Int32.Type) throws -> Int32 {
        guard PyLong_Check(data) else { throw PythonError.long }
        return .init(clamping: PyLong_AsLong(data))
    }

    func decode(_ type: Int64.Type) throws -> Int64 {
        guard PyLong_Check(data) else { throw PythonError.long }
        return PyLong_AsLongLong(data)
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        guard PyLong_Check(data) else { throw PythonError.long }
        return PyLong_AsUnsignedLong(data)
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        guard PyLong_Check(data) else { throw PythonError.long }
        return .init(clamping: PyLong_AsUnsignedLong(data))
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        guard PyLong_Check(data) else { throw PythonError.long }
        return .init(clamping: PyLong_AsUnsignedLong(data))
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        guard PyLong_Check(data) else { throw PythonError.long }
        return .init(clamping: PyLong_AsUnsignedLong(data))
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        guard PyLong_Check(data) else { throw PythonError.long }
        return PyLong_AsUnsignedLongLong(data)
    }
  
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
		try PyDecoder().decode(type, from: data)
		
		//let decoder = PyDecoder._Decoder(data: data)
		//return try T.init(from: decoder)
    }
}

extension PyDecoder.SingleValueContainer: PyDecodingContainer {}
