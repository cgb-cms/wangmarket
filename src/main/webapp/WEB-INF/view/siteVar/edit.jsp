<%@page import="com.xnx3.j2ee.Global"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../iw/common/head.jsp">
	<jsp:param name="title" value="编辑全局变量"/>
</jsp:include>
<script src="/<%=Global.CACHE_FILE %>SiteVar_type.js"></script>

<form id="form" class="layui-form" action="save.do" method="post" style="padding-top:20px; padding-right:20px;">
	<input type="hidden" name="updateName" value="${siteVar.name }">
	<div class="layui-form-item">
		<label class="layui-form-label" id="columnCode">变量名</label>
		<div class="layui-input-block">
			<input type="text" name="name" lay-verify="name" autocomplete="off" placeholder="请输入变量名" class="layui-input" value="${siteVar.name }">
		</div>
		<div class="layui-form-mid" style="margin-left: 110px;line-height: 14px; color: gray; font-size: 12px; padding-top:0px;">同一个网站中，变量名必须是唯一的,限英文、数字、下划线_<br/>在制作模板时，也就是在模板变量跟模板页面中，可以用 {var.${siteVar.name }} 来调取变量值</div>
	</div>
	<div class="layui-form-item">
		<label class="layui-form-label" id="columnCode">标题</label>
		<div class="layui-input-block">
			<input type="text" name="title" class="layui-input" value="${siteVar.title}">
		</div>
		<div class="layui-form-mid" style="margin-left: 110px;line-height: 14px; color: gray; font-size: 12px; padding-top:0px;">实际给客户使用时，会隐藏变量名，这个标题就是显示给用户看的录入项的标题</div>
	</div>
	<div class="layui-form-item">
		<label class="layui-form-label" id="columnCode">录入方式</label>
		<div class="layui-input-block">
			<script type="text/javascript">writeSelectAllOptionFortype_('${siteVar.type}','', true);</script>
		</div>
		<div class="layui-form-mid" style="margin-left: 110px;line-height: 14px; color: gray; font-size: 12px; padding-top:0px;">用户填写此变量的方式</div>
	</div>
	<div class="layui-form-item" id="valueItemsFormItem">
		<label class="layui-form-label" id="columnCode">下拉数值</label>
		<div class="layui-input-block">
			<textarea name="valueItems" onchange="showVarValue('select');" id="valueItems" autocomplete="off" class="layui-textarea">${siteVar.valueItems }</textarea>
		</div>
		<div class="layui-form-mid" style="margin-left: 110px;line-height: 14px; color: gray; font-size: 12px; padding-top:0px;">下拉选择框的可选项，每个选项一行，填写如：<br/>
			<div>
				0:关闭<br/>
				1:开启
			</div> 
			每行格式的含义为  变量的值:用户看到的文字说明
		</div>
	</div>
	<div class="layui-form-item">
		<label class="layui-form-label" id="description_label">备注说明</label>
		<div class="layui-input-block">
			<textarea name="description" lay-verify="description" autocomplete="off" placeholder="限200个字符以内" class="layui-textarea">${siteVar.description }</textarea>
		</div>
		<div class="layui-form-mid" style="margin-left: 110px;line-height: 14px; color: gray; font-size: 12px; padding-top:0px;">只是备注而已，没有什么其他作用。修改的时候看到这个，能直到这是干嘛的</div>
	</div>
	<div class="layui-form-item">
		<label class="layui-form-label" id="keywords_label">变量值</label>
		<div class="layui-input-block" id="var_value_div">
			<textarea name="value" lay-verify="value" autocomplete="off" class="layui-textarea">${siteVar.value }</textarea>
		</div>
	</div>
  
	  <div class="layui-form-item" style="text-align:center;">
	  	<button class="layui-btn" lay-submit="" lay-filter="demo1">保存</button>
	  </div>
</form>

<div id="varValue" style="display:none;">${siteVar.value }</div>
<script>

layui.use(['element', 'form', 'layedit', 'laydate'], function(){
  var form = layui.form;
  var element = layui.element;
  
  //自定义验证规则
  form.verify({
    name: function(value){
      if(value.length < 1){
      	return '请输入变量名';
      }
		if(/^[a-zA-Z0-9_]*$/g.test(value)){
			//success
		}else{
			return '变量名只限英文、数字、下划线_';
		}
    },
  });
  
  //监听提交
  form.on('submit(demo1)', function(data){
		parent.parent.msg.loading('保存中');
		var d=$("form").serialize();
        $.post("/siteVar/save.do", d, function (result) { 
        	parent.msg.close();
        	var obj = JSON.parse(result);
        	if(obj.result == '1'){
        		parent.parent.msg.success("保存成功");
        		parent.location.reload();
        	}else if(obj.result == '0'){
        		parent.parent.msg.failure(obj.info);
        	}else{
        		parent.parent.msg.failure(result);
        	}
         }, "text");
		
    return false;
  });
  
  	//当类型发生变动改变
	form.on('select(type)', function (data) {
		showVarValue(document.getElementById("type").value);
	});
  
});

