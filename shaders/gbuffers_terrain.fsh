#version 120
#include "headers/constants.glsl"

/*
    Gbuffers_Terrain Fragment Shader
    Gbuffers programs are the main geometry passes, where entities, particals, blocks, etc. are rendered.
    Gbuffers_Terrain is a program specifically for any solid blocks, like dirt, stone, etc.
    A list of solid blocks can be found here: https://minecraft.fandom.com/wiki/Solid_block
*/

void
main()
{
    /* Albedo color */
    vec4 albedo = texture2D( texture, tex_coords ) * color;
    
    /* DRAWBUFFERS:0125 */
    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4( normal * 0.5 + 0.5, 1.0 );
    gl_FragData[2] = vec4( lightmap_coords, 0.0, 1.0 );
    gl_FragData[3] = vec4(0.0);
}