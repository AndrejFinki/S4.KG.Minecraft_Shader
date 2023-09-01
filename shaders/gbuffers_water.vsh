#version 120
#include "constants.glsl"

attribute vec4 at_tangent;

void
main()
{
    vec4 vertex_position = ( gl_ModelViewMatrix * gl_Vertex );
	view_dir = normalize( vertex_position.xyz );
    gl_Position = gl_ProjectionMatrix * vertex_position;
    normal = gl_NormalMatrix * gl_Normal;
    tex_coords = ( gl_TextureMatrix[0] * gl_MultiTexCoord0 ).xy;
	lightmap_coords  = ( gl_TextureMatrix[1] * gl_MultiTexCoord1 ).xy;
	color = gl_Color;
}