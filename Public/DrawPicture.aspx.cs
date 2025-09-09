using System;
using System.Data;
using System.Drawing;
using System.Collections;

using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using CloudMagnetWeb;

public partial class Public_DrawPicture : System.Web.UI.Page
{
    string m_sPoint = "";
    DateTime m_dStart = DateTime.Today;
    DateTime m_dEnd = DateTime.Today;
    int m_iType = 11;
    string m_sStart = "";
    string m_sEnd = "";

    private void GetParameter()
    {
        m_sPoint = CPublicFunction.GetRequestPara("Point");
        if (m_sPoint == "")
            m_sPoint = CPublicFunction.GetSessionItem("Point");
        if (m_sPoint == "")
            m_sPoint = "1";

        m_iType = CPublicFun.GetInt(CPublicFunction.GetRequestPara("Type"));
        string sCondition = CPublicFunction.GetRequestPara("Condi");
        string[] sCondi = sCondition.Split(Convert.ToChar("|"));

        int iDays = CPublicFun.IsDate(sCondi[0]);
        if (iDays != -1000000000)
            m_dStart = m_dStart.AddDays(iDays);

        if (sCondi.Length > 1)
        {
            iDays = CPublicFun.IsDate(sCondi[1]);
            if (iDays != -1000000000)
                m_dEnd = m_dEnd.AddDays(iDays);
        }

        m_sStart = m_dStart.ToString("yyyy-MM-dd");
        m_sEnd = m_dEnd.ToString("yyyy-MM-dd");
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        GetParameter();
        int iLocation = (m_iType - m_iType % 10) / 10;
        switch (iLocation)
        {
            
            case 1:
                //柱子曲线图
                DrawMagnetLine();
                break;
            case 2:
                DrawMangetPie();
                //柱子饼图
                break;
            case 3:
                //环境监测曲线
                if (m_iType == 31)
                    DrawWostLine1();
                if (m_iType == 34)
                    DrawWostLine2();
                break;
            case 4:
                //统计分析
                if (m_iType == 41)
                    DrawMangetPie_Stat();
                break;
        }
    }

    private void DrawLine(ref System.Drawing.Graphics g,ref Pen pLine,ref System.Collections.Generic.Dictionary<int, double> hsValue, int iWidth,int iHeight,int iMaxX,int iFactor)
    {
        double dMaxY = 0;
        
        foreach (System.Collections.Generic.KeyValuePair<int,double> de in hsValue)
        {
            if ((double)de.Value > dMaxY)
                dMaxY = (double)de.Value;
            if ((int)de.Key > iMaxX - 1)
                iMaxX = (int)de.Key + 1;
        }
        System.Collections.Generic.Dictionary<int, int> hsPoint = new System.Collections.Generic.Dictionary<int, int>();
        int iPointX = 0;
        //缩放坐标值
        foreach (System.Collections.Generic.KeyValuePair<int, double> de in hsValue)
        {
            iPointX = (int)pLine.Width + (int)de.Key * (iWidth - 2 * (int)pLine.Width) / iMaxX;
            if (!hsPoint.ContainsKey(iPointX))
                hsPoint.Add(iPointX, (int)(pLine.Width + (1 - ((double)de.Value) / dMaxY / (1 + iFactor* 0.1)) * (iHeight - 2 * (int)pLine.Width)));
        }

        int iSize = hsPoint.Count;
        if (iSize > 0)
        {
            Point[] pPoint = new Point[iSize];
            int i = 0;
            foreach (System.Collections.Generic.KeyValuePair<int, int> de in hsPoint)
            {
                pPoint[i].X = (int)de.Key;
                pPoint[i].Y = (int)de.Value;
                i++;
            }
            if (iSize > 2)
                g.DrawCurve(pLine, pPoint);
            else if (iSize == 1)
                g.DrawPie(pLine, pPoint[0].X, pPoint[0].Y, pLine.Width, pLine.Width, 0, 360);
            else
                g.DrawLine(pLine, pPoint[0].X, pPoint[0].Y, pPoint[1].X, pPoint[1].Y);
        }
    }

