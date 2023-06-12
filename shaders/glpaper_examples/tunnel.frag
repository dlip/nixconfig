#extension GL_OES_standard_derivatives : enable

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI  = 3.141592653589793;
const float PI2 = PI* 2.;

#define saturate(x) clamp(x,0.,1.)

float tri(float x){return abs(2.*fract(x*.5-.25)-1.)*2.-1.;}
float sqr(float x){return -2.*(step(.5,fract(x*.5))-.5);}
float circuit(float x){return clamp(tri(x*4.)*.25,(sqr(x)-1.)*.5,(sqr(x+.5)+1.)*.5);}
float circuit2(float x){return clamp(tri(x*.5)*.5,0.,.25);}
float flow(float x,float d){return (1.+sin(x+d*time*5.+3.))*.3+.3;}
vec2 pp(vec2 p){float r=.5/p.y;return vec2(p.x*r, r);}


void main(void){
 float t=floor(time * 0.8 *30.)/15.;
 vec2 p = ( gl_FragCoord.xy -  resolution.xy*.5 ) / resolution.x;
 vec2 p2 = p;
 vec3 color;
 vec3 light_color = vec3(1,0.6,1.0);
 float k = mix(fract(-p.y), 1.0, step(0., -p.y));
 if (p.y > 10.0) {
 } else {
     float l=0.,d=sign(p.y);
     vec2 r = p;
     vec2 q = p;
     q=pp(q);
     float n = floor(q.x/.5);
     q.x=mod(q.x,.5)-.25;
     p=pp(p);
     l+=step(abs(q.x+circuit(q.y+sign(p.y)*t+n)),.005);
     l+=pow(.001/abs(p.x+circuit(p.y+d*t)),flow(p.y,d));
     l+=pow(.001/abs(p.x+.75+circuit2(p.y+d*t)),(1.+sin(p.y+d*time*5.))*.3+.3);
     l+=pow(.001/abs(p.x-.75+circuit2(p.y+d*t)),(1.+sin(p.y+d*time*5.))*.3+.3);
     l=saturate(l);
     l*=abs(r.y*2.);
     l*=abs(sin(r.y*200.+sign(p.y)*time*5.))*.5+.5;
     l+=pow(.001/abs(p.x+circuit(p.x+d*time)),(1.+sin(p.x+d*time*5.+3.))*.3+.3);
     //l+=pow(.001/abs(p.x+circuit(p.x+d*time + 0.3)),(1.+sin(p.x+d*time*5.+3.))*.3+.3);
     color = vec3(l) - vec3(.2, .4, 0.);
     color *= k;
 }
 
 	float angle = atan(p2.y,p2.x)/(2.*3.14159265359);
	angle -= floor(angle);
	float rad = length(p2);
	
	float c = 0.1;
	float brightness = 0.012;
	float speed = 0.8;
	
	for (int i = 0; i < 1; ++i){
	float angleRnd = floor(angle*14.)+1.;
    float angleRnd1 = fract(angleRnd*fract(angleRnd*.7235)*45.1);
    float angleRnd2 = fract(angleRnd*fract(angleRnd*.82657)*13.724);
    float t = t*speed + angleRnd1*10.;
    float radDist = sqrt(angleRnd2+float(i));
    
    float adist = radDist/rad*.1;
    float dist = (t*.1+adist);
    dist = abs(fract(dist)-.5);
    c +=  (1.0 / (dist))*cos(0.7*(sin(t)))*adist/radDist * brightness;
    }
    angle = fract(angle+.161);

 gl_FragColor = vec4(color + vec3(c) * light_color, 1.0);
}
