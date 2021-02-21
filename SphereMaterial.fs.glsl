varying vec4 NormalOut;
varying vec4 ColorOut;

void main()
{
	vec4 nn = NormalOut + NormalOut * 0.2;
	gl_FragColor = nn + ColorOut * 0.5;
}