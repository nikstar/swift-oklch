
import SwiftUI

/// Represents a color using Oklch color model:
///   - lightness: Perceived lightness (0...1). Zero is dark, one is bright. For perfect white/black set chroma to 0.
///   - chroma: Chroma (0...0.5+). Similar to saturation ("amount of color"). Maximum is theoretically unbounded but in practice does not exceed 0.5. In CSS, 100% is 0.4.
///   - hue: Hue (-π...π). Angle corresponding to a particular color.
///   - opacity: Optional
public struct Oklch {
    
    /// Perceived lightness (0...1). Zero is dark, one is bright. For perfect white/black set chroma to 0.
    public var lightness: Float
    
    /// Chroma (0...0.5+). Similar to saturation ("amount of color"). Maximum is theoretically unbounded but in practice does not exceed 0.5. In CSS, 100% is 0.4.
    public var chroma: Float
    
    /// Hue (-π...π). Angle  corresponding to a particular color.
    public var hue: Angle
    
    public var opacity: Float? = nil
    
    /// From green (-0.4) to red (+0.4)
    public var a: Float {
        return chroma * cos(Float(hue.radians))
    }
    
    /// From blue (-0.4) to yellow (+0.4)
    public var b: Float {
        return chroma * sin(Float(hue.radians))
    }
    
    /// Represents a color using Oklch color model.
    ///
    /// - Parameters:
    ///   - lightness: Perceived lightness (0...1). Zero is dark, one is bright. For perfect white/black set chroma to 0.
    ///   - chroma: Chroma (0...0.5+). Similar to saturation ("amount of color"). Maximum is theoretically unbounded but in practice does not exceed 0.5. In CSS, 100% is 0.4.
    ///   - hue: Hue (-π...π). Angle corresponding to a particular color.
    ///   - opacity: Opacity (optional)
    public init(lightness: Float, chroma: Float, hue: Angle, opacity: Float? = nil) {
        self.lightness = lightness
        self.chroma = chroma
        self.hue = hue
        self.opacity = opacity
    }
}


extension Oklch {
    func with(_ f: (inout Oklch) -> ()) -> Oklch {
        var color = self
        f(&color)
        return color
    }
}


extension SwiftUI.Color {
    
    /// Create a color with <Oklch> values
    public init(oklch: Oklch) {
        if let opacity = oklch.opacity {
            self = .oklch(oklch.lightness, oklch.chroma, oklch.hue, opacity: opacity)
        } else {
            self = .oklch(oklch.lightness, oklch.chroma, oklch.hue)
        }
    }
    
    /// Create a color with using Oklch color model.
    ///
    /// - Parameters:
    ///   - lightness: Perceived lightness (0...1). Zero is dark, one is bright. For perfect white/black set chroma to 0.
    ///   - chroma: Chroma (0...0.5+). Similar to saturation ("amount of color"). Maximum is theoretically unbounded but in practice does not exceed 0.5. In CSS, 100% is 0.4.
    ///   - hue: Hue (-π...π). Angle corresponding to a particular color.
    ///   - opacity: Optional, defaults to 1
    public static func oklch(_ lightness: Float, _ chroma: Float, _ hue: Angle, opacity: Float = 1.0) -> SwiftUI.Color {
        
        let (l, a, b, _) = oklchToOKLAB(lightness, chroma, Float(hue.radians), opacity)
        let (r_, g_, b_, _) = oklabToLinearsRGB(l, a, b, opacity)
        let rgba = linearsRGBTosRGB(r_, g_, b_, opacity)
        return Color.init(.sRGB, red: Double(rgba.r), green: Double(rgba.g), blue: Double(rgba.b), opacity: Double(opacity))
    }
}


extension SwiftUI.Color.Resolved {
    
    public var oklch: Oklch {
        
        let (r, g, b, a) = sRGBToLinearsRGB(Float(red), Float(green), Float(blue), Float(opacity))
        let oklab = linearsRGBToOKLAB(r, g, b, a)
        let oklch = oklabToOKLCH(oklab.l, oklab.a, oklab.b, a)
        
        return Oklch(lightness: oklch.l, chroma: oklch.c, hue: .radians(Double(oklch.h)), opacity: a)
    }
    
}



extension SwiftUI.Color {
    
    public var oklch: Oklch? {
        let uiColor = UIColor(self)
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        let ok = uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        guard ok else { return nil }
        
        let rgba = sRGBToLinearsRGB(Float(r), Float(g), Float(b), Float(a))
        let oklab = linearsRGBToOKLAB(rgba.r, rgba.g, rgba.b, rgba.alpha)
        let oklch = oklabToOKLCH(oklab.l, oklab.a, oklab.b, oklab.alpha)
        
        return Oklch(lightness: oklch.l, chroma: oklch.c, hue: .radians(Double(oklch.h)), opacity: oklch.alpha)
    }
    
}



private struct P: View {
    @Environment(\.self) var env
    @State var color = Oklch(lightness: 0.2, chroma: 0.2, hue: .radians(0))
    
    var body: some View {
        VStack {
            Color(oklch: color)
                .overlay {
                    VStack {
                        Text("White")
                            .foregroundStyle(.white)
                        Text("Yellow")
                            .foregroundStyle(.yellow)

                        Text("Black")
                        
                    }
                    .font(.system(size: 32).bold())
                }
            Text("\(color.lightness) \(color.chroma) \(color.hue.degrees)")
            Text("\(color.a) \(color.b)")

            Text("\(Color(oklch: color).resolve(in: env))")
            Slider(value: $color.lightness, in: 0...1)
            Slider(value: $color.chroma, in: 0...0.55)
            Slider(value: $color.hue.degrees, in: -180...180)
            
        }
        .padding(.bottom, 20)
        
    }
}



#Preview {
    ZStack {
        P()
//        Rectangle()
//            .fill(Material.thin)
//            .environment(\.colorScheme, .dark)
    }
    .ignoresSafeArea()
}
