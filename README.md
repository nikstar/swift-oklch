# Oklch support for Swift

```swift
import SwiftUI
import Oklch

let color = Color.oklch(0.8, 0.35, .degress(230))

// nil for colors with different light and dark appearances such as `Color.red` 
let maybeOklch: Oklch? = someColor.oklch 

let oklch: Oklch = Color.red.resolved(in: env).oklch

let brighterColor = oklch.with { $0.lightness *= 1.15 }
```
