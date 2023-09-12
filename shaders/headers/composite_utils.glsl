#ifndef COMPOSITE_UTILS_H
#define COMPOSITE_UTILS_H

#include "constants.glsl"
#include "lightmap.glsl"
#include "shadow.glsl"

bool
sky_box_check( vec3 albedo, float depth )
{
    if( depth != 1.0 ) return false;
    gl_FragData[0] = vec4( albedo, 1.0 );
    return true;
}

bool
night_time_check()
{
    return worldTime >= 13000;
}

bool
day_time_check()
{
    return worldTime < 13000;
}

void
night_time( vec3 albedo, float depth )
{
    vec3 normal = normalize( texture2D( colortex1, tex_coords ).rgb * 2.0 - 1.0 );
    vec2 lightmap = texture2D( colortex2, tex_coords ).rg;
    vec3 lightmap_color = get_lightmap_color( lightmap , vec3( 0.15, 0.25, 0.8 ) );
    float NdotL = max( dot( normal, normalize( moonPosition ) ), 0.0 );
    vec3 diffuse = albedo * ( lightmap_color * 1.35 + NdotL * get_shadow( depth ) + ambient_gamma ) * vec3( 0.2, 0.2, 0.4 );

    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4( diffuse, 1.0 );
}

void
day_time( vec3 albedo, float depth )
{
    vec3 normal = normalize( texture2D( colortex1, tex_coords ).rgb * 2.0 - 1.0 );
    vec2 lightmap = texture2D( colortex2, tex_coords ).rg;
    vec3 lightmap_color = get_lightmap_color( lightmap, vec3( 0.05, 0.15, 0.6 ) );
    float NdotL = max( dot( normal, normalize( sunPosition ) ), 0.0 );
    vec3 diffuse = albedo * ( lightmap_color * 1.35 + NdotL * get_shadow( depth ) + ambient_gamma );

    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4( diffuse, 1.0 );
}

void
default_time( vec3 albedo, float depth )
{
    vec3 normal = normalize( texture2D( colortex1, tex_coords ).rgb * 2.0 - 1.0 );
    vec2 lightmap = texture2D( colortex2, tex_coords ).rg;
    vec3 lightmap_color = get_lightmap_color( lightmap );
    float NdotL = max( dot( normal, normalize( sunPosition ) ), 0.0 );
    vec3 diffuse = albedo * ( lightmap_color + NdotL * get_shadow( depth ) + ambient_gamma );

    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4( diffuse, 1.0 );
}

#endif