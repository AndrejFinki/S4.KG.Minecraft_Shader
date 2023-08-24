#version 120

#include "distort.glsl"

#define SHADOW_SAMPLES 2

/* Texture Coordinates */
varying vec2 TexCoords;

/* Optifine: Sun Position */
uniform vec3 sunPosition;

/* Optifine: Color Textures */
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;

/* Optifine: Depth Texture */
uniform sampler2D depthtex0;

/* Optifine: Shadow Texture */
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;

/* Optifine: Shadow Color */
uniform sampler2D shadowcolor0;

/* Optifine: Noise Texture Map */
uniform sampler2D noisetex;

/* Optifine: Matrices */
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

/* Optifine: Color Texture Format
const int colortex0Format = RGBA16F;
const int colortex1Format = RGB16;
const int colortex2Format = RGB16;
*/

/* Optifine: Describes how titled the sun is from an overhead path in degrees */
const float sunPathRotation = -60.0f;

/* Optifine: Map Resolutions */
const int shadowMapResolution=1024;

const int noiseTextureResolution = 256;

/* Optifine: Shadow Constants */
const int ShadowSamplesPerSize = 2 * SHADOW_SAMPLES + 1;
const int TotalSamples = ShadowSamplesPerSize * ShadowSamplesPerSize;

/* Ambient lighting factor used in lighting calculations */
const float Ambient = 0.025f;

float AdjustLightmapTorch( in float );
float AdjustLightmapSky( in float );
vec2 AdjustLightmap( in vec2 );
vec3 GetLightmapColor( in vec2 );
vec3 GetShadow( in float );
float Visibility( in sampler2D, in vec3 );
vec3 TransparentShadow( in vec3 );

void
main()
{

    vec3 Albedo = pow( texture2D( colortex0, TexCoords ).rgb, vec3( 2.2 ) );
    float Depth = texture2D( depthtex0, TexCoords ).r;

    if( Depth == 1.0 ) {
        gl_FragData[0] = vec4( Albedo, 1.0f );
        return;
    }

    vec3 Normal = normalize( texture2D( colortex1, TexCoords ).rgb * 2.0 - 1.0 );
    vec2 Lightmap = texture2D( colortex2, TexCoords ).rg;
    vec3 LightmapColor = GetLightmapColor( Lightmap );

    float NdotL = max( dot( Normal, normalize( sunPosition ) ), 0.0 );

    vec3 Diffuse = Albedo * ( LightmapColor + NdotL * GetShadow( Depth ) + Ambient );

    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4( Diffuse, 1.0 );
}

float
AdjustLightmapTorch( in float torch )
{
    const float K = 2.0;
    const float P = 5.06;
    return K * pow( torch, P );
}

float
AdjustLightmapSky( in float sky )
{
    return pow( sky, 8 );
}

vec2
AdjustLightmap( in vec2 Lightmap )
{
    vec2 NewLightMap;
    NewLightMap.x = AdjustLightmapTorch( Lightmap.x );
    NewLightMap.y = AdjustLightmapSky( Lightmap.y );
    return NewLightMap;
}

vec3
GetLightmapColor( in vec2 Lightmap )
{
    Lightmap = AdjustLightmap( Lightmap );

    const vec3 TorchColor = vec3( 1.0, 0.25, 0.08 );
    const vec3 SkyColor = vec3( 0.05, 0.25, 0.54 );

    vec3 TorchLighting = Lightmap.x * TorchColor;
    vec3 SkyLighting = Lightmap.y * SkyColor;

    vec3 LightmapLighting = TorchLighting + SkyLighting;

    return LightmapLighting*1.15;
}

vec3
GetShadow( in float depth )
{
    vec3 ClipSpace = vec3( TexCoords, depth ) * 2.0 - 1.0;
    vec4 ViewW = gbufferProjectionInverse * vec4( ClipSpace, 1.0 );
    vec3 View = ViewW.xyz / ViewW.w;
    vec4 World = gbufferModelViewInverse * vec4( View, 1.0 );
    vec4 ShadowSpace = shadowProjection * shadowModelView * World;
    ShadowSpace.xy = DistortPosition( ShadowSpace.xy );
    vec3 SampleCoords = ShadowSpace.xyz * 0.5 + 0.5;
    
    float RandomAngle = texture2D( noisetex, TexCoords * 20.0 ).r * 100.0;
    float cosTheta = cos( RandomAngle );
    float sinTheta = sin( RandomAngle );
    mat2 Rotation = mat2( cosTheta, -sinTheta, sinTheta, cosTheta ) / shadowMapResolution;

    vec3 ShadowAccum = vec3( 0.0 );
    for( int x = -SHADOW_SAMPLES ; x <= SHADOW_SAMPLES ; x++ ){
        for( int y = -SHADOW_SAMPLES ; y <= SHADOW_SAMPLES ; y++ ){
            vec2 Offset = Rotation * vec2( x, y );
            vec3 CurrentSampleCoordinate = vec3( SampleCoords.xy + Offset, SampleCoords.z );
            ShadowAccum += TransparentShadow( CurrentSampleCoordinate );
        }
    }

    ShadowAccum /= TotalSamples;
    return ShadowAccum * 2.15;
}

float
Visibility( in sampler2D ShadowMap, in vec3 SampleCoords )
{
  return step( SampleCoords.z - 0.001, texture2D( ShadowMap, SampleCoords.xy ).r );
}

vec3
TransparentShadow( in vec3 SampleCoords )
{
  float ShadowVisibility0 = Visibility( shadowtex0, SampleCoords );
  float ShadowVisibility1 = Visibility( shadowtex1, SampleCoords );
  vec4 ShadowColor0 = texture2D( shadowcolor0, SampleCoords.xy );
  vec3 TransmittedColor = ShadowColor0.rgb * ( 1.0 - ShadowColor0.a );
  return mix( TransmittedColor * ShadowVisibility1, vec3( 1.0 ), ShadowVisibility0 );
}
