/*
 * A collection of potentially-reusable functions I am collecting while learning
 * GLSL and fragment shaders.
 */

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718

// Function for drawing a rectangle
float rectangle(in vec2 st, in vec2 origin, in vec2 dimensions) {
    // bottom-left
    vec2 bl = step(origin, st);
    float pct = bl.x * bl.y;

    // top-right 
    vec2 tr = step(1.0 - origin - dimensions, 1.0 - st);
    pct *= tr.x * tr.y;

    return pct;
}

// Draws a hollow rectangle with the given borderWidth
float rectangleOutline(in vec2 st, in vec2 origin, in vec2 dimensions, in float borderWidth) {
    float pct = rectangle(st, origin, dimensions);
    float inverse = 1.0 - rectangle(st, origin + borderWidth, dimensions - borderWidth * 2.0);

    return pct * inverse;
}

// Draws a circle with a feathered edge
float circle(in vec2 st, in vec2 center, in float radius, in float feather) {
    float pct = smoothstep(radius, radius - feather, distance(st, center));
    return pct;
}

// Draws an n-sided polygon
float polygon(vec2 st, int vertices) {
  // Angle and radius from the current pixel
  float a = atan(st.x,st.y)+PI;
  float r = TWO_PI/float(vertices);
  
  // Shaping function that modulate the distance
  return cos(floor(.5+a/r)*r-a)*length(st);
}

// Create a repeating pattern
vec2 tile(vec2 st, int cols, int rows) {
    return fract(st * vec2(float(cols), float(rows)));
}

void main(){
    vec2 st = gl_FragCoord.xy/iResolution.xy;
    st -= 0.5;
    st *= 2.0;
    st = tile(st, 2, 2);
    st -= 0.5;
    st *= mat2(1.5, 0.0, 0.0, 1.5);
    float color = step(0.5, polygon(st, 5));

    gl_FragColor = vec4(vec3(color),1.0);
}
