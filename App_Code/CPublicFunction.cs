using System;
using System.Data;
using System.Web.UI.WebControls ;
using System.IO;
using System.Web;
using System.Runtime.InteropServices;
using System.Data.OracleClient;
using System.Collections;
using MySql.Data.MySqlClient;

namespace CloudMagnetWeb
{
	/// <summary>
	/// CPublicFunction 的摘要说明。
	/// </summary>
	public class CPublicFunction
	{
		static MemoryStream m_msFirst = null;
		static public byte[] GetFirst(string sName)
		{
			if (m_msFirst == null)
				GetFirstPicture();
			if (m_msFirst != null)
			{
				if (sName == "")
					return m_msFirst.ToArray();
				else
					return WriteFirstName(sName);;
			}
			return null;
		}

		static MemoryStream m_msEmpty = null;
		static public byte[] GetEmpty()
		{
			if (m_msEmpty == null)
			{
				m_msEmpty = new MemoryStream();
				System.Drawing.Bitmap imgEmpty = new System.Drawing.Bitmap(700,1000);
				System.Drawing.Graphics g = System.Drawing.Graphics.FromImage(imgEmpty);
				g.FillRectangle(new System.Drawing.SolidBrush(System.Drawing.Color.White),0,0,imgEmpty.Width,imgEmpty.Height);
				imgEmpty.Save(m_msEmpty,System.Drawing.Imaging.ImageFormat.Jpeg);
				imgEmpty.Dispose();
				g.Dispose();
			}
			return m_msEmpty.ToArray();
		}

		static MemoryStream m_msEmpty1 = null;
		static public byte[] GetEmpty1()
		{
			if (m_msEmpty1 == null)
			{
				m_msEmpty1 = new MemoryStream();
				System.Drawing.Bitmap imgEmpty = new System.Drawing.Bitmap(700,1000);
				System.Drawing.Graphics g = System.Drawing.Graphics.FromImage(imgEmpty);
				g.FillRectangle(new System.Drawing.SolidBrush(System.Drawing.Color.FromArgb(98,55,48)),0,0,imgEmpty.Width,imgEmpty.Height);
				imgEmpty.Save(m_msEmpty1,System.Drawing.Imaging.ImageFormat.Jpeg);
				imgEmpty.Dispose();
				g.Dispose();
			}
			return m_msEmpty1.ToArray();
		}

		static MemoryStream m_msEmpty2 = null;
		static public byte[] GetEmpty2()
		{
			if (m_msEmpty2 == null)
			{
				m_msEmpty2 = new MemoryStream();
				System.Drawing.Bitmap imgEmpty = new System.Drawing.Bitmap(700,1000);
				System.Drawing.Graphics g = System.Drawing.Graphics.FromImage(imgEmpty);
				g.FillRectangle(new System.Drawing.SolidBrush(System.Drawing.Color.FromArgb(135,206,250)),0,0,imgEmpty.Width,imgEmpty.Height);
				imgEmpty.Save(m_msEmpty2,System.Drawing.Imaging.ImageFormat.Jpeg);
				imgEmpty.Dispose();
				g.Dispose();
			}
			return m_msEmpty2.ToArray();
		}

		static public byte[] WriteFirstName(string sName)
		{
			if (m_msFirst == null)
				return null;
			byte[] Bb_Pic = null;
			System.Drawing.Image img = System.Drawing.Image.FromStream(m_msFirst);
			System.Drawing.Graphics g = System.Drawing.Graphics.FromImage(img);
			System.Drawing.Font font = new System.Drawing.Font("楷体",24.0f);
			System.Drawing.Brush brush = new System.Drawing.SolidBrush(System.Drawing.Color.Black);
			g.DrawString(sName,font,brush,1150.0f,2530.0f);
			System.IO.MemoryStream ms = new System.IO.MemoryStream();
			img.Save(ms,System.Drawing.Imaging.ImageFormat.Jpeg);
			Bb_Pic = ms.ToArray();
			img.Dispose();
			g.Dispose();
			ms.Close();
			return Bb_Pic;
		}

		static private void GetFirstPicture()
		{
			DataTable dtList = null;
			string sError = GetList("SELECT TP FROM RS_R_IMAGE WHERE RYBH = '0' AND JLXH = '0'",ref dtList);
			if (dtList != null)
			{
				if (dtList.Rows.Count > 0)
				{
					byte[] Bb_pic = (byte[])dtList.Rows[0][0];
					m_msFirst = new MemoryStream();
					m_msFirst.Write(Bb_pic,0,Bb_pic.Length);
				}
				dtList.Dispose();
			}
		}

		public CPublicFunction()
		{
			//
			// TODO: 在此处添加构造函数逻辑
			//
		}

		static public void MsgBox(string strErr)
		{
			string strHtml;
			strErr =strErr.Replace("'",""); 
			strErr= strErr.Replace("\n","" );
			strErr= strErr.Replace("\r","" );
			strHtml = "<script language='javascript'>alert('"+ strErr+ "');</script>";
			HttpContext.Current.Response.Write(strHtml);
		}

