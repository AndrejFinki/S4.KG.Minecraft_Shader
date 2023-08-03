/* Fragment Shader ( gbuffers_water.fsh ) */
# version 120

uniform float frameTimeCounter;
uniform sampler2D colortex0;
varying vec2 TexCoords;

void
main()
{
    float frequency = 2.0;
    float amplitude = 0.1;

    vec3 colorOscillation = vec3(
        0.5 + amplitude * sin( frequency * frameTimeCounter ),
        0.5 + amplitude * sin( frequency * frameTimeCounter + 2.0 ),
        0.5 + amplitude * sin( frequency * frameTimeCounter + 4.0 )
    );

    vec3 Color = texture2D( colortex0, TexCoords ).rgb;

    Color = mix( Color, colorOscillation, 0.5 );

    gl_FragColor = vec4( Color, 1.0 );
}