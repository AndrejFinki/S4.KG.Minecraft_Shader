#version 120
#include "constants.glsl"

void
main()
{
    /* Albedo colour */
    vec4 albedo = texture2D( texture, tex_coords ) * color;
    
    /* DRAWBUFFERS:01 */
    gl_FragData[0] = albedo;
    gl_FragData[1] = vec4( clamp( normal, 0, 1 ), 1.0f );
}