		static public string GetSessionItem(string sItem)
		{
			string sItemValue = "";
			if (HttpContext.Current.Session[sItem] != null)
				sItemValue = HttpContext.Current.Session[sItem].ToString();
			return sItemValue;
		}

        static public string ChangeEncodeing(string sSource,string sSEncode,string sDEncode)
        {
            string sDistict = sSource;
            try
            {
                System.Text.Encoding source = System.Text.Encoding.GetEncoding(sSEncode);
                System.Text.Encoding distinct = System.Text.Encoding.GetEncoding(sDEncode);
                byte[] bs = source.GetBytes(sSource);
                sDistict = distinct.GetString(bs);
            }
            catch
            {

            }
            return sDistict;
        }
		static public string GetRequestPara(string sItem)
		{
			string sItemValue = "";
			if (HttpContext.Current.Request.Params[sItem] != null)
				sItemValue = HttpContext.Current.Request.Params[sItem].ToString();
			return sItemValue;
		}

		static public string GetUserName()
		{
			return GetSessionItem("UserName");
		}

		static public void AddRunlog(string sType,string sMsg,string sTitle)
		{
			string sIP = HttpContext.Current.Request.UserHostAddress;
            if (sIP == "::1" || sIP == "127.0.0.1")
                sIP = CPublicFun.GetLocalHost();
			AddRunlog(sType,sMsg,sTitle,sIP);
		}

		static public void AddRunlog(string sType,string sMsg,string sTitle,string sIP)
		{
			try
			{
				sMsg = sMsg.Replace("'"," ");
				sTitle = sTitle.Replace("'"," ");
				string sSql = "INSERT INTO SYS_RUNLOG(XXLB,XXLR,FZXX,KHDZ) VALUES(?XXLB,?XXLR,?XXBT,?YHDZ)";
				MySqlParameter[] parms = {
											  MysqlConnect.MakeParm("?XXLB",MySqlDbType.VarChar,12,sType),
											  MysqlConnect.MakeParm("?XXLR",MySqlDbType.VarChar,128,sMsg),
											  MysqlConnect.MakeParm("?XXBT",MySqlDbType.VarChar,128,sTitle),
											  MysqlConnect.MakeParm("?YHDZ",MySqlDbType.VarChar,20,sIP)
										  };
				sMsg = MysqlConnect.ExecSql(sSql,parms);
			}
			catch
			{
			}
		}

		static public string GetList(string sSql,ref DataTable dtList)
		{
			if (dtList != null)
			{
				dtList.Dispose();
				dtList = null;
			}
			return MysqlConnect.GetList(sSql,ref dtList);
		}

		static public bool CheckLogin()
		{
			if (GetSessionItem("Person") == "")
			{
				HttpContext.Current.Session.Abandon(); 
				HttpContext.Current.Response.Write("<script language='javascript'>window.parent.location.reload();</script>");
				return false;
			}
			return true;
		}

		static public string Login(string sUserName,string sPassward)
		{
			string sError = CheckPassward(sUserName,sPassward);
			AddRunlog("1",sError,sUserName);
			return sError;
		}

		static public void Logout(string sUserName)
		{
			if (sUserName != "")
				AddRunlog("2","",sUserName);
		}

		static public string CheckPassward(string sUserName,string sPassward)
		{
			DataTable dtList = null;
			string sError = CPublicFunction.GetList("SELECT DLMM FROM ACR_EMPLOYEE WHERE RYZT = '0' AND DLYH = '" + sUserName + "'",ref dtList);
			if (sError == "")
			{
				sError = "用户名和密码不正确";
				if (dtList != null && dtList.Rows.Count > 0)
				{
					sPassward = CPublicFun.MD5Encrypt(sPassward);
					if (sPassward == dtList.Rows[0][0].ToString())
						sError = "";
				}
			}
			if (dtList != null)
				dtList.Dispose();
			return sError;
		}

		static public string CheckPassward(int iUser,string sPassward)
		{
			DataTable dtList = null;
			string sError = CPublicFunction.GetList("SELECT DLMM FROM ACR_EMPLOYEE WHERE RYBH = '" + iUser.ToString() + "'",ref dtList);
			if (sError == "")
			{
				sError = "用户名和密码不正确";
				if (dtList != null && dtList.Rows.Count > 0)
				{
					sPassward = CPublicFun.MD5Encrypt(sPassward);
					if (sPassward == dtList.Rows[0][0].ToString())
						sError = "";
				}
			}
			if (dtList != null)
				dtList.Dispose();
			return sError;
		}

		static public string UpdatePassward(string sUserName,string sPassward)
		{
			string sSql = "UPDATE ACR_EMPLOYEE SET DLMM = ?KL WHERE RYZT = '0' AND DLYH = ?YHM";
			MySqlParameter[] parms = {
										  MysqlConnect.MakeParm("?YHM",MySqlDbType.VarChar,30,sUserName),
										  MysqlConnect.MakeParm("?KL",MySqlDbType.VarChar,40,CPublicFun.MD5Encrypt(sPassward)),
			};
			return MysqlConnect.ExecSql(sSql,parms);
		}

