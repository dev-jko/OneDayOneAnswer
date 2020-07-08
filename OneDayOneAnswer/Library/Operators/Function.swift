//
//  Function.swift
//  OneDayOneAnswer
//
//  Created by Jaedoo Ko on 2020/07/08.
//  Copyright © 2020 JMJ. All rights reserved.
//

import Foundation

precedencegroup LeftApplyPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: TernaryPrecedence
}

precedencegroup FunctionCompositionPrecedence {
    associativity: right
    higherThan: LeftApplyPrecedence
}

infix operator |> : LeftApplyPrecedence
infix operator ||> : LeftApplyPrecedence
infix operator ?|> : LeftApplyPrecedence
infix operator <> : FunctionArrowPrecedence

public func |> <A, B>(x: A, f: (A) -> B) -> B {
    return f(x)
}

public func ||> <A, B>(xs: [A], f: (A) -> B) -> [B] {
    return xs.map(f)
}

public func ?|> <A, B>(x: A?, f: (A) -> B) -> B? {
    return x.map(f)
}

public func <> <A>(f: @escaping (A) -> A, g: @escaping (A) -> A) -> (A) -> A {
    return { g(f($0)) }
}
