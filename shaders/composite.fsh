#version 120

varying vec2 TexCoords;

uniform vec3 sunPosition;
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D depthtex0;
uniform sampler2D shadowtex0;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

/*
const int colortex0Format = RGB16;
const int colortex1Format = RGB16;
const int colortex2Format = RGB16;
*/

const float sunPathRotation = -40.0;
const float Ambient = 0.1;

float GetShadow(in float);
float AdjustLightmapTorch( in float );
float AdjustLightmapSky( in float );
vec2 AdjustLightmap( in vec2 );
vec3 GetLightmapColor( in vec2 );

void
main()
{
	vec3 Albedo = pow( texture2D( colortex0, TexCoords ).rgb, vec3( 2.2 ) );
	float Depth = texture2D(depthtex0, TexCoords).r;
    if(Depth == 1.0f){
        gl_FragData[0] = vec4(Albedo, 1.0f);
        return;
    }
    vec3 Normal = normalize( texture2D( colortex1, TexCoords ).rgb * 2.0 - 1.0 );
	vec2 Lightmap = texture2D( colortex2, TexCoords ).rg;
	vec3 LightmapColor = GetLightmapColor( Lightmap );
	float NdotL = max( dot( Normal, normalize( sunPosition ) ), 0.0 );
	vec3 Diffuse = Albedo * ( LightmapColor + NdotL*GetShadow(Depth) + Ambient );
	/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4( Diffuse, 1.0 );
}

float
AdjustLightmapTorch( in float torch )
{
    const float K = 2.0f;
    const float P = 5.06f;
    return K * pow( torch, P );
}

float
AdjustLightmapSky( in float sky )
{
    float sky_2 = sky * sky;
    return sky_2 * sky_2;
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
    const vec3 TorchColor = vec3( 1.0f, 0.25f, 0.08f );
    const vec3 SkyColor = vec3( 0.05f, 0.15f, 0.3f );
    vec3 TorchLighting = Lightmap.x * TorchColor;
    vec3 SkyLighting = Lightmap.y * SkyColor;
    vec3 LightmapLighting = TorchLighting + SkyLighting;
    return LightmapLighting;
}

float
GetShadow(float depth){
    vec3 ClipSpace = vec3(TexCoords, depth) * 2.0f - 1.0f;
	vec4 ViewW = gbufferProjectionInverse*vec4(ClipSpace, 1.0f);
	vec3 View = ViewW.xyz / ViewW.w;
	vec4 World = gbufferModelViewInverse * vec4(View, 1.0f);
	vec4 ShadowSpace = shadowProjection * shadowModelView * World;
	vec3 SampleCoords = ShadowSpace.xyz*0.5f + 0.5f;
	return step(SampleCoords.z-0.001f, texture2D(shadowtex0, SampleCoords.xy).r);
}