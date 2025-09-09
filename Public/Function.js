function disableFuncKey(event) {
    var bIn = false;
    var i = 0;
    for (i = 0; i < disKeys.length; i++) {
        if (disKeys[i] == event.keyCode) {
            bIn = true;
            break;
        }
    }
    if (!bIn && event.ctrlKey) {
        for (i = 0; i < disCtrKeys.length; i++) {
            if (disCtrKeys[i] == event.keyCode) {
                bIn = true;
                break;
            }
        }
    }
    if (!bIn && event.altKey) {
        for (i = 0; i < disAltKeys.length; i++) {
            if (disAltKeys[i] == event.keyCode) {
                bIn = true;
                break;
            }
        }
    }
    if (bIn) {
        event.preventDefault();
        event.stopPropagation();
        return false;
    }
}

function disableTextSelection() {
    if (typeof document.onselectstart != "undefined") {
        document.onselectstart = disableSelection;
    } else {
        document.onmousedown = disableSelection;
        document.onmouseup = disableSelection;
    }
    document.oncontextmenu = disableSelection;
}

function disableSelection(event) {
    event.preventDefault();
    return false;
}

function GetSelectIndex(obj) {
    var iSel = -1;
    var iItems = obj.options.length;
    for (var i = 0; i < iItems; i++) {
        if (obj.options[i].selected) {
            iSel = i;
            break;
        }
    }
    return iSel;
}

function GetSort(sListBox) {
    var sSort = "";
    var obj = document.getElementById(sListBox);
    var iItems = obj.options.length;
    for (var i = 0; i < iItems; i++) {
        sSort += "[" + obj.options[i].value + "]";
    }
    return sSort;
}

function MoveListItem(sListBox, sType) {
    var obj = document.getElementById(sListBox);
    if (obj == null)
        return;
    var iSel = GetSelectIndex(obj);
    var iDis = iSel;
    if (sType == "1")
        iDis--;
    else
        iDis++;
    if (iDis < 0 || iDis >= obj.options.length)
        return;
    var sValue = obj.options[iSel].value;
    var sText = obj.options[iSel].text;
    obj.options[iSel].value = obj.options[iDis].value;
    obj.options[iSel].text = obj.options[iDis].text;
    obj.options[iSel].selected = false;
    obj.options[iDis].value = sValue;
    obj.options[iDis].text = sText;
    obj.options[iDis].selected = true;
    SetHtmlValue("workflag", "V", "btSort");
    SetHtmlValue("lbOperate", "T", "调整排序");
    DisableControl();
}

function disableRight() {
	if (IsModiAccredit() == 0) {
		SetHtmlValue("workflag", "V", "ARightModify");
		SetHtmlValue("lbOperate", "T", "授权变更");
	}
	else {
		SetHtmlValue("workflag", "V", "");
		SetHtmlValue("lbOperate", "T", "");
	}
	DisableControl();
}

function MPermission(object, sPermission, sType)
{
	if (object.checked)
		AddAccValue("hRel" + sType, "hAdd" + sType, "[" + sPermission + "]");
	else
		AddAccValue("hAdd" + sType, "hRel" + sType, "[" + sPermission + "]");
	disableRight();
}

function AddAccValue(sSource, sDist, sValue) {
    var sSourceValue = GetHtmlValue(sSource,"V");
    var sDistValue = GetHtmlValue(sDist, "V");
    if (sDistValue.indexOf(sValue) >= 0)
        return;
    if (sSourceValue.indexOf(sValue) >= 0)
        sSourceValue = sSourceValue.replace(sValue, "");
    else
        sDistValue = sDistValue + sValue;
    SetHtmlValue(sSource,"V",sSourceValue);
    SetHtmlValue(sDist,"V", sDistValue);
}

function GetSessionItem(sKey)
{
    if (sessionStorage)
        return sessionStorage.getItem(sKey);
    return "";
}

function Calendar(obj, iLevel) {
    var sUrl = "";
    for (var i = 0; i < iLevel; i++)
        sUrl += "..\\";
    sUrl += "Public\\OpenWindow.aspx?PWORK=CALENDAR";
    var str = window.showModalDialog(sUrl, '', "dialogWidth=264px;dialogHeight=264px;center=yes;help=no;status=no");
    if (str != null && str != "")
        obj.value = str;
}

