#version 120
#include "headers/constants.glsl"
#include "headers/wavy_terrain.glsl"
#include "headers/wavy_liquid.glsl"

/*
    Gbuffers_Terrain Vertex Shader
    Gbuffers programs are the main geometry passes, where entities, particals, blocks, etc. are rendered.
    Gbuffers_Terrain is a program specifically for any solid blocks, like dirt, stone, etc.
    A list of solid blocks can be found here: https://minecraft.fandom.com/wiki/Solid_block
*/

void
main()
{
    gl_Position = ftransform();
    tex_coords = gl_MultiTexCoord0.st;
    normal = gl_NormalMatrix * gl_Normal;
    color = gl_Color;
    lightmap_coords = mat2( gl_TextureMatrix[1] ) * gl_MultiTexCoord1.st;
    lightmap_coords = ( lightmap_coords * 33.05 / 32.0 ) - ( 1.05 / 32.0 );
    if( wave_check() ) wave_glsl();
    if( liquid_check() ) liquid_wave_glsl();
}
