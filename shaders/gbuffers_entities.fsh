#version 120
#include "headers/constants.glsl"

/*
    Gbuffers_Entities Fragment Shader
    Gbuffers programs are the main geometry passes, where entities, particals, blocks, etc. are rendered.
    Gbuffers_Entities is a program specifically for entities, such as mobs, chests, boats, minecarts, etc.
    A full list of entities can be found here: https://minecraft.fandom.com/wiki/Entity#Types_of_entities
*/

void
main()
{
	vec4 final_color = texture2D( texture, tex_coords ) * color;
	final_color.rgb = mix( final_color.rgb, entityColor.rgb, entityColor.a );
	final_color *= texture2D( lightmap, lightmap_coords );

    /* DRAWBUFFERS:012 */
	gl_FragData[0] = final_color;
    gl_FragData[1] = vec4( normal * 0.5 + 0.5, 1.0 );
    gl_FragData[2] = vec4( lightmap_coords, 0.0, 1.0 );
}