function SelTree(sOperate, sCondi, iLevel)
{
	var sUrl = "";
	for (var i = 0; i < iLevel; i ++)
		sUrl += "..\\";
	sUrl += "Public\\SelectDepartment.aspx?PTYPE=" + sOperate + "&PCOND=" + sCondi + "&t=" + (new Date().getTime());
	var str = window.showModalDialog(sUrl,'', "dialogWidth=380px;dialogHeight=560px;center=yes;help=no;status=no");
	return str;
}

function SelPerson(sOrganize,sType,iLevel)
{
	var sUrl = "";
	for (var i = 0; i < iLevel; i ++)
		sUrl += "..\\";
	sUrl += "Public\\WinOpenMain.aspx?PWORK=";
	if (sType == "1")
		sUrl += "SELEMPLOYEE";
	else
		sUrl += "SELPERSON&PLB=" + sType;
	sUrl += "&PID=" + sOrganize + "&t=" + (new Date().getTime());
	var str = window.showModalDialog(sUrl,'', "dialogWidth=460px;dialogHeight=540px;center=yes;help=no;status=no");
	return str;
}

function SelMulti(sType,sCondi,sSort,sKey,iLevel)
{
	var sUrl = "";
	for (var i = 0; i < iLevel; i ++)
		sUrl += "..\\";
	sUrl += "Public\\MultiSelect.aspx?PTYPE=" + sType + "&PCONDI=" + sCondi + "&PSORT=" + sSort + "&PKEY=" + sKey + "&t=" + (new Date().getTime());
	var str = window.showModalDialog(sUrl,'', "dialogWidth=480px;dialogHeight=560px;center=yes;help=no;status=no");
	return str;
}

//DataGrid全选
function SelectAll(sList,sCheck,chkAll)
{
	var dgList = document.getElementById("dgList");
	if (dgList != null)
	{
		for(var i = 2; i < dgList.rows.length + 1; i ++)
		{
			var e = document.getElementById(sList + "__ctl" + i + "_" + sCheck);
			if (e != null && e.disabled == false)
				e.checked = chkAll.checked;
		}
	}
}

//
function saveFile(sContext, sFileName) {
    if (sContext != "") {
        var winn = window.open('', '_blank', '');
        winn.document.open('text/html', 'replace');
        winn.document.write("<html><head><title></title></head><body>" + sContext + "</body></html>");
        winn.document.execCommand('saveas', '', sFileName);
        winn.close();
    }
}

//
function PrintHtml(sContext) {
    var winn = window.open('', '_blank', '');
    winn.document.open('text/html', 'replace');
    winn.document.write(sContext);
    winn.print();
}

//取消操作
function ACancelModifyClick(obj)
{
	if (obj.disabled == true)
		return;
	if (window.confirm("您确定要取消变更吗？"))
	{
		SetHtmlValue("workflag","V","CancelModify");
		FormSubmit();
	}
}
			
//提交操作
function ASubmitModifyClick(obj)
{
	if (obj.disabled == true)
		return;
	if (CheckData() == 1)
	{
		if (window.confirm("您确定要" + document.getElementById("lbOperate").innerText + "吗？"))
			FormSubmit();
	}
}

//控制按钮点击
function btNormalClick(vObject)
{
	SetHtmlValue("workflag","V",vObject.id);
	DisableControl();
}

//直接提交按钮
function btSubmitClick(vObject,bAlert)
{
	if (vObject.disabled == false)
	{
	    var sName = "";
	    var attri = vObject.attributes.getNamedItem("data-title");
	    if (attri != null)
	        sName = attri.value;
	    SetHtmlValue("workflag", "V", vObject.id);
		if (CheckData() == 1)
		{
			if (bAlert)
			    bAlert = window.confirm("您确定要执行" + sName + "吗？");
			else
				bAlert = true;
			if (bAlert)
				FormSubmit();
			else
				SetHtmlValue("workflag","V","");
		}
	}
}

//焦点设置于末尾
function EndFocus()
{
	var e = event.srcElement;
	var r =e.createTextRange();
	r.moveStart('character',e.value.length);
	r.collapse(true);
	r.select();
}			

//回车相当于tab

