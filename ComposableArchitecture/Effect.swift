//
//  Effect.swift
//  ComposableArchitecture
//
//  Created by Henry Cooper on 19/08/2022.
//

import Foundation
import Combine

public struct Effect<Output>: Publisher {
    
    public typealias Failure = Never
    
    public let publisher: AnyPublisher<Output, Failure>
    
    public func receive<S>(subscriber: S) where S: Subscriber,
                                                Never == S.Failure,
                                                Output == S.Input {
                                                    publisher.receive(subscriber: subscriber)
                                                }
    
}

public extension Effect {
    
    static func async(work: @escaping (@escaping (Output) -> Void) -> Void) -> Effect {
        Deferred {
            Future { promise in
                work { output in
                    promise(.success(output))
                }
                
            }
        }.eraseToEffect()
    }
}
extension Publisher where Failure == Never {
    
    public func eraseToEffect() -> Effect<Output> {
        return Effect(publisher: self.eraseToAnyPublisher())
    }
}

extension Publisher {
    
    static func fireAndForget(work: @escaping () -> Void) -> Effect<Output> {
        Deferred { () -> Empty<Output, Never> in
            work()
            return Empty(completeImmediately: true)
        }.eraseToEffect()
    }
    
}
