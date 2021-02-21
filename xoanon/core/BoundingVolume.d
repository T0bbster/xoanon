module xoanon.system.BoundingVolume;

enum IntersectionState
{
	In,
	Out,
	Intersects,
	Around
}

interface IBoundingVolume
{
	IntersectionState intersects(IBoundingVolume other);
}