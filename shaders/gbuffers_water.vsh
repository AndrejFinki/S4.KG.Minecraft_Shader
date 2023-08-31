#version 120

attribute vec4 at_tangent;

uniform sampler2D noisetex;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;
uniform vec3 cameraPosition;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 viewDir;
varying vec3 Normal;
varying mat3 tbnMatrix;


void main() {
	//gl_Position = ftransform();
    vec4 vertexPosition = (gl_ModelViewMatrix * gl_Vertex);

	viewDir = normalize(vertexPosition.xyz);

    gl_Position = gl_ProjectionMatrix*vertexPosition;

    Normal = gl_NormalMatrix * gl_Normal;
		
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glcolor = gl_Color;

}