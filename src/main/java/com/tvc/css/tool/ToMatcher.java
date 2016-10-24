package com.tvc.css.tool;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 工具类
 * 将字符串进行正则匹配
 * @author mike
 *
 */
public class ToMatcher {
public static ArrayList<String> toMatcher(String ss){
	ArrayList<String> list =new ArrayList<String>();
	Pattern pattern = Pattern.compile("[A-Za-z]+");
	Matcher matcher = pattern.matcher(ss);
	while (matcher.find()) {
		list.add(matcher.group());
		list.add(ss.replace(matcher.group(),"").trim());
	}
	return list;
}
}
