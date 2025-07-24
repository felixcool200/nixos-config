/*
 * Grayscale Shader
 * Source: https://github.com/loqusion/hyprshade
 * Adapted from Mustache template - using HDR luminosity by default
 */

precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

const int LUMINOSITY = 0;
const int LIGHTNESS = 1;
const int AVERAGE = 2;

const int Type = LUMINOSITY;

const int PAL = 0;
const int HDTV = 1;
const int HDR = 2;

const int LuminosityType = HDR;

void main() {
    vec4 pixColor = texture2D(tex, v_texcoord);
    float gray = 0.0;

    if (Type == LUMINOSITY) {
        if (LuminosityType == PAL) {
            gray = dot(pixColor.rgb, vec3(0.299, 0.587, 0.114));
        } else if (LuminosityType == HDTV) {
            gray = dot(pixColor.rgb, vec3(0.2126, 0.7152, 0.0722));
        } else if (LuminosityType == HDR) {
            gray = dot(pixColor.rgb, vec3(0.2627, 0.6780, 0.0593));
        }
    } else if (Type == LIGHTNESS) {
        float maxColor = max(pixColor.r, max(pixColor.g, pixColor.b));
        float minColor = min(pixColor.r, min(pixColor.g, pixColor.b));
        gray = (maxColor + minColor) / 2.0;
    } else if (Type == AVERAGE) {
        gray = (pixColor.r + pixColor.g + pixColor.b) / 3.0;
    }

    gl_FragColor = vec4(vec3(gray), pixColor.a);
}