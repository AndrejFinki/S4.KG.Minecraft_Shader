#ifndef LIGHTMAP_H
#define LIGHTMAP_H

#include "constants.glsl"

float
adjust_lightmap_torch( float torch )
{
    return lightmap_torch_k * pow( torch, lightmap_torch_p );
}

float
adjust_lightmap_sky( float sky )
{
    return pow( sky, 8 );
}

vec2
adjust_lightmap( vec2 lightmap )
{
    vec2 new_lightmap;
    new_lightmap.x = adjust_lightmap_torch( lightmap.x );
    new_lightmap.y = adjust_lightmap_sky( lightmap.y );
    return new_lightmap;
}

vec3
get_lightmap_color( vec2 lightmap )
{
    lightmap = adjust_lightmap( lightmap );
    vec3 torch_lighthing = lightmap.x * torch_color;
    vec3 sky_lighthing = lightmap.y * sky_color;
    vec3 total_lighthing = torch_lighthing + sky_lighthing;
    return total_lighthing;
}

vec3
get_lightmap_color( vec2 lightmap, vec3 sky_type_lighting )
{
  lightmap = adjust_lightmap( lightmap );
  vec3 torch_lighthing = lightmap.x * torch_color;
  vec3 sky_lighthing = lightmap.y * sky_color;
  vec3 total_lighthing = torch_lighthing + sky_type_lighting;
  return total_lighthing;
}

#endif