#version 120

varying vec2 TexCoords;
varying vec3 Normal;

void
main()
{
	gl_Position = gtransform();
	TexCoords = gl_MultiTexCoord0.st;
	Normal = gl_NormalMatrix * gl_Normal;
}