function KeyDown()
{
	var keycode=event.keyCode;
	if (keycode==13)
	{
		event.keyCode=9;
	}
}


function RTrim(sValue)
{
    if (sValue != null)
        return sValue.replace(/(\s+$)/g, "");
    return sValue;
}

//取控件值，右去空格
function GetHtmlValue(sObject, sType) {
    var obj = document.getElementById(sObject);
    var sValue = "";
    if (obj != null) {
        var attri = obj.attributes.getNamedItem(sType);
        if (attri != null)
            sValue = attri.value;
        if (sType == "V" || sType == "v")
            sValue = obj.value;
        if (sType == "H" || sType == "h")
            sValue = obj.innerHTML;
        if (sType == "T" || sType == "t")
            sValue = obj.innerText;
    }
    return RTrim(sValue);
}

function SetHtmlValue(sObject, sType ,sValue) {
    var obj = document.getElementById(sObject);
    if (obj != null) {
        if (sType == "V" || sType == "v")
            obj.value = sValue;
        if (sType == "H" || sType == "h")
            obj.innerHTML = sValue;
        if (sType == "T" || sType == "t")
            obj.innerText = sValue;
    }
}

function ChangeHtmlValue(sObject1, sObject2, sType) {
    var obj1 = document.getElementById(sObject1);
    var obj2 = document.getElementById(sObject2);
    var sValue = "";
    if (obj1 != null && obj2 != null) {
        if (sType == "V")
        {
            sValue = obj1.value;
            obj1.value = obj2.value;
            obj2.value = sValue;
        }
        else
        {
            sValue = obj1.innerText;
            obj1.innerText = obj2.innerText;
            obj2.innerText = sValue;
        }
    }
}


//是否为空
function IsNull(myTitle,myObject,bFocus,sType)
{
	var blJudge = 1;
	var sValue = GetHtmlValue(myObject, "V");
	if (RTrim(sValue) == "")
	{	
		alert(myTitle+"不能为空，请输入！");
	    var obj = document.getElementById(myObject);
		if (bFocus && obj != null)
			obj.focus();
		blJudge = 0;
	}
	return blJudge;
}

//是否为空选择
function IsNullCheck(myTitle,myCheck,iCount)
{
	var blJudge = 1;
	var i = 1;
	for (; i <= iCount; i ++)
	{
		if (document.getElementById(myCheck + i).checked == true)
			break;
	}
	if (i > iCount)
	{
		alert("请选择" + myTitle);
		blJudge = 0;
	}
	
	return blJudge;
}

//是否为数字
function IsNumber(myTitle,myObject,bFocus,sType)
{
	var blJudge = 1;
	var obj = document.getElementById(myObject);
	var sValue = "";
	if (obj != null)
	{
		sValue = obj.innerText;
		if (sType == "V")
			sValue = obj.value;
	}
	
	if (String(Number(sValue)) == "NaN" || RTrim(sValue) == "")
	{
		alert(myTitle+"必须为数字，请修改！");
		if (bFocus && obj != null)
			obj.focus();
		blJudge=0;
	}
	return blJudge;
}

function IsNum(sNum)
{
	var blJudge = 1;
	if (sNum.length > 0 && String(Number(sNum)) == "NaN")
		blJudge=0;
	return blJudge;
}

//是否为时间(YYYY-MM-DD)
function IsDate(myTitle,myObject)
{
	var blJudge = 1;
	
	var sDate = myObject.value;
	
	if (sDate.length == 0)  return blJudge=0;
	
	sMessage = myTitle + "必须是时间格式(YYYY-MM-DD)，请修改！";
	
	if (sDate.length != 10)
	{
		alert(sMessage);
		myObject.focus();
		blJudge=0;
	
	}
	else
	{
		if ((String(Number(sDate.substring(0,4))) == "NaN") || (String(Number(sDate.substring(5,7))) == "NaN") 
			|| (String(Number(sDate.substring(8,10))) == "NaN"))
		{
			alert(sMessage);
			myObject.focus();
			blJudge=0;
		}
	}
	
	return blJudge;
}

