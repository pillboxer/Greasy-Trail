//
//  CasePath.swift
//  CasePaths
//
//  Created by Henry Cooper on 23/08/2022.
//

import Foundation

public struct CasePath<Root, Value> {
    private let extract: (Root) -> Value?
    
    private let embed: (Value) -> Root
    
    public func extract(from root: Root) -> Value? {
        self.extract(root)
    }
    
    public func embed(_ value: Value) -> Root {
        self.embed(value)
    }
    
    public init(embed: @escaping (Value) -> Root, extract: @escaping (Root) -> Value?) {
      self.embed = embed
      self.extract = extract
    }
}

extension CasePath {
  public static func `case`(_ embed: @escaping (Value) -> Root) -> CasePath {
    return self.init(
      embed: embed,
      extract: { CasePaths.extract(case: embed, from: $0) }
    )
  }
}

prefix operator /
public prefix func / <Root, Value>(
  embed: @escaping (Value) -> Root
) -> CasePath<Root, Value> {
  .case(embed)
}

public func extract<Root, Value>(case embed: (Value) -> Root, from root: Root) -> Value? {
    
    func extractHelp(from root: Root) -> ([String?], Value)? {
        if let value = root as? Value {
            // Recursive Enum handlingO
            var otherRoot = embed(value)
            var root = root
            if memcmp(&root, &otherRoot, MemoryLayout<Root>.size) == 0 {
                return ([], value)
            }
        }
        var path: [String?] = []
        var any: Any = root
        
        while case let (label?, anyChild)? = Mirror(reflecting: any).children.first {
            path.append(label)
            path.append(String(describing: type(of: anyChild)))
            if let child = anyChild as? Value {
                return (path, child)
            }
            any = anyChild
        }
        if MemoryLayout<Value>.size == 0 {
            return (["\(root)"], unsafeBitCast((), to: Value.self))
        }
        return nil
    }
    if let (rootPath, child) = extractHelp(from: root),
       let (otherPath, _) = extractHelp(from: embed(child)),
       rootPath == otherPath {
        return child
        
    }
    return nil
}
