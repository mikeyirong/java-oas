package com.tvc.css.aliexpress.message.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.osworks.aos.core.dao.SqlDao;
import cn.osworks.aos.core.typewrap.Dto;
import cn.osworks.aos.core.typewrap.Dtos;

/**
 * 速卖通站内信服务
 * 
 * @author Administrator
 *
 */
@Service
public class AliexpressMessageService {
	@Autowired
	private SqlDao sqlDao;

	/**
	 * 查找速卖通站内信模版
	 * 
	 * @param inDto
	 * @return
	 */
	public List<Dto> findMessageTemplate(Dto inDto) {
		return sqlDao.list("AliexpressMessageMapper.findMessageTemplatePage", inDto);
	}

	/**
	 * 保存速卖通站内信模板
	 * 
	 * @param inDto
	 * @return
	 */
	public Dto saveMessageTemplate(Dto inDto) {
		List<Dto> exist = findMessageTemplate(inDto);
		Dto out = Dtos.newOutDto();
		if (exist.isEmpty()) {
			/* 插入数据 */
			sqlDao.insert("AliexpressMessageMapper.insertMessageTemplate", inDto);
		} else {
			sqlDao.update("AliexpressMessageMapper.updateMessageTemplate", inDto);
		}
		return out;
	}

	/**
	 * 修改速卖通站内信模版状态
	 * 
	 * @param inDto
	 * @return
	 */
	public Dto changeMessageTemplateStatus(Dto inDto) {
		Dto out = Dtos.newOutDto();
		sqlDao.update("AliexpressMessageMapper.changeTemplateStatus", inDto);
		return out;
	}

	/**
	 * 获取所有的待发送消息队列
	 * 
	 * @param inDto
	 * @return
	 */
	public List<Dto> findMessageQueue(Dto inDto) {
		return sqlDao.list("AliexpressMessageMapper.listMessageQueuePage", inDto);
	}

	/**
	 * 查看发送记录
	 * 
	 * @param inDto
	 * @return
	 */
	public List<Dto> findMessageSentHistories(Dto inDto) {
		return sqlDao.list("AliexpressMessageMapper.findMessageSentHistoriesPage", inDto);
	}
}