//是否为时间(YYYY-MM-DD HH:mm:ss)
function IsDateTime(myTitle,myObject)
{
	var blJudge = 1;
	
	var sDate = myObject.value;
	
	if (sDate.length == 0)  return blJudge=0;
	
	sMessage = myTitle + "必须是时间格式(YYYY-MM-DD HH:mm:ss)，请修改！";
	
	if (sDate.length != 19)
	{
		alert(sMessage);
		myObject.focus();
		blJudge=0;
	
	}
	else
	{
		
		if ((String(Number(sDate.substring(0,4))) == "NaN") || (String(Number(sDate.substring(5,7))) == "NaN") 
			|| (String(Number(sDate.substring(8,10))) == "NaN") || (String(Number(sDate.substring(11,13))) == "NaN")
			|| (String(Number(sDate.substring(14,16))) == "NaN") || (String(Number(sDate.substring(17,19))) == "NaN")
			|| (sDate.substring(13,14) != ":") || (sDate.substring(16,17) != ":"))
		{
			alert(sMessage);
			myObject.focus();
			blJudge=0;
		}
	}
	
	return blJudge;
}

//比较时间
function DateDiff(myDate1,myDate2)
{
	var blJudge = 0;
	
	var sDate1 = myDate1.value;
	var sDate2 = myDate2.value;
	
	var year1 = Number(sDate1.substring(0,4));
	var month1 =Number(sDate1.substring(5,7));
	var day1 = Number(sDate1.substring(8,10));
	
	var year2 = Number(sDate2.substring(0,4));
	var month2 =Number(sDate2.substring(5,7));
	var day2 = Number(sDate2.substring(8,10));
	
	if (year1 > year2)
	{
		blJudge = 1
	}
	else if (year1 < year2)
	{
		blJudge = -1;
	}
	else
	{
		if (month1 > month2)
		{
			blJudge = 1;
		}
		else if(month1 < month2)
		{
			blJudge = -1;
		}
		else
		{
			if (day1 > day2)
			{
				blJudge = 1;
			}
			else if (day1 < day2)
			{
				blJudge = -1;
			}
		}
	}	
	
	return blJudge;
}


//验证是否长度符合
function CheckLength(myTitle,ilength,myObject)
{
	var blJudge = 1;

	var sData = myObject.value;
	
	var sMessage = myTitle + "长度必须为" + ilength +"位，请修改！"
	
	if (sData.length != ilength || sData.length == 0)
	{
		alert(sMessage);
		myObject.focus();
		blJudge=0;
	}
	return blJudge;
}

//比较时间
function DateDiffA(sDate1,sDate2)
{
	var blJudge = 0;

	var year1 = Number(sDate1.substring(0,4));
	var month1 =Number(sDate1.substring(5,7));
	var day1 = Number(sDate1.substring(8,10));
	
	var year2 = Number(sDate2.substring(0,4));
	var month2 =Number(sDate2.substring(5,7));
	var day2 = Number(sDate2.substring(8,10));
	
	if (year1 > year2)
	{
		blJudge = 1
	}
	else if (year1 < year2)
	{
		blJudge = -1;
	}
	else
	{
		if (month1 > month2)
		{
			blJudge = 1;
		}
		else if(month1 < month2)
		{
			blJudge = -1;
		}
		else
		{
			if (day1 > day2)
			{
				blJudge = 1;
			}
			else if (day1 < day2)
			{
				blJudge = -1;
			}
		}
	}	
	
	return blJudge;
}

//判断对象是否为空
function IsObjectNull(element)
{
	if(element==null || element == "undefined")
	    return true;
	else
	    return false;
}

//判断对象是否为  CheckBox
function IsCheckBox(element)
{
	if(IsObjectNull(element))
	    return false;
	    
	if(element.tagName!="INPUT" || element.type!="checkbox")
	    return false;
	else
	    return true;
}

//------------鼠标经过时-----------
function OnFoucsMouseOver( obj,fontColor,backColor )
{
 if ( obj.rowIndex > 0 )
 {
  obj.style.color = fontColor;
  obj.style.backgroundColor = backColor;
 }
}

//-----------鼠标离开时-----------
function FoucsMouseOut( obj,clickIndex,fontColor,backColor )
{
	if ( obj.rowIndex > 0 && obj.rowIndex != document.getElementById(clickIndex).value)
	{
		obj.style.color = fontColor;
		obj.style.backgroundColor = backColor;
	}
}