    private void ReadPieData(string sSql, ref int[] iValues,ref Color[] cColors)
    {
        if (sSql == "")
            return;
        DataTable dtList = null;
        int iCols = 0;
        CPublicFunction.GetList(sSql, ref dtList);
        if (dtList != null)
            iCols = dtList.Columns.Count;
        if (iCols > 0)
            iValues = new int[iCols];
        cColors = new Color[iCols + 1];

        for (int i = 0; i < iCols; i ++)
        {
            iValues[i] = CPublicFun.GetInt(dtList.Rows[0][i].ToString());
            cColors[i] = Color.FromName(dtList.Columns[i].ColumnName);
        }
        if (dtList != null)
            dtList.Dispose();
    }

    private void ReadLineData(string sSql,ref System.Collections.Generic.Dictionary<int, double> mapValues,bool bAppend)
    {
        mapValues.Clear();
        if (sSql == "")
            return;
        DataTable dtList = null;
        CPublicFunction.GetList(sSql, ref dtList);
        int iSize = 0;
        if (dtList != null)
            iSize = dtList.Rows.Count;
        
        int iKeys = 0;
        double dValue = 0;
        for (int i = 0; i < iSize; i++)
        {
            dValue = 0;
            int iKey = CPublicFun.GetInt(dtList.Rows[i][0].ToString());
            if (bAppend)
            {
                for (; iKeys < iKey; iKeys++)
                {
                    if (!mapValues.ContainsKey(iKeys))
                        mapValues.Add(iKeys, dValue);
                }
            }
            dValue = CPublicFun.GetDouble(dtList.Rows[i][1].ToString());
            if (!mapValues.ContainsKey(iKey))
                mapValues.Add(iKey, dValue);
            else
                mapValues[iKey] = dValue;
        }
        if (dtList != null)
            dtList.Dispose();
    }


    private void DrawPie(ref Graphics g, ref int[] iValues, ref Color[] cColors, int x,int y,int iWidth,int iHeight)
    {
        int iTotal = 0;
        int i = 0;
        int iCount = 0;
        if (iValues != null)
            iCount = iValues.Length;

        for (; i < iCount; i ++)
            iTotal += iValues[i];
        if (iTotal > 0)
        {
            int iTotalS = 0;
            for (i = 0; i < iCount; i++)
            {
                if (iValues[i] > 0)
                {
                    SolidBrush brBrush = new SolidBrush(cColors[i]);
                    g.FillPie(brBrush, x, y, iWidth, iHeight, (float)iTotalS * 360 / (float)iTotal, (float)(iValues[i]) * 360 / (float)iTotal);
                    iTotalS += iValues[i];
                    brBrush.Dispose();
                }
            }
        }
        else
        {
            SolidBrush brBrush = new SolidBrush(cColors[iCount]);
            g.FillPie(brBrush, x, y, iWidth, iHeight, 0,360);
            brBrush.Dispose();
        }
    }

