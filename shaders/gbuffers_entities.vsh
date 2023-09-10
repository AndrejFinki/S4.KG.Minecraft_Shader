#version 120
#include "headers/constants.glsl"

/*
    Gbuffers_Entities Vertex Shader
    Gbuffers programs are the main geometry passes, where entities, particals, blocks, etc. are rendered.
    Gbuffers_Entities is a program specifically for entities, such as mobs, chests, boats, minecarts, etc.
    A full list of entities can be found here: https://minecraft.fandom.com/wiki/Entity#Types_of_entities
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