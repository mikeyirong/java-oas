package com.tvc.css.aliexpress.financial.controller;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.alibaba.fastjson.JSON;
import com.tvc.css.LoggingSupport;
import com.tvc.css.aliexpress.financial.services.AliexpressFinancialServices;
import com.tvc.css.model.Aliexpressbill;

import cn.osworks.aos.core.asset.AOSJson;
import cn.osworks.aos.core.asset.WebCxt;
import cn.osworks.aos.core.dao.SqlDao;
import cn.osworks.aos.core.typewrap.Dto;
import cn.osworks.aos.core.typewrap.Dtos;

/**
 * 速卖通财务小工具控制器
 * 
 * @author mike
 *
 */
@Controller
@RequestMapping(value = "css/aliexpress/financial")
public class AliexpressFinancialController extends LoggingSupport {
	@Autowired
	private AliexpressFinancialServices financilService;
	private int number = 0;

	@RequestMapping("financial")
	public String init(HttpServletRequest request, HttpServletResponse response) {
		return "css/aliexpress/financial/financial.jsp";
	}

	@RequestMapping("financialSend")
	public String initq(HttpServletRequest request, HttpServletResponse response) {
		return "css/aliexpress/financial/financialSend.jsp";
	}

	/**
	 * 文件上传
	 * 
	 * @param request
	 * @param response
	 * @param model
	 * @throws Exception
	 */
	@RequestMapping("file_uploading")
	public void fileUploading(HttpServletRequest request, HttpServletResponse response, ModelMap model)
			throws Exception {
		Dto dto = Dtos.newDto(request);
		// 获取上传文件信息
		MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
		MultipartFile mfile = multiRequest.getFile("excel");
		String path = System.getProperty("user.home") + "\\" + "upload";
		File fileExit = new File(path);
		if (fileExit.exists() || fileExit.isDirectory()) {
			fileExit.mkdir();
		}

		String uuid = new File(mfile.getOriginalFilename()).getName();
		String filename = mfile.getOriginalFilename();
		if (!filename.isEmpty()) {
			InputStream in = mfile.getInputStream();
			byte[] buf = new byte[1024];
			path = path + "\\" + uuid;// + ".xls";
			File f = new File(path);
			FileOutputStream out = new FileOutputStream(f);
			// dto.put("path", path.replace("\\", "/"));
			int length = 0;
			while ((length = in.read(buf)) > -1) {
				out.write(buf, 0, length);
			}
			in.close();
			out.flush();
			out.close();
		}
		String hostname = dto.getUserInfo().getAccount_();
		String account = dto.getString("account");
		if (readExcel(new File(path), account)) {
			dto.put("status", "1");
		} else {
			dto.put("status", "0");
		}
		String datecontrol = dto.getString("date1");
		String type = dto.getString("type");
		logger.info("control date is-------->" + datecontrol);
		dto.put("type", type);
		dto.put("date", datecontrol);
		dto.put("account", account);
		dto.put("hostname", hostname);
		dto.put("path", uuid + ".xls");
		WebCxt.write(response, AOSJson.toJson(financilService.saveMessagelist(dto)));
	}

