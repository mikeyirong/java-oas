<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/tags.jsp"%>
<aos:html>
<aos:head title="速卖通客服邮件模版设置">
	<aos:include lib="ext" />
	<aos:base href="css/aliexpress/message" />
</aos:head>
<aos:body>
	<script src="http://cdn.bootcss.com/jquery/3.1.0/jquery.min.js"></script>
	<div id="_div_tips" class="x-hidden">
		<ul>
			<li>当您需要在某一个订单状态上主动向顾客发起站内信通知，那么你可以使用本功能</li>
			<li>每一个订单状态上在某个时刻只且只能有一个模版</li>
			<li>如果您忽略某个订单状态，仅做到不为其设置模版或者停用其绑定的模版即可</li>
			<li>本功能只对：速卖通平台 有效</li>
			<li>模版语法：<a target="_blank"
				href="http://120.25.194.95/index.php/%E9%80%9F%E5%8D%96%E9%80%9A%E7%AB%99%E5%86%85%E4%BF%A1%E6%A8%A1%E7%89%88%E7%BC%96%E8%BE%91%E8%AF%AD%E6%B3%95">点击查看...</a></li>
		</ul>
	</div>

	<div id="contentEI">
		<textarea id="contentValue" style="width: 100%; height: 600px"></textarea>
	</div>
