package com.tvc.css.aliexpress.financial.services;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tvc.css.model.Aliexpressbill;

import cn.osworks.aos.core.dao.SqlDao;
import cn.osworks.aos.core.typewrap.Dto;
import cn.osworks.aos.core.typewrap.Dtos;

/**
 * 财务账单处理器
 * 
 * @author mike
 *
 */
@Service
public class AliexpressFinancialServices {
	@Autowired
	private SqlDao sqlDao;
	private Logger logger = LoggerFactory.getLogger(getClass());

	public Dto fileNameget(Dto inDto) {
		return sqlDao.selectDto("JobManager.jobnameget", inDto);
	}

	/**
	 * 查询业务员对应下的店铺
	 * 
	 * @param inDto
	 * @return
	 */
	public List<Dto> accountSelect(Dto inDto) {
		return sqlDao.list("AliexpressMessageMapper.accountSelect", inDto);
	}

	/**
	 * 保存上传excel后的信息
	 * 
	 * @param inDto
	 * @return
	 */
	public Dto saveMessagelist(Dto inDto) {
		inDto.setPageLimit(50);
		inDto.setPageStart(0);
		Dto sss = sqlDao.selectDto("AliexpressMessageMapper.selectExcelMessage", inDto);
		String hostname = sss.getString("hostname");
		logger.info("appcode is---------->" + hostname);
		if (hostname == "") {
			sqlDao.insert("AliexpressMessageMapper.saveExcelMessage", inDto);
		} else {
			logger.info("已存在");
			String path1 = System.getProperty("user.home") + "\\" + "upload";
			String path = sss.getString("path");
			File file = new File(path1, path);
			if (file.exists()) {
				file.delete();
			}
			sqlDao.insert("AliexpressMessageMapper.updateExcelMessage", inDto);
		}
		return Dtos.newOutDto();
	}

	/**
	 * 查询上传excel记录信息
	 * 
	 * @param inDto
	 * @return
	 */
	public List<Dto> findMessagelist(Dto inDto) {
		logger.info("信息---------》" + sqlDao.list("AliexpressMessageMapper.findAliexpressStorePage", inDto));
		return sqlDao.list("AliexpressMessageMapper.findAliexpressStorePage", inDto);
	}
    /**
     * 查询对应店铺下的excel记录信息
     * @param inDto
     * @return
     */
	public List<Dto> findMessageSingle(Dto inDto){
		return sqlDao.list("AliexpressMessageMapper.findAliexpressByaccount", inDto);
	}
	/**
	 * 下载附件
	 * 
	 * @param inDto
	 * @return
	 */
	public byte[] downloadAttachment(Dto inDto) throws Exception {
		String baseDir = System.getProperty("user.home") + "/" + "upload";
		File target = new File(baseDir, inDto.getString("hash"));
		InputStream in = new FileInputStream(target);
		byte[] buffer = new byte[in.available()];
		in.read(buffer);
		in.close();
		return buffer;
	}

	/**
	 * 删除文件和记录
	 * 
	 * @param inDto
	 * @return
	 */
	public Dto deleteMessageList(Dto inDto) {
		sqlDao.insert("AliexpressMessageMapper.deleteExcelMessage", inDto);
		return Dtos.newOutDto();
	}

	/**
	 * 更新记录状态
	 * 
	 * @param inDto
	 * @return
	 */
	public Dto sendMessagelist(Dto inDto) {
		sqlDao.insert("AliexpressMessageMapper.sendMessagelist", inDto);
		return Dtos.newOutDto();
	}
	public void saveHistory(Aliexpressbill bill){
		sqlDao.insert("AliexpressMessageMapper.hostoryMessage", bill.asDto());
	}
}
