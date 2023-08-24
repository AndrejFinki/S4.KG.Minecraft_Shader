#version 120
#include "constants.glsl"

void
main()
{
    /* Albedo color */
    vec4 albedo = texture2D( texture, tex_coords ) * color;
    
    /* DRAWBUFFERS:012 */
    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4( normal * 0.5 + 0.5, 1.0 );
    gl_FragData[2] = vec4( lightmap_coords, 0.0, 1.0 );
}