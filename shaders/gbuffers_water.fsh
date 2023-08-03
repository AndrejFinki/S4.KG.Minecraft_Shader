// Fragment Shader (gbuffers_water.fsh)

uniform float frameTimeCounter;

void main() {
    // Frequency of color change (higher values make it faster)
    float frequency = 2.0;

    // Amplitude of color change (how much the color changes)
    float amplitude = 0.1;

    // Calculate color oscillation using the sine function
    vec3 colorOscillation = vec3(
        0.5 + amplitude * sin(frequency * frameTimeCounter),
        0.5 + amplitude * sin(frequency * frameTimeCounter + 2.0),
        0.5 + amplitude * sin(frequency * frameTimeCounter + 4.0)
    );

    gl_FragColor = vec4(colorOscillation, 1.0);
}