    private void DrawMagnetLine()
    {
        MemoryStream oStream = new MemoryStream();
        int iWidth = 1040;
        int iHeight = 540;

        int iMaxX = 0;
        string sSql = "";
        if (m_dStart == m_dEnd)
        {
            sSql = "SELECT HOUR(KSSJ) XS,COUNT(*) ZL FROM V_EQP_EVENT WHERE SBBH IN (SELECT SBBH FROM EQP_EQUIPMENT WHERE DWBH = '" + m_sPoint + "' AND SUBSTR(SBLX,1,1) IN ('1','2','3')) AND KSSJ >= DATE('" + m_sStart + "') AND KSSJ < DATE_ADD(DATE('" + m_sEnd + "'),INTERVAL 1 DAY) GROUP BY HOUR(KSSJ)  ORDER BY XS";
            iMaxX = 24;
        }
        else
        {
            sSql = "SELECT DATEDIFF(DATE(DATE_FORMAT(KSSJ, '%Y-%m-%d')),DATE('" + m_sStart + "')) TS,COUNT(*) ZL FROM V_EQP_EVENT WHERE SBBH IN (SELECT SBBH FROM EQP_EQUIPMENT WHERE DWBH = '" + m_sPoint + "' AND SUBSTR(SBLX,1,1) IN ('1','2','3')) AND KSSJ >= DATE('" + m_sStart + "') AND KSSJ < DATE_ADD(DATE('" + m_sEnd + "'),INTERVAL 1 DAY) GROUP BY DATE_FORMAT(KSSJ, '%Y-%m-%d') ORDER BY TS";
            TimeSpan tSpan = m_dEnd - m_dStart;
            iMaxX = tSpan.Days + 1;
        }

        Bitmap bmPic = new Bitmap(iWidth, iHeight);
        Graphics g = Graphics.FromImage(bmPic);

        g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
        g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
        g.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
        Int64 qualityLevel = 100L;

        SolidBrush brOut = new SolidBrush(Color.FromArgb(142, 202, 238));
        SolidBrush brWhite = new SolidBrush(Color.White);

        Pen pLine = new Pen(Color.FromArgb(95, 127, 186), 6);
        g.FillRectangle(brOut, 0, 0, iWidth, iHeight);
        g.FillRectangle(brWhite, 6, 6, iWidth - 12, iHeight - 12);
        System.Collections.Generic.Dictionary<int, double> mapValues = new System.Collections.Generic.Dictionary<int, double>();

        ReadLineData(sSql, ref mapValues,true);
        DrawLine(ref g, ref pLine, ref mapValues, iWidth, iHeight, iMaxX,1);

        System.Drawing.Imaging.ImageCodecInfo[] codec = System.Drawing.Imaging.ImageCodecInfo.GetImageEncoders();
        System.Drawing.Imaging.EncoderParameters eParams = new System.Drawing.Imaging.EncoderParameters(1);
        eParams.Param[0] = new System.Drawing.Imaging.EncoderParameter(System.Drawing.Imaging.Encoder.Quality, qualityLevel);

        bmPic.Save(oStream, codec[1], eParams);
        Response.BinaryWrite(oStream.ToArray());
        bmPic.Dispose();
        g.Dispose();
        pLine.Dispose();
        oStream.Close();
        eParams.Dispose();
    }

    private void DrawMangetPie()
    {

        MemoryStream oStream = new MemoryStream();
        int iWidth = 360;
        int iHeight = 300;

        string sSql = "SELECT SUM(CASE WHEN SJJB = '1' THEN 1 ELSE 0 END) Blue,SUM(CASE WHEN SJJB = '2' THEN 1 ELSE 0 END) Orange,SUM(CASE WHEN SJJB = '3' THEN 1 ELSE 0 END) Red,SUM(CASE WHEN SJJB = '0' THEN 1 ELSE 0 END) Green FROM V_EQP_EVENT WHERE SBBH IN (SELECT SBBH FROM EQP_EQUIPMENT WHERE DWBH = '" + m_sPoint + "' AND SUBSTR(SBLX,1,1) IN ('1','2','3')) AND KSSJ >= DATE('" + m_sStart + "') AND KSSJ < DATE_ADD(DATE('" + m_sEnd + "'),INTERVAL 1 DAY)";

        Bitmap bmPic = new Bitmap(iWidth, iHeight);
        Graphics g = Graphics.FromImage(bmPic);

        g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
        g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
        g.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
        Int64 qualityLevel = 100L;
        
        SolidBrush brBack = new SolidBrush(Color.FromArgb(242, 248, 248));

        g.FillRectangle(brBack, 0, 0, iWidth, iHeight);
        int[] iValues = null;
        Color[] cColors = null;
        ReadPieData(sSql, ref iValues, ref cColors);
        if (cColors == null)
            cColors = new Color[1];
        cColors[cColors.Length - 1] = Color.White;

        DrawPie(ref g, ref iValues, ref cColors, 60, 30, 240, 240);
        //g.FillPie(brBack, 90, 60, 180, 180, 0,360);

        System.Drawing.Imaging.ImageCodecInfo[] codec = System.Drawing.Imaging.ImageCodecInfo.GetImageEncoders();
        System.Drawing.Imaging.EncoderParameters eParams = new System.Drawing.Imaging.EncoderParameters(1);
        eParams.Param[0] = new System.Drawing.Imaging.EncoderParameter(System.Drawing.Imaging.Encoder.Quality, qualityLevel);

        bmPic.Save(oStream, codec[1], eParams);
        Response.BinaryWrite(oStream.ToArray());
        bmPic.Dispose();
        g.Dispose();
        brBack.Dispose();
        oStream.Close();
        eParams.Dispose();
    }