//获取当前select的可选值
function getValueItems(){
	var v = document.getElementById('valueItems').value;
	return v.split(/[\s\n]/);
}

//显示变量值的方式
function showVarValue(ctype){
	var currentValue = document.getElementById('varValue').innerHTML;
	document.getElementById('valueItemsFormItem').style.display = 'none';	//默认隐藏
	
	if(ctype == 'image'){
		
		layui.use('upload', function(){
			var upload = layui.upload;
			//上传图片,封面图
			upload.render({
				elem: "#uploadImagesButton" //绑定元素
				,url: '/sites/uploadImage.do' //上传接口
				,field: 'image'
				,accept: 'file'
				,size: ${maxFileSizeKB}
				,exts:'${ossFileUploadImageSuffixList }'	//可上传的文件后缀
				,done: function(res){
					//上传完毕回调
					parent.parent.msg.close();
					if(res.result == 1){
						try{
							document.getElementById("titlePicInput").value = res.url;
							document.getElementById("titlePicA").href = res.url;
							document.getElementById("titlePicImg").src = res.url;
							document.getElementById("titlePicImg").style.display='';	//避免新增加的文章，其titlepicImg是隐藏的
						}catch(err){}
						parent.parent.msg.success("上传成功");
					}else{
						parent.parent.msg.failure(res.info);
					}
				}
				,error: function(index, upload){
					//请求异常回调
					parent.parent.msg.close();
					parent.parent.msg.failure('操作异常');
				}
				,before: function(obj){ //obj参数包含的信息，跟 choose回调完全一致，可参见上文。
					parent.parent.msg.loading('上传中');
				}
			});
			
			//上传图片,图集，v4.6扩展
			//upload.render(uploadExtendPhotos);
		});
		
		var text = '<input name="value" id="titlePicInput" type="text" autocomplete="off" placeholder="点击右侧添加" class="layui-input" value="'+currentValue+'" style="padding-right: 120px;"><button type="button" class="layui-btn" id="uploadImagesButton" style="float: right;margin-top: -38px;">	<i class="layui-icon layui-icon-upload"></i></button><a href="'+currentValue+'" id="titlePicA" style="float: right;margin-top: -38px;margin-right: 60px;" title="预览原始图片" target="_black">	<img id="titlePicImg" src="'+currentValue+'?x-oss-process=image/resize,h_38" onerror="this.style.display=\'none\';" style="height: 36px;max-width: 57px; padding-top: 1px;" alt="预览原始图片"></a><input class="layui-upload-file" type="file" name="fileName">';	
		document.getElementById('var_value_div').innerHTML = text;
	}else if(ctype == 'select'){
		document.getElementById('valueItemsFormItem').style.display = '';	//显示编辑项
		try{
			var optionList = '';
			var s = getValueItems();
			for(var i = 0; i< s.length; i++){
				var vs = s[i].split(":");
				var sel = '';
				if(currentValue==vs[0]){
					sel = ' selected="selected"';
				}
				optionList = optionList + '<option value="'+vs[0]+'"' +sel+'>'+vs[1]+'</option>'; 
			}
			document.getElementById('var_value_div').innerHTML = '<select name="value">'+optionList+'</select>';
		}catch(e){
			console.log(e);
			document.getElementById('var_value_div').innerHTML = '下拉数值格式填写错误，解析失败';
		}
	}else if(ctype == 'number'){
		//number输入方式
		document.getElementById('var_value_div').innerHTML = '<input type="number" name="value" value="'+currentValue+'" class="layui-input" />';
	}else{
		//text方式
		document.getElementById('var_value_div').innerHTML = '<textarea name="value" lay-verify="value" autocomplete="off" class="layui-textarea">'+currentValue+'</textarea>';
	}
	
	layui.use('form', function(){
		layui.form.render();;
	});
}
showVarValue('${siteVar.type}');
</script>

<jsp:include page="../iw/common/foot.jsp"></jsp:include>