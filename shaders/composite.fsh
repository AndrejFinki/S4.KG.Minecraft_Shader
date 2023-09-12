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
    vec3 color_nonalbedo = texture2D(colortex0, tex_coords).rgb;
    /* Depth check for sky */
    float depth = texture2D( depthtex0, tex_coords ).z;
    if( depth == 1.0 ) {
        gl_FragData[0] = vec4( albedo, 1.0 );
        return;
    }

    /* Get the normal */
    vec3 normal = normalize( texture2D( colortex1, tex_coords ).rgb * 2.0 - 1.0 );

    /* Get lightmap and it's color */
    vec2 lightmap = texture2D( colortex2, tex_coords ).rg;
    vec3 lightmap_color = get_lightmap_color( lightmap, vec3(0.05, 0.15, 0.6) );

    /* Compute cos theta between the normal and sun directions */
    float NdotL = max( dot( normal, normalize( sunPosition ) ), 0.0 );

    if( worldTime > 13050 ){

        vec3 diffuse;
        
        float NdotL = max( dot( normal, normalize( moonPosition ) ), 0.0 );
        lightmap_color = get_lightmap_color( lightmap , vec3(0.15, 0.25, 0.8));

        diffuse = albedo * (ambient_gamma + NdotL*get_shadow(depth)+ lightmap_color)*vec3(0.2,0.2,1.2);
        
        /* DRAWBUFFERS:0 */
        gl_FragData[0] = vec4( diffuse, 1.0);

        return;
    }
 
    /* Final diffuse color */
    vec3 diffuse;

    
    diffuse = albedo * ( lightmap_color*1.35 + NdotL * get_shadow( depth ) + ambient_gamma )  ;
    
    
    
    /* DRAWBUFFERS:0 */
    
    gl_FragData[0] = vec4( diffuse, 1.0 );
  
}