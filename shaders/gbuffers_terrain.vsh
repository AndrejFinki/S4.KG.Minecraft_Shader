#version 120
#define VSH
#include "constants.glsl"
#include "tall_grass.glsl"
#undef VSH

void
main()
{
    gl_Position = ftransform();
    tex_coords = gl_MultiTexCoord0.st;
    normal = gl_NormalMatrix * gl_Normal;
    color = gl_Color;
    lightmap_coords = mat2( gl_TextureMatrix[1] ) * gl_MultiTexCoord1.st;
    lightmap_coords = ( lightmap_coords * 33.05 / 32.0 ) - ( 1.05 / 32.0 );
    if( mc_Entity.x == 10031.0 ) tall_grass_glsl();
}
