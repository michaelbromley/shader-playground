/**
 * Experiment with circles, based on excercise from second part of
 * https://thebookofshaders.com/07/
 */

#ifdef GL_ES
precision mediump float;
#endif

float circle(in vec2 st, in vec2 center, in float radius, in float feather) {
    float pct = smoothstep(radius, radius - feather, distance(st, center));
    return pct;
}

float radius(float rate) {
    return (sin(iGlobalTime * rate / 3.0) + 1.0) / 10.0 + 0.3;
}

vec2 center(float radius, float r1, float r2) {
     vec2 center = vec2(0.5);
    center.y += sin((iGlobalTime / 10.0) * r1) / r2;
    center.x += cos((iGlobalTime / 10.0) * r2) / r2;
    return center;
}

void main(){
	vec2 st = gl_FragCoord.xy/iResolution.xy;    
    vec3 color = vec3(0.0);
    color.bg += circle(st, center(radius(3.2), 5.0, 3.0), radius(3.0), 0.05)
    - circle(st, 1.0 - center(radius(2.0), 12.0, 5.0), radius(2.0), 0.1);
    color.b  += circle(st, center(radius(1.45), 7.0, 6.0), radius(1.5), 0.1);

	gl_FragColor = vec4( color, 1.0 );
}