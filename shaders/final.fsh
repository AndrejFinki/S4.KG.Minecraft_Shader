#version 120
#include "constants.glsl"

void
main()
{
   /* Gamma Correction */
   vec3 color = pow( texture2D( colortex0, tex_coords ).rgb, vec3( final_gamma ) );
   
   gl_FragColor = vec4( color, 1.0 );
}