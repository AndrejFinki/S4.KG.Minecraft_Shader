#version 120
#include "headers/constants.glsl"
#include "headers/lightmap.glsl"
#include "headers/shadow.glsl"
#extension GL_EXT_gpu_shader4 : enable

uniform sampler2D colortex5;
/*
    Composite Fragment Shader
    The composite programs are fullscreen passes that run after all the gbuffers programs have finished executing.
*/

float linearizeDepthFast(float depth, float near, float far) {
     return (2.0 * near) / (far + near - depth * (far - near));
}

const int kernel_size = 64; // change to 16 to compare]
const int noise_resolution = 16;

 void pcg(inout uint seed) {
    uint state = seed * 747796405u + 2891336453u;
    uint word = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;
    seed = (word >> 22u) ^ word;
}

uint rngState = 185730u * uint(frameCounter) + uint(gl_FragCoord.x + gl_FragCoord.y * aspectRatio);

float randF()  { pcg(rngState); return float(rngState) / float(0xffffffffu); }

const int stepcount = 32;
const int stepsize = 1/stepcount;

vec4 raymarch(vec3 rayPos, vec3 rayDir){
    float depth_pos;
    float intersected = 0.0;
    //rayPos += rayDir*randF();
    //rayPos += rayDirection*0.1512;
    //rayDir*=stepsize;
    //rayPos+=rayDir;
    for(int i = 0; i<stepcount; i++){
        rayPos+=rayDir*stepsize;

        depth_pos = texture2D(depthtex0, rayPos.xy).z;

        if(rayPos.z > depth_pos){
            intersected = 1.0;
            break;
        }
        if(clamp(rayPos.xy, 0.0, 1.0) != rayPos.xy){
            return vec4(0.0);
        }
    }

    return vec4(rayPos,intersected);
}

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
    

    if(texture2D(colortex5,tex_coords).x > 0.5){
        vec3 normspace = normalize( texture2D( colortex1, tex_coords ).rgb*2.0 - 1.0 );
        vec3 viewPos = vec3(tex_coords, texture2D(depthtex0, tex_coords));
        vec3 rayPos = reflect(viewPos, normspace);
        vec3 rayDir = normalize(rayPos);
        vec4 hit = raymarch(rayPos, rayDir);
        vec4 color = pow( texture2D( colortex0, tex_coords ), vec4( gamma_correction ) );
        if(hit.a == 1.0){
            //color = vec4(0.0);
            color += texture2D(colortex0, hit.xy);
        }
        /* DRAWBUFFERS:0 */
    
        gl_FragData[0] = color;

        //test

        return;
    }
    

    /* Final diffuse color */
    vec3 diffuse;

    
    diffuse = albedo * ( lightmap_color*1.35 + NdotL * get_shadow( depth ) + ambient_gamma )  ;
    
    
    
    /* DRAWBUFFERS:0 */
    
    gl_FragData[0] = vec4( diffuse, 1.0 );
  
}