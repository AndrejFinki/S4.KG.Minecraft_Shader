#version 120
#include "headers/constants.glsl"
#include "headers/lightmap.glsl"
#include "headers/shadow.glsl"
#extension GL_EXT_gpu_shader4 : enable

uniform sampler2D colortex5;
varying vec3 pos;
varying vec3 Normal;


/*
    Composite Fragment Shader
    The composite programs are fullscreen passes that run after all the gbuffers programs have finished executing.
*/

struct Hit{
    vec3 rayPos;
    bool hit;
};


vec3 FromViewtoScreenSpace(vec3 pos){
    vec4 intermediary = gbufferProjection*vec4(pos,1.0);
    vec3 screenSpace = intermediary.xyz/intermediary.w;
    return screenSpace*0.5+0.5;
}

const int stepcount = 64;
const int stepsize = 1/stepcount;

vec3 binaryRefinement(vec3 rayPos, vec3 rayDir){
    float depth_pos;
    float dist = 0.5;
    for(int i = 0; i<64; i++){
        

        vec3 rayScreenPos = FromViewtoScreenSpace(rayPos);

        depth_pos = texture2D(depthtex0, rayScreenPos.xy).r;

        if(rayScreenPos.z > depth_pos){
            rayPos-=rayDir*dist;
        }else{
            rayPos+=rayDir*dist;
        }
        dist*=0.5;
    }

    rayPos = FromViewtoScreenSpace(rayPos);

    return rayPos;
}


Hit raymarch(vec3 rayPos, vec3 rayDir){
    float depth_pos;
    bool intersected = false;
    float distanceD = 50;

    rayPos+=rayDir;

    vec3 raystep = (rayDir*distanceD)/stepcount;
    
    for(int i = 0; i<stepcount; i++){
        
        rayPos+=raystep;

        vec3 rayScreenPos = FromViewtoScreenSpace(rayPos);
        
        depth_pos = texture2D(depthtex0, rayScreenPos.xy).r;

        if(rayScreenPos.z > depth_pos){
            intersected = true;
            rayPos = binaryRefinement(rayPos,rayDir);
            break;
        }
        if(rayScreenPos.xy != clamp(rayScreenPos.xy, 0.0, 1.0)){
            Hit hit;
            hit.rayPos = vec3(0.0);
            hit.hit = false;
            return hit;
        }

    }

    Hit hit;
    hit.rayPos = rayPos;
    hit.hit = intersected;

    return hit;
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
        //vec3 viewNormal = Normal;

        vec3 viewNormal = normalize(texture2D(colortex1, tex_coords).xyz*2.0-1.0);
        
        vec3 ndcPos = vec3(tex_coords, texture2D(depthtex0, tex_coords))*2.0-1.0;
        vec4 intermediary = gbufferProjectionInverse * vec4(ndcPos, 1.0);
        vec3 viewPos = intermediary.xyz/intermediary.w;

        vec3 rayPos = viewPos;
        vec3 rayDir =  reflect(viewPos, viewNormal);
        Hit hit = raymarch(rayPos, rayDir);

        vec4 color = pow( texture2D( colortex0, tex_coords ), vec4( gamma_correction ) );
        if(hit.hit){
            //color = vec4(0.0);
            color += texture2D(colortex0, hit.rayPos.xy)*0.375;
        }
        /* DRAWBUFFERS:0 */
       // color = vec4 (normalize(texture2D(colortex1, tex_coords).xyz*2.0-1.0), 1.0);
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