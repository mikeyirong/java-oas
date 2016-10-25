package com.tvc.css.model;

import java.lang.reflect.Field;

import cn.osworks.aos.core.typewrap.Dto;
import cn.osworks.aos.core.typewrap.Dtos;

/**
 * 
 * @author 阿里巴巴账单实体类
 *
 */
public class Aliexpressbill {
	private String currency;// 币种
	private String storeAccount;// 店铺账号
	private String date;// 日期
	private String tradingInformation;// 交易信息
	private String balance;// 余额
	private String deposit;// 入款
	private String dispensing;// 出款
	private String businessType;// 业务类型
	private String accountLogId;// 账户id

	public String getCurrency() {
		return currency;
	}

	public void setCurrency(String currency) {
		this.currency = currency;
	}

	public String getStoreAccount() {
		return storeAccount;
	}

	public void setStoreAccount(String storeAccount) {
		this.storeAccount = storeAccount;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getTradingInformation() {
		return tradingInformation;
	}

	public void setTradingInformation(String tradingInformation) {
		this.tradingInformation = tradingInformation;
	}

	public String getBalance() {
		return balance;
	}

	public void setBalance(String balance) {
		this.balance = balance;
	}

	public String getDeposit() {
		return deposit;
	}

	public void setDeposit(String deposit) {
		this.deposit = deposit;
	}

	public String getDispensing() {
		return dispensing;
	}

	public void setDispensing(String dispensing) {
		this.dispensing = dispensing;
	}

	public String getBusinessType() {
		return businessType;
	}

	public void setBusinessType(String businessType) {
		this.businessType = businessType;
	}

	public String getAccountLogId() {
		return accountLogId;
	}

	public void setAccountLogId(String accountLogId) {
		this.accountLogId = accountLogId;
	}

	public Dto asDto() {
		Dto dto = Dtos.newDto();
		try {
			Field[] fields = this.getClass().getDeclaredFields();
			for (Field field : fields) {
				field.setAccessible(true);
				dto.put(field.getName(), field.get(this));
			}
			return dto;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
}
