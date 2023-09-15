#ifndef WAVY_WATER_H
#define WAVY_WATER_H

#include "constants.glsl"

attribute vec4 mc_Entity;

bool
water_check()
{
  bool is_water = mc_Entity.x == 10002.0;
  return is_water;
}

float
water_wave( float amp1, float amp2, vec3 world_pos, float w1, float w2 )
{
    return amp1 * sin( 2 * PI * ( frameTimeCounter * w1 - world_pos.x / 11.0 + world_pos.z / 6.0 ) ) + amp2 * sin( 2 * PI * 48 * 0.0081 * ( frameTimeCounter * w2 + world_pos.x / 13.0 - world_pos.z / 8.0 ) );
}

#endif