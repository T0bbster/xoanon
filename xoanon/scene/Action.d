module xoanon.scene.Action;

import tango.util.container.HashSet;
import xoanon.scene.Entity;

abstract class Action
{
	public Entity user;
	public Entity target;
	public HashSet!(Entity) targets;
	abstract void process();
}