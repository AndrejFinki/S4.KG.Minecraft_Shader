#version 120

varying vec2 TexCoords;
varying vec3 Normal;
varying vec4 Color;
uniform float frameTimeCounter;

void
main()
{
    gl_Position = ftransform();
    gl_Position.x = cos(frameTimeCounter);
    TexCoords = gl_MultiTexCoord0.st;
    Normal = gl_NormalMatrix * gl_Normal;
	Color = gl_Color;
}