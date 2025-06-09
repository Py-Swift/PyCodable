import Foundation
//import PythonLib
import PySwiftKit
import PythonCore

extension PyDecoder {
	struct UnkeyedContainer {
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]
        var data: PyPointer
        
        var count: Int?
        var currentIndex: Int = 0
        
        let buffer: UnsafeBufferPointer<PythonPointer?>
        //let iter:
        private var iter: UnsafeBufferPointer<PythonPointer?>.Iterator
       
        init(data: PyPointer,codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) {
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.data = data
            self.buffer = data.pySequence
            self.count = buffer.count
            self.iter = buffer.makeIterator()
		
//            Py_IncRef(data)
        }
        
//        deinit {
//            Py_DecRef(data)
//        }
        
        
        @inlinable
		mutating func next() -> PythonPointer? { iter.next() ?? nil }
    }
}


extension PyDecoder {
	
}
fileprivate enum __astbase_CodingKeys: CodingKey {
	case __class__
}

fileprivate enum __object__CodingKeys: CodingKey {
	case __class__
}
fileprivate enum __class__CodingKeys: CodingKey {
	case __name__
}
extension UnkeyedDecodingContainer {
	
	public mutating func decode__class__() throws -> String {
		let __astbase__ = try self.nestedContainer(keyedBy: __astbase_CodingKeys.self)
		let __object__ = try __astbase__.nestedContainer(keyedBy: __object__CodingKeys.self, forKey: .__class__)
		let __class__ = try __object__.nestedContainer(keyedBy: __class__CodingKeys.self, forKey: .__class__)
		let __name__ = try __class__.nestedContainer(keyedBy: __class__CodingKeys.self, forKey: .__name__)
		return try __name__.decode(String.self, forKey: .__name__)
	}
//	public func decode(__class__ key: KeyedDecodingContainer<K>.Key) throws -> String {
//
//	}
}


extension PyDecoder.UnkeyedContainer: UnkeyedDecodingContainer {
 
    
    var isAtEnd: Bool {
        currentIndex == count
    }
  
    
    func decodeNil() throws -> Bool {
		data == PyNone
    }
    
    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        currentIndex += 1
		//fatalError()
		return try PyDecoder().decode(type, from: next() ?? .None)
    }
    

    
    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
		var path = self.codingPath
		path.append(type.init(intValue: currentIndex)!)
		currentIndex += 1
		let data = next()!
		var info = userInfo
		if let key = CodingUserInfoKey(rawValue: "indent"), let indent = info[key] as? Int {
			info[key] = indent + 1
		}
		
		return PyDecoder.newKeyedContainer(data: data, codingPath: path, userInfo: info)
//		if PyDict_Check(data) {
//			let container = PyDecoder.DictContainer<NestedKey>(data: data, codingPath: self.codingPath, userInfo: self.userInfo)
//			//self.container = container
//			
//			return KeyedDecodingContainer(container)
//		}
//		let container = PyDecoder.ClassContainer<NestedKey>(data: data, codingPath: self.codingPath, userInfo: self.userInfo)
//		//self.container = container
//
// return KeyedDecodingContainer(container)
    }

    func superDecoder() throws -> Decoder {
        fatalError()
    }
	
	
	mutating func decode(_ type: String.Type) throws -> String {
		guard let obj = next() else { throw PythonError.attribute }
		defer { Py_DecRef(obj) }
		return .init(cString: PyUnicode_AsUTF8(obj))
	}
	
	mutating func decode(_ type: Double.Type) throws -> Double {
		currentIndex += 1
		guard let data = next() else { throw PythonError.attribute }
		if PyFloat_Check(data){
			return PyFloat_AsDouble(data)
		} else if PyLong_Check(data) {
			return PyLong_AsDouble(data)
		}
		else { throw PythonError.float }
	}
	
	mutating func decode(_ type: Float.Type) throws -> Float {
		currentIndex += 1
		guard let data = next() else { throw PythonError.attribute }
		if PyFloat_Check(data){
			return .init(PyFloat_AsDouble(data))
		} else if PyLong_Check(data) {
			return .init(PyFloat_AsDouble(data))
		}
		else { throw PythonError.float }
	}
	
	mutating func decode(_ type: Int.Type) throws -> Int {
		currentIndex += 1
		guard let data = next() else { throw PythonError.attribute }
		guard PyLong_Check(data) else { throw PythonError.long }
		return PyLong_AsLong(data)
	}
	
	mutating func decode(_ type: Int8.Type) throws -> Int8 {
		currentIndex += 1
		guard let data = next() else { throw PythonError.attribute }
		guard PyLong_Check(data) else { throw PythonError.long }
		return .init(clamping: PyLong_AsLong(data))
	}
	
	mutating func decode(_ type: Int16.Type) throws -> Int16 {
		currentIndex += 1
		guard let data = next() else { throw PythonError.attribute }
		guard PyLong_Check(data) else { throw PythonError.long }
		return .init(clamping: PyLong_AsLong(data))
	}
	
	mutating func decode(_ type: Int32.Type) throws -> Int32 {
		currentIndex += 1
		guard let data = next() else { throw PythonError.attribute }
		guard PyLong_Check(data) else { throw PythonError.long }
		return .init(clamping: PyLong_AsLong(data))
	}
	
	mutating func decode(_ type: Int64.Type) throws -> Int64 {
		currentIndex += 1
		guard let data = next() else { throw PythonError.attribute }
		guard PyLong_Check(data) else { throw PythonError.long }
		return PyLong_AsLongLong(data)
	}
	
	mutating func decode(_ type: UInt.Type) throws -> UInt {
		currentIndex += 1
		guard let data = next() else { throw PythonError.attribute }
		guard PyLong_Check(data) else { throw PythonError.long }
		return PyLong_AsUnsignedLong(data)
	}
	
	mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
		currentIndex += 1
		guard let data = next() else { throw PythonError.attribute }
		guard PyLong_Check(data) else { throw PythonError.long }
		return .init(clamping: PyLong_AsUnsignedLong(data))
	}
	
	mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
		currentIndex += 1
		guard let data = next() else { throw PythonError.attribute }
		guard PyLong_Check(data) else { throw PythonError.long }
		return .init(clamping: PyLong_AsUnsignedLong(data))
	}
	
	mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
		currentIndex += 1
		guard let data = next() else { throw PythonError.attribute }
		guard PyLong_Check(data) else { throw PythonError.long }
		return .init(clamping: PyLong_AsUnsignedLong(data))
	}
	
	mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
		currentIndex += 1
		guard let data = next() else { throw PythonError.attribute }
		guard PyLong_Check(data) else { throw PythonError.long }
		return PyLong_AsUnsignedLongLong(data)
	}
}

extension PyDecoder.UnkeyedContainer: PyDecodingContainer {}
