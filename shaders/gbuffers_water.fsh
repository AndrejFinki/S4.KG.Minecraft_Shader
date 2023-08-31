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
    
    vec3 halfwayDir = normalize(normalize(sunPosition) - viewDir);

    float spec = max(dot(Normal, halfwayDir),0.0) ;
    

    vec4 finalColor = color + pow(spec, 32)*vec4(0.65f)*fresnelSchlick(max(dot(-viewDir, Normal), 0.0), 0.8);
    

/* DRAWBUFFERS:0 */
	gl_FragData[0] = finalColor; //gcolor
}