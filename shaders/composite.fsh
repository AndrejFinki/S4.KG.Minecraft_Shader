#version 120
#include "constants.glsl"
#include "lightmap.glsl"
#include "shadow.glsl"
#extension GL_EXT_gpu_shader4 : enable
#define SSAO_I 100
#define SSAO_I_FACTOR 0.004
#define SSAO_IM SSAO_I * SSAO_I_FACTOR

varying vec3 Normal;
varying mat3 tbn;
varying vec3 pos;

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
    vec3 lightmap_color = get_lightmap_color( lightmap );

    /* Compute cos theta between the normal and sun directions */
    float NdotL = max( dot( normal, normalize( sunPosition ) ), 0.0 );
    
    float ao = AmbientOcclusion();
    
    vec3 ambient = vec3(ambient_gamma * color_nonalbedo * ao);

    if( worldTime > 13050 ){

        vec3 diffuse;
        
        float NdotL = max( dot( normal, normalize( moonPosition ) ), 0.0 );

        diffuse = albedo * (ambient + lightmap_color*2);
        
        /* DRAWBUFFERS:0 */
        gl_FragData[0] = vec4( diffuse, 1.0);

        return;
    }
 
    /* Final diffuse color */

    
    vec3 diffuse = albedo * ( lightmap_color*1.35 + NdotL * get_shadow( depth ) + ambient_gamma )  ;
    
    /* DRAWBUFFERS:0 */
    
    gl_FragData[0] = vec4( diffuse, 1.0 );
  
}