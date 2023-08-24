#version 120
#include "constants.glsl"

void
main()
{
    gl_Position = ftransform();
    tex_coords = gl_MultiTexCoord0.st;
    normal = gl_NormalMatrix * gl_Normal;
    color = gl_Color;
    lightmap_coords /= 15;
}
