#ifndef WAVY_LIQUID_H
#define WAVY_LIQUID_H

#include "constants.glsl"

#ifndef MC_ENTITY
#define MC_ENTITY
attribute vec4 mc_Entity;
#endif

bool
liquid_check()
{
  bool is_water = mc_Entity.x == 10002.0;
  bool is_lava = mc_Entity.x == 10003.0;
  return is_water || is_lava;
}

float
liquid_wave( float amp1, float amp2, vec3 world_pos, float w1, float w2 )
{
  return amp1 * sin( 2 * PI * ( frameTimeCounter * w1 - world_pos.x / 11.0 + world_pos.z / 6.0 ) ) + amp2 * sin( 2 * PI * 48 * 0.0081 * ( frameTimeCounter * w2 + world_pos.x / 13.0 - world_pos.z / 8.0 ) );
}

void
liquid_wave_glsl() {
  vec4 vertex_position = ( gl_ModelViewMatrix * gl_Vertex );
  vec3 eye_player_pos = mat3( gbufferModelViewInverse ) * vertex_position.xyz;
  vec3 world_pos = eye_player_pos + cameraPosition + gbufferModelViewInverse[3].xyz;
  float fy = fract( world_pos.y + 0.001 );
  float displacement = liquid_wave( 0.05, 0.07, world_pos, 0.6, 0.75 );
  vertex_position.y += clamp( displacement, -fy, 1.0 - fy );
  view_dir = normalize( vertex_position.xyz );
  gl_Position = gl_ProjectionMatrix * vertex_position;
}

#endif