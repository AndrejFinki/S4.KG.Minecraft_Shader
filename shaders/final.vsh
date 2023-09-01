#version 120
#include "headers/constants.glsl"

void
main()
{
   gl_Position = ftransform();
   tex_coords = gl_MultiTexCoord0.st;
}