#version 120
#include "headers/constants.glsl"

void
main()
{
	vec4 final_color = texture2D( texture, tex_coords ) * color;
        
	final_color *= texture2D( lightmap, lightmap_coords );

    /* DRAWBUFFERS:012 */
	gl_FragData[0] = final_color;
    gl_FragData[1] = vec4( normal * 0.5 + 0.5, 1.0 );
    gl_FragData[2] = vec4( lightmap_coords, 0.0, 1.0 );
}