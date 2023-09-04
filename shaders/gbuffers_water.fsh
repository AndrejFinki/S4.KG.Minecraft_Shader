#version 120
#include "distort_v2.glsl"

uniform sampler2D lightmap;
uniform sampler2D texture;
uniform sampler2D depthtex0;
uniform sampler2D shadowtex0;
uniform vec3 sunPosition;
uniform float rainStrength;
uniform int worldTime;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferProjection;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 viewDir;
varying vec3 Normal;
varying vec3 worldPos;
varying vec4 shadowPos;

float fresnelSchlick(float cosTheta, float F0) {
    return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}

void main() {
	vec4 color = texture2D(texture, texcoord) * glcolor;

    if(worldTime > 13050 || rainStrength>0.1){
        /* DRAWBUFFERS:012 */
        gl_FragData[0] = color;
        gl_FragData[1] = vec4( Normal * 0.5 + 0.5, 1.0 );
        gl_FragData[2] = vec4( lmcoord, 0.0, 1.0 );
        return;
    }
    
    vec3 halfwayDir = normalize(normalize(sunPosition) - viewDir);

    float spec = max(dot(Normal, halfwayDir),0.0) ;
    

    vec4 finalColor = color + pow(spec, 32)*vec4(0.65f)*fresnelSchlick(max(dot(-viewDir, Normal), 0.0), 0.8);
    

    /* DRAWBUFFERS:012 */
	gl_FragData[0] = finalColor; //gcolor
    gl_FragData[1] = vec4( Normal * 0.5 + 0.5, 1.0 );
    gl_FragData[2] = vec4( lmcoord, 0.0, 1.0 );
}