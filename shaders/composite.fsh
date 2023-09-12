#version 120
#include "headers/constants.glsl"
#include "headers/lightmap.glsl"
#include "headers/shadow.glsl"
#include "headers/composite_utils.glsl"

/*
    Composite Fragment Shader
    The composite programs are fullscreen passes that run after all the gbuffers programs have finished executing.
*/

void
main()
{
    /* Account for gamma correction */
    vec3 init_color = texture2D( colortex0, tex_coords ).rgb;
    vec3 albedo = pow( init_color, vec3( gamma_correction ) );
    float depth = texture2D( depthtex0, tex_coords ).z;

    if( sky_box_check( albedo, depth ) ) return;

    /* Get the normal */
    vec3 normal = normalize( texture2D( colortex1, tex_coords ).rgb * 2.0 - 1.0 );
    
    /* Get lightmap and it's color */
    vec2 lightmap = texture2D( colortex2, tex_coords ).rg;
    vec3 lightmap_color = get_lightmap_color( lightmap );

    /* Compute cos theta between the normal and sun directions */
    float NdotL = max( dot( normal, normalize( sunPosition ) ), 0.0 );

    /* Final diffuse color */
    vec3 diffuse = albedo * ( lightmap_color + NdotL * get_shadow( depth ) + ambient_gamma );
    
    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4( diffuse, 1.0 );
}