#version 120
#include "headers/constants.glsl"
#include "headers/schlick_fresnel.glsl"

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