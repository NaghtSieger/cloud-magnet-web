using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Xml;
using CloudMagnetWeb;

public partial class Services_XmlServer : System.Web.UI.Page
{
	private void Page_Load(object sender, System.EventArgs e)
	{
		// 在此处放置用户代码以初始化页面

		DataSet dsList = AddResult();
		int iResult = 1;
		string[] saCondition =  CPublicFunction.GetRequestPara("PCOND").Split(Convert.ToChar("|"));
		string sError =  "";
		string sType = CPublicFunction.GetRequestPara("PTYPE");
		switch(sType)
		{
			case "POSTIN":
				sError = PostInOut(ref saCondition,0);
				break;
			case "POSTOUT":
				sError = PostInOut(ref saCondition,1);
				break;
            case "TEST":
                break;
            default:
				sError = AddQueryResult(CPublicFunction.GetRequestPara("PTYPE"),saCondition,ref dsList,ref iResult);
				break;
		}

		dsList.Tables[0].Rows[0][0] = iResult.ToString();
		dsList.Tables[0].Rows[0][1] = sError;

			
		XmlTextWriter writer = new XmlTextWriter(Response.OutputStream,System.Text.Encoding.UTF8); //Response.ContentEncoding);
		writer.Formatting = Formatting.Indented;
		writer.Indentation = 4;
		writer.IndentChar = ' ';
		dsList.WriteXml(writer);
		writer.Flush();
		Response.End();
		writer.Close();
	}

	#region Web 窗体设计器生成的代码
	override protected void OnInit(EventArgs e)
	{
		//
		// CODEGEN: 该调用是 ASP.NET Web 窗体设计器所必需的。
		//
		InitializeComponent();
		base.OnInit(e);
	}
		
	/// <summary>
	/// 设计器支持所需的方法 - 不要使用代码编辑器修改
	/// 此方法的内容。
	/// </summary>
	private void InitializeComponent()
	{    
		this.Load += new System.EventHandler(this.Page_Load);
	}
	#endregion

	private string PostInOut(ref string[] saCondition,short iType)
	{
		string sError = "";
		if (saCondition.Length < 3)
			sError = "条件格式不正确";
		else
		{
			sError = CPublicFunction.CheckPassward(CPublicFun.GetInt(saCondition[1]),saCondition[2]);
			if (sError == "")
			{
				string sSql = "INSERT INTO EQP_LOCATION_POST(DWBH,RYBH) VALUES('" + saCondition[0] + "','" + saCondition[1] + "')";
				if (iType == 1)
					sSql = "UPDATE EQP_LOCATION_POST SET ZSZT = '1' WHERE DWBH = '" + saCondition[0] + "' AND RYBH = '" + saCondition[1] + "'";
				sError = CPublicFunction.ExecSql(sSql);
			}
		}
		return sError;
	}

	private DataSet AddResult()
	{
		DataSet dsList = new DataSet();

		DataTable dtResult = new DataTable();
		dtResult.TableName = "head";
		dtResult.Columns.Add("result",System.Type.GetType("System.String"));
		dtResult.Columns.Add("message",System.Type.GetType("System.String"));
		dtResult.Columns.Add("count",System.Type.GetType("System.String"));
		DataRow drResult = dtResult.NewRow();
		drResult[0] = "1";
		drResult[1] = "";
		drResult[2] = "0";
		dtResult.Rows.Add(drResult);

		dsList.DataSetName = "root";
		dsList.Tables.Add(dtResult);
		dtResult.Dispose();
		return dsList;
	}

	private string AdjustSql(string sSql, string[] saCondition)
	{
		int iLen = saCondition.Length;
		for (int i = 0; i < iLen; i ++)
			sSql = sSql.Replace("|" + i.ToString("000"),saCondition[i]);
		return sSql;
	}

	private string AddQueryResult(string sInterId, string[] saCondi, ref DataSet dsResult,ref int iResult)
	{
		DataTable dtList = null;
		DataTable dtResult = null;
		int iLen = 0;
		string sError = CPublicFunction.GetList("SELECT SCBH,SJLY,JDMC FROM INT_ITEM WHERE JKBH = '" + sInterId + "' ORDER BY SCBH",ref dtList);
		string sSql = "";
		int iSize = 0;
		if (sError == "")
		{
			if (dtList != null && dtList.Rows.Count > 0)
				iSize = dtList.Rows.Count;
			for (int i = 0; i < iSize; i ++)
			{
				sSql = AdjustSql(dtList.Rows[i][1].ToString(),saCondi);

				int iType = CPublicFun.GetInt(dtList.Rows[i][0].ToString());
				if (iType < 1)
					sError = CPublicFunction.ExecSql(sSql);
				else
					sError = CPublicFunction.GetList(sSql,ref dtResult);
				if (sError != "")
					break;

				if (iType == 1)
				{
					if (dtList != null && dtList.Rows.Count > 0)
						iResult = CPublicFun.GetInt(dtResult.Rows[0][0].ToString());
					else
						iResult = -12;

					if (iResult < 1)
						break;
				}
				else if (iType > 1)
				{
					int iSub = 0;
					if (dtResult != null)
						iSub = dtResult.Rows.Count;
					if (iSub > 0)
					{
						dtResult.TableName = dtList.Rows[i][2].ToString();
						iLen += iSub;
						dsResult.Tables.Add(dtResult);
					}
				}
			}
		}
		if (sError == "")
		{
			if (iResult < 1)
				iResult *= -1;
			else if (iResult > 1)
			{
				sError = iResult.ToString();
				iResult = 1;
			}
		}
		else
			iResult = 99;
		dsResult.Tables[0].Rows[0][2] = iLen.ToString();
		if (dtResult != null)
			dtResult.Dispose();
		if (dtList != null)
			dtList.Dispose();
		return sError;
	}
}
