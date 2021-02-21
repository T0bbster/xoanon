module xoanon.scene.Entity;

import tango.util.container.HashSet;
import xoanon.scene.Action;
import xoanon.scene.Controller;
import xoanon.scene.Scene;
import tango.util.container.HashMap;

class Entity : IController
{
	public this()
	{
		this.states = new HashMap!(char[], State);
		this.actions = new HashMap!(char[], Action);
	}
	
	public HashMap!(char[], State) states;
	public HashMap!(char[], Action) actions;
	
	mixin ControllerMixin!();
	
	void process()
	{
		foreach(k, action; actions)
			action.process();
	}
}