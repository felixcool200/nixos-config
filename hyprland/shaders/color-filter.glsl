/*
 * Color Filter
 * Source: https://github.com/loqusion/hyprshade
 * Original: https://godotshaders.com/shader/colorblindness-correction-shader/
 * Adapted from Mustache template - using protanopia correction with 0.2 strength
 */

precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

/**
 * Strength of filter.
 */
const float Strength = 0.2;  // 0.0-1.0 range

// Enum for color correction type
const int PROTANOPIA = 0;
const int PROTAN = PROTANOPIA;
const int REDGREEN = PROTANOPIA;
const int DEUTERANOPIA = 1;
const int DEUTAN = DEUTERANOPIA;
const int GREENRED = DEUTERANOPIA;
const int TRITANOPIA = 2;
const int TRITAN = TRITANOPIA;
const int BLUEYELLOW = TRITANOPIA;

/**
 * Type of color correction.
 */
const int Type = PROTANOPIA;  // Default to protanopia (red-green)

void main() {
    vec4 pixColor = texture2D(tex, v_texcoord);

    // Convert to LMS color space
    float L = 17.8824 * pixColor.r + 43.5161 * pixColor.g + 4.11935 * pixColor.b;
    float M = 3.45565 * pixColor.r + 27.1554 * pixColor.g + 3.86714 * pixColor.b;
    float S = 0.0299566 * pixColor.r + 0.184309 * pixColor.g + 1.46709 * pixColor.b;

    float l, m, s;

    if (Type == PROTANOPIA) {
        l = 2.02344 * M - 2.52581 * S;
        m = M;
        s = S;
    } else if (Type == DEUTERANOPIA) {
        l = L;
        m = 0.494207 * L + 1.24827 * S;
        s = S;
    } else if (Type == TRITANOPIA) {
        l = L;
        m = M;
        s = -0.395913 * L + 0.801109 * M;
    }

    // Convert back to RGB
    vec4 error;
    error.r = 0.0809444479 * l + -0.130504409 * m + 0.116721066 * s;
    error.g = -0.0102485335 * l + 0.0540193266 * m - 0.113614708 * s;
    error.b = -0.000365296938 * l - 0.00412161469 * m + 0.693511405 * s;
    error.a = 1.0;

    vec4 diff = pixColor - error;

    // Apply correction
    vec4 correction;
    correction.r = 0.0;
    correction.g = diff.r * 0.7 + diff.g;
    correction.b = diff.r * 0.7 + diff.b;

    vec4 result = mix(pixColor, pixColor + correction, Strength);

    gl_FragColor = vec4(result.rgb, pixColor.a);
}