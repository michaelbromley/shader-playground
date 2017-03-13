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

float rectangle(in vec2 st, in vec2 centre, in vec2 dimensions) {
    // bottom-left
    vec2 bl = step(vec2(centre.x - dimensions.x / 2., centre.y - dimensions.y / 2.), st);
    float pct = bl.x * bl.y;

    // top-right 
    vec2 tr = step(
        vec2(1.0 - centre.x - dimensions.x / 2., 1.0 - centre.y - dimensions.y / 2.),
         1.0 - st);
    pct *= tr.x * tr.y;

    return pct;
}

void main(void){
    float time = iGlobalTime * 4.0;
    vec2 st = gl_FragCoord.xy/iResolution.xy;
    const float zoom = 5.0;
    float col = floor(st.x * zoom); 
    float row = (st.y * zoom);
    
    st = tile(st, zoom);

    float m = sin(row);
    const float n = 20.0;
    vec3 color = vec3(0.0);
    for(int i = 0; i <= int(n); i++) {
        float width = .4 / n;
        float offset = (sin(time + (sin(col + time + m)) + (TWO_PI * float(i) / n)) + 1.1) / 2.2;
        float rect = rectangle(st, vec2(0.5, (1.0 / n ) * float(i)), vec2(offset, width));
        color.r += rect / (col + 1.4);
        color.b += rect / (zoom / col);
        color.g += rect * (sin(row + time / 10.0) + 1.0) / 3.0;
    }
    
    gl_FragColor = vec4(vec3(color), 1.0);
}