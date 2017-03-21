package com;

import java.util.Timer;
import java.util.TimerTask;

import fiberwire.dwr.FiberWireDwr;

public class StopTask extends TimerTask {

	private FiberWireDwr _fiber;
	private Timer _timer;
	public StopTask(FiberWireDwr fiberWireDwr,Timer tm) {
		// TODO Auto-generated constructor stub
		_fiber = fiberWireDwr;
		_timer = tm;
	}
	@Override
	public void run() {
		// TODO Auto-generated method stub
		_fiber._nodeCount = 0;
		_timer.cancel();
	}

}
