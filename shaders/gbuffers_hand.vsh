#version 120
#include "headers/constants.glsl"

/*
    Gbuffers_Hand Vertex Shader
    Gbuffers programs are the main geometry passes, where entities, particals, blocks, etc. are rendered.
    Gbuffers_Hand is a program specifically for the player's hand, and any objects they might be carrying.
*/

void
main()
{
	gl_Position = ftransform();
	tex_coords = ( gl_TextureMatrix[0] * gl_MultiTexCoord0 ).xy;
	lightmap_coords = ( gl_TextureMatrix[1] * gl_MultiTexCoord1 ).xy;
	color = gl_Color;
    normal = gl_NormalMatrix * gl_Normal;
}