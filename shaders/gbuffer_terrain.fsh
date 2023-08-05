#version 120

varying vec2 TexCoords;
varying vec3 Normal;

uniform sampler2D texture;

void
main()
{
	vec4 albedo	= texture2D( texture, TexCoords );
	/* DRAWBUFFERS:01 */
	gl_FragData[0] = albedo;
	gl_FragData[1] = vec4( Normal * 0.5 + 0.5, 1.0 );
}