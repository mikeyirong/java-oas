<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/tags.jsp"%>
<aos:html>
<aos:head title="速卖通客财务设置">
	<aos:include lib="ext" />
	<aos:base href="css/aliexpress/financial" />
</aos:head>
<aos:body>
	<script src="http://cdn.bootcss.com/jquery/3.1.0/jquery.min.js"></script>
</aos:body>
<aos:onready>
	<aos:viewport layout="border">
		<aos:formpanel id="_f_query" layout="column" labelWidth="70"
			header="false" region="north" border="false">
			<aos:docked forceBoder="0 0 1 0">
				<aos:dockeditem xtype="tbtext" text="查询条件" />
			</aos:docked>
			<aos:combobox name="account" fieldLabel="店铺账号"
				url="accountSelect.jhtml">
			</aos:combobox>
			<aos:combobox name="status" fieldLabel="状态">
				<aos:option value="0" display="0-未发送" />
				<aos:option value="1" display="1-已发送" />
			</aos:combobox>
			<aos:docked dock="bottom" ui="footer" margin="0 0 4 0">
				<aos:dockeditem xtype="tbfill" />
				<aos:dockeditem xtype="button" text="新增" onclick="add_store_api"
					icon="add.png" />
				<aos:dockeditem xtype="button" text="查询"
					onclick="query_message_queue" icon="query.png" />
				<aos:dockeditem xtype="button" text="重置"
					onclick="AOS.reset(_f_query);" icon="refresh.png" />
				<aos:dockeditem xtype="tbfill" />
			</aos:docked>
		</aos:formpanel>

		<aos:gridpanel id="_g_message_queue" url="findExceMessageSingle.jhtml"
			onrender="query_message_queue" region="center">
			<aos:docked forceBoder="1 0 1 0">
				<aos:dockeditem xtype="tbtext" text="速卖通店铺财务excel上传信息" />
			</aos:docked>
			<aos:column type="rowno" />
			<aos:column header="ID" dataIndex="id" hidden="true" />
			<aos:column header="业务员" dataIndex="name" width="100" />
			<aos:column header="店铺账号" dataIndex="account" width="100" />
			<aos:column id="month_id" header="月份" dataIndex="date" width="100" />
			<aos:column header="状态" dataIndex="status" width="100"
				rendererFn="fn_status_format" />
			<aos:column header="创建时间" dataIndex="create_at" width="100" />
			<aos:column header="路径" dataIndex="path" width="100" hidden="true" />
			<aos:column header="操作" dataIndex="id" width="200"
				rendererFn="fn_operation_format" />
		</aos:gridpanel>

		<aos:window id="storeWindow" title="新增上传记录" layout="fit"
			closable="true" width="500" height="160">
			<aos:formpanel id="storeForm" title="">
				<aos:hiddenfield id="storeId" name="id" />
				<aos:combobox id="myaccount" name="myaccount" fieldLabel="我的店铺"
					url="accountSelect.jhtml" width="400">
				</aos:combobox>
				<aos:textfield id="date1" name="date1" fieldLabel="日期" width="400"
					disabled="false" />
				<aos:filefield id="excel" name="excel" fieldLabel="上传excel文件"
					width="400"></aos:filefield>
				<aos:docked dock="bottom" ui="footer" margin="0 0 8 0">
					<aos:dockeditem xtype="tbfill" />
					<aos:dockeditem xtype="button" text="保存"
						onclick="save_excel_message()" icon="save.png" />
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
			var html = '<a href="downExcelfile.jhtml?path=' + record.data.path
					+ '">点击下载</a>';
			return html;
		}
		
		function fn_status_format(value, metaData, record, rowIndex, colIndex,
				store) {
			switch(record.data.status){
			    case "1":return "<span class=\"badge\" style=\"color:  #CD0000\">已发送</span>";
			    case "0":return "<span class=\"badge\" style=\"color:  #8DEEEE\">未发送</span>";
			}
			
		}

		/**
		 * 添加新的财务账单记录
		 */
		function add_store_api() {
			AOS.reset(storeForm);
			storeWindow.setTitle("上传新的excel文件");
			var date = new Date();
			var year = date.getYear() + 1900;
			var mouth = date.getMonth();
			if (mouth == 0) {
				mouth = 12;
				year = year - 1;
			}
			var mouth1 = mouth < 10 ? ("0" + mouth) : ("" + mouth);
			var year1 = year + "-" + mouth1;
			storeWindow.show();
			$("input[name='date1']").val(year1);
		}

		/**
		 * 保存财务上传记录
		 */
		function save_excel_message() {
			var date = date1.getValue();
			var account = myaccount.getValue();
			if (account == "") {
				AOS.err("店铺名不能为空");
				return;
			}
			var str = excel.getValue();
			if (!str.endWith(".xls")) {
				AOS.err("上传文件格式不符合");
				return;
			}
			var form = storeForm.getForm();
			AOS.wait();
			form.submit({
				url : 'file_uploading.jhtml?date1=' + date + "&account="
						+ account,
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

		String.prototype.endWith = function(str) {
			if (str == null || str == "" || this.length == 0
					|| str.length > this.length)
				return false;
			if (this.substring(this.length - str.length) == str)
				return true;
			else
				return false;
			return true;
		}
	</script>
</aos:onready>
</aos:html>