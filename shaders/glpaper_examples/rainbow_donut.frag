#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main()
{
    vec2 r = resolution,
    o = gl_FragCoord.xy - r/2.;
    o = vec2(length(o) / r.y - .35, atan(o.y,o.x));    
    vec4 s = .1*cos(1.6*vec4(0,1,2,3) + time + o.y + asin(sin(o.x)) * sin(time)*10.);
    vec4 e = s.yzwx;
    vec4 f = min(o.x-s,e-o.x);
    gl_FragColor = dot(clamp(f*r.y,0.,1.), 80.*(s-e)) * (s-.1) - f;
}
