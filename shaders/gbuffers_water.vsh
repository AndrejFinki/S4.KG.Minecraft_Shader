#version 120
#include "headers/constants.glsl"
#include "headers/wavy_liquid.glsl"

/*
    Gbuffers_Water Vertex Shader
    Gbuffers programs are the main geometry passes, where entities, particals, blocks, etc. are rendered.
    Gbuffers_Water is a program specifically for any bodies of water.
    This does not affect other liquids, such as lava.
    More information about water blocks can be found here: https://minecraft.fandom.com/wiki/Water
*/

attribute vec4 at_tangent;

void
main()
{
    vec4 vertex_position = ( gl_ModelViewMatrix * gl_Vertex );
    vec3 eye_player_pos = mat3( gbufferModelViewInverse ) * vertex_position.xyz;
    vec3 world_pos = eye_player_pos + cameraPosition + gbufferModelViewInverse[3].xyz;
    gl_Position = ftransform();
    normal = gl_NormalMatrix * gl_Normal;
    tex_coords = ( gl_TextureMatrix[0] * gl_MultiTexCoord0 ).xy;
    lightmap_coords  = ( gl_TextureMatrix[1] * gl_MultiTexCoord1 ).xy;
    view_dir = normalize( vertex_position.xyz );
    color = gl_Color;
    if( liquid_check() ) liquid_wave_glsl();
}