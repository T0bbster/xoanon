module xoanon.scene.Controller;

import xoanon.scene.Scene;

template ControllerMixin(T)
{
	public HashSet!(SceneNode) nodes;
	
	override void addNode(SceneNode node)
	{
		nodes.add(node);
	}
	
	override void removeNode(SceneNode node)
	{
		nodes.remove(node);
	}
}

interface IController
{
	void addNode(SceneNode node);
	void removeNode(SceneNode node);
	void process();
}