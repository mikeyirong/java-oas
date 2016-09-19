package com.tvc.css;

import cn.osworks.aos.AOS;

public class CssStartUp {
	public static void main(String[] args) throws Exception {
		Thread.currentThread().setContextClassLoader(CssStartUp.class.getClassLoader());
		AOS.main(args);
	}
}