function FoucsMouseClick(obj,clickIndex,dataGrid,fontColor,backColor,oldColor)
{
	var oDG = document.getElementById(dataGrid);
	if (oDG == null)
		return;
	if (oDG.disabled)
		return;
	var oldIndex = document.getElementById(clickIndex).value;
	if (oldIndex != "")
	{
		oDG.rows[oldIndex].style.color = fontColor;
		oDG.rows[oldIndex].style.backgroundColor = oldColor;
	}
	if (obj != null && obj.rowIndex > 0 )
	{
		obj.style.color = fontColor;
		obj.style.backgroundColor = backColor;
		document.getElementById(clickIndex).value = obj.rowIndex;
	}
	else
		document.getElementById(clickIndex).value = "";
}

function SelectDGItem(sIndex,sDataGrid)
{
	var oInd = document.getElementById(sIndex);
	if (oInd == null)
		return;
	if (oInd.value != "")
	{
		var oDG = document.getElementById(sDataGrid);
		oDG.rows[oInd.value].style.color = "#003399";
		oDG.rows[oInd.value].style.backgroundColor = "Silver";
	}
}

//选择树
function SelItem(sFirst,sType,sValue,sKey,iLevel)
{
	var str = SelTree(sFirst,sType,iLevel);
	if(str != null)  
	{
		var ssA;					
		ssA  = str.split("$");
		if (document.getElementById(sKey) != null)
			document.getElementById(sKey).value =ssA[0];
		if (document.getElementById(sValue) != null)
			document.getElementById(sValue).innerText =ssA[1];
	}			
}
//
function SelItemCommit(sFirst,sType,sValue,sKey,iLevel,sCommand)
{
	var str = SelTree(sFirst,sType,iLevel);
	if(str != null)  
	{
		var ssA;					
		ssA  = str.split("$");
		if (document.getElementById(sValue) != null)
			document.getElementById(sValue).innerText =ssA[1];
		if (document.getElementById(sKey) != null)
		{
			if (document.getElementById(sKey).value != ssA[0])
			{	
				document.getElementById(sKey).value =ssA[0];
				SetHtmlValue("workflag","V",sCommand);
				FormSubmit();
			}
		}
	}			
}
//
function SelItemControl(sFirst,sType,sValue,sKey,iLevel)
{
	var str = SelTree(sFirst,sType,iLevel);
	if(str != null)  
	{
		var ssA;					
		ssA  = str.split("$");
		if (document.getElementById(sKey) != null)
			document.getElementById(sKey).value = ssA[0];
		var oSelValue = document.getElementById(sValue);
		if (oSelValue != null)
		{
			oSelValue.innerText =ssA[1];
			if (ssA[0] != "")
				oSelValue.disabled = false;
			else
				oSelValue.disabled = true;
		}
	}			
}

//多选
function SelMultiItem(sType,sCondi,sSort,sValue,sKey,iLevel)
{
	var sSelKey = "";
	var oSelKey = document.getElementById(sKey);
	if (oSelKey != null)
		sSelKey = oSelKey.value;
	var str = SelMulti(sType,sCondi,sSort,sSelKey,iLevel);
	if(str != null)  
	{
		var ssA;					
		ssA  = str.split("$");
		if (oSelKey != null)
			oSelKey.value =ssA[0];
		if (document.getElementById(sValue) != null)
			document.getElementById(sValue).innerText =ssA[1];
	}			
}

//改变组CheckBox
function ChangeCheck(sGroup,iCurrent,iCount)
{
	
	for (var i = 1; i <= iCount; i ++)
	{
		if (i != iCurrent)
			document.getElementById(sGroup + i).checked = false;
	}
}

function SetCheck(sGroup,iCurrent,iCount)
{
	
	for (var i = 1; i <= iCount; i ++)
	{
		if (i != iCurrent)
			document.getElementById(sGroup + i).checked = false;
		else
			document.getElementById(sGroup + i).checked = true;
	}
}

