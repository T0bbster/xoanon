module xoanon.core.Time;

class GameTime
{
	private static int muPerFrame;
	private static ulong totalmus;
	private static real _speed = 100;
	
	public static void speed(real factor)
	{
		_speed = factor;
	}
	
	public static real factor()
	{
		return muPerFrame / (1000.0 * _speed);
	}
	
	public static int microsecondsPerFrame()
	{
		return muPerFrame;
	}
	
	public static ulong totalMicroseconds()
	{
		return totalmus; 
	}
	
	public static void update(ulong perFrame, ulong total)
	{
		muPerFrame = perFrame;
		totalmus = total;
	}
}