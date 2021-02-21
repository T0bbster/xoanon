module graphics.hardware.MultiSampling;

import xoanon.core.math.Vector;
import xoanon.system.graphics.hardware.gl.GL3;

struct MultiSampling 
{
	private bool enabled = false;
	public void enable()
	{
		glEnable(GL_MULTISAMPLE);
		enabled = true;
	}
	
	public void disable() 
	{
		glDisable(GL_MULTISAMPLE);
		enabled = false;
	}

	public bool isEnabled() 
	{
		return enabled;
	}

	public Vector!(float, 2) getSamplePosition(uint index)
	{
		float[] val;
		glGetMultisamplefv(GL_SAMPLE_POSITION, index, val.ptr);
		return Vector!(float, 2)(val[0], val[1]);
	}

	//TODO
  public void SampleMask() {
  }

  public void SampleCoverage() {
  }

}
