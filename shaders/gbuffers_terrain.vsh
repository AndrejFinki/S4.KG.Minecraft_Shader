#version 120
#include "headers/constants.glsl"
#include "headers/wavy_terrain.glsl"

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
}
