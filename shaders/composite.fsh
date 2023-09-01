#version 120
#include "headers/constants.glsl"
#include "headers/lightmap.glsl"
#include "headers/shadow.glsl"

void
main()
{
    /* Account for gamma correction */
    vec3 albedo = pow( texture2D( colortex0, tex_coords ).rgb, vec3( gamma_correction ) );
    
    /* Depth check for sky */
    float depth = texture2D( depthtex0, tex_coords ).r;
    if( depth == 1.0 ) {
        gl_FragData[0] = vec4( albedo, 1.0 );
        return;
    }

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