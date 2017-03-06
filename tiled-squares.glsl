/**
 * Experimenting with tiles and matrix transforms
 */

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265358979323846

vec2 rotate2D(vec2 _st, float _angle){
    _st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    _st += 0.5;
    return _st;
}

vec2 tile(vec2 _st, float _zoom){
    _st *= _zoom;
    return fract(_st);
}

float box(vec2 _st, vec2 _size, float _smoothEdges){
    _size = vec2(0.5)-_size*0.5;
    vec2 aa = vec2(_smoothEdges*0.5);
    vec2 uv = smoothstep(_size,_size+aa,_st);
    uv *= smoothstep(_size,_size+aa,vec2(1.0)-_st);
    return uv.x*uv.y;
}

void main(void){
    vec2 st = gl_FragCoord.xy/iResolution.xy;
    vec3 color = vec3(0.0);
    const float zoom = 8.0;
    float col = floor(st.x * zoom);
    float row = floor(st.y * zoom);

    st = tile(st, zoom);
    st = rotate2D(st, (iGlobalTime) + (row + sin(iGlobalTime / 3.1) * col + cos(iGlobalTime / 1.7)));
    
    st = vec3(vec3(st, 1.0) * mat3(
        1.0 + (sin(iGlobalTime) + 1.0) / 2.0, 
        0.0, 
        0.0, 
        0.0,
        1.0 + (sin(iGlobalTime * 0.87) + 1.0) / 2.0,
        0.0,
        0.0,
        0.0,
        1.0 + (sin(iGlobalTime * 0.7) + 1.0) / 2.0
    )).xy;

    st = rotate2D(st, -iGlobalTime * 1.345);

    // Draw a square
    color.b = box(st,vec2(0.5),0.02) / (col + 1.0 / zoom);
    color.r = box(st,vec2(0.5),0.02) / (sin(row / 1.3) + 1.0);
    color.g = box(st,vec2(0.5),0.01) / (sin(col / 1.3) + 1.0) / 6.0;

    gl_FragColor = vec4(color,1.0);
}