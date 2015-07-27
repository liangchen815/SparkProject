<%@ page language="java" import="java.util.*" contentType="text/html;"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>大数据分析平台</title>
</head>
<style type="text/css">
.menu_btn {
	margin: 10px 10px 10px 10px;
	width: 160px;
	height: 30px;
}

.menu_btn_selected {
	background-color: #999
}
</style>
<style>
* {
	/* padding: 0;
	margin: 0; */
	font-size: 20px;
}

.fl {
	float: left
}

.fr {
	float: right
}

.dn {
	display: none
}
/*日历 begin*/
.data_box {
	width: 260px;
}

.showDate {
	width: 160px;
	height: 30px;
	line-height: 30px;
	padding: 0 5px;
	border: 1px solid #e1e1e1;
	color: #999;
	display: block;
	cursor: pointer
}

.show_mn {
	text-align: center;
	padding: 0 20px;
}

.sel_date {
	margin-top: 1px;
	border: 1px solid #999;
	padding: 3px;
	position: fixed;
	width: 250px;
	background-color: white;
	z-index: 9;
}

.data_table {
	width: 100%;
	margin-top: 10px;
}

.data_table td {
	text-align: center;
	cursor: pointer;
	height: 24px;
	font-size: 14px;
}

.data_table td.active {
	color: #fff;
	background-color: #999
}

.data_table td.hover {
	color: blue;
}

.showDate2 {
	width: 35px;
	padding: 3px 5px;
	color: #999;
	border: 1px solid #e1e1e1;
	text-align: center
}

.showDate2.active {
	border: 1px solid #c50000;
}

.prev_m,.next_m {
	width: 10px;
	height: 22px;
	display: block;
	background-color: #0094ff;
	color: #fff;
	cursor: pointer;
	text-align: center;
	font: bold 12px/22px "宋体"
}

.prev_y,.next_y {
	width: 18px;
	height: 22px;
	display: block;
	background-color: #0094ff;
	color: #fff;
	cursor: pointer;
	text-align: center;
	font: bold 12px/22px "宋体";
	margin: 0 5px;
}

.title1 {
	font: bold 13px/40px "宋体";
	font-color: black;
}
/*日历 end*/
</style>
<!-- <script src="js/model.js" type="text/javascript"></script> -->
<script src="js/date.js" type="text/javascript"></script>
<script type="text/javascript">
	menu_click = function(menu_id) {
		for ( var i = 0; i < 4; i++) {
			var divInfo = document.getElementById('page' + (i + 1));
			var buttonInfo = document.getElementById('button' + (i + 1));
			divInfo.style.display = 'none';
			buttonInfo.style.color = "black";
		}
		var div = document.getElementById('page' + menu_id);
		var button = document.getElementById('button' + menu_id);
		div.style.display = 'block';
		button.style.color = "red";
		if (menu_id == 3) {
			var model = document.getElementById("model");
			model.src = 'model.jsp';
			var subWeb = document.frames ? document.frames["model"].document
					: model.contentDocument;
			if (model != null && subWeb != null) {
				model.height = subWeb.body.scrollHeight;
				model.width = subWeb.body.scrollWidth;
			}
		}
		if (menu_id == 4) {
			var model1 = document.getElementById("model1");
			model1.src = 'model.jsp';
			var subWeb1 = document.frames ? document.frames["model1"].document
					: model1.contentDocument;
			if (model1 != null && subWeb1 != null) {
				model1.height = subWeb1.body.scrollHeight;
				model1.width = subWeb1.body.scrollWidth;
			}
		}
	};
	
	function analysis(){
		document.getElementById("bb").setAttribute("src","http://192.168.77.1:4040");
	}
	
	var finished = false;
	window.onload = function() {

		var btn = document.getElementById("btn");//单输入
		var btn1 = document.getElementById("btn1");//多输入

		btn.onclick = function() {
			refresh();
			draw();
		};
		btn1.onclick = function() {
			var well,allwell;
			refresh();
			setTimeout(function() {
				well = frames['model1'].drawMultiplePoint();
				allwell=well[0]+well[1]+well[2]+well[3]+well[4];
				document.getElementById("IWellNum").setAttribute("value",well[0]);
				document.getElementById("IIWellNum").setAttribute("value",well[1]);
				document.getElementById("IIIWellNum").setAttribute("value",well[2]);
				document.getElementById("IVWellNum").setAttribute("value",well[3]);
				document.getElementById("VWellNum").setAttribute("value",well[4]);
				document.getElementById("AllWellNum").setAttribute("value",allwell);
				document.getElementById("IWellPer").setAttribute("value",(well[0]/allwell*100).toFixed(2)+"%");
				document.getElementById("IIWellPer").setAttribute("value",(well[1]/allwell*100).toFixed(2)+"%");
				document.getElementById("IIIWellPer").setAttribute("value",(well[2]/allwell*100).toFixed(2)+"%");
				document.getElementById("IVWellPer").setAttribute("value",(well[3]/allwell*100).toFixed(2)+"%");
				document.getElementById("VWellPer").setAttribute("value",(well[4]/allwell*100).toFixed(2)+"%");
				document.getElementById("AllWellPer").setAttribute("value","100%");
			}, 100);
		};

		function refresh() {
			var model1 = document.getElementById("model1");
			model1.src = 'model.jsp';
			finished = true;
		}
		function draw() {
			setTimeout(function() {
				var bengxiao = document.getElementById("bengxiao").value;
				var youya = document.getElementById("youya").value;
				frames['model1'].drawSinglePoint(bengxiao, youya);
			}, 1000);
		}

	}
