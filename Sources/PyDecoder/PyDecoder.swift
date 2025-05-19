import Foundation
import PySwiftKit
import PythonCore
//import PythonLib
/**
 
 */

extension CodingKey {
    
    func pyDictItem(data: PyPointer) -> PyPointer {
		return self.stringValue.withCString {key in PyDict_GetItemString(data, key)}
    }
    func pyClassItem(data: PyPointer) -> PyPointer {
		
		guard let rtn = self.stringValue.withCString( {key in PyObject_GetAttrString(data, key)}) else {
			PyErr_Print()
			
			//fatalError()
			return .None
		}
        //defer { Py_DecRef(rtn) }
        return rtn
    }
}



public struct PyDecoder {
	
	public init() {}
	
	public func decode<T>(_ type: T.Type, from data: PyPointer, codingPath: [CodingKey] = []) throws -> T where T : Decodable {
		//Py_IncRef(data)
		let decoder = _Decoder(data: data)
		decoder.codingPath = codingPath
		return try T(from: decoder)
	}
	
	public static func newKeyedContainer<NestedKey>(data: PyPointer, codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) -> KeyedDecodingContainer<NestedKey> {
		if PyDict_Check(data) {
			let container = DictContainer<NestedKey>(data: data, codingPath: codingPath, userInfo: userInfo)
			//self.container = container
			
			return KeyedDecodingContainer(container)
		}
		let container = ClassContainer<NestedKey>(data: data, codingPath: codingPath, userInfo: userInfo)
		//self.container = container
		
		return KeyedDecodingContainer(container)
	}
	
	final class _Decoder {
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
	
}
extension PyDecoder._Decoder: Decoder {
    fileprivate func assertCanCreateContainer() {
        precondition(self.container == nil)
    }
        
    func container<Key>(keyedBy type: Key.Type) -> KeyedDecodingContainer<Key> where Key : CodingKey {
        //assertCanCreateContainer()
        if PyDict_Check(data) {
			let container = PyDecoder.DictContainer<Key>(data: data, codingPath: self.codingPath, userInfo: self.userInfo)
            self.container = container
            
            return KeyedDecodingContainer(container)
        }
		let container = PyDecoder.ClassContainer<Key>(data: data, codingPath: self.codingPath, userInfo: self.userInfo)
        self.container = container
        
        return KeyedDecodingContainer(container)
    }

    func unkeyedContainer() -> UnkeyedDecodingContainer {
        //assertCanCreateContainer()
		let container = PyDecoder.UnkeyedContainer(data: data, codingPath: self.codingPath, userInfo: self.userInfo)
        self.container = container
        return container
    }
    
    func singleValueContainer() -> SingleValueDecodingContainer {
        //assertCanCreateContainer()
		let container = PyDecoder.SingleValueContainer(data: data, codingPath: self.codingPath, userInfo: self.userInfo)
		self.container = container
        
        return container
    }
}

protocol PyDecodingContainer {
    
}
