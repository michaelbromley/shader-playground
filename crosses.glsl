// Author @patriciogv ( patriciogonzalezvivo.com ) - 2015

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

float box(in vec2 _st, in vec2 _size){
    _size = vec2(0.5) - _size*0.5;
    vec2 uv = smoothstep(_size,
                        _size+vec2(0.02),
                        _st);
    uv *= smoothstep(_size,
                    _size+vec2(0.02),
                    vec2(1.0)-_st);
    return uv.x*uv.y;
}

float cross(in vec2 _st, float _size){
    return  box(_st, vec2(_size,_size/8.)) + 
            box(_st, vec2(_size/8.,_size));
}

float rotatingCross(vec2 st, float offset) {
    vec2 translate = vec2(sin(iGlobalTime / 4.0), cos(iGlobalTime / 2.0)) / ((log(offset) + .5) * 1.5);
    st -= vec2(0.5);
    st = rotate2d( iGlobalTime * offset / 15.0 * sin(log(iGlobalTime) * log(offset) / 4.0) ) * st;
    st += vec2(0.5);
    return cross(st + translate, log(offset) / 8.0) / 1.5;
}

void main(){
    vec2 st = gl_FragCoord.xy/iResolution.xy;
    vec3 color = vec3(0.0);
    const float n = 25.0;
    for(int i = 0; i <= int(n); i++) { 
        float val = rotatingCross(st, float(i + 1));
        float fi = float(i);
        color += vec3(val * (1.5 *n - fi) / n,  0.0, val * fi / n);
    }

    gl_FragColor = vec4(color, .1);
}