/**
 * More experimentation with tiling.
 */

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265358979323846
#define TWO_PI 6.283185307179586

vec2 tile(vec2 _st, float _zoom){
    _st *= _zoom;
    return fract(_st);
}

float rectangle(in vec2 st, in vec2 centre, in vec2 dimensions, float bloom) {
    // bottom-left
    vec2 bl = smoothstep(
        vec2(centre - dimensions / 2.0 - bloom), 
        vec2(centre - dimensions / 2.0), 
        st);
    float pct = bl.x * bl.y;

    // top-right 
    vec2 tr = smoothstep(
        vec2(1.0 - centre - dimensions / 2. - bloom),
        vec2(1.0 - centre - dimensions / 2.),
         1.0 - st);
    pct *= tr.x * tr.y;

    return pct;
}

vec3 drips(in vec2 st, in float row, in float col, in float time, in float zoom) {
    float m = sin(row * 2.345); 
    const float n = 35.0;
    vec3 color = vec3(0.0);

    for(int i = 0; i <= int(n); i++) {
        float width = .01 / n; 
        float offset = (sin(time + (sin((col) + time + m) * sin(time / 10.) * 5.) + (TWO_PI * float(i) / n)) + (0.8 + (sin(time + row + col) + 1.0) / 6.0)) / 2.2;
        float rect = rectangle(st, vec2(0.5, (1.0 / n ) * float(i)), vec2(offset, width), 0.031);
        color.r += rect / (col + 1.4);
        color.b += rect / (zoom / col);
        color.g += rect * (sin(row + time / 10.0) + 1.0) / 2.0;
    }

    return color;
}

void main(void){
    float time = iGlobalTime * 1.335;
    vec2 st = gl_FragCoord.xy/iResolution.xy;
    const float zoom = 5.0; 
    float col = (st.x * zoom); 
    float row = (st.y * zoom);
    
    st = tile(st, zoom);
    vec3 color = drips(st, row, col, time, zoom); 
    
    gl_FragColor = vec4(vec3(color), 1.0);
}