    private void DrawMangetPie_Stat()
    {
        string sOrganize = CPublicFunction.GetRequestPara("Depart");
        string sPoint = CPublicFunction.GetRequestPara("Point");
        MemoryStream oStream = new MemoryStream();
        int iWidth = 380;
        int iHeight = 300;

        string sSql = "SELECT SUM(CASE WHEN SJJB = '1' THEN 1 ELSE 0 END) Blue,SUM(CASE WHEN SJJB = '2' THEN 1 ELSE 0 END) Orange,SUM(CASE WHEN SJJB = '3' THEN 1 ELSE 0 END) Red,SUM(CASE WHEN SJJB = '0' THEN 1 ELSE 0 END) Green FROM V_EQP_EVENT WHERE SBBH IN (SELECT SBBH FROM EQP_EQUIPMENT WHERE DWBH IN (SELECT DWBH FROM EQP_LOCATION A RIGHT JOIN (SELECT '" + sOrganize + "' GLBM,'" + sPoint + "' DW) AS B ON A.GLBM = B.GLBM AND A.DWBH = CASE B.DW WHEN '' THEN A.DWBH ELSE B.DW END) AND SUBSTR(SBLX,1,1) IN ('1','2','3')) AND KSSJ >= DATE('" + m_sStart + "') AND KSSJ < DATE_ADD(DATE('" + m_sEnd + "'),INTERVAL 1 DAY)";

        Bitmap bmPic = new Bitmap(iWidth, iHeight);
        Graphics g = Graphics.FromImage(bmPic);

        g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
        g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
        g.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
        Int64 qualityLevel = 100L;

        SolidBrush brBack = new SolidBrush(Color.FromArgb(233, 239, 239));

        g.FillRectangle(brBack, 0, 0, iWidth, iHeight);
        int[] iValues = null;
        Color[] cColors = null;
        ReadPieData(sSql, ref iValues, ref cColors);
        if (cColors == null)
            cColors = new Color[1];
        cColors[cColors.Length - 1] = Color.White;

        DrawPie(ref g, ref iValues, ref cColors, 70, 30, 240, 240);
        //g.FillPie(brBack, 90, 60, 180, 180, 0,360);

        System.Drawing.Imaging.ImageCodecInfo[] codec = System.Drawing.Imaging.ImageCodecInfo.GetImageEncoders();
        System.Drawing.Imaging.EncoderParameters eParams = new System.Drawing.Imaging.EncoderParameters(1);
        eParams.Param[0] = new System.Drawing.Imaging.EncoderParameter(System.Drawing.Imaging.Encoder.Quality, qualityLevel);

        bmPic.Save(oStream, codec[1], eParams);
        Response.BinaryWrite(oStream.ToArray());
        bmPic.Dispose();
        g.Dispose();
        brBack.Dispose();
        oStream.Close();
        eParams.Dispose();
    }
    private void DrawWostLine1()
    {
        MemoryStream oStream = new MemoryStream();
        int iWidth = 1280;
        int iHeight = 540;

        int iMaxX = 0;

        Bitmap bmPic = new Bitmap(iWidth, iHeight);
        Graphics g = Graphics.FromImage(bmPic);

        g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
        g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
        g.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
        Int64 qualityLevel = 100L;

        SolidBrush brOut = new SolidBrush(Color.FromArgb(42, 45, 62));

        Pen pLine1 = new Pen(Color.Red, 6);
        Pen pLine2 = new Pen(Color.Yellow, 4);
        Pen pLine3 = new Pen(Color.Blue, 2);
        Pen pLine4 = new Pen(Color.Gray, 2);

        g.FillRectangle(brOut, 0, 0, iWidth, iHeight);
        int x1 = 0, y1 = 140, x2 = 1280, y2 = 140;
        for (int i = 0; i < 5; i ++)
            g.DrawLine(pLine4,x1,y1 + i * 80,x2,y2 + i * 80);

        string sSql = "SELECT * FROM (SELECT TIMESTAMPDIFF(SECOND, DATE_SUB(NOW(), INTERVAL 1 HOUR), JCSJ) MS, QTLD FROM WOST_RESULT_HIS WHERE SBBH IN(SELECT SBBH FROM EQP_EQUIPMENT WHERE DWBH = " + m_sPoint + " AND SBLX IN (|SBLX)) AND TDH = '|TDH' AND JCSJ >= DATE_SUB(NOW(), INTERVAL 1 HOUR) AND JCSJ < NOW() UNION SELECT 0, QTLD FROM WOST_RESULT_HIS A RIGHT JOIN(SELECT A.SBBH, A.TDH, A.JCSJ, MAX(HMZ) HMZ FROM WOST_RESULT_HIS A RIGHT JOIN(SELECT SBBH, TDH, MAX(JCSJ) JCSJ FROM WOST_RESULT_HIS WHERE SBBH IN(SELECT SBBH FROM EQP_EQUIPMENT WHERE DWBH = " + m_sPoint + " AND SBLX IN (|SBLX)) AND TDH = '|TDH' AND JCSJ < DATE_SUB(NOW(), INTERVAL 1 HOUR) GROUP BY SBBH, TDH) B  ON A.SBBH = B.SBBH AND A.TDH = B.TDH AND A.JCSJ = B.JCSJ GROUP BY B.SBBH, B.TDH, B.JCSJ) B ON A.SBBH = B.SBBH AND A.TDH = B.TDH AND A.JCSJ = B.JCSJ AND A.HMZ = B.HMZ UNION SELECT TIMESTAMPDIFF(SECOND, DATE_SUB(NOW(), INTERVAL 1 HOUR), NOW()) - 1 MS, QTLD FROM WOST_RESULT_HIS A RIGHT JOIN(SELECT A.SBBH, A.TDH, A.JCSJ, MAX(HMZ) HMZ FROM WOST_RESULT_HIS A RIGHT JOIN(SELECT SBBH, TDH, MAX(JCSJ) JCSJ FROM WOST_RESULT_HIS WHERE SBBH IN(SELECT SBBH FROM EQP_EQUIPMENT WHERE DWBH = " + m_sPoint + " AND SBLX IN (|SBLX)) AND TDH = '|TDH' AND JCSJ < NOW() GROUP BY SBBH, TDH) B ON A.SBBH = B.SBBH AND A.TDH = B.TDH AND A.JCSJ = B.JCSJ GROUP BY B.SBBH, B.TDH, B.JCSJ) B ON A.SBBH = B.SBBH AND A.TDH = B.TDH AND A.JCSJ = B.JCSJ AND A.HMZ = B.HMZ) A ORDER BY MS";
        System.Collections.Generic.Dictionary<int, double> mapValues = new System.Collections.Generic.Dictionary<int, double>();
        ReadLineData(sSql.Replace("|SBLX","'A1'").Replace("|TDH","1"), ref mapValues,false);
        DrawLine(ref g, ref pLine1, ref mapValues, iWidth, iHeight, iMaxX,1);

        ReadLineData(sSql.Replace("|SBLX", "'A2','A3'").Replace("|TDH", "1"), ref mapValues, false);
        DrawLine(ref g, ref pLine2, ref mapValues, iWidth, iHeight, iMaxX,2);

        ReadLineData(sSql.Replace("|SBLX", "'A2','A3'").Replace("|TDH", "2"), ref mapValues, false);
        DrawLine(ref g, ref pLine3, ref mapValues, iWidth, iHeight, iMaxX,3);

        System.Drawing.Imaging.ImageCodecInfo[] codec = System.Drawing.Imaging.ImageCodecInfo.GetImageEncoders();
        System.Drawing.Imaging.EncoderParameters eParams = new System.Drawing.Imaging.EncoderParameters(1);
        eParams.Param[0] = new System.Drawing.Imaging.EncoderParameter(System.Drawing.Imaging.Encoder.Quality, qualityLevel);

        bmPic.Save(oStream, codec[1], eParams);
        Response.BinaryWrite(oStream.ToArray());
        bmPic.Dispose();
        g.Dispose();
        pLine1.Dispose();
        pLine2.Dispose();
        pLine3.Dispose();
        pLine4.Dispose();
        oStream.Close();
        eParams.Dispose();
    }

