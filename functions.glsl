/*
 * A collection of potentially-reusable functions I am collecting while learning
 * GLSL and fragment shaders.
 */

#ifdef GL_ES
precision mediump float;
#endif

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

void main(){
    vec2 st = gl_FragCoord.xy/iResolution.xy;
    float color = circle(st, vec2(0.5), 0.4, 0.1);

    gl_FragColor = vec4(vec3(color),1.0);
}
