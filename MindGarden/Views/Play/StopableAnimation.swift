//
//  StopableAnimation.swift
//  MindGarden
//
//  Created by Vishal Davara on 09/08/22.
//

import SwiftUI

public extension Animation {
  static let instant = Animation.linear(duration: 0.0001)
}

public struct StoppableAnimationModifier<Value: VectorArithmetic>: AnimatableModifier {
  @Binding var binding: Value
  @Binding var paused: Bool

  public var animatableData: Value

  public init(binding: Binding<Value>,
              paused: Binding<Bool>) {
    _binding = binding
    _paused = paused
    animatableData = binding.wrappedValue
  }

  public func body(content: Content) -> some View {
    content
      .onChange(of: paused) { isPaused in
        if isPaused {
          withAnimation(.instant) {
            binding = animatableData // the magic happens here
          }
        }
      }
  }
}

public typealias RemainingDurationProvider<Value: VectorArithmetic> = (Value) -> TimeInterval
public typealias AnimationWithDurationProvider = (TimeInterval) -> Animation

public struct PausableAnimationModifier<Value: VectorArithmetic>: AnimatableModifier {
  @Binding var binding: Value
  @Binding var paused: Bool

  private let targetValue: Value
  private let remainingDuration: RemainingDurationProvider<Value>
  private let animation: AnimationWithDurationProvider

  public var animatableData: Value

  public init(binding: Binding<Value>,
              targetValue: Value,
              remainingDuration: @escaping RemainingDurationProvider<Value>,
              animation: @escaping AnimationWithDurationProvider,
              paused: Binding<Bool>) {
    _binding = binding
    self.targetValue = targetValue
    self.remainingDuration = remainingDuration
    self.animation = animation
    _paused = paused
    animatableData = binding.wrappedValue
  }

  public func body(content: Content) -> some View {
    content
      .onChange(of: paused) { isPaused in
        if isPaused {
          withAnimation(.instant) {
            binding = animatableData
          }
        } else { // resuming
          withAnimation(animation(remainingDuration(animatableData))) {
            binding = targetValue
          }
        }
      }
  }
}

public extension View {
  func pausableAnimation<Value: VectorArithmetic>(binding: Binding<Value>,
                                                  targetValue: Value,
                                                  remainingDuration: @escaping RemainingDurationProvider<Value>,
                                                  animation: @escaping AnimationWithDurationProvider,
                                                  paused: Binding<Bool>) -> some View {
    self.modifier(PausableAnimationModifier(binding: binding,
                                            targetValue: targetValue,
                                            remainingDuration: remainingDuration,
                                            animation: animation,
                                            paused: paused))
  }
}
