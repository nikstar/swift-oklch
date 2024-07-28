
import Foundation


internal func sRGBComponentToLinearsRGBComponent(_ component: Float) -> Float {
    return if (component <= 0.04045) {
        component / 12.92
    } else {
        pow((component + 0.055) / 1.055, 2.4)
    }
}

internal func sRGBToLinearsRGB(_ r: Float, _ g: Float, _ b: Float, _ alpha: Float) -> (r: Float, g: Float, b: Float, alpha: Float) {
    return (
        sRGBComponentToLinearsRGBComponent(r),
        sRGBComponentToLinearsRGBComponent(g),
        sRGBComponentToLinearsRGBComponent(b),
        alpha
    )
}

internal func linearsRGBToOKLAB(_ r: Float, _ g: Float, _ b: Float, _ alpha: Float) -> (l: Float, a: Float, b: Float, alpha: Float) {
    let l = 0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b
    let m = 0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b
    let s = 0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b
    
    let l_ = pow(l, 1.0 / 3.0)
    let m_ = pow(m, 1.0 / 3.0)
    let s_ = pow(s, 1.0 / 3.0)
    
    return (
        0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
        1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
        0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_,
        alpha
    )
}

internal func oklabToOKLCH(_ l: Float, _ a: Float, _ b: Float, _ alpha: Float) -> (l: Float, c: Float, h: Float, alpha: Float) {
    let c = sqrt(pow(a, 2) + pow(b, 2))
    let h = atan2(b, a)
    
    return (l, c, h, alpha)
}

internal func linearsRGBComponentTosRGBComponent(_ component: Float) -> Float {
    return if component <= 0.0031308 {
        12.92 * component
    } else {
        1.055 * pow(component, 1.0 / 2.4) - 0.055;
    }
}

internal func linearsRGBTosRGB(_ r: Float, _ g: Float, _ b: Float, _ alpha: Float) -> (r: Float, g: Float, b: Float, alpha: Float) {
    return (
        linearsRGBComponentTosRGBComponent(r),
        linearsRGBComponentTosRGBComponent(g),
        linearsRGBComponentTosRGBComponent(b),
        alpha
    )
}

internal func oklabToLinearsRGB(_ l: Float, _ a: Float, _ b: Float, _ alpha: Float) -> (r: Float, g: Float, b: Float, alpha: Float) {
    let l_ = l + 0.3963377774 * a + 0.2158037573 * b
    let m_ = l - 0.1055613458 * a - 0.0638541728 * b
    let s_ = l - 0.0894841775 * a - 1.2914855480 * b
    
    let l = l_ * l_ * l_
    let m = m_ * m_ * m_
    let s = s_ * s_ * s_
    
    return (
        +4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
        -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
        -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s,
        alpha
    )
}

internal func oklchToOKLAB(_ l: Float, _ c: Float, _ h: Float, _ alpha: Float) -> (l: Float, a: Float, b: Float, alpha: Float) {
    let a = c * cos(h)
    let b = c * sin(h)
    return (l, a, b, alpha)
}