</aos:body>
<aos:onready>
	<aos:viewport layout="border">
		<aos:formpanel id="_f_query" layout="column" labelWidth="70"
			header="false" region="north" border="false">
			<aos:docked forceBoder="0 0 1 0">
				<aos:dockeditem xtype="tbtext" text="查询条件" />
			</aos:docked>
			<aos:combobox name="name" width="300" fieldLabel="订单状态">
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
				<aos:dockeditem xtype="button" text="添加新模版"
					onclick="_g_new_template" icon="add.png" />
				<aos:dockeditem xtype="button" text="查询" onclick="query_templates"
					icon="query.png" />
				<aos:dockeditem xtype="button" text="重置"
					onclick="AOS.reset(_f_query);" icon="refresh.png" />
				<aos:dockeditem xtype="tbfill" />
			</aos:docked>
		</aos:formpanel>

		<aos:gridpanel id="_g_template" url="listMessageTemplate.jhtml"
			onrender="query_templates" region="center">
			<aos:docked forceBoder="1 0 1 0">
				<aos:dockeditem xtype="tbtext" text="速卖通站内信模版信息" />
			</aos:docked>
			<aos:column type="rowno" />
			<aos:column header="模版ID" dataIndex="id" hidden="true" />
			<aos:column header="模版内容" dataIndex="content" hidden="true" />
			<aos:column header="模版名称" dataIndex="name" />
			<aos:column header="模版描述" dataIndex="description" />
			<aos:column header="模版作者" dataIndex="created_by" />
			<aos:column header="创建时间" dataIndex="created_at" />
			<aos:column header="状态" dataIndex="status"
				rendererFn="fn_status_format" />
			<aos:column header="操作" dataIndex="status" width="220"
				rendererFn="fn_operation_format" />
		</aos:gridpanel>

		<aos:window id="templateWindow" title="新建速卖通站内信模版" layout="border"
			maximized="true">
			<aos:panel layout="fit" region="west" width="300" title="模版基本信息"
				collapsible="true" bodyBorder="0 1 0 0">
				<aos:layout type="vbox" align="stretch" />
				<aos:formpanel id="templateForm" layout="column" labelWidth="70"
					border="false" height="200">
					<aos:combobox id="templateName" name="name" width="300"
						fieldLabel="订单状态" columnWidth="0.9">
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
					<aos:hiddenfield id="content" name="content" />
					<aos:hiddenfield id="status" name="status" />
					<aos:textfield id="description" name="description"
						fieldLabel="模版描述" columnWidth="0.9" />
				</aos:formpanel>

				<aos:panel flex="1" layout="fit" contentEl="_div_tips"
					autoScroll="true">
					<aos:docked forceBoder="1 0 1 0">
						<aos:dockeditem xtype="tbtext" text="设置速卖通模版注意事项" />
					</aos:docked>
				</aos:panel>
			</aos:panel>

			<aos:panel region="center" border="false" title="模版编辑区"
				contentEl="contentEI">
			</aos:panel>
			<aos:panel region="south" border="false">
				<aos:docked dock="bottom" ui="footer" margin="0 0 8 0">
					<aos:dockeditem xtype="tbfill" />
					<aos:dockeditem xtype="button" text="保存" onclick="save_template"
						icon="save.png" />
					<aos:dockeditem xtype="button" text="重置"
						onclick="AOS.reset(_f_query);" icon="up2.png" />
					<aos:dockeditem xtype="tbfill" />
				</aos:docked>
			</aos:panel>
		</aos:window>
	</aos:viewport>
	<script type="text/javascript">
		//定义一个Hashtable
		//加载表格数据结构
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

		function query_templates() {
			var params = AOS.getValue('_f_query');
			_g_template_store.getProxy().extraParams = params;
			_g_template_store.loadPage(1);
		}

		/**
		 * 添加新的站内信模版
		 */
		function _g_new_template() {
			templateWindow.show();
		}
		/**
		 * 保存模板信息
		 */
		function save_template() {
			var form = templateForm.getForm();
			content.setValue(document.getElementById("contentValue").value);

			if (content.getValue() == "") {
				AOS.tip("模板内容不能为空!");
				return;
			}

			if (description.getValue() == "") {
				AOS.tip("模板描述不能为空!");
				return;
			}

			AOS.confirm('确认要保存该数据?', function(btn) {
				if (btn == 'cancel') {
					AOS.tip('操作被取消。');
					return;
				}
				if (templateForm.isValid() == false) {
					AOS.tip('模板内容或描述尚未填写完整');
					return;
				}

				AOS.wait();

				form.submit({
					url : "saveMessageTemplate.jhtml",
					type : "POST",
					success : function(fm, action) {
						delete window.dataMap;
						query_templates();
						templateWindow.hide();
						AOS.hide();
					},
					error : function(err) {
						AOS.error("保存模板出错!");
					}
				});
			});
		}

		function fn_status_format(value, metaData, record, rowIndex, colIndex,
				store) {
			return (value == 1) ? "正常" : "停用";
		}

		function fn_operation_format(value, metaData, record, rowIndex,
				colIndex, store) {
			window.dataMap = window.dataMap || newMap();
			window.dataMap.put(record.data.id, record.data);

			var html = '<input type="button" value = "查看/修改" class = "cbtn" onclick="editTemplate(\''
					+ record.data.id + '\')">';
			console.log("===>" + JSON.stringify(record.data));
			if (value == 1) {
				html += '<input type="button" value = "停用" class = "cbtn" onclick="changeStatus(\''
						+ record.data.id + '\',0)">';
			} else {
				html += '<input type="button" value = "启用" class = "cbtn" onclick="changeStatus(\''
						+ record.data.id + '\',1)">';
			}
			return html;
		}

		/**
		 *  修改模板
		 */
		window.editTemplate = function(templateId) {
			console.log("+++++++++++++EDIT+++++++" + templateId);
			var template = window.dataMap.get(templateId);
			templateWindow.setTitle("修改模板 " + template.description);
			description.setValue(template.description);
			templateName.setValue(template.name);
			status.setValue(1);
			document.getElementById("contentValue").value = template.content;
			templateWindow.show();
		}

		/**
		 * 停用当前模板
		 */
		window.changeStatus = function(templateId, status) {
			AOS.confirm('确认要停用该模板?', function(btn) {
				if (btn == 'cancel') {
					AOS.tip('操作被取消。');
					return;
				}

				AOS.wait();
				$.ajax({
					url : 'changeTemplateStatus.jhtml?templateId=' + templateId
							+ "&status=" + status,
					success : function(d) {
						delete window.dataMap;
						query_templates();
						AOS.hide();
					},
					error : function(e) {
						AOS.error("操作出错")
					}
				});

			});

		}
	</script>
</aos:onready>
</aos:html>