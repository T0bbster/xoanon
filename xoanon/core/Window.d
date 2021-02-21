module xoanon.core.Window;

import tango.stdc.stringz;
import derelict.sdl.sdlfuncs;
import derelict.sdl.sdltypes;

/**
 * A window.
 */
class Window
{
	private
	{
		uint _width = 1, _height = 1;
		bool _fullScreen;
		char[] _text;
		const int bitPerPixel = 32;
		int videoFlag = SDL_DOUBLEBUF | SDL_HWPALETTE | SDL_HWSURFACE | SDL_OPENGL;
	}
	/**
	 * Returns: The width of the window.
	 */
	public int width() 
	{
		return this._width;
	}
	
	/**
	 * Returns: The height of the window.
	 */
	public int height() 
	{ 
		return this._height;
	}
	
	/**
	 * Construct a new Window. 
	 * Params:
	 *     width = The width. Must be greater than 0.
	 *     height = The height. Must be greater than 0.
	 *     fullScreen = 
	 *     text = The text displayed on the window.
	 */
	this(uint width, uint height, char[] text, bool fullScreen, bool resizable)
	{
		this._width = width;
		this._height = height;
		this._fullScreen = fullScreen; 
		this._text = text;
		
	    SDL_WM_SetCaption(toStringz(text), null);	//Setze Titel.
	    
	    if (fullScreen)
	    	this.videoFlag |= SDL_FULLSCREEN;
	    if (resizable)
	    	this.videoFlag |= SDL_RESIZABLE;
	    
	    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
	    
	    this.create();
	}
	
	/**
	 * Creates the window.
	 */
	public void create()
	{
	    SDL_SetVideoMode(_width, _height, bitPerPixel, videoFlag);
	}
	/**
	 * Resizes the window.
	 * Params:
	 *     newWidth = The new width of the window. Must be greater than 0.
	 *     newHeight = The new height of the window. Must be greater than 0.
	 */
	public void resize(int newWidth, int newHeight)
	in
	{
		assert(newWidth > 0);
		assert(newHeight > 0);
	}
	body
	{
		this._width = newWidth;
		this._height = newHeight;
		this.create();
	}
}