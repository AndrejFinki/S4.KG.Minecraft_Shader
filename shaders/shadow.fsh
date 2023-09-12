#version 120
#include "headers/constants.glsl"

/*
    Shadow Fragment Shader
    The Shadow pass is a stage that runs for all types of blocks, entities, etc.
    It is optional, but it can be used to improve the look of shadows in general.
*/

void
main()
{
    gl_FragData[0] = texture2D( texture, tex_coords ) * color;
}