#version 120
#include "constants.glsl"
#include "lightmap.glsl"
#include "shadow.glsl"
#extension GL_EXT_gpu_shader4 : enable

varying vec3 Normal;

const int kernel_size = 64; // change to 16 to compare]
const int noise_resolution = 16;

 void pcg(inout uint seed) {
    uint state = seed * 747796405u + 2891336453u;
    uint word = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;
    seed = (word >> 22u) ^ word;
}

uint rngState = 185730u * uint(frameCounter) + uint(gl_FragCoord.x + gl_FragCoord.y * aspectRatio);

float randF()  { pcg(rngState); return float(rngState) / float(0xffffffffu); }

float linearizeDepthFast(float depth, float near, float far) {
    return (near * far) / (depth * (near - far) + far);
}

float lerp(float a, float b, float f)
{
    return a + f * (b - a);
}

vec3 depthToView(vec2 texCoord, float depth, mat4 projInv) {
    vec4 ndc = vec4(texCoord, 1, 1) * 2 - 1;
    vec4 viewPos = projInv * ndc;
    return normalize(viewPos.xyz / viewPos.w);
}

mat3 tbnNormalTangent(vec3 normal, vec3 tangent) {
    // For DirectX normal mapping you want to switch the order of these 
    vec3 bitangent = cross(normal, tangent);
    return mat3(tangent, bitangent, normal);
}

mat3 tbnNormal(vec3 normal) {
    // This could be
    // normalize(vec3(normal.y - normal.z, -normal.x, normal.x))
    vec3 tangent = normalize(cross(normal, vec3(0, 1, 1)));
    return tbnNormalTangent(normal, tangent);
}




float AmbientOcclusion(){
    
    const float radius = 0.5;
    const float bias = 0.025;

    vec3 kernel[kernel_size];

    for(int i = 0; i<kernel_size ; i++){
        kernel[i] = vec3(
            randF() * 2.0 - 1.0,
            randF() * 2.0 - 1.0,
            randF()
        );

        kernel[i] = normalize(kernel[i]);
        kernel[i] *= randF();
        float scale = float(i) / float(kernel_size);
        scale = lerp(0.1f, 1.0f, scale * scale);
        kernel[i] *= scale;
    }

    vec3 noise[noise_resolution];

    for(int i = 0; i<noise_resolution; i++){
        noise[i] = vec3(
            randF()*2.0 - 1.0,
            randF()*2.0 - 1.0,
            0.0f
        );

    }

    vec3 normal = normalize( texture2D( colortex1, tex_coords ).rgb ) * 2.0 - 1.0;
    vec4 intermediaryNormal = gbufferProjectionInverse*vec4(normal, 1.0);
    normal = intermediaryNormal.xyz/intermediaryNormal.w;

    mat3 tbnMatrix = tbnNormal(normal);

    normal = tbnMatrix * Normal;

    vec2 NoiseScale = vec2(viewWidth/noiseTextureResolution, viewHeight/noiseTextureResolution);
    
    float depth = texture2D(depthtex0,tex_coords).z;

    vec3 test = depthToView(tex_coords, depth, gbufferProjectionInverse);

    vec3 origin = vec3(tex_coords, texture2D(depthtex0, tex_coords)) * 2.0 - 1.0;
    vec4 intermediary = gbufferProjectionInverse*vec4(origin, 1.0);
    origin = intermediary.xyz/intermediary.w;
    origin = -origin;
    //origin = -test;
    
    float ao = 0.0;

    //vec3 RandomVector = normalize(texture2D(noisetex, tex_coords*NoiseScale).rgb);
    int noiseX = int(gl_FragCoord.x - 0.5) % int(sqrt(noise_resolution));
    int noiseY = int(gl_FragCoord.y - 0.5) % int(sqrt(noise_resolution));
    vec3 RandomVector = noise[noiseX + (noiseY*4)];
    vec3 tangent = normalize(RandomVector - normal * dot(RandomVector, normal));
    vec3 bitangent = cross(normal, tangent);
    mat3 tbn = mat3(tangent, bitangent, normal);
        
    for(int i = 0; i<kernel_size; i++){
        
        vec3 samplePos = tbn*kernel[i];
        samplePos = radius * samplePos + origin;

        vec4 offset = vec4(samplePos, 1.0);
        offset = gbufferProjection * offset;
        offset.xyz /= offset.w;
        offset.xyz = offset.xyz * 0.5 + 0.5;
        
        float thisDepth = texture2D(depthtex0, offset.xy).z;

        float linear = linearizeDepthFast(thisDepth, near, far);

        float rangeCheck = smoothstep(0.0, 1.0, radius / abs(origin.z - linear));
        
        ao += (linear >= samplePos.z + bias ? 1.0 : 0.0) * rangeCheck ;
         
    }

    ao = (ao / kernel_size);

    return ao;
}

void
main()
{
    /* Account for gamma correction */
    vec3 albedo = pow( texture2D( colortex0, tex_coords ).rgb, vec3( gamma_correction ) );
    
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
    
    vec3 ambient = vec3(ambient_gamma * albedo * ao);

    if( worldTime > 13050 ){

        vec3 diffuse;
        
        float NdotL = max( dot( normal, normalize( moonPosition ) ), 0.0 );

        diffuse = albedo * (ambient + lightmap_color*2);
        
        /* DRAWBUFFERS:0 */
        gl_FragData[0] = vec4( diffuse, 1.0);

        return;
    }
 
    /* Final diffuse color */

    
    vec3 diffuse = albedo * ( lightmap_color*1.35 + NdotL * get_shadow( depth ) + ambient )  ;
    
    /* DRAWBUFFERS:0 */
    
    gl_FragData[0] = vec4( diffuse, 1.0 );
  
}