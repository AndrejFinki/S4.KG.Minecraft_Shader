#ifndef CONSTANTS_H
#define CONSTANTS_H

varying vec2 tex_coords;
varying vec3 normal;
varying vec4 color;
varying vec2 lightmap_coords;

uniform sampler2D texture;
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D depthtex0;
uniform sampler2D shadowtex0;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform vec3 sunPosition;

/*
const int colortex0Format = RGBA16;
const int colortex1Format = RGBA16;
const int colortex2Format = RGBA16;
const int shadowMapResolution = 1024;
*/

const float sunPathRotation = -40.0;

const float gamma_correction = 2.2;
const float final_gamma_correction = 1.0 / gamma_correction;
const float ambient_gamma = 0.1;
const float lightmap_torch_k = 2.0;
const float lightmap_torch_p = 5.06;
const vec3 torch_color = vec3( 1.0, 0.25, 0.08 );
const vec3 sky_color = vec3( 0.05, 0.15, 0.3 );

#endif