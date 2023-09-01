#version 120
#include "headers/constants.glsl"

void
main()
{
    gl_FragData[0] = texture2D( texture, tex_coords ) * color;
}