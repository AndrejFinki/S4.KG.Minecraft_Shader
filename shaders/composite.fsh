#version 120

varying vec2 TexCoords;

uniform vec3 sunPosition;
uniform sampler2D colortex0;
uniform sampler2D colortex1;

/*
const int colortex0Format = RGBA16;
const int colortex1Format = RGBA16;
*/

const float sunPathRotation = -40.0;
const float Ambient = 0.1;

void
main()
{
	vec3 Albedo = pow( texture2D( colortex0, TexCoords ).rgb, vec3( 2.2 ) );
	vec3 Normal = normalize( texture2D( colortex1, TexCoords ).rgb * 2.0 - 1.0 );
	float NdotL = max( dot( Normal, normalize( sunPosition ) ), 0.0 );
	vec3 Diffuse = Albedo * ( NdotL + Ambient );
	/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4( Diffuse, 1.0 );
}