module graphics.hardware.GraphicsApplication;


import tango.sys.win32.Types;
import tango.sys.win32.UserGdi;
import base.GL3;

import base.GL3;
import base.SDL_Window;
import derelict.util.exception;
import tango.io.Console;
import tango.io.Stdout;
import derelict.sdl.sdl;

/**
 * Base class for the lessons.
 */
class GraphicsApplication
{
	///The aspect ratio of the window.
	protected const float aspectRatio;
	///The window.
	protected SDL_Window window;
	
	/**
	 * Constructs a new GraphicsContext.
	 * Params:
	 *     width = The width. Must be greater than 0.
	 *     height = The height. Must be greater than 0.
	 *     windowText = The text displayed on the window.
	 *     fullScreen = If the lesson should run in fullscreen mode.
	 *     resizable = If the lesson should be resizable.
	 */
	this(int width, int height, char[] windowText, bool fullScreen = false, bool resizable = false)
	{
		this.window = new SDL_Window(width, height, windowText, fullScreen, resizable);
		this.aspectRatio = cast(float) width / cast(float) height;
		glViewport(0, 0, this.window.Width(), this.window.Width());
		
	}
	
	public this()
	{
		this(800, 800, "GraphicsContext", false, false);
	}
	
	/**
	 * Creates the lesson.
	 */
	public final void CreateContext()
	{
		resize(this.window.Width, this.window.Height);
	}
	
	/// Runs the lesson.
	public final void Run()
	{
		this.CreateContext();
		LoadExtensions();
		
		this.Initialize();
		bool running = true;
		
		while(running)
		{
			running = this.Update();
			this.Draw();
		}
	}
	
	/**
	 * 
	 * Params:
	 *     newWidth = 
	 *     newHeight =
	 */
	private void resize(int newWidth, int newHeight)
	{
		this.window.Resize(newWidth, newHeight);
		glViewport(0, 0, this.window.Width, this.window.Height);
	}
	
	/**
	 * Initialize here all.
	 */
	public void Initialize()
	{
	    glClearColor (0.0f, 0.0f, 0.0f, 0.0f);						// Black Background
		glClearDepth (1.0f);										// Depth Buffer Setup
		glDepthFunc (GL_LEQUAL);									// The Type Of Depth Testing (Less Or Equal)
		glEnable (GL_DEPTH_TEST);									// Enable Depth Testing
	}
	
	/**
	 * Draw here all OpenGL frames.
	 */
	public void Draw()
	{
		SDL_GL_SwapBuffers();
	}
	
	/**
	 * Updates the lesson.
	 * Returns: $(D_KEYWORD true) if it should continue otherwise $(D_KEYWORD false).
	 */
	public bool Update()
	{
		SDL_Event event;
		bool result = true;
		while(SDL_PollEvent(&event))
		{
			switch(event.type)
			{
				case SDL_VIDEORESIZE:
					this.resize(event.resize.w, event.resize.h);
					break;
				case SDL_QUIT:
					result = false;
					break;
				default:
					break;
			}
		}
		return result;
	}
}