    private void DrawWostLine2()
    {
        string sType = CPublicFunction.GetRequestPara("DataType");
        MemoryStream oStream = new MemoryStream();
        int iWidth = 1040;
        int iHeight = 540;

        int iMaxX = 0;
        string sSql = "";
        if (m_dStart == m_dEnd)
        {
            sSql = "SELECT HOUR(KSSJ) XS,COUNT(*) ZL FROM V_EQP_EVENT WHERE SBBH IN (SELECT SBBH FROM EQP_EQUIPMENT WHERE DWBH = '" + m_sPoint + "' AND SBLX IN (|SBLX)) AND KSSJ >= DATE('" + m_sStart + "') AND KSSJ < DATE_ADD(DATE('" + m_sEnd + "'),INTERVAL 1 DAY) GROUP BY HOUR(KSSJ)  ORDER BY XS";
            iMaxX = 24;
        }
        else
        {
            sSql = "SELECT DATEDIFF(DATE(DATE_FORMAT(KSSJ, '%Y-%m-%d')),DATE('" + m_sStart + "')) TS,COUNT(*) ZL FROM V_EQP_EVENT WHERE SBBH IN (SELECT SBBH FROM EQP_EQUIPMENT WHERE DWBH = '" + m_sPoint + "' AND SBLX IN (|SBLX)) AND KSSJ >= DATE('" + m_sStart + "') AND KSSJ < DATE_ADD(DATE('" + m_sEnd + "'),INTERVAL 1 DAY) GROUP BY DATE_FORMAT(KSSJ, '%Y-%m-%d') ORDER BY TS";
            TimeSpan tSpan = m_dEnd - m_dStart;
            iMaxX = tSpan.Days + 1;
        }

        Bitmap bmPic = new Bitmap(iWidth, iHeight);
        Graphics g = Graphics.FromImage(bmPic);

        g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
        g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;
        g.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
        Int64 qualityLevel = 100L;

        SolidBrush brOut = new SolidBrush(Color.FromArgb(142, 202, 238));
        SolidBrush brWhite = new SolidBrush(Color.White);

        Pen pLine1 = new Pen(Color.Red, 6);
        Pen pLine2 = new Pen(Color.Yellow, 4);
        g.FillRectangle(brOut, 0, 0, iWidth, iHeight);
        g.FillRectangle(brWhite, 6, 6, iWidth - 12, iHeight - 12);
        System.Collections.Generic.Dictionary<int, double> mapValues = new System.Collections.Generic.Dictionary<int, double>();

        if (sType == "1" || sType == "3")
        { 
            ReadLineData(sSql.Replace("|SBLX","'A1'"), ref mapValues, true);
            DrawLine(ref g, ref pLine1, ref mapValues, iWidth, iHeight, iMaxX, 1);
        }

        if (sType == "2" || sType == "3")
        {
            ReadLineData(sSql.Replace("|SBLX", "'A2','A3'"), ref mapValues, true);
            DrawLine(ref g, ref pLine2, ref mapValues, iWidth, iHeight, iMaxX, 1);
        }

        System.Drawing.Imaging.ImageCodecInfo[] codec = System.Drawing.Imaging.ImageCodecInfo.GetImageEncoders();
        System.Drawing.Imaging.EncoderParameters eParams = new System.Drawing.Imaging.EncoderParameters(1);
        eParams.Param[0] = new System.Drawing.Imaging.EncoderParameter(System.Drawing.Imaging.Encoder.Quality, qualityLevel);

        bmPic.Save(oStream, codec[1], eParams);
        Response.BinaryWrite(oStream.ToArray());
        bmPic.Dispose();
        g.Dispose();
        pLine1.Dispose();
        pLine2.Dispose();
        oStream.Close();
        eParams.Dispose();
    }

}