#version 300 es

// This is a fragment shader. If you've opened this file first, please
// open and read lambert.vert.glsl before reading on.
// Unlike the vertex shader, the fragment shader actually does compute
// the shading of geometry. For every pixel in your program's output
// screen, the fragment shader is run for every bit of geometry that
// particular pixel overlaps. By implicitly interpolating the position
// data passed into the fragment shader by the vertex shader, the fragment shader
// can compute what color to apply to its pixel based on things like vertex
// position, light position, and vertex color.
precision highp float;

uniform vec4 u_Color; // The color with which to render this instance of geometry.

// These are the interpolated values out of the rasterizer, so you can't know
// their specific values without knowing the vertices that contributed to them
in vec4 fs_Nor;
in vec4 fs_LightVec;
in vec4 fs_Col;

in vec4 fs_Pos;

out vec4 out_Col; // This is the final output color that you will see on your
                  // screen for the pixel that is currently being processed.


// reused from 5600
vec3 random3D( vec3 p ) {
    return fract(sin(vec3(dot(p, vec3(127.1f, 311.7f, 191.999f)),
                                         dot(p, vec3(269.5f, 183.3f, 773.2f)),
                                         dot(p, vec3(103.37f, 217.83f, 523.7f)))) * 43758.5453f);
}

void main()
{
    // Material base color (before shading)
        vec4 diffuseColor = u_Color;

        // Calculate the diffuse term for Lambert shading
        float diffuseTerm = dot(normalize(fs_Nor), normalize(fs_LightVec));
        // Avoid negative lighting values
        // diffuseTerm = clamp(diffuseTerm, 0, 1);

        float ambientTerm = 0.2;

        float lightIntensity = diffuseTerm + ambientTerm;   //Add a small float value to the color multiplier
                                                            //to simulate ambient lighting. This ensures that faces that are not
                                                            //lit by our point light are not completely black.

        // Compute final shaded color
        // diffuseColor = vec4(sin(gl_FragCoord.xyz), 1);
        // diffuseColor = vec4(sin(fs_Pos.xyz), 1);
        diffuseColor = vec4(random3D(floor(fs_Pos.xyz * 10.f)), 1.f);
        // diffuseColor = vec4(random3D(gl_FragCoord.xyz), 1);
        out_Col = vec4(diffuseColor.rgb * lightIntensity, diffuseColor.a);
}
