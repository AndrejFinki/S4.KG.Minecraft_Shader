#version 120
#include "headers/constants.glsl"

/*
    Final Fragment Shader
    Final is a fullscreen pass, and also the last pass in the shader pipeline.
    Whatever color final outputs is the color that gets displayed in-game.
*/

void
main()
{
   /* Gamma Correction */
   vec3 color = pow( texture2D( colortex0, tex_coords ).rgb, vec3( final_gamma_correction ) );
   
   gl_FragColor = vec4( color, 1.0 );
}