		static public RowItem[] MakeRowItems(int iLen)
		{
			if (iLen < 1)
				return null;
			RowItem[] oItems = new RowItem[iLen];
			for (int i= 0; i < iLen; i ++)
				oItems[i] = new RowItem();
			return oItems;
		}

		static public string UpdateRow(string sSql,RowItem[] lsRow,int iLen,ref string sKey)
		{
            MySqlConnection oConn = null;
			if (iLen > lsRow.Length || iLen < 0)
				iLen = lsRow.Length;
			MySqlParameter[] parms = null;
			if (iLen > 0)
				parms = new MySqlParameter[iLen];
			for (int i = 0; i < iLen; i ++)
				parms[i] = MysqlConnect.MakeParm("?"+i.ToString(),lsRow[i]);

			string sError = MysqlConnect.ExecSql(ref oConn,sSql,parms);
			if (sError == "")
			{
				DataTable dtList = null;
                MysqlConnect.GetList(ref oConn,"SELECT LAST_INSERT_ID()",ref dtList);
				if (dtList != null)
				{
					if (dtList.Rows.Count > 0)
						sKey = dtList.Rows[0][0].ToString();
					dtList.Dispose();
				}
			}
            MysqlConnect.Close(ref oConn);
			return sError;
		}

		static public string UpdateRow(string sSql,RowItem[] lsRow,int iLen)
		{
			if (iLen > lsRow.Length || iLen < 0)
				iLen = lsRow.Length;
			MySqlParameter[] parms = null;
			if (iLen > 0)
				parms = new MySqlParameter[iLen];
			for (int i = 0; i < iLen; i ++)
				parms[i] = MysqlConnect.MakeParm("?"+i.ToString(),lsRow[i]);

			return MysqlConnect.ExecSql(sSql,parms);
		}

		static public string UpdateRow(string sSql,ref DataSet dsRow,int iLen)
		{
			string sError = "";
			if (dsRow != null && dsRow.Tables.Count > 0 && dsRow.Tables[0].Rows.Count > 0)
			{
				if (iLen > dsRow.Tables[0].Rows.Count || iLen < 0)
					iLen = dsRow.Tables[0].Rows.Count;
				MySqlParameter[] parms = null;
				if (iLen > 0)
					parms = new MySqlParameter[iLen];
				for (int i = 0; i < iLen; i ++)
					parms[i] = MysqlConnect.MakeParm(":"+i.ToString(),dsRow.Tables[0].Rows[i]);
				sError = MysqlConnect.ExecSql(sSql,parms);
			}
			return sError;
		}

		public static string UpdateAccreditItem(RowItem[] saItem)
		{
			int iLen = 4;
			string sSql = "INSERT INTO RS_ACCREDIT(GNBM,YHMC,SQLB,SQR) VALUES(:0,:1,:2,:3)";
			if (saItem[4].DataValue.ToString() != "0")
			{
				sSql = "DELETE RS_ACCREDIT WHERE GNBM = :0 AND YHMC = :1 AND SQLB = :2";
				iLen = 3;
			}
			return UpdateRow(sSql,saItem,iLen);
		}

		static public string ExecSql(string sSql)
		{
			return MysqlConnect.ExecSql(sSql,null);
		}

		static public string ExecSql(string sSql,ref string sKey)
		{
            MySqlConnection oConn = null;
            string sError = MysqlConnect.ExecSql(ref oConn,sSql,null);
			if (sError == "")
			{
				DataTable dtList = null;
                MysqlConnect.GetList(ref oConn,"SELECT LAST_INSERT_ID()",ref dtList);
				if (dtList != null)
				{
					if (dtList.Rows.Count > 0)
						sKey = dtList.Rows[0][0].ToString();
					dtList.Dispose();
				}
			}
            MysqlConnect.Close(ref oConn);
			return sError;
		}

        public static bool CheckPermission(string sFunction)
        {
            string sPerson = GetSessionItem("Person");
            return CheckPermission(sFunction,sPerson);

        }

        private static bool CheckPermission(string sFunction, string sPerson)
		{
			if (sFunction == "")
				return false;
			if (sPerson == "")
				return false;

			bool bOk = false;
			string sSql = "SELECT DXXH FROM ACR_ACCREDIT WHERE ZTXH = '" + sPerson + "' AND DXXH = '" + sFunction + "' AND SQLB = '2' UNION SELECT DXXH FROM ACR_ACCREDIT WHERE DXXH = '" + sFunction + "' AND ZTXH IN (SELECT DXXH FROM ACR_ACCREDIT WHERE ZTXH = '" + sPerson + "' AND SQLB = '3') AND SQLB = '1'";
			DataTable dtList= null;
			string sError = MysqlConnect.GetList(sSql,ref dtList);
			if (dtList != null)
			{
				if (dtList.Rows.Count > 0)
					bOk = true;
				dtList.Dispose();
			}
			return bOk;
		}


	}
}
