#version 120
#include "headers/constants.glsl"
#include "headers/lightmap.glsl"
#include "headers/shadow.glsl"

/*
    Composite Fragment Shader
    The composite programs are fullscreen passes that run after all the gbuffers programs have finished executing.
*/

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
    if( worldTime > 13050 || rainStrength>0.1){

        vec3 normal = normalize( texture2D( colortex1, tex_coords ).rgb * 2.0 - 1.0 );
    
        /* Get lightmap and it's color */
        vec2 lightmap = texture2D( colortex2, tex_coords ).rg;
        sky_color = vec3(0.05, 0.03, 0.25);
        vec3 lightmap_color = get_lightmap_color( lightmap );

        /* Compute cos theta between the normal and sun directions */
        float NdotL = max( dot( normal, normalize( sunPosition ) ), 0.0 );

        vec3 diffuse;
        if(rainStrength > 0.1 && worldTime<13050){
            diffuse = albedo *(ambient_gamma + NdotL*get_shadow(depth) + lightmap_color)*0.125;
            
        }else{
            diffuse = albedo * (ambient_gamma + lightmap_color*2.0);
        }

        
        /* DRAWBUFFERS:0 */
        gl_FragData[0] = vec4( diffuse, 1.0);

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
    vec3 diffuse = albedo * ( lightmap_color + NdotL * get_shadow( depth ) + ambient_gamma ) * 1.25;
    
    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4( diffuse, 1.0 );
}