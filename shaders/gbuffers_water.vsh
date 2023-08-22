#version 120

#define TWO_PI 6.28318530718
#define Pi 3.14579

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 Normal;
varying vec3 FlatNormal;

varying vec3 viewDir;
varying mat3 tbnMatrix;
varying float NdotL;

varying vec3 wpos;
varying float frameTimeCounteri;
varying mat3 TbnMatrix;

uniform float frameTimeCounter;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;
uniform vec3 cameraPosition;
uniform vec3 sunPosition;

attribute vec4 at_tangent;

void main() {
	
    vec4 pos = gl_ModelViewMatrix * gl_Vertex;

    vec4 viewPos = gbufferModelViewInverse * pos;

    vec3 worldpos = viewPos.xyz + cameraPosition;
    wpos = worldpos;

    float fy = fract(worldpos.y + 0.001);
    float displacement = 0.0;
	
    

	if (fy > 0.1) {

            float amp1 = 0.03;
            float amp2 = 0.05;
            float phase1 = (frameTimeCounter*0.75 + worldpos.x /  7.0 + worldpos.z / 13.0);
            float phase2 = (frameTimeCounter*0.6 + worldpos.x / 11.0 + worldpos.z /  5.0);
            float angle1 = TWO_PI * phase1;
            float angle2 = TWO_PI * phase2;

			float wave = amp1 * sin(angle1) + amp2 * sin(angle2);

            displacement = clamp(wave, -fy, 1.0-fy);
			viewPos.y += displacement;

            frameTimeCounteri = frameTimeCounter;

            vec3 derivative1 = normalize(vec3(1, amp1*cos(angle1), 0));
            vec3 derivative2 = normalize(vec3(0, amp2*cos(angle2), 1));
            
            Normal = normalize(cross(derivative1, derivative2));
	}
    
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;

	glcolor = gl_Color;

    viewPos = gbufferModelView * viewPos; 
   
    //vec3 normal = normalize(gl_NormalMatrix * Normal).xyz;
    vec3 normal = normalize(gl_NormalMatrix * gl_Normal).xyz;

    vec3 tangent = normalize(gl_NormalMatrix * at_tangent.xyz);
	vec3 binormal = normalize(gl_NormalMatrix * cross(at_tangent.xyz, gl_Normal.xyz) * at_tangent.w);
	tbnMatrix = mat3(tangent.x, binormal.x, normal.x,
					 tangent.y, binormal.y, normal.y,
					 tangent.z, binormal.z, normal.z);

	
	viewDir = tbnMatrix * (gl_ModelViewMatrix * gl_Vertex).xyz;
	viewDir.xy = viewDir.xy / 0.125 ;
   

    gl_Position = gl_ProjectionMatrix * viewPos;
    FlatNormal = normalize(gl_NormalMatrix * gl_Normal).xyz;
    TbnMatrix = tbnMatrix;
}