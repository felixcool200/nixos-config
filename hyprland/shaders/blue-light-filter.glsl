/*
 * Blue Light Filter
 * Source: https://github.com/loqusion/hyprshade
 * Original: https://github.com/hyprwm/Hyprland/issues/1140#issuecomment-1335128437
 * Adapted for Hyprland GLSL 3.20 ES - using 2600K temperature and full strength
 */

#version 320 es
precision mediump float;

in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;

/**
 * Color temperature in Kelvin.
 * https://en.wikipedia.org/wiki/Color_temperature
 */
const float Temperature = 2600.0;  // Warm temperature (1000-40000 range)

/**
 * Strength of filter.
 */
const float Strength = 1.0;  // Full strength (0.0-1.0 range)

#define WithQuickAndDirtyLuminancePreservation
const float LuminancePreservationFactor = 1.0;

// function from https://www.shadertoy.com/view/4sc3D7
// valid from 1000 to 40000 K (and additionally 0 for pure full white)
vec3 colorTemperatureToRGB(const in float temperature) {
    // values from: http://blenderartists.org/forum/showthread.php?270332-OSL-Goodness&p=2268693&viewfull=1#post2268693
    mat3 m = (temperature <= 6500.0)
        ? mat3(vec3(0.0, -2902.1955373783176, -8257.7997278925690),
               vec3(0.0, 1669.5803561666639, 2575.2827530017594),
               vec3(1.0, 1.3302673723350029, 1.8993753891711275))
        : mat3(vec3(1745.0425298314172, 1216.6168361476490, -8257.7997278925690),
               vec3(-2666.3474220535695, -2173.1012343082230, 2575.2827530017594),
               vec3(0.55995389139931482, 0.70381203140554553, 1.8993753891711275));

    return mix(
        clamp(m[0] / (vec3(clamp(temperature, 1000.0, 40000.0)) + m[1]) + m[2], 0.0, 1.0),
        vec3(1.0),
        smoothstep(1000.0, 0.0, temperature)
    );
}

void main() {
    vec4 pixColor = texture(tex, v_texcoord);
    vec3 color = pixColor.rgb;

#ifdef WithQuickAndDirtyLuminancePreservation
    float lum = dot(color, vec3(0.2126, 0.7152, 0.0722));
    color *= mix(1.0, lum / max(lum, 1e-5), LuminancePreservationFactor);
#endif

    color = mix(color, color * colorTemperatureToRGB(Temperature), Strength);

    fragColor = vec4(color, pixColor.a);
}
