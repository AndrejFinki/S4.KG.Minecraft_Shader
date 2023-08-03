// Vertex Shader (gbuffers_water.vsh)

varying vec2 TexCoords;

void main() {
    gl_Position = ftransform();
    TexCoords = gl_MultiTexCoord0.st;
}