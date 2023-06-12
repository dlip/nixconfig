#ifdef GL_ES
precision mediump float;
#endif

//dashxdr
// showing the points while performing the mandelbrot function

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform sampler2D bb;

void main( void )
{

	float sum = 0.0;
	float size = .0025;
	vec2 tpos = gl_FragCoord.xy / resolution;
	float px,py;
	float scale = 1.0;
	float basex = -1.0;
	float basey = 0.0;
	float x = basex + (mouse.x-.5)*scale;
	float y = basey + (mouse.y-.5)*scale;
	float t;
	if(true) // change to false to control with mouse
	{
		t = time;
		float t1 = t;
		float scale1 = .3;
		float t2 = t *.61223;
		float scale2 = .5;
		x = basex + scale1*cos(t1) + scale2*cos(t2);
		y = basey + scale1*sin(t1) + scale2*sin(t2);
	}

	vec2 position = 2.0*(tpos + vec2(-0.75, -0.5));

#define NUM 30
	float u, v;
	u = v = .317;

	for(int j=0;j<4;++j)
	{
		px = py = 0.0;
		float x0, y0;
		x0 = x + u;
		y0 = y + v;
		for (int i=0; i < NUM; ++i) {
			t = (px*px-py*py)+x0;
			py = (2.0*px*py) + y0;
			px = t;
			float dist = length(vec2(px, py) - position);
			if(dist > .0001)
				sum += size/dist;
			else break;
		}
		t = u;
		u = -v;
		v = t;
	}

	float val = sum;

	vec3 color;
	color = vec3(val, val*0.66666, 0.0);
	tpos = .5 + 1.2 * (tpos - .5);
#define INDENT .02
	vec3 tcolor;
	if(tpos.x>INDENT && tpos.y>INDENT &&
		tpos.x < 1.0-INDENT && tpos.y < 1.0-INDENT)
		tcolor = .9*texture2D(bb, tpos).rgb;
	else tcolor = vec3(0.0);
	gl_FragColor = vec4(max(color,tcolor), 1.0);
}
