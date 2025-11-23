pragma Singleton
import QtQuick

QtObject {
    // Neon Color Palette
    readonly property color neonBlue: "#00D9FF"
    readonly property color neonCyan: "#00FFF0"
    readonly property color neonPurple: "#A855F7"
    readonly property color neonPink: "#FF00FF"
    readonly property color neonGreen: "#39FF14"
    
    // Background Colors
    readonly property color bgDark: "#0A0A0F"
    readonly property color bgDarkGray: "#1A1A2E"
    readonly property color bgMediumGray: "#16213E"
    readonly property color bgLightGray: "#2A2A40"
    
    // Text Colors
    readonly property color textPrimary: "#FFFFFF"
    readonly property color textSecondary: "#B0B0C0"
    readonly property color textMuted: "#707080"
    
    // Accent Colors
    readonly property color accentDanger: "#FF3366"
    readonly property color accentWarning: "#FFB800"
    readonly property color accentSuccess: "#00FF88"
    
    // Glow Effect Properties
    readonly property int glowRadius: 24
    readonly property int glowSmall: 12
    readonly property int glowMedium: 18
    readonly property int glowLarge: 32
    
    // Border Radii
    readonly property int radiusSmall: 8
    readonly property int radiusMedium: 12
    readonly property int radiusLarge: 20
    readonly property int radiusXLarge: 32
    
    // Spacing
    readonly property int spacingXSmall: 4
    readonly property int spacingSmall: 8
    readonly property int spacingMedium: 16
    readonly property int spacingLarge: 24
    readonly property int spacingXLarge: 32
    
    // Font Sizes
    readonly property int fontSizeSmall: 12
    readonly property int fontSizeMedium: 14
    readonly property int fontSizeLarge: 16
    readonly property int fontSizeXLarge: 20
    readonly property int fontSizeXXLarge: 28
    readonly property int fontSizeHuge: 48
    
    // Animation Durations
    readonly property int animationFast: 150
    readonly property int animationNormal: 250
    readonly property int animationSlow: 400
    
    // Gradients
    function radialNeonGradient(centerColor, edgeColor) {
        return {
            type: "radial",
            center: Qt.point(0.5, 0.5),
            radius: 0.5,
            stops: [
                { position: 0.0, color: centerColor },
                { position: 1.0, color: edgeColor }
            ]
        }
    }
    
    function linearGradient(color1, color2, vertical) {
        return {
            type: "linear",
            x1: 0, y1: vertical ? 0 : 0,
            x2: vertical ? 0 : 1, y2: vertical ? 1 : 0,
            stops: [
                { position: 0.0, color: color1 },
                { position: 1.0, color: color2 }
            ]
        }
    }
}
