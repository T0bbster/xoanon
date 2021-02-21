module graphics.hardware.SyncObject;

import base.GL3types;
import base.GL3functions;

enum SyncStatus
{
	AlreadySignaled 	= GL_ALREADY_SIGNALED,
	TimeoutExpired		= GL_TIMEOUT_EXPIRED,
	ConditionSatisfied 	= GL_CONDITION_SATISFIED 
}

class SyncObject
{
	private uint object;
	
	public this()
	{
		this.object = glFenceSync(GL_SYNC_GPU_COMMANDS_COMPLETE, 0);
	}
	
	~this()
	{
		glDeleteSync(this.object);
	}
	
	public SyncStatus clientWait(ulong nanoseconds)
	{
		return cast(SyncStatus) glClientWaitSync(this.object, GL_SYNC_FLUSH_COMMANDS_BIT, nanoseconds);
	}
	
	public void wait()
	{
		glWaitSync(this.object, 0, GL_TIMEOUT_IGNORED);
	}
}
