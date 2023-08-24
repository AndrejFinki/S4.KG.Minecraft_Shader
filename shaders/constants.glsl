#ifndef CONSTANTS_H
#define CONSTANTS_H

varying vec2 tex_coords;
varying vec3 normal;
varying vec4 color;

uniform sampler2D texture;
uniform sampler2D colortex0;
uniform sampler2D colortex1;

uniform vec3 sunPosition;

/*
const int colortex0Format = RGBA16;
const int colortex1Format = RGBA16;
*/

const float sunPathRotation = -40.0;

const float gamma_correction = 2.2;
const float final_gamma_correction = 1.0 / gamma_correction;
const float ambient_gamma = 0.1;

#endif