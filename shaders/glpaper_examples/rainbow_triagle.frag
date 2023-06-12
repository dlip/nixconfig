#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main()
{

    	
	
    vec2 r = resolution,o = gl_FragCoord.xy - r / 2.00;
	
    o = vec2(max(abs(o.x) * 0.8996 + o.y * 0.5, -o.y) * 2.0 / r.y - 0.25, atan(o.y,o.x));    
    vec4 s = 0.07 * sin(1.5 * vec4(1,2,3,4) + 2.0 * time / 90.0 + o.y + sin(time) * 1.75),
    
    e = s.yzwx, 
    f = max(o.x - s-0.1, e-o.x);
    
    
    gl_FragColor = dot(clamp(f*r.y,0.,1.), 82.*(s-e)) * (s-.1)*1.5 ;
}
