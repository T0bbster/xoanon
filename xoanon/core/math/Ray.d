module xoanon.core.math.Ray;

struct Ray(T, t)
{
	alias Vector!(T, t) vector;
	
	vector position;
	vector direction;
}