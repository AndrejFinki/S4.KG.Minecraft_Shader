#version 120
#include "constants.glsl"
#include "lightmap.glsl"
#include "shadow.glsl"

float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

float lerp(float a, float b, float f)
{
    return a + f * (b - a);
}  

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

    
    const int kernel_size = 64; // change to 16 to compare

    vec3 kernel[kernel_size];



    for(int i = 0; i<kernel_size ; i++){
        kernel[i] = vec3(
            rand(vec2(-1.0,1.0)),
            rand(vec2(-1.0,1.0)),
            rand(vec2(0.0,1.0))
        );

        float scale = float(i) / float(kernel_size);
        scale = lerp(0.1f, 1.0f, scale * scale);
        kernel[i] *= scale;
    }
    
    vec2 NoiseScale = vec2(viewWidth/noiseTextureResolution, viewHeight/noiseTextureResolution);
    
    vec3 screenPos = vec3(tex_coords, texture2D(depthtex0, tex_coords));
    vec3 ndcPos = screenPos * 2.0 - 1.0;
    vec4 homogenousViewPos = gbufferProjectionInverse * vec4(ndcPos, 1.0);
    vec3 viewPos = homogenousViewPos.xyz/homogenousViewPos.w;

    vec3 origin = viewPos * texture2D(depthtex0, tex_coords).r;

    float ao = 0.0;

    for(int i = 0; i<kernel_size; i++){
        vec3 RandomVector = texture2D(noisetex, tex_coords*NoiseScale).rgb * 2.0 - 1.0;
        
        vec3 tangent = normalize(RandomVector - normal * dot(RandomVector, normal));
        vec3 bitangent = cross(normal, tangent);
        mat3 tbn = mat3(tangent, bitangent, normal);
        vec3 samplePos = tbn*kernel[i];
        samplePos = 0.65 * samplePos + origin;
        //vec3 samplePos = viewPos + RandomVector * kernel[i];

        vec4 intermediaryPos = gbufferProjection * vec4(samplePos, 1.0);
        vec3 offset = intermediaryPos.xyz/intermediaryPos.w;
        offset = samplePos * 0.5 + 0.5;

        float thisDepth = texture2D(depthtex0, offset.xy).r;

        float rangeCheck = abs(origin.z - thisDepth) < 0.65 ? 1.0 : 0.0;
        
        ao+=(thisDepth <= samplePos.z ? 1.0 : 0.0) * rangeCheck  ;
         
    }

    ao = 1.0 - (ao / kernel_size);
    
    vec3 ambient = vec3(ambient_gamma * albedo * ao);

        if( worldTime > 13050 || rainStrength>0.1){

        vec3 normal = normalize( texture2D( colortex1, tex_coords ).rgb * 2.0 - 1.0 );
    
        /* Get lightmap and it's color */
        vec2 lightmap = texture2D( colortex2, tex_coords ).rg;
        sky_color = vec3(0.05, 0.03, 0.25);
        vec3 lightmap_color = get_lightmap_color( lightmap );

        /* Compute cos theta between the normal and sun directions */
        float NdotL = max( dot( normal, normalize( sunPosition ) ), 0.0 );

        vec3 diffuse;
        if(rainStrength > 0.1){
            diffuse = albedo *(ambient + NdotL + lightmap_color*2.0);
            
        }else{
            diffuse = albedo * (ambient + lightmap_color*2);
        }

        
        /* DRAWBUFFERS:0 */
        gl_FragData[0] = vec4( diffuse, 1.0);

        return;
    }

    /* Final diffuse color */
    
    vec3 diffuse = albedo * ( lightmap_color + NdotL * get_shadow( depth ) + ambient) ;
    
    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4( diffuse, 1.0 );
}