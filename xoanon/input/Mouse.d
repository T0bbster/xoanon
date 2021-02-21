module xoanon.input.Mouse;

import xoanon.core.math.Vector;
import derelict.sdl.sdlfuncs;
import derelict.sdl.sdltypes;

enum ButtonState
{
	Pressed,
	Released
}

package alias Vector!(int, 2) Vector2i;

struct MouseState
{
	Vector2i position;
	Vector2i motion;
	ButtonState left, right, middle;
	float wheel = 0f;
}

static class Mouse
{
	static MouseState mouseState;
	
	public static MouseState getState()
	{
		return mouseState;
	}
	
	public static void move(Vector2i position)
	{
		SDL_WarpMouse(position.x, position.y);
	}
	
	///TODO mouse wheel
	public static void update(SDL_Event event)
	{
		switch(event.type)
		{
			case SDL_MOUSEMOTION:
				mouseState.position = Vector2i(event.motion.x, event.motion.y);
				mouseState.motion = Vector2i(event.motion.xrel, event.motion.yrel);
				break;
			case SDL_MOUSEBUTTONDOWN:
				switch(event.button.button)
				{
					case SDL_BUTTON_LEFT:
						mouseState.left = ButtonState.Pressed;
						break;
					case SDL_BUTTON_RIGHT:
						mouseState.right = ButtonState.Pressed;
						break;
					case SDL_BUTTON_MIDDLE:
						mouseState.middle = ButtonState.Pressed;
						break;
					default:
						break;
				}
				break;
			case SDL_MOUSEBUTTONUP:
				switch(event.button.button)
				{
					case SDL_BUTTON_LEFT:
						mouseState.left = ButtonState.Released;
						break;
					case SDL_BUTTON_RIGHT:
						mouseState.right = ButtonState.Released;
						break;
					case SDL_BUTTON_MIDDLE:
						mouseState.middle = ButtonState.Released;
						break;
					default:
						break;
				}
				break;
			default:
				break;
		}
	}
}