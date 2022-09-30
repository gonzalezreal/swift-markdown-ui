import Foundation

public enum _ConditionalContent<First, Second> {
  case first(First)
  case second(Second)
}
