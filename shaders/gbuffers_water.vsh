#version 120
#define TWO_PI 6.28318530718

attribute vec4 at_tangent;

uniform sampler2D noisetex;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;
uniform vec3 cameraPosition;
uniform float frameTimeCounter;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 viewDir;
varying vec3 Normal;
varying mat3 tbnMatrix;


float water_wave(float amp1, float amp2, vec3 world_pos, float w1, float w2){
    
    return amp1*sin(TWO_PI*(frameTimeCounter*w1 - world_pos.x/11.0 + world_pos.z/6.0)) + amp2*sin(TWO_PI*48*0.0081*(frameTimeCounter*w2 + world_pos.x/13.0 - world_pos.z/8.0));
}



void main() {
	//gl_Position = ftransform();
    vec4 vertexPosition = (gl_ModelViewMatrix * gl_Vertex);

    vec3 eye_player_pos = mat3(gbufferModelViewInverse)*vertexPosition.xyz;
    vec3 world_pos = eye_player_pos + cameraPosition + gbufferModelViewInverse[3].xyz;

    float fy = fract(world_pos.y+0.001);

    float displacement = water_wave(0.05, 0.07, world_pos, 0.6, 0.75);

    vertexPosition.y += clamp(displacement, -fy, 1.0-fy);
    //vertexPosition.z -= clamp(displacement, -fy, 1.0-fy);
    
	viewDir = normalize(vertexPosition.xyz);

    gl_Position = gl_ProjectionMatrix*vertexPosition;

    Normal = gl_NormalMatrix * gl_Normal;
		
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glcolor = gl_Color;

}