module xoanon.core.Application;

import tango.time.StopWatch;
import xoanon.system.graphics.hardware.gl.GL3;
import xoanon.input.Keyboard;
import xoanon.input.Mouse;
import derelict.devil.ilfuncs;
import derelict.devil.ilufuncs;
import derelict.devil.ilutfuncs;
import derelict.devil.iluttypes;
import derelict.sdl.sdlfuncs;
import derelict.sdl.sdltypes;
import xoanon.core.Time;
import xoanon.core.Window;

class Application
{
	private Window _window;
	
	public final Window window()
	{
		return this._window;
	}
	
	public this(uint width, uint height, char[] windowText, bool fullscreen, bool resizable)
	{
		init;
		this._window = new Window(width, height, windowText, fullscreen, resizable);
		//!
		LoadExtensions(); //wichtig!!!
		//!
	}
	
	private void init()
	{
		DerelictSDL.load();
		OpenGL3.load();
		
		SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER);
		
		DerelictIL.load();
		DerelictILU.load();
		DerelictILUT.load();
		
		ilInit();
		iluInit();
		ilutInit();
		ilutRenderer(ILUT_OPENGL);
	}
	
	private void quit()
	{
		SDL_Quit();
		
		//DerelictGLU.unload();
		OpenGL3.unload();
	    DerelictSDL.unload();
	    
	    DerelictILUT.unload();
	    DerelictILU.unload();
	    DerelictIL.unload();
	}
	
	abstract void initialize();
	abstract void close();
	abstract void update();
	abstract void render();
	
	public final void run()
	{
		initialize();
		
		StopWatch watch, total;
		
		bool running = true;
		SDL_Event event;
		total.start();
		while(running)
		{
			watch.start;
			while(SDL_PollEvent(&event))
			{
				Keyboard.update(event);
				Mouse.update(event);
				
				switch(event.type)
				{
					case SDL_QUIT:
						running = false;
						break;
					default:
						break;
				}
			}
			update();
			render();
			GameTime.update(watch.microsec(), total.microsec());
		}
		
		close();
		quit();
	}
}