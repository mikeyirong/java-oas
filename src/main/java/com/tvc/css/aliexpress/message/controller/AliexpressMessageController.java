package com.tvc.css.aliexpress.message.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tvc.css.LoggingSupport;
import com.tvc.css.aliexpress.message.services.AliexpressMessageService;

import cn.osworks.aos.core.asset.AOSJson;
import cn.osworks.aos.core.asset.WebCxt;
import cn.osworks.aos.core.typewrap.Dto;
import cn.osworks.aos.core.typewrap.Dtos;

/**
 * 速卖通站内信控制器
 * 
 * @author mclaren
 *
 */
@Controller
@RequestMapping(value = "css/aliexpress/message")
public class AliexpressMessageController extends LoggingSupport {
	@Autowired
	private AliexpressMessageService messageService;

	/**
	 * 初始化速卖通站内信模版
	 * 
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "template")
	public String initTemplate(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "css/aliexpress/message/template.jsp";
	}

	/**
	 * 返回与之条件匹配的速卖通站内信模版
	 * 
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "listMessageTemplate")
	public void listMessageTemplate(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Dto inDto = Dtos.newDto(request);
		WebCxt.write(response, AOSJson.toGridJson(messageService.findMessageTemplate(inDto), inDto.getPageTotal()));
	}

	/**
	 * 修改模版状态
	 * 
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("changeTemplateStatus")
	public void changeMessageTemplateStatus(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Dto inDto = Dtos.newDto(request);
		WebCxt.write(response, AOSJson.toJson(messageService.changeMessageTemplateStatus(inDto)));
	}

	/**
	 * 保存速卖通站内信模板
	 * 
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "saveMessageTemplate")
	public void saveMessageTemplate(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Dto inDto = Dtos.newDto(request);
		inDto.put("created_by", inDto.getUserInfo().getId_());
		inDto.put("limit", 50);
		inDto.put("start", 0);
		WebCxt.write(response, AOSJson.toJson(messageService.saveMessageTemplate(inDto)));
	}

	/**
	 * 实时展示速卖通站内信待发送队列UI
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("preparedSendingQueue")
	public String showPreparedSendingQueue(HttpServletRequest request, HttpServletResponse response) {
		return "css/aliexpress/message/preparedSendingQueue.jsp";
	}

	/**
	 * 实施查询速卖通站内信待发送队列
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("listAliexpressMessageQueue")
	public void listAliexpressMessageQueue(HttpServletRequest request, HttpServletResponse response) {
		Dto inDto = Dtos.newDto(request);
		WebCxt.write(response, AOSJson.toGridJson(messageService.findMessageQueue(inDto), inDto.getPageTotal()));
	}
}
