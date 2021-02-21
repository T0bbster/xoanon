module xoanon.input.Keyboard;

import derelict.sdl.sdltypes;
import tango.util.container.HashMap;

enum Key
{
	Unknown        = 0,
    First      = 0,
    Backspace      = 8,
    Tab        = 9,
    Clear      = 12,
    Return     = 13,
    Pause      = 19,
    Escape     = 27,
    Space      = 32,
    Exclaim        = 33,
    Quotedbl       = 34,
    Hash       = 35,
    Dollar     = 36,
    Ampersand      = 38,
    Quote      = 39,
    Leftparen      = 40,
    Rightparen     = 41,
    Asterisk       = 42,
    Plus       = 43,
    Comma      = 44,
    Minus      = 45,
    Period     = 46,
    Slash      = 47,
    _0          = 48,
    _1          = 49,
    _2          = 50,
    _3          = 51,
    _4          = 52,
    _5          = 53,
    _6          = 54,
    _7          = 55,
    _8          = 56,
    _9          = 57,
    Colon      = 58,
    Semicolon      = 59,
    Less       = 60,
    Equals     = 61,
    Greater        = 62,
    Question       = 63,
    At         = 64,
    /*
       Skip uppercase letters
     */
    Leftbracket    = 91,
    Backslash      = 92,
    Rightbracket   = 93,
    Caret      = 94,
    Underscore     = 95,
    Backquote      = 96,
    a          = 97,
    b          = 98,
    c          = 99,
    d          = 100,
    e          = 101,
    f          = 102,
    g          = 103,
    h          = 104,
    i          = 105,
    j          = 106,
    k          = 107,
    l          = 108,
    m          = 109,
    n          = 110,
    o          = 111,
    p          = 112,
    q          = 113,
    r          = 114,
    s          = 115,
    t          = 116,
    u          = 117,
    v          = 118,
    w          = 119,
    x          = 120,
    y          = 121,
    z          = 122,
    Delete     = 127,
    /* End of ASCII mapped keysyms */

    /* International keyboard syms */
    World_0        = 160,      /* 0xa0 */
    World_1        = 161,
    World_2        = 162,
    World_3        = 163,
    World_4        = 164,
    World_5        = 165,
    World_6        = 166,
    World_7        = 167,
    World_8        = 168,
    World_9        = 169,
    World_10       = 170,
    World_11       = 171,
    World_12       = 172,
    World_13       = 173,
    World_14       = 174,
    World_15       = 175,
    World_16       = 176,
    World_17       = 177,
    World_18       = 178,
    World_19       = 179,
    World_20       = 180,
    World_21       = 181,
    World_22       = 182,
    World_23       = 183,
    World_24       = 184,
    World_25       = 185,
    World_26       = 186,
    World_27       = 187,
    World_28       = 188,
    World_29       = 189,
    World_30       = 190,
    World_31       = 191,
    World_32       = 192,
    World_33       = 193,
    World_34       = 194,
    World_35       = 195,
    World_36       = 196,
    World_37       = 197,
    World_38       = 198,
    World_39       = 199,
    World_40       = 200,
    World_41       = 201,
    World_42       = 202,
    World_43       = 203,
    World_44       = 204,
    World_45       = 205,
    World_46       = 206,
    World_47       = 207,
    World_48       = 208,
    World_49       = 209,
    World_50       = 210,
    World_51       = 211,
    World_52       = 212,
    World_53       = 213,
    World_54       = 214,
    World_55       = 215,
    World_56       = 216,
    World_57       = 217,
    World_58       = 218,
    World_59       = 219,
    World_60       = 220,
    World_61       = 221,
    World_62       = 222,
    World_63       = 223,
    World_64       = 224,
    World_65       = 225,
    World_66       = 226,
    World_67       = 227,
    World_68       = 228,
    World_69       = 229,
    World_70       = 230,
    World_71       = 231,
    World_72       = 232,
    World_73       = 233,
    World_74       = 234,
    World_75       = 235,
    World_76       = 236,
    World_77       = 237,
    World_78       = 238,
    World_79       = 239,
    World_80       = 240,
    World_81       = 241,
    World_82       = 242,
    World_83       = 243,
    World_84       = 244,
    World_85       = 245,
    World_86       = 246,
    World_87       = 247,
    World_88       = 248,
    World_89       = 249,
    World_90       = 250,
    World_91       = 251,
    World_92       = 252,
    World_93       = 253,
    World_94       = 254,
    World_95       = 255,      /* 0xff */

    /* Numeric keypad */
    KP0        = 256,
    KP1        = 257,
    KP2        = 258,
    KP3        = 259,
    KP4        = 260,
    KP5        = 261,
    KP6        = 262,
    KP7        = 263,
    KP8        = 264,
    KP9        = 265,
    KP_period      = 266,
    KP_divide      = 267,
    KP_multiply    = 268,
    KP_minus       = 269,
    KP_plus        = 270,
    KP_enter       = 271,
    KP_equals      = 272,

    /* Arrows + Home/End pad */
    Up         = 273,
    Down       = 274,
    Right      = 275,
    Left       = 276,
    Insert     = 277,
    Home       = 278,
    End        = 279,
    Pageup     = 280,
    Pagedown       = 281,

    /* Function keys */
    F1         = 282,
    F2         = 283,
    F3         = 284,
    F4         = 285,
    F5         = 286,
    F6         = 287,
    F7         = 288,
    F8         = 289,
    F9         = 290,
    F10        = 291,
    F11        = 292,
    F12        = 293,
    F13        = 294,
    F14        = 295,
    F15        = 296,

    /* Key state modifier keys */
    Numlock        = 300,
    Capslock       = 301,
    Scrollock      = 302,
    Rshift     = 303,
    Lshift     = 304,
    Rctrl      = 305,
    Lctrl      = 306,
    Ralt       = 307,
    Lalt       = 308,
    Rmeta      = 309,
    Lmeta      = 310,
    Lsuper     = 311,      /* left "windows" key */
    Rsuper     = 312,      /* right "windows" key */
    Mode       = 313,      /* "alt gr" key */
    Compose        = 314,      /* multi-key compose key */

    /* Miscellaneous function keys */
    Help       = 315,
    Print      = 316,
    Sysreq     = 317,
    Break      = 318,
    Menu       = 319,
    Power      = 320,      /* power macintosh power key */
    Euro       = 321,      /* some european keyboards */
    Undo       = 322,      /* atari keyboard has undo */

    /* Add any other keys here */

    Last
}

enum KeyState : ubyte
{
	Up,
	Down
}

struct KeyboardState
{
	HashMap!(Key, KeyState) keys;
	
	public bool isKeyDown(Key key)
	{
		if(keys.containsKey(key))
			if(keys[key] == KeyState.Down)
				return true;
		return false;
	}
	
	public bool isKeyUp(Key key)
	{
		if(keys.containsKey(key))
			if(keys[key] == KeyState.Up)
				return true;
		return false;
	}
}

static class Keyboard
{
	private static KeyboardState keyboardState;
	
	private static this()
	{
		keyboardState.keys = new HashMap!(Key, KeyState);
	}
	
	public static KeyboardState getState()
	{
		return keyboardState;
	}
	
	public static void update(SDL_Event event)
	{
		switch(event.type)
		{
			case SDL_KEYDOWN:
				auto temp = cast(Key) event.key.keysym.sym;
				keyboardState.keys[temp] = KeyState.Down;
			break;
			case SDL_KEYUP:
				auto temp = cast(Key) event.key.keysym.sym;
				keyboardState.keys[temp] = KeyState.Up;
			break;
			default:
				break;
		}
	}
}