</script>

<body style="font-size: 20px;width: 100%," onload="this.focus()">
	<table width=100% align=center border=1>
		<tr>
			<td height=600px width=20% align="center"><div>XX公司</div> <input
				type="button" id="button1" value="数据导入" class="menu_btn"
				onclick="menu_click(1)" /> <br /> <input type="button" id="button2"
				value="大数据分析" class="menu_btn" onclick="menu_click(2)" /> <br /> <input
				type="button" id="button3" value="分析结果展示" class="menu_btn"
				onclick="menu_click(3)" /> <br /> <input type="button" id="button4"
				value="智能决策" class="menu_btn" onclick="menu_click(4)" /> <br /></td>
			<td width=80%><div id="page1"
					style="display: block; float: left; width: 90%; position: relative;">

					<div style="margin-left: 40px; width: 100%; float: left;">
						<div style="width: 150px; float: left;">
							<label for="file" style="background-color:;">导入数据</label>
						</div>
						<div style="width: 325x; float: left;">
							<form name="form2" enctype="multipart/form-data" target="aa"
								method="post" action="UploadServlet">

								<input type="file" name="file" id="file"> <input
									type="submit" value="上传文件" />
							</form>
						</div>
						<iframe name="aa" src=""
							style="display: block; height: 100px; width: 300px;"></iframe>
					</div>

					<br />
					<div
						style="margin-top: 20px; margin-left: 40px; width: 100%; float: left;">
						<div style="width: 150px; float: left; margin-top: 5px;">
							<label for="database">导入数据库文件 </label>
						</div>
						<div style="width: 640px; float: left;">
							<form name="form1" method="post" action="">
								<div style="float: left; margin-top: 5px;">
									<select name="database" id="database">
										<option value="tuha">A</option>
										<option value="xinjiang">B</option>
									</select>
								</div>

								<!--  <div style="float:left"><label>起始时间</label></div> -->
								<div style="float: right; line-height: 1.5">
									<label>起始时间: </label>
									<!--日历 begin-->
									<div class="data_box" id="data_box"
										style="float: right; position: relative">
										<span class="showDate">2015-01-01</span>
										<div class="sel_date dn">
											<div class="clearfix">
												<span class="prev_y fl"><<</span><span class="prev_m fl"><</span>
												<span class="next_y fr">>></span><span class="next_m fr">></span>
												<div class="show_mn">
													<input type="text" class="showDate2 year" value="选择年份" />
													<span class="ml5 mr5">年</span> <input type="text"
														class="showDate2 month" value="选择月份" /> <span class="ml5">月</span>
												</div>
											</div>
											<table class="data_table">
												<thead>
													<tr>
														<td>日</td>
														<td>一</td>
														<td>二</td>
														<td>三</td>
														<td>四</td>
														<td>五</td>
														<td>六</td>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td>1</td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
													</tr>
													<tr>
														<td>1</td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
													</tr>
													<tr>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
													</tr>
													<tr>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
													</tr>
													<tr>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
													</tr>
													<tr>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
								</div>
								<!--日历 end-->
								<div style="float: left; height: 80px;"></div>
								<!--日历 begin-->
								<div style="float: right; line-height: 1.5">
									<label>结束时间: </label>
									<div class="data_box" id="data_box2"
										style="float: right; position: relative">
										<span class="showDate">2015-05-01</span>
										<div class="sel_date dn">
											<div class="clearfix">
												<span class="prev_y fl"><<</span><span class="prev_m fl"><</span>
												<span class="next_y fr">>></span><span class="next_m fr">></span>
												<div class="show_mn">
													<input type="text" class="showDate2 year" value="选择年份" />
													<span class="ml5 mr5">年</span> <input type="text"
														class="showDate2 month" value="选择月份" /> <span class="ml5">月</span>
												</div>
											</div>
											<table class="data_table">
												<thead>
													<tr>
														<td>日</td>
														<td>一</td>
														<td>二</td>
														<td>三</td>
														<td>四</td>
														<td>五</td>
														<td>六</td>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td>1</td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
													</tr>
													<tr>
														<td>1</td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
													</tr>
													<tr>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
													</tr>
													<tr>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
													</tr>
													<tr>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
													</tr>
													<tr>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
								</div>
								<!--日历 end-->
								<div style="float: right; width: 260px;">
									<input type="submit"
										style="margin-top: 10px; padding-left: 10px;" id="submite"
										value="确定" />
								</div>
								<div style="clear: both"></div>
							</form>
						</div>
					</div>
					<br />
				</div>
				<div id="page2" style="display: none">
				<div style="font-size: 25px">
						处理情况：
					</div>
					<form name="form3"  target="result"   method="post" action="ModelServlet" >
						<input type="submit" value="分析" target="bb"   onclick="analysis()"/>
					</form>
					<iframe id="bb" name="bb" src=""
						style="display: block; height: 500px; width: 100%;"></iframe>
						<iframe id="result" name="result" src=""
						style="display: block; height: 50px; width: 100%;"></iframe>
				</div>
				<div id="page3" style="display: none">
					<!-- <canvas height="400" width="600" onmousemove="pop_alert(event)"  id="c" style="border:1px solid #c3c3c3;"></canvas>
        <div id="xycoordinates"></div> -->
        			<div style="font-size: 25px">
						总体图
					</div>
					<iframe id="model" style="float: left"
						src="model.jsp"
						frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
					<ul style="float: left;list-style: none;margin-top: 180px">
						<li>I区</li>
						<li>II区</li>
						<li>III区</li>
						<li>IV区</li>
						<li>V区</li>
					</ul>
					
				</div>
				<div id="page4" style="display: none">
					<!--  单输入<br/>
        多输入<br/> -->
					<div style="width: 20%; float: left; height: 150px;">
						<label
							style="padding-left: 70px; padding-top: 70px; position: absolute">单输入</label>
					</div>
					<div style="width: 50%; float: left; height: 150px;">
						<div
							style="float: left; width: 50%; margin-top: 30px;">
							<label>A参数  </label><input type="text" id="bengxiao"
								style="width: 50px;" />
						</div>
						<div
							style="float: left; width: 50%; margin-top: 20px;">
							<label>B参数 </label><input type="text" id="youya"
								style="width: 50px;" />
						</div>
						<div style="float: right; width: 100%; margin-top: 20px;">
							<button id="btn">确定</button>
						</div>

					</div>
					<div style="width: 20%; float: left; height: 50px;">
						<label
							style="padding-left: 70px; padding-top: 25px; position: absolute">
							多输入</label>
					</div>
					<div style="width: 50%; float: left; height: 50px; padding-top: 25px;">
						<form name="form3" enctype="multipart/form-data" target="xx" method="post"
							action="DownloadServlet">
							<input type="file" name="datafile" id="datafile"> <input
								type="submit" value="上传文件" />
						</form>
						<iframe id="xx" name="xx" style="display: none;"></iframe>
					</div>
					<div style=" width: 30%; float: left; height: 50px;  padding-top: 25px; ">
						<button id="btn1" >分析</button>
					</div>
					<div style="width: 80%; float: right " >
						<iframe id="model1" name="model1"
							src="model.jsp"
							frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
					</div>
					<div style="width: 100%; float: left; height: 200px; margin-top: 10px">
						<table width="100%" border="1">
  <caption style="font-size: 27px;">
    总体图
  </caption>
  <tr>
    <th scope="col">范围</th>
    <th scope="col">个数</th>
    <th scope="col">百分比</th>
    <th scope="col">范围</th>
    <th scope="col">个数</th>
    <th scope="col">百分比</th>
  </tr>
  <tr>
    <td>I区</td>
    <td><input id="IWellNum" name="IWellNum" type="text" value="0" readonly></td>
    <td><input id="IWellPer"  name="IWellPer" type="text" value="0" readonly></td>
    <td>II区</td>
    <td><input id="IIWellNum" name="IIWellNum" type="text" value="0" readonly></td>
    <td><input id="IIWellPer"  name="IIWellPer" type="text" value="0" readonly></td>
  </tr>
  <tr>
    <td>III区</td>
 	<td><input id="IIIWellNum" name="IIIWellNum" type="text" value="0" readonly></td>
    <td><input id="IIIWellPer"  name="IIIWellPer" type="text" value="0" readonly></td>
    <td>IV区</td>
    <td><input id="IVWellNum" name="IVWellNum" type="text" value="0" readonly></td>
    <td><input id="IVWellPer"  name="IVWellPer" type="text" value="0" readonly></td>
  </tr>
  <tr>
    <td>V区</td>
    <td><input id="VWellNum" name="VWellNum" type="text" value="0" readonly></td>
    <td><input id="VWellPer"  name="VWellPer" type="text" value="0" readonly></td>
    <td>总井数</td>
    <td><input id="AllWellNum" name="AllWellNum" type="text" value="0" readonly></td>
    <td><input id="AllWellPer"  name="AllWellPer" type="text" value="0" readonly></td>
  </tr>
</table>
					</div>
				</div>
		</tr>
	</table>

</body>
</html>