//改变行
function ChangeRow(sTable,iCurrent,sSColor,sUColor)
{
	if (GetHtmlValue("workflag","V") != "")
	    return;
	var iOld = GetHtmlValue("hRow" + sTable, "V");
	if (iOld != iCurrent)
	{
	    var obj = document.getElementById("TR" + sTable + "_" + iOld);
		if (obj != null)
		    obj.style.backgroundColor = sUColor;
		SetHtmlValue("hRow" + sTable, "V", iCurrent);
		obj = document.getElementById("TR" + sTable + "_" + iCurrent);
		if (obj != null)
			obj.style.backgroundColor=sSColor;
	}
	GetRow(sTable,iCurrent);
}

function SetRow(sTable,sSColor)
{
	var obj = document.getElementById("TR" + sTable + "_" + GetHtmlValue("hRow" + sTable,"V"));
	if (obj != null)
		obj.style.backgroundColor=sSColor;
}

//日期格式化
function FormatData(sDate)
{
	var sFormat = "0000-00-00";
	var iLen = sDate.length;
	if (iLen == 11 || iLen == 10)
	{
		var sTemp = sDate.substring(0,4);
		if (IsNum(sTemp) == 1)
			sFormat = sTemp;
		sTemp = sDate.substring(5,7);
		if (IsNum(sTemp) == 1)
			sFormat = sFormat + "-" + sTemp;
		sTemp = sDate.substring(8,10);
		if (IsNum(sTemp) == 1)
			sFormat = sFormat + "-" + sTemp;
	}
	if (sFormat.length != 10)
		sFormat = "0000-00-00";
	return sFormat.replace(/ /g,"0");
}

//切换分页
function ShowDiv(sIndex,sSColor,sUColor)
{
	if (sIndex != GetHtmlValue("hIndex","V"))
	{
		var obj = null;
		if (sUColor != null && sUColor != "")
		{
			obj = document.getElementById("TDL_" + GetHtmlValue("hIndex","V"));
			if (obj != null)	
				obj.style.backgroundColor=sUColor;
		}
		obj = document.getElementById("dvList_" + GetHtmlValue("hIndex","V"));
		if (obj != null)	
			obj.style.display="none";
		SetHtmlValue("hIndex","V",sIndex);
		if (sSColor != null && sSColor != "")
		{
			obj = document.getElementById("TDL_" + sIndex);
			if (obj != null)	
				obj.style.backgroundColor=sSColor;
		}
		obj = document.getElementById("dvList_" + sIndex);
		if (obj != null)	
			obj.style.display="block";
	}
}

function SetDiv(sSColor,sUColor)
{
	var sIndex = GetHtmlValue("hIndex","V");
	SetHtmlValue("hIndex","V","1");
	if (sIndex != "1")
		ShowDiv(sIndex,sSColor,sUColor);
}

//检验数字输入
function CheckNum(obj)
{
	if (IsNum(obj.value) == 0)
		obj.value = "";
}
			
function SetCombox(sDrpdown,sValue)
{
	var obj = document.getElementById(sDrpdown);
	if (obj != null)
	{
		for (var i = 0; i < obj.options.length; i ++)
		{
			if (obj.options[i].value == sValue)
				obj.options[i].selected = "selected";
			else
				obj.options[i].selected = "";
		}
	}
}

function IsPermission(iLoc)
{
	var sPermission = GetHtmlValue("hPermission","V");
	if (iLoc >= sPermission.length)
		return 0;
	var sPermi = sPermission.substr(iLoc,1);
	if (sPermi == "1")
		return 1;
	return 0;
}

function GetRepCondition(vKey,sColum,vKey1,vObject)
{
    var sKey = GetHtmlValue(vKey,"V");
    if (vKey1 != "")
        sKey = GetHtmlValue(vKey1,"V") + "|" + sKey;
    sKey = sKey + "|" + sColum + "|" + 	encodeURI(GetHtmlValue(vObject,"V")) + "|" + GetHtmlValue("workflag","V");
    return sKey;
}
		
function TimeHandle(iLoc) {
    if (oHttpReq.length > iLoc && oHttpReq[iLoc]) 
    {
        oHttpReq[iLoc].abort();
        oHttpReq[iLoc] = null;
    }
}

function AsyncRepHttp(iLoc)
{
    if (oHttpReq.length > iLoc  && oHttpReq[iLoc] == null) 
    {
        oHttpReq[iLoc] = new ActiveXObject("MSXML2.XMLHTTP");
        var sUrl = "";
        for (var i = 0; i < iLevel; i ++)
            sUrl += "../";
        sUrl = sUrl + "Services/XmlServer.aspx?PTYPE=" + GetRepOperate(iLoc) + "&PCOND=" + GetRepCondi(iLoc) + "&t=" + (new Date().getTime());

        oHttpReq[iLoc].onreadystatechange = function () {
            if (oHttpReq[iLoc] && oHttpReq[iLoc].readyState == 4 && oHttpReq[iLoc].status == 200) {
                DealRepAnswer(iLoc);
            }
        }
        oHttpReq[iLoc].open("POST", sUrl, true);
        oHttpReq[iLoc].send("");

        if (oTimeout.length > iLoc) 
        {
            oTimeout[iLoc] = setTimeout(TimeHandle, 1000, iLoc);
        }
    }
}
		                                                                                                                                   
function DealRepeatAnswer(iLoc)
{
    if (oHttpReq.length > iLoc && oHttpReq[iLoc]) 
    {
        var oDoc = new ActiveXObject("MSXML2.DOMDocument");
        oDoc.loadXML(oHttpReq[iLoc].responseText);
        oHttpReq[iLoc] = null;
        var sUrl = "";
        for (var i = 0; i < iLevel; i ++)
            sUrl += "../";

        var oCheck = document.getElementById(GetRepCheck(iLoc));
		
        var items1 = oDoc.selectSingleNode("//root/head/result").nodeTypedValue;
        var items2 = oDoc.selectSingleNode("//root/head/count").nodeTypedValue;
        if (items1 == 1 && items2 == 0)
            oCheck.src = sUrl + "Images/Check.gif";
        else
            oCheck.src = sUrl + "Images/CheckU.gif";
    }
    if (oTimeout.length > iLoc && oTimeout[iLoc]) 
    {
        clearTimeout(oTimeout[iLoc]);
    }
}  

function CheckRepeat(vObject,vKey,sOperate,sColum,vCheck,iLevel,vKey1)
{
	var sUrl = "";
	for (var i = 0; i < iLevel; i ++)
		sUrl += "../";
	var oKey = document.getElementById(vKey);
	var oCheck = document.getElementById(vCheck);
	var sKey = "";
	var sAction = GetHtmlValue("workflag","V");
	if (oKey != null && oCheck != null)
	{
		sKey = oKey.value;
		if (vKey1 != null)
		{
			oKey = document.getElementById(vKey1);
			if (oKey != null)
				sKey = oKey.value + "|" + sKey; 
		}
		
		sKey = sKey + "|" + sColum + "|" + 	encodeURI(vObject.value) + "|" + sAction;
	}
		
	var oHttpReq = new ActiveXObject("MSXML2.XMLHTTP");
	var oDoc = new ActiveXObject("MSXML2.DOMDocument");
	oHttpReq.open("POST", sUrl + "Services/XmlServer.aspx?PTYPE=" + sOperate + "&PCOND=" + sKey + "&t=" + (new Date().getTime()), false);
	oHttpReq.send("");
	
	result = oHttpReq.responseText;
	oDoc.loadXML(result);

	var items1 = oDoc.selectSingleNode("//root/head/result").nodeTypedValue;
	var items2 = oDoc.selectSingleNode("//root/head/count").nodeTypedValue;
	if (items1 == 1 && items2 == 0)
		oCheck.src = sUrl + "Images/Check.gif";
	else
		oCheck.src = sUrl + "Images/CheckU.gif";
}

function GetXMLService(sOperate,sCondition,iLevel)
{
	var sUrl = "";
	for (var i = 0; i < iLevel; i ++)
		sUrl += "../";
	sUrl += "Services/XmlServer.aspx?PTYPE=" + sOperate + "&PCOND=" + sCondition + "&t=" + (new Date().getTime());
    var oHttpReq = new ActiveXObject("MSXML2.XMLHTTP");
	//oHttpReq.timeout = 300;
    //setTimeout()
	//var oHttpReq = new ActiveXObject("Msxml2.ServerXMLHTTP");
    //oHttpReq.setTimeouts(300,300,300,300);

	oHttpReq.open("POST", sUrl, false);
	oHttpReq.send("");
	return oHttpReq.responseText;
}

