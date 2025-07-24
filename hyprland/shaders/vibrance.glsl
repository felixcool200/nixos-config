/*
 * Vibrance Shader
 * Source: https://github.com/loqusion/hyprshade
 * Original: https://github.com/hyprwm/Hyprland/issues/1140#issuecomment-1614863627
 * Adapted from Mustache template - using default values
 */

precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

const vec3 Balance = vec3(1.0, 1.0, 1.0);  // RGB balance multipliers
const float Strength = 0.15;                // Vibrance strength

const vec3 VIB_coeffVibrance = Balance * -Strength;

void main() {
    vec4 pixColor = texture2D(tex, v_texcoord);
    vec3 color = pixColor.rgb;

    vec3 VIB_coefLuma = vec3(0.212656, 0.715158, 0.072186);
    float luma = dot(VIB_coefLuma, color);

    float max_color = max(color.r, max(color.g, color.b));
    float min_color = min(color.r, min(color.g, color.b));
    float color_saturation = max_color - min_color;

    vec3 p_col = (sign(VIB_coeffVibrance) * color_saturation - 1.0) * VIB_coeffVibrance + 1.0;

    vec3 adjustedColor = mix(vec3(luma), color, p_col);
    gl_FragColor = vec4(adjustedColor, pixColor.a);
}