/**
 * A tartan-inspired pattern, an exercise from https://thebookofshaders.com/09/
 */

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265358979323846

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

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

void main(void){
    float time = iGlobalTime * .5;
     float osc1 = smoothstep(0.3, 0.7, (sin(time) + 1.0) / 2.0);
    float osc2 = smoothstep(0.5, 0.6, (sin(time * 2.) + 1.0) / 2.0);
    
    vec2 st = gl_FragCoord.xy/iResolution.xy;
    vec3 color = vec3(0.54, 0.13, 0.13);
    float zoom = 4.0 * (1.0 + osc1 + osc2);
    float col = floor(st.x * zoom);
    float row = floor(st.y * zoom);
    st = tile(st, zoom);
    
    vec2 trans = vec2(0.5, 0.5);
    st -= trans;
    st -= vec2(0.21, 0.);    
    st *= rotate2d((floor(time) + smoothstep(0.9, 1.0, (sin(time) + 1.0) / 2.0)) * PI / 4.0);
    //st *= rotate2d(PI / 4.0); 
    st += trans;

    const float lighten = 4.5;
    // thick black lines
    color -= vec3(box(st, vec2(0.2, 2.0), 0.01)) / lighten * osc2;
    color -= vec3(box(st + vec2(0.3, 0.0), vec2(0.2, 2.0), 0.01)) / lighten * osc2;
    color -= vec3(box(st, vec2(2.0, 0.2), 0.01)) / lighten * (1.0 - osc1);
    color -= vec3(box(st + vec2(0.0, 0.3), vec2(2.0, 0.2), 0.01)) / lighten * (1.0 - osc1);

    // thin light lines
    color += vec3(box(st + vec2(0.3, 0.0), vec2(0.01, 2.0), 0.01)) / 1.5 * osc1;
    color += vec3(box(st + vec2(0.0, 0.0), vec2(0.01, 2.0), 0.01)) / 1.5;
    color += vec3(box(st + vec2(0.0, 0.3), vec2(2.0, 0.01), 0.01)) / 1.5;
    color += vec3(box(st + vec2(0.0, 0.0), vec2(2.0, 0.01), 0.01)) / 1.5;

    // thin highlights
    color.rg += vec2(box(st + vec2(0.33, 0.0), vec2(0.01, 2.0), 0.01)) / 2.5;
    color.rg += vec2(box(st + vec2(-0.03, 0.0), vec2(0.01, 2.0), 0.01)) / 2.5;
    color.rg += vec2(box(st + vec2(0.0, -0.03), vec2(2.0, 0.01), 0.01)) / 2.5 * osc1;
    color.rg += vec2(box(st + vec2(0.0, 0.33), vec2(2.0, 0.01), 0.01)) / 2.5 * osc1;
    
    // thin vertical lines
    color -= vec3(box(st + vec2(-0.25, 0.0), vec2(0.02, 2.0), 0.01)) / lighten;
    color -= vec3(box(st + vec2(0.457, 0.0), vec2(0.02, 2.0), 0.01)) / lighten;
    color += vec3(box(st + vec2(-0.18, 0.0), vec2(0.02, 2.0), 0.01)) / 2.5 * (1.0 - osc1);
    color += vec3(box(st + vec2(0.527, 0.0), vec2(0.02, 2.0), 0.01)) / 2.5 * (1.0 - osc1);
    // thin horizontal lines
    color -= vec3(box(st + vec2(0.0, -0.25), vec2(2.0, 0.02), 0.01)) / lighten;
    color -= vec3(box(st + vec2(0.0, 0.457), vec2(2.0, 0.02), 0.01)) / lighten;
    color += vec3(box(st + vec2(0.0, -0.18), vec2(2.0, 0.02), 0.01)) / 2.5 * (1.0 - osc1);
    color += vec3(box(st + vec2(0.0, 0.527), vec2(2.0, 0.02), 0.01)) / 2.5 * (1.0 - osc1);
    
    gl_FragColor = vec4(color,1.0);
}