<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <script type="text/javascript" src="https://rerubx.zwjk.com/v1.3.0/jquery.min.js"></script>
    <title></title>
</head>
<body>
    
    <div>
        院区列表:<input type="text" disabled="disabled" value="branchList"/>&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" value="保存数据" onclick="save('branchList')"/><br/>
        <textarea id="branchList" cols="50" rows="10"></textarea>
    </div>
    <div>
        病区列表:<input type="text" disabled="disabled" value="wardList"/>&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" value="保存数据" onclick="save('wardList')"/><br/>
        <textarea id="wardList" cols="50" rows="10"></textarea>
    </div>
    <div>
        病人列表:<input type="text" disabled="disabled" value="patientList"/>&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" value="保存数据" onclick="save('patientList')"/><br/>
        <textarea id="patientList" cols="50" rows="10"></textarea>
    </div>
    <#--<div>
        医院-院区关系:<input type="text" disabled="disabled" value="relationHospitalAndBranch"/>
        <input type="button" value="保存数据" onclick="save('relationHospitalAndBranch')"/><br/>
        <textarea id="relationHospitalAndBranch" cols="50" rows="10"></textarea>
    </div>
    <div>
        院区-病区关系:<input type="text" disabled="disabled" value="relationBranchAndWard"/>&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" value="保存数据" onclick="save('relationBranchAndWard')"/><br/>
        <textarea id="relationBranchAndWard" cols="50" rows="10"></textarea>
    </div>-->
    <div>
        病区-病人关系:<input type="text" disabled="disabled" value="relationWardAndPatient"/>&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" value="保存数据" onclick="save('relationWardAndPatient')"/><br/>
        <textarea id="relationWardAndPatient" cols="50" rows="10"></textarea>
    </div>
    <div>
        记录列表:<input type="text" disabled="disabled" value="allRecordList"/>&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" value="保存数据" onclick="save('allRecordList')"/><br/>
        <textarea id="allRecordList" cols="50" rows="10"></textarea>
    </div>
    <#--<div>
        二级记录列表:<input type="text" disabled="disabled" value="secondaryRecordList"/>&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" value="保存数据" onclick="save('secondaryRecordList')"/><br/>
        <textarea id="secondaryRecordList" cols="50" rows="10"></textarea>
    </div>-->
    <div>
        记录详情:<input type="text" disabled="disabled" value="recordDetails"/>&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" value="保存数据" onclick="save('recordDetails')"/>
        <#--<input id="init" type="button" value="初始化病程记录数据" onclick="initConfig('progressNoteInfo')"/>--><br/>
        <textarea id="recordDetails" cols="50" rows="10"></textarea>
    </div>

    <div>
        患者费用清单日期列表:<input type="text" disabled="disabled" value="patientAndDate"/>&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" value="保存数据" onclick="save('patientAndDate')"/><br/>
        <textarea id="patientAndDate" cols="50" rows="10"></textarea>
    </div>

    <div>
        费用清单详细:<input type="text" disabled="disabled" value="feeInfo"/>&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" value="保存数据" onclick="save('feeInfo')"/><br/>
        <textarea id="feeInfo" cols="50" rows="10"></textarea>
    </div>

</body>
</html>

<script>

    function save(key){
        var txt = $("#"+ key).val();

        if(/^\s*$/.test(txt)){
            alert('数据为空,无法格式化! ');
            return;
        }
        try{var data = eval('('+txt+')');}
        catch(e){
            alert('数据源语法错误,格式化失败! 错误信息: '+e.description,'err');
            return;
        };
        $.ajax({
            type: "post",
            dataType: "json",
            url: '/configs/setConfig',
            data: {key:key,value:$("#" + key).val()},
            success: function (data,status) {
                if (status == "success") {
                    alert("保存成功");
                }else{
                    alert("保存失败");
                }
            }
        });
    }

    function format(txt,compress/*是否为压缩模式*/){/* 格式化JSON源码(对象转换为JSON文本) */
        var indentChar = '    ';
        if(/^\s*$/.test(txt)){
            alert('数据为空,无法格式化! ');
            $("#content").text('');
            return;
        }
        try{var data=eval('('+txt+')');}
        catch(e){
            alert('数据源语法错误,格式化失败! 错误信息: '+e.description,'err');
            return;
        };
        var draw=[],last=false,This=this,line=compress?'':'\n',nodeCount=0,maxDepth=0;

        var notify=function(name,value,isLast,indent/*缩进*/,formObj){
            nodeCount++;/*节点计数*/
            for (var i=0,tab='';i<indent;i++ )tab+=indentChar;/* 缩进HTML */
            tab=compress?'':tab;/*压缩模式忽略缩进*/
            maxDepth=++indent;/*缩进递增并记录*/
            if(value&&value.constructor==Array){/*处理数组*/
                draw.push(tab+(formObj?('"'+name+'":'):'')+'['+line);/*缩进'[' 然后换行*/
                for (var i=0;i<value.length;i++)
                    notify(i,value[i],i==value.length-1,indent,false);
                draw.push(tab+']'+(isLast?line:(','+line)));/*缩进']'换行,若非尾元素则添加逗号*/
            }else   if(value&&typeof value=='object'){/*处理对象*/
                draw.push(tab+(formObj?('"'+name+'":'):'')+'{'+line);/*缩进'{' 然后换行*/
                var len=0,i=0;
                for(var key in value)len++;
                for(var key in value)notify(key,value[key],++i==len,indent,true);
                draw.push(tab+'}'+(isLast?line:(','+line)));/*缩进'}'换行,若非尾元素则添加逗号*/
            }else{
                if(typeof value=='string')value='"'+value+'"';
                draw.push(tab+(formObj?('"'+name+'":'):'')+value+(isLast?'':',')+line);
            };
        };
        var isLast=true,indent=0;
        notify('',data,isLast,indent,false);
        return draw.join('');
    }

</script>
