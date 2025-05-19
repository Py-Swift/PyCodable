import Foundation
//import PythonLib
import PySwiftKit
import PythonCore

fileprivate let py_decoder = PyDecoder()

extension PyDecoder {
    struct DictContainer<Key> where Key: CodingKey {
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]
        var data: PyPointer
        
        init(data: PyPointer, codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) {
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.data = data
            //Py_IncRef(data) // - PyDict_GetItemString gives a weakRef so we must make it strong
        }
        
//        deinit {
//            Py_DecRef(data)
//        }
    }
    
    struct ClassContainer<Key> where Key: CodingKey {
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]
        var data: PyPointer
        
        init(data: PyPointer, codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) {
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.data = data
            //Py_IncRef(data) - PyObject_GetAttr gives a strongRef
        }
        
//        deinit {
//            Py_DecRef(data)
//        }
    }
}

fileprivate func PyDict_GetItem(_ dp: UnsafeMutablePointer<PyObject>!,_ key: CodingKey) -> PyPointer? {
	key.stringValue.withCString({PyDict_GetItemString(dp, $0)})
}

extension PyDecoder.DictContainer: KeyedDecodingContainerProtocol {
    
    
    var allKeys: [Key] {
        fatalError()
    }
    
    func contains(_ key: Key) -> Bool {
        //let k = key.stringValue.pyPointer
		let k = key.stringValue.withCString(PyUnicode_FromString)
        defer { Py_DecRef(k) }
        return PyDict_Contains(data, k) == 1
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        key.pyDictItem(data: data) == PyNone
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
		//fatalError()
        //return try py_decoder.decode(type, from: key.pyDictItem(data: data))
		let item = key.pyDictItem(data: data)
		//defer { Py_DecRef(item) }
		let decoder = PyDecoder()
		decoder
		return try py_decoder.decode(type, from: item)
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError()
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
		let _data = PyDict_GetItem(data, key)!
		var path = codingPath
		path.append(key)
		var info = userInfo
		if let key = CodingUserInfoKey(rawValue: "indent"), let indent = info[key] as? Int {
			info[key] = indent + 1
		}
		let result = PyDecoder.UnkeyedContainer(data: _data, codingPath: path, userInfo: info)
		//Py_DecRef(_data)
		return result
    }
    
    func superDecoder() throws -> Decoder {
        fatalError()
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        fatalError()
    }
	
	func decode(_ type: String.Type, forKey key: Key) throws -> String {
		let obj = key.pyDictItem(data: data)
		//defer { Py_DecRef(obj) }
		let result = String(cString: PyUnicode_AsUTF8(obj))
		//Py_DecRef(obj)
		return result
	}
	func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
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
	
	
}

extension PyDecoder.DictContainer: PyDecodingContainer {}

fileprivate struct __classname__: Decodable, CustomStringConvertible {
	struct __classinfo__: Decodable {
		let __name__: String
	}
	//let wrapped: __name__
	let __class__: __classinfo__
	
	var description: String { __class__.__name__ }
}

extension KeyedDecodingContainer {
	
	fileprivate enum __object__CodingKeys: CodingKey {
		case __class__
	}
	fileprivate enum __class__CodingKeys: CodingKey {
		case __name__
	}
	public func decode(__class__ key: KeyedDecodingContainer<K>.Key) throws -> String {
		try decode(__classname__.self, forKey: key).description
//		let __object__ = try nestedContainer(keyedBy: __object__CodingKeys.self, forKey: key)
//		let __class__ = try __object__.nestedContainer(keyedBy: __class__CodingKeys.self, forKey: .__class__)
		//return try __class__.decode(String.self, forKey: .__name__)
	}
}

    
extension PyDecoder.ClassContainer: KeyedDecodingContainerProtocol {
    var allKeys: [Key] {
		guard let _keys = PyObject_Dir(data) else {
			PyErr_Print()
			return []
		}
		return []
//		return (try? _keys.sequence.compactMap { str -> Key? in
//			guard let str = str else { return nil }
//			return Key(stringValue: try String(object: str))
//		})!
    }
    
    func contains(_ key: Key) -> Bool {
        PyObject_HasAttr(data, key)
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
		guard PyObject_HasAttr(data, key.stringValue) else { return false }
		let item = key.pyClassItem(data: data)
        let result = (item == PyNone)
		Py_DecRef(item)
		return result
    }
    
	
	
	
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
		if PyDict_Check(data) {
			let container = PyDecoder.DictContainer<NestedKey>(data: data, codingPath: self.codingPath, userInfo: self.userInfo)
			//self.container = container
			
			return KeyedDecodingContainer<NestedKey>(container)
		}
		let container = PyDecoder.ClassContainer<NestedKey>(data: data, codingPath: self.codingPath, userInfo: self.userInfo)
		//self.container = container
		
		return KeyedDecodingContainer<NestedKey>(container)
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
		let _data = PyObject_GetAttr(data, key.stringValue) ?? .None
		var path = codingPath
		path.append(key)
		let result = PyDecoder.UnkeyedContainer(data: _data, codingPath: path, userInfo: self.userInfo)
		Py_DecRef(_data)
		return result
    }
    
    func superDecoder() throws -> Decoder {
        fatalError()
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        fatalError()
    }
//    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
//        fatalError()
//    }
//

	
	func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
		
		let obj = key.pyClassItem(data: data)
		
		let result =  try PyDecoder().decode(type, from: obj)
		Py_DecRef(obj)
		return result
		//try self.decode(type, forKey: key)
		//return try PyDecoder.SingleValueContainer(data: obj, codingPath: self.codingPath, userInfo: self.userInfo).decode(T.self)
	}
	func decode(_ type: String.Type, forKey key: Key) throws -> String {
		let obj = key.pyClassItem(data: data)
		defer { Py_DecRef(obj) }
		var result: String
		if PyUnicode_Check(obj) {
			result =  String(cString: PyUnicode_AsUTF8(obj))
		} else {
			let str = PyObject_Str(obj)
			defer { Py_DecRef(str)}
			result = String(cString: PyUnicode_AsUTF8(str))
		}
		return result
		
	}
	func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
		fatalError()
	}
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        fatalError()
    }

    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        fatalError()
    }

    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
		let obj = key.pyClassItem(data: data)
		let result =  PyLong_AsLong(obj)
		Py_DecRef(obj)
		return result
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
    
    
    
     
}
extension PyDecoder.ClassContainer: PyDecodingContainer {}
