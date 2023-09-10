#version 120
#include "headers/constants.glsl"
#include "headers/schlick_fresnel.glsl"

/*
    Gbuffers_Water Fragment Shader
    Gbuffers programs are the main geometry passes, where entities, particals, blocks, etc. are rendered.
    Gbuffers_Water is a program specifically for any bodies of water.
    This does not affect other liquids, such as lava.
    More information about water blocks can be found here: https://minecraft.fandom.com/wiki/Water
*/

void
main()
{
    vec4 final_color = texture2D( texture,  tex_coords ) * color;
    final_color *= texture2D( lightmap, lightmap_coords );
    vec3 half_dir = normalize( normalize( sunPosition ) - view_dir );
    float specular = max( dot( normal, half_dir ), 0.0 );
    final_color = final_color + pow( specular, 32 ) * vec4( 0.65 ) * schlick_fresnel( max( dot( -view_dir, normal ), 0.0 ), 0.8 );
    
    /* DRAWBUFFERS:0 */
    gl_FragData[0] = final_color;
}