#version 120
#include "headers/constants.glsl"

void
main()
{
	gl_Position = ftransform();
	tex_coords = ( gl_TextureMatrix[0] * gl_MultiTexCoord0 ).xy;
	lightmap_coords = ( gl_TextureMatrix[1] * gl_MultiTexCoord1 ).xy;
	color = gl_Color;
    normal = gl_NormalMatrix * gl_Normal;
}