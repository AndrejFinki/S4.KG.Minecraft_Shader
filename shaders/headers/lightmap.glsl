#ifndef LIGHTMAP_H
#define LIGHTMAP_H
#include "constants.glsl"

float
adjust_lightmap_torch( in float torch )
{
    return lightmap_torch_k * pow( torch, lightmap_torch_p );
}

float
adjust_lightmap_sky( in float sky )
{
    return pow( sky, 8 );
}

vec2
adjust_lightmap( in vec2 lightmap )
{
    vec2 new_lightmap;
    new_lightmap.x = adjust_lightmap_torch( lightmap.x );
    new_lightmap.y = adjust_lightmap_sky( lightmap.y );
    return new_lightmap;
}

vec3
get_lightmap_color( in vec2 lightmap, vec3 sky_type_lighting)
{
    lightmap = adjust_lightmap( lightmap );
    vec3 torch_lighthing = lightmap.x * torch_color * vec3(3, 0.85, 0.85);
    vec3 sky_lighthing = lightmap.y * sky_type_lighting;
    vec3 total_lighthing = torch_lighthing + sky_lighthing;
    return total_lighthing;
}

#endif