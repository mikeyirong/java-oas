<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/tags.jsp"%>
<aos:html>
<aos:head title="速卖通客服邮件模版设置">
	<aos:include lib="ext" />
	<aos:base href="css/aliexpress/message" />
</aos:head>
<aos:body>
</aos:body>
<aos:onready>
	<aos:viewport layout="border">
		<aos:formpanel id="_f_query" layout="column" labelWidth="70"
			header="false" region="north" border="false">
			<aos:docked forceBoder="0 0 1 0">
				<aos:dockeditem xtype="tbtext" text="查询条件" />
			</aos:docked>
			<aos:textfield name="order_id" fieldLabel="订单ID" />
			<aos:textfield name="seller_name" fieldLabel="卖家名称" />
			<aos:combobox name="order_status" width="300" fieldLabel="订单状态">
				<aos:option value="" display="----全部订单状态----" />
				<aos:option value="PLACE_ORDER_SUCCESS" display="等待买家付款" />
				<aos:option value="IN_CANCEL" display="买家申请取消" />
				<aos:option value="WAIT_SELLER_SEND_GOODS" display="等待您发货" />
				<aos:option value="SELLER_PART_SEND_GOODS" display="部分发货" />
				<aos:option value="WAIT_BUYER_ACCEPT_GOODS" display="等待买家收货" />
				<aos:option value="FUND_PROCESSING" display="买卖家达成一致，资金处理中" />
				<aos:option value="IN_ISSUE" display="含纠纷中的订单" />
				<aos:option value="IN_FROZEN" display="冻结中的订单" />
				<aos:option value="WAIT_SELLER_EXAMINE_MONEY" display="等待您确认金额" />
				<aos:option value="RISK_CONTROL" display="订单处于风控24小时中" />
				<aos:option value="FINISH" display="已结束的订单" />
			</aos:combobox>
			<aos:docked dock="bottom" ui="footer" margin="0 0 8 0">
				<aos:dockeditem xtype="tbfill" />
				<aos:dockeditem xtype="button" text="查询"
					onclick="query_message_queue" icon="query.png" />
				<aos:dockeditem xtype="button" text="重置"
					onclick="AOS.reset(_f_query);" icon="refresh.png" />
				<aos:dockeditem xtype="tbfill" />
			</aos:docked>
		</aos:formpanel>

		<aos:gridpanel id="_g_message_queue"
			url="findMessageSentHistory.jhtml" onrender="query_message_queue"
			region="center">
			<aos:docked forceBoder="1 0 1 0">
				<aos:dockeditem xtype="tbtext"
					text="速卖通站内信待发送队列  [本列表中的数据将会在4小时内完成发送]" />
			</aos:docked>
			<aos:column type="rowno" />
			<aos:column header="ID" dataIndex="id" hidden="true" />
			<aos:column header="content" dataIndex="content" hidden="true" />
			<aos:column header="消息源" dataIndex="source" />
			<aos:column header="消息接受者" dataIndex="destination" />
			<aos:column header="订单状态" dataIndex="order_status" />
			<aos:column header="买家登录ID" dataIndex="buyer_login_id" />
			<aos:column header="订单ID" dataIndex="order_id" />
			<aos:column header="发送时间" dataIndex="created_at" />
			<aos:column header="卖家" dataIndex="seller" />
			<aos:column header="操作" dataIndex="seller" width="220"
				rendererFn="fn_operation_format" />
		</aos:gridpanel>

		<aos:window id="messageWindow" title="查看站内信内容" layout="fit"
			closable="true" width="500" height="300">
			<aos:textareafield id="messageBody" />
		</aos:window>
	</aos:viewport>
	<script type="text/javascript">
		function newMap() {
			return {
				entry : [],
				put : function(k, v) {
					this.entry.push({
						key : k,
						value : v
					});
				},
				get : function(k) {
					for (var i = 0; i < this.entry.length; i++) {
						var element = this.entry[i];
						if (element.key == k) {
							return element.value;
						}
					}
					return null;
				}
			};
		}
		function query_message_queue() {
			var params = AOS.getValue('_f_query');
			_g_message_queue_store.getProxy().extraParams = params;
			_g_message_queue_store.loadPage(1);
		}

		function fn_operation_format(value, metaData, record, rowIndex,
				colIndex, store) {
			window.dataMap = window.dataMap || newMap();
			window.dataMap.put(record.data.id, record.data);
			return '<input type="button" value = "查看信息内容" class = "cbtn" onclick="viewMessage(\''
					+ record.data.id + '\')">';
		}

		window.viewMessage = function(mid) {
			var message = window.dataMap.get(mid);
			messageWindow.setTitle("查看消息内容: " + message.order_id);
			messageBody.setValue(message.content);
			messageWindow.show();
		}
	</script>
</aos:onready>
</aos:html>