#version 120

uniform sampler2D lightmap;
uniform sampler2D texture;
uniform vec3 sunPosition;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 viewDir;
varying vec3 Normal;

float fresnelSchlick(float cosTheta, float F0) {
    return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}

void main() {
	vec4 color = texture2D(texture, texcoord) * glcolor;
	color *= texture2D(lightmap, lmcoord);
    
    vec3 halfwayDir = normalize(normalize(sunPosition) - normalize(viewDir));

    float spec = max(dot(Normal, halfwayDir),0.0) ;
    
    
    float intensity = 1.0f;

    intensity = mix(intensity, 1.0, fresnelSchlick(dot(-normalize(viewDir), Normal), 0.8));

    vec4 finalColor = color + pow(spec, 32)*vec4(0.45f)*intensity;
    

/* DRAWBUFFERS:0 */
	gl_FragData[0] = finalColor; //gcolor
}