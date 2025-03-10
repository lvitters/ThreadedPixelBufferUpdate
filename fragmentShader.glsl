// fragmentShader.glsl
uniform float noiseIncR;
uniform float noiseIncG;
uniform float noiseIncB;
uniform vec2 resolution;

float random(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    // Normalize the pixel coordinates (UV space)
    vec2 uv = gl_FragCoord.xy / resolution;

    // Generate random noise for each color channel
    float r = random(uv * noiseIncR);
    float g = random(uv * noiseIncG);
    float b = random(uv * noiseIncB);

    // Map noise to a desired range (50-255)
    r = mix(50.0, 255.0, r);
    g = mix(50.0, 255.0, g);
    b = mix(50.0, 255.0, b);

    // Output the final color to the screen
    gl_FragColor = vec4(r, g, b, 1.0);
}