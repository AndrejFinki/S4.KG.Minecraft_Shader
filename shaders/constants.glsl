#ifndef CONSTANTS_H
#define CONSTANTS_H

#define SHADOW_SAMPLES 2
#define PI 3.1415926535

#ifdef VSH
attribute vec4 mc_Entity;
#endif

varying vec2 tex_coords;
varying vec3 normal;
varying vec4 color;
varying vec2 lightmap_coords;

uniform float frameTimeCounter;

uniform sampler2D texture;
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D depthtex0;
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor0;
uniform sampler2D noisetex;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform vec3 sunPosition;
uniform vec3 cameraPosition;

/*
const int colortex0Format = RGBA16;
const int colortex1Format = RGBA16;
const int colortex2Format = RGBA16;
*/

const int shadowMapResolution = 1024;
const float sunPathRotation = -40.0;
const int noiseTextureResolution = 128;

const float gamma_correction = 2.2;
const float final_gamma_correction = 1.0 / gamma_correction;
const float ambient_gamma = 0.1;
const float lightmap_torch_k = 2.0;
const float lightmap_torch_p = 5.06;
const vec3 torch_color = vec3( 1.0, 0.25, 0.08 );
const vec3 sky_color = vec3( 0.05, 0.15, 0.3 );
const int shadow_samples_per_size = 2 * SHADOW_SAMPLES + 1;
const int total_samples = shadow_samples_per_size * shadow_samples_per_size;

#endif