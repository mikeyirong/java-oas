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
			<aos:textfield name="name" fieldLabel="店铺名称" />
			<aos:textfield name="principal" fieldLabel="店铺账号" />
			<aos:docked dock="bottom" ui="footer" margin="0 0 8 0">
				<aos:dockeditem xtype="tbfill" />
				<aos:dockeditem xtype="button" text="添加" onclick="add_store_api"
					icon="add.png" />
				<aos:dockeditem xtype="button" text="查询"
					onclick="query_message_queue" icon="query.png" />
				<aos:dockeditem xtype="button" text="重置"
					onclick="AOS.reset(_f_query);" icon="refresh.png" />
				<aos:dockeditem xtype="tbfill" />
			</aos:docked>
		</aos:formpanel>

		<aos:gridpanel id="_g_message_queue" url="findAliexpressStore.jhtml"
			onrender="query_message_queue" region="center">
			<aos:docked forceBoder="1 0 1 0">
				<aos:dockeditem xtype="tbtext" text="速卖通店铺API授权信息" />
			</aos:docked>
			<aos:column type="rowno" />
			<aos:column header="ID" dataIndex="id" hidden="true" />
			<aos:column header="店铺名称" dataIndex="name" width="100" />
			<aos:column header="店铺账号" dataIndex="principal" width="150" />
			<aos:column header="App key" dataIndex="app_key" width="100" />
			<aos:column header="Client secret" dataIndex="client_secret"
				width="100" />
			<aos:column header="Refresh token" dataIndex="refresh_token"
				width="100" />
			<aos:column header="创建时间" dataIndex="created_at" width="150" />
			<aos:column header="操作" dataIndex="id" width="150"
				rendererFn="fn_operation_format" />
		</aos:gridpanel>

		<aos:window id="storeWindow" title="查看站内信内容" layout="fit"
			closable="true" width="500" height="300">
			<aos:formpanel id="storeForm" title="请务必认真对照速卖通授权文档填写">
				<aos:hiddenfield id="storeId" name="id" />
				<aos:textfield id="name" name="name" fieldLabel="店铺名称" width="400" />
				<aos:textfield id="principal" name="principal" fieldLabel="店铺账号"
					width="400" />
				<aos:textfield id="appKey" name="app_key" fieldLabel="App key"
					width="400" />
				<aos:textfield id="clientSecret" name="client_secret"
					fieldLabel="Client secret" width="400" />
				<aos:textfield id="refreshToken" name="refresh_token"
					fieldLabel="Refresh token" width="400" />
				<aos:docked dock="bottom" ui="footer" margin="0 0 8 0">
					<aos:dockeditem xtype="tbfill" />
					<aos:dockeditem xtype="button" text="保存" onclick="save_store_api()"
						icon="save.png" />
					<aos:dockeditem xtype="button" text="关闭"
						onclick="storeWindow.hide()" icon="undo.png" />
					<aos:dockeditem xtype="tbfill" />
				</aos:docked>
			</aos:formpanel>
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
			return '<input type="button" value = "修改" class = "cbtn" onclick="viewMessage(\''
					+ record.data.id + '\')">';
		}

		window.viewMessage = function(mid) {
			var message = window.dataMap.get(mid);
			storeWindow.setTitle("修改店铺API授权信息: " + message.principal);
			AOS.reset(storeForm);
			storeId.setValue(message.id);
			name.setValue(message.name);
			principal.setValue(message.principal);
			appKey.setValue(message.app_key);
			clientSecret.setValue(message.client_secret);
			refreshToken.setValue(message.refresh_token);
			storeWindow.show();
		}

		/**
		 * 添加店铺
		 */
		function add_store_api() {
			AOS.reset(storeForm);
			storeWindow.setTitle("添加新的速卖通店铺API授权");
			storeWindow.show();
		}

		/**
		 * 保存店铺API授权信息
		 */
		function save_store_api() {
			if (name.getValue() == "") {
				AOS.err("店铺名称不能为空");
				return;
			}

			if (principal.getValue() == "") {
				AOS.err("店铺帐号不能为空");
				return;
			}

			if (appKey.getValue() == "") {
				AOS.err("店铺App key不能为空");
				return;
			}

			if (clientSecret.getValue() == "") {
				AOS.err("店铺client secret不能为空");
				return;
			}

			if (refreshToken.getValue() == "") {
				AOS.err("店铺refresh token不能为空");
				return;
			}

			var form = storeForm.getForm();
			AOS.wait();
			form.submit({
				url : 'saveAliexpressStoreApi.jhtml',
				type : 'POST',
				success : function(fmt, body) {
					AOS.tip("保存成功!");
					AOS.hide();
					storeWindow.hide();
					query_message_queue();
				},
				error : function(err) {
					alert("错误:" + err);
				}
			});
		}
	</script>
</aos:onready>
</aos:html>