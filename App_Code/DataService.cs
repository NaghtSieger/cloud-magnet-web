using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
using CloudMagnetWeb;

/// <summary>
/// DataService 的摘要说明
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允许使用 ASP.NET AJAX 从脚本中调用此 Web 服务，请取消注释以下行。 
// [System.Web.Script.Services.ScriptService]
public class DataService : System.Web.Services.WebService
{

    public DataService()
    {

        //如果使用设计的组件，请取消注释以下行 
        //InitializeComponent(); 
    }

    private string GetQueryAddress()
    {
        string sAddress = "";
        if (Context.Request.ServerVariables["HTTP_VIA"] != null)
            sAddress = Context.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
        else
            sAddress = Context.Request.ServerVariables["REMOTE_ADDR"].ToString();
        return sAddress;
    }

    private string WriteXML(ref DataSet dsList)
    {
        if (dsList == null)
            return "";
        System.IO.StringWriter oStream = new System.IO.StringWriter();
        dsList.WriteXml(oStream);
        string sResult = oStream.ToString();
        oStream.Close();
        dsList.Dispose();
        return sResult;
    }

    private string CheckAccess(string sSerial, string sInterId, ref RowItem[] saData, ref int iResult)
    {
        string sAccess = System.Text.Encoding.Default.GetString(Convert.FromBase64String(sSerial));
        if (sAccess.Length > 4)
            sAccess = sAccess.Substring(0, 4);
        saData[0].SetData("", 8, sAccess);
        saData[1].SetData("", 2, sInterId);

        DataTable dtList = null;
        string sError = CPublicFunction.GetList("SELECT DZXZ,FWXL FROM INT_USER WHERE YHMC = '" + sAccess + "'", ref dtList);
        if (sError != "")
            iResult = 4;
        else
        {
            if (dtList == null || dtList.Rows.Count < 0)
                iResult = 5;
            else
            {
                string sLimmit = dtList.Rows[0][0].ToString();
                if (sLimmit != "" && sLimmit != saData[3].DataValue.ToString())
                    iResult = 6;
                else if (sSerial != dtList.Rows[0][1].ToString())
                    iResult = 7;
            }
        }

        if (iResult == 1)
            sError = CheckAccess(sAccess, sInterId, ref iResult);

        if (dtList != null)
            dtList.Dispose();
        return sError;
    }

    private string CheckAccess(string sAccess, string sInterId, ref int iResult)
    {
        DataTable dtList = null;
        string sError = CPublicFunction.GetList("SELECT RXZL FROM INT_ACCREDIT WHERE YHMC = '" + sAccess + "' AND JKBH = '" + sInterId + "'", ref dtList);
        int iLimmit = 0;
        if (sError != "")
            iResult = 8;
        else
        {
            if (dtList == null)
                iResult = 9;
            else
                iLimmit = CPublicFun.GetInt(dtList.Rows[0][0].ToString());
        }
        string sAccessDate = System.DateTime.Today.ToString("yyyyMMdd");
        RowItem[] saData = CPublicFunction.MakeRowItems(5);
        saData[0].SetData("", 8, sAccessDate);
        saData[1].SetData("", 8, sAccess);
        saData[2].SetData("", 2, sInterId);
        saData[3].SetData("N", 10, "1");
        saData[4].SetData("", 10, "0");
        string sSql = "INSERT INTO INT_STAT(SJBJ,YHMC,JKBH,FWCS,CLCS) VALUES(:0,:1,:2,:3,:4)";

        if (sError == "")
        {
            sError = CPublicFunction.GetList("SELECT FWCS FROM INT_STAT WHERE SJBJ = '" + sAccessDate + "' AND YHMC = '" + sAccess + "' AND JKBH = '" + sInterId + "'", ref dtList);
            if (sError != "")
                iResult = 10;
        }
        if (sError == "")
        {
            if (dtList == null || dtList.Rows.Count < 1)
                sSql = CPublicFunction.UpdateRow(sSql, saData, 5);
            else
            {
                if (iLimmit < 1 || iLimmit > CPublicFun.GetInt(dtList.Rows[0][0].ToString()))
                    sSql = "UPDATE INT_STAT SET FWCS = FWCS + 1 WHERE SJBJ = :0 AND YHMC = :1 AND JKBH = :2";
                else
                {
                    iResult = 11;
                    sSql = "UPDATE INT_STAT SET CLCS = CLCS + 1 WHERE SJBJ = :0 AND YHMC = :1 AND JKBH = :2";
                }
                sSql = CPublicFunction.UpdateRow(sSql, saData, 3);
            }
        }
        if (dtList != null)
            dtList.Dispose();
        return sError;
    }

    private DataSet AddResult()
    {
        DataSet dsList = new DataSet();

        DataTable dtResult = new DataTable();
        dtResult.TableName = "head";
        dtResult.Columns.Add("result", System.Type.GetType("System.String"));
        dtResult.Columns.Add("message", System.Type.GetType("System.String"));
        dtResult.Columns.Add("count", System.Type.GetType("System.String"));
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

    private DataSet GetCondi(string sConditionXml)
    {
        DataSet dsCondi = null;
        System.IO.StringReader oStream = null;
        System.Xml.XmlTextReader oReader = null;
        if (sConditionXml != "")
        {
            dsCondi = new DataSet();
            try
            {

                oStream = new System.IO.StringReader(sConditionXml);
                oReader = new System.Xml.XmlTextReader(oStream);
                dsCondi.ReadXml(oReader);
            }
            catch
            {
            }
        }
        if (oReader != null)
            oReader.Close();
        if (oStream != null)
            oStream.Close();
        return dsCondi;
    }

    private string AdjustSql(string sSql, DataSet dsCondi)
    {
        if (dsCondi != null && dsCondi.Tables.Count > 0 && dsCondi.Tables[0].Rows.Count > 0)
        {
            int iSize = dsCondi.Tables[0].Columns.Count;
            for (int i = 0; i < iSize; i++)
                sSql = sSql.Replace("|" + dsCondi.Tables[0].Columns[i].ColumnName, dsCondi.Tables[0].Rows[0][i].ToString());
        }
        return sSql;
    }

    private string AddQueryResult(string sInterId, ref DataSet dsCondi, ref DataSet dsResult, ref int iResult)
    {
        DataTable dtList = null;
        DataTable dtResult = null;
        int iLen = 0;
        string sError = CPublicFunction.GetList("SELECT JGXH,JGLY,JGBS FROM RS_I_ITEM WHERE SJLX = '" + sInterId + "' ORDER BY JGXH", ref dtList);
        string sSql = "";
        int iSize = 0;
        if (sError == "")
        {
            if (dtList != null && dtList.Rows.Count > 0)
                iSize = dtList.Rows.Count;
            for (int i = 0; i < iSize; i++)
            {
                sSql = AdjustSql(dtList.Rows[i][1].ToString(), dsCondi);

                int iType = CPublicFun.GetInt(dtList.Rows[i][0].ToString());
                if (iType < 1)
                    sError = CPublicFunction.ExecSql(sSql);
                else
                    sError = CPublicFunction.GetList(sSql, ref dtResult);
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
        if (dsCondi != null)
            dsCondi.Dispose();
        if (dtResult != null)
            dtResult.Dispose();
        if (dtList != null)
            dtList.Dispose();
        return sError;
    }

    [WebMethod]
    public string QueryData(string sSerial, string sInterId, string sConditionXml)
    {
        DataSet dsList = AddResult();
        DataSet dsCondi = null;
        RowItem[] saData = CPublicFunction.MakeRowItems(8);
        saData[2].SetData("S", 0, sConditionXml);
        saData[3].SetData("", 16, GetQueryAddress());
        saData[4].SetData("D", 0, System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
        string sError = "";
        int iResult = 1;
        if (sConditionXml == "")
            iResult = 2;
        else
        {
            dsCondi = GetCondi(sConditionXml);
            if (dsCondi == null || dsCondi.Tables.Count < 1 || dsCondi.Tables[0].Rows.Count < 1)
                iResult = 3;
        }
        if (iResult == 1)
            sError = CheckAccess(sSerial, sInterId, ref saData, ref iResult);
        if (iResult == 1)
            sError = AddQueryResult(sInterId, ref dsCondi, ref dsList, ref iResult);

        saData[5].SetData("D", 0, System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
        saData[6].SetData("S", 0, sError);
        saData[7].SetData("", 2, iResult.ToString());
        dsList.Tables[0].Rows[0][0] = iResult.ToString();
        dsList.Tables[0].Rows[0][1] = sError;

        string sResult = WriteXML(ref dsList);
        sError = CPublicFunction.UpdateRow("INSERT INTO INT_LOG(QQYH,QQLB,QQTJ,QQDZ,QQSJ,FHSJ,FHXX,QQZT) VALUES(:0,:1,:2,:3,:4,:5,:6,:7)", saData, 8);
        dsList.Dispose();
        if (dsCondi != null)
            dsCondi.Dispose();
        return sResult;
    }

    [WebMethod]
    public string WriteData(string sSerial, string sInterId, string sDataXml)
    {
        DataSet dsList = AddResult();
        DataSet dsCondi = null;
        RowItem[] saData = CPublicFunction.MakeRowItems(8);
        saData[2].SetData("S", 0, sDataXml);
        saData[3].SetData("", 16, GetQueryAddress());
        saData[4].SetData("D", 0, System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
        string sError = "";
        int iResult = 1;
        if (sDataXml == "")
            iResult = 2;
        else
        {
            dsCondi = GetCondi(sDataXml);
            if (dsCondi == null || dsCondi.Tables.Count < 1 || dsCondi.Tables[0].Rows.Count < 1)
                iResult = 3;
        }
        if (iResult == 1)
            sError = CheckAccess(sSerial, sInterId, ref saData, ref iResult);
        if (iResult == 1)
        {
            dsCondi.Tables[0].Columns.Add("XXLY", System.Type.GetType("System.String"));
            dsCondi.Tables[0].Rows[0]["XXLY"] = saData[0].DataValue;
        }
        if (iResult == 1)
            sError = AddQueryResult(sInterId, ref dsCondi, ref dsList, ref iResult);

        saData[5].SetData("D", 0, System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
        saData[7].SetData("", 2, iResult.ToString());
        dsList.Tables[0].Rows[0][0] = iResult.ToString();
        dsList.Tables[0].Rows[0][1] = sError;

        string sResult = WriteXML(ref dsList);
        saData[6].SetData("S", 0, sResult);
        sError = CPublicFunction.UpdateRow("INSERT INTO RS_I_LOG(QQYH,QQLB,QQTJ,QQDZ,QQSJ,FHSJ,FHXX,QQZT) VALUES(:0,:1,:2,:3,:4,:5,:6,:7)", saData, 8);
        dsList.Dispose();
        if (dsCondi != null)
            dsCondi.Dispose();
        return sResult;
    }

}
