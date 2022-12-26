import Foundation

@resultBuilder public enum TextStyleBuilder {
  public static func buildBlock() -> some TextStyleProtocol {
    EmptyTextStyle()
  }

  public static func buildBlock(_ component: some TextStyleProtocol) -> some TextStyleProtocol {
    component
  }

  public static func buildEither<S0: TextStyleProtocol, S1: TextStyleProtocol>(
    first component: S0
  ) -> _Conditional<S0, S1> {
    _Conditional<S0, S1>.first(component)
  }

  public static func buildEither<S0: TextStyleProtocol, S1: TextStyleProtocol>(
    second component: S1
  ) -> _Conditional<S0, S1> {
    _Conditional<S0, S1>.second(component)
  }

  public static func buildLimitedAvailability(_ component: some TextStyleProtocol)
    -> any TextStyleProtocol
  {
    component
  }

  public static func buildOptional(_ component: (some TextStyleProtocol)?) -> some TextStyleProtocol
  {
    component
  }

  public static func buildPartialBlock(first: some TextStyleProtocol) -> some TextStyleProtocol {
    first
  }

  public static func buildPartialBlock(
    accumulated: some TextStyleProtocol,
    next: some TextStyleProtocol
  ) -> some TextStyleProtocol {
    Pair(accumulated, next)
  }

  public enum _Conditional<First: TextStyleProtocol, Second: TextStyleProtocol>: TextStyleProtocol {
    case first(First)
    case second(Second)

    public func transformAttributes(_ attributes: inout AttributeContainer) {
      switch self {
      case .first(let first):
        first.transformAttributes(&attributes)
      case .second(let second):
        second.transformAttributes(&attributes)
      }
    }
  }

  private struct Pair<S0: TextStyleProtocol, S1: TextStyleProtocol>: TextStyleProtocol {
    let s0: S0
    let s1: S1

    init(_ s0: S0, _ s1: S1) {
      self.s0 = s0
      self.s1 = s1
    }

    func transformAttributes(_ attributes: inout AttributeContainer) {
      s0.transformAttributes(&attributes)
      s1.transformAttributes(&attributes)
    }
  }
}

extension Optional: TextStyleProtocol where Wrapped: TextStyleProtocol {
  public func transformAttributes(_ attributes: inout AttributeContainer) {
    self?.transformAttributes(&attributes)
  }
}