	/**
	 * 文件下载
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("downExcelfile")
	public void fileDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Dto inDto = Dtos.newDto(request);
		String path = inDto.getString("path");
		String root = System.getProperty("user.home") + "\\" + "upload";
		try {
			File file = new File(root, path);
			FileInputStream in = new FileInputStream(file);
			response.setHeader("Content-Disposition",
					"attachment;filename=" + URLEncoder.encode(file.getName(), "utf-8"));
			response.setContentType("application/x-download");
			OutputStream out = response.getOutputStream();
			byte[] buf = new byte[1024];
			int length = 0;
			while ((length = in.read(buf)) > 0) {
				out.write(buf, 0, length);

			}
			in.close();
			out.flush();
			out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * 实时查询所有店铺与条件相匹配的excel上传记录信息
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("findExcelMessage")
	public void findExcelMessage(HttpServletRequest request, HttpServletResponse response) {
		Dto inDto = Dtos.newDto(request);
		WebCxt.write(response, AOSJson.toGridJson(financilService.findMessagelist(inDto), inDto.getPageTotal()));
	}

	/**
	 * 实时查询单个店铺下与条件相匹配的excel上传记录信息
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("findExceMessageSingle")
	public void findExceMessageSingle(HttpServletRequest request, HttpServletResponse response) {
		Dto inDto = Dtos.newDto(request);
		String account = inDto.getUserInfo().getAccount_();
		inDto.put("hostname", account);
		WebCxt.write(response, AOSJson.toGridJson(financilService.findMessageSingle(inDto), inDto.getPageTotal()));
	}

	/**
	 * 查询业务员对应下的店铺
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("accountSelect")
	public void accountSelect(HttpServletRequest request, HttpServletResponse response) {
		Dto inDto = Dtos.newDto(request);
		String host = inDto.getUserInfo().getAccount_();
		inDto.put("host", host);
		WebCxt.write(response, AOSJson.toGridJson(financilService.accountSelect(inDto)));
	}

	/**
	 * 删除宿主机文件和记录
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("deleteExcelMessage")
	public void deleteExcelMessage(HttpServletRequest request, HttpServletResponse response) {
		logger.info("删除文件");
		Dto inDto = Dtos.newDto(request);
		// 文件路径
		String root = System.getProperty("user.home") + "\\" + "upload";
		String path = inDto.getString("path");
		File file = new File(root, path);
		if (file.exists()) {
			file.delete();
		}
		WebCxt.write(response, AOSJson.toJson(financilService.deleteMessageList(inDto)));
	}

	/**
	 * 发送消息至boss系统
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping("sendMessageBoss")
	public void sendMessageBoss(HttpServletRequest request, HttpServletResponse response) {
		logger.info("推送消息至boss机");
		Dto inDto = Dtos.newDto(request);
		String path = inDto.getString("path");
		logger.info("文件路径-----------" + path);
		String account = inDto.getString("account");
		String root = System.getProperty("user.home") + "\\" + "upload";
		File file = new File(root, path);
		if (readExcel(file, account)) {
			// 发送成功
			inDto.put("status", "1");
		} else {
			// 发送失败
			inDto.put("status", "0");
		}
		WebCxt.write(response, AOSJson.toJson(financilService.sendMessagelist(inDto)));
	}

	boolean isEmpty(Object o) {
		return (o == null || "null".equals(o)) || o.toString().trim().length() < 1;
	}

	private Aliexpressbill process(HSSFRow sheet1, String account) {
		int columns = sheet1.getLastCellNum();
		int number = 0;
		Aliexpressbill bill = new Aliexpressbill();
		if (sheet1 != null) {
			Inner: for (int j = 0; j < columns; j++) {
				Cell cell = sheet1.getCell(j);
				if (cell != null && cell.getStringCellValue().startsWith("20")) {
					number = number + 1;
					String StartTime = cell.getStringCellValue(); // 起始时间
					String type = sheet1.getCell(j + 1).getStringCellValue();// 业务类型
					// 判断业务类型是否是中文
					if (isChinese(type)) {
						return null;
					}
					String information = sheet1.getCell(j + 2).getStringCellValue(); // 交易信息
					HSSFCell emptyCell = sheet1.getCell(j + 3);
					String moneyIn = emptyCell == null ? null : emptyCell.getStringCellValue(); // 入款

					HSSFCell emptyCell3 = sheet1.getCell(j + 4);
					String moneyOut = emptyCell3 == null ? null : emptyCell3.getStringCellValue();// 出款
					HSSFCell emptyCell2 = sheet1.getCell(j + 5);
					String balance = emptyCell2 == null ? null : emptyCell2.getStringCellValue(); // 余额
					boolean Lawenforcers2 = false;
					try {
						sheet1.getCell(j + 7).getStringCellValue();
					} catch (Exception e) {
						Lawenforcers2 = true;
					}
					if (!Lawenforcers2) {
						return null;
					}
					String str1 = StartTime + type + balance + moneyOut;
					bill.setAccountLogId(str1.replace(" ", ""));
					bill.setTradingInformation(information);
					bill.setStoreAccount(account);
					bill.setDate(StartTime);
					bill.setBusinessType(type);
					if (isEmpty(moneyIn)) {
						bill.setDeposit("0");
					} else {
						bill.setDeposit((String) com.tvc.css.tool.ToMatcher.toMatcher(moneyIn).get(1).replace(" ", ""));
					}
					bill.setCurrency((String) com.tvc.css.tool.ToMatcher.toMatcher(balance).get(0));
					if (isEmpty(moneyOut)) {
						bill.setDispensing("0");
					} else {
						bill.setDispensing(
								(String) com.tvc.css.tool.ToMatcher.toMatcher(moneyOut).get(1).replace(" ", ""));
					}
					bill.setBalance((String) com.tvc.css.tool.ToMatcher.toMatcher(balance).get(1).replace(" ", ""));
					financilService.saveHistory(bill);
					break Inner;
				}
			}
		}
		return bill;
	}

	/**
	 * 解析excel表
	 * 
	 * @param file
	 */
	public boolean readExcel(File file, final String account) {
		if (!file.exists()) {
			return false;
		}

		final Function<List<Aliexpressbill>, Void> function = new Function<List<Aliexpressbill>, Void>() {
			@Override
			public Void apply(List<Aliexpressbill> pack) {
				String url = "http://boss.test.dev/B2C/SyncAliAccountDetail";
				String url1 = "http://admin.sjlpj.cn/B2C/SyncAliAccountDetail";
				String js = JSON.toJSONString(pack);
				logger.info("发送数据----------->" + pack.size());
				logger.info("数据--------" + js);
				logger.info("number" + number);
				number += 1;
				sendMessage(url, js);
				return null;
			}
		};

		try {
			FileInputStream in = new FileInputStream(file);
			BufferedInputStream bufer = new BufferedInputStream(in);
			POIFSFileSystem fs = new POIFSFileSystem(bufer);
			HSSFWorkbook wb = new HSSFWorkbook(fs);
			final HSSFSheet sheet = wb.getSheetAt(0);
			final int rows = sheet.getPhysicalNumberOfRows();
			List<Aliexpressbill> pack = new ArrayList<Aliexpressbill>();
			for (int i = 0; i < rows; i++) {
				HSSFRow row = sheet.getRow(i);
				Aliexpressbill bill = process(row, account);
				if (bill == null) {
					return false;
				}

				if (bill.getAccountLogId() == null) {
					continue;
				}
				pack.add(bill);

				if (pack.size() >= 50) {
					// do batch
					function.apply(pack);
					pack.clear();
				}
			}

			if (!pack.isEmpty()) {
				function.apply(pack);
			}

		} catch (FileNotFoundException e) {
			logger.info("读取excel出错了" + e);
			return false;
		} catch (IOException e) {
			logger.info("读取excel出错了" + e);
			return false;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	/**
	 * 发送数据
	 */
	/**
	 * @param url
	 * @param json
	 */
	public void sendMessage(String url, String json) {
		logger.info("boss请求--------->");
		CloseableHttpClient httpClient = HttpClients.createDefault();
		HttpPost method = new HttpPost(url);
		StringEntity se = new StringEntity(json, "utf-8");
		se.setContentEncoding("UTF-8");
		se.setContentType("application/json");
		method.setEntity(se);
		try {
			CloseableHttpResponse result = httpClient.execute(method);
			if (result.getStatusLine().getStatusCode() != 200) {
				logger.error("出错了" + result.getStatusLine().getStatusCode());
			} else {
				HttpEntity requestString = result.getEntity();
				logger.info("返回结果是：" + EntityUtils.toString(requestString));
			}
		} catch (IOException e) {
			logger.info("出现异常,重新发送数据");
			sendMessage(url, json);
		}
	}

	/**
	 * 检查excel文件中是否含有中文
	 * 
	 * @param file
	 * @return
	 */
	// 判断一个字符串是否含有中文
	public static boolean isChinese(String str) {
		if (str == null)
			return false;
		for (char c : str.toCharArray()) {
			if (isChinese(c))
				return true;// 有一个中文字符就返回
		}
		return false;
	}

	// 判断一个字符是否是中文
	public static boolean isChinese(char c) {
		return c >= 0x4E00 && c <= 0x9FA5;// 根据字节码判断
	}
	
	/**
	 * 
	 */
	
	public String  readUrl(){
		return null;
	}
}
