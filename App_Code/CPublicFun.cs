using System;
using System.Data;
using System.Web.UI.WebControls;

using System.IO;
using System.Text;
using System.Web;
using System.Collections;

using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Configuration;
using System.Net;
using System.Net.Sockets;
using System.Xml;

namespace CloudMagnetWeb
{
	/// <summary>
	/// CPublicFun 的摘要说明。
	/// </summary>
	public class CPublicFun
	{
		static char[] m_sCheck = {'0','1','2','3','4','5','6','7','8','9'
									 ,'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
									 ,'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','*','#'};

        public CPublicFun()
        {

        }

		static public string MakeSerial(string sName)
		{
			string sSerial = "";
			if (sName.Length > 4)
				sName = sName.Substring(0,4);
			else
				sSerial = sName;
			Random oRan = new Random();
			for (int i = 0; i < 30; i ++)
				sSerial += m_sCheck[oRan.Next(64)].ToString();
			return Convert.ToBase64String(System.Text.Encoding.Default.GetBytes(sSerial));		
		}

		static public int GetInt(string sValue)
		{
			int iResult = 0;
			try
			{
				iResult = Convert.ToInt32(sValue);
			}
			catch
			{
			}
			return iResult;
		}

		static public double GetDouble(string sValue)
		{
			double dResult = 0;
			try
			{
				dResult = Convert.ToDouble(sValue);
			}
			catch
			{
			}
			return dResult;
		}

		static public int IsDate(string sValue)
		{
			int iResult = -1000000000;
			try
			{
				DateTime dResult = Convert.ToDateTime(sValue);
				TimeSpan tSpan = dResult.Date - DateTime.Today;
				iResult = tSpan.Days;
			}
			catch
			{
			}
			return iResult;
		}

		static public short GetShort(string sValue)
		{
			short iResult = 0;
			try
			{
				iResult = Convert.ToInt16(sValue);
			}
			catch
			{
			}
			return iResult;
		}

		static public bool Contrains(string sSource,string sValue)
		{
			if (sValue == "")
				return true;
			if (sSource.IndexOf(sValue) >= 0)
				return true;
			return false;
		}

		static public string ConverTime(string sTime,short iDirect)
		{
			string sDist = "";
			if (sTime.Length > 9)
			{
				sDist = GetInt(sTime.Substring(0,4)).ToString();
				if (iDirect == 0)
					sDist += "-";
				else
					sDist += "年";
				sDist += GetInt(sTime.Substring(5,2)).ToString("00");
				if (iDirect == 0)
					sDist += "-";
				else
					sDist += "月";
				sDist += GetInt(sTime.Substring(8,2)).ToString("00");
				if (iDirect != 0)
					sDist += "日";
			}
			if (iDirect == 0)
			{
				if (sDist.Length != 10)
					sDist = "0000-00-00";
			}
			else
			{
				if (sDist.Length != 11)
					sDist = "    年  月  日";
			}
			return sDist;
		}

		static public string CatDepart(string sOrganize)
		{
			int iLen = sOrganize.Length;
			if (iLen >= 12)
			{
				if (sOrganize.Substring(10,2) == "00" || sOrganize.Substring(10,2) == "10")
					iLen = 10;
			}
			if (iLen >= 10 && iLen < 12)
			{
				if (sOrganize.Substring(8,2) == "00")
					iLen = 8;
			}
			if (iLen >= 8 && iLen < 10)
			{
				if (sOrganize.Substring(6,2) == "00")
					iLen = 6;
			}
			if (iLen >= 6 && iLen < 8)
			{
				if (sOrganize.Substring(4,2) == "00")
					iLen = 4;
			}
			if (iLen >= 4 && iLen < 6)
			{
				if (sOrganize.Substring(2,2) == "00")
					iLen = 2;
				else
					iLen = 4;
			}
			if (iLen > 0)
				return sOrganize.Substring(0,iLen);
			return "";
		}

		static public int CalcAge(string sBirthDay,string sTime)
		{
			int iAge = -1;
			if (sBirthDay != "")
			{
				try
				{
					System.DateTime dEnd = System.DateTime.Today;
					if (sTime != "")
						dEnd = Convert.ToDateTime(sTime);
					System.DateTime dDay = Convert.ToDateTime(sBirthDay);
					iAge = dEnd.Year - dDay.Year;
					if (dDay.AddYears(iAge) > dEnd)
						iAge --;
				}
				catch
				{
				}
			}
			return iAge;
		}

		static public string SubString(string sSource,int iStart,int iSize)
		{
			string sResult = "";
			if (iStart < sSource.Length)
			{
				if (iSize > sSource.Length - iStart)
					iSize = sSource.Length - iStart;
				if (iSize > 0)
					sResult = sSource.Substring(iStart,iSize);
			}
			return sResult;
		}

		static public void DeleteTempFile(string mPath)
		{
			try
			{
				if (Directory.Exists(mPath))
				{
					string[] saFile = Directory.GetFiles(mPath);

					for (int j = 0;j<saFile.Length;j++)
					{
						File.Delete(saFile[j]);
					}
					Directory.Delete(mPath);
				}
			}
			catch
			{
				
			}
		}

        static public string GetLocalHost()
        {
            string sIp = "";
            /*
            System.Net.Sockets.Socket oSocket = new Socket(SocketType.Dgram,ProtocolType.Udp);
            oSocket.Connect("8.8.8.8", 65530);
            sIp = oSocket.LocalEndPoint.Adress.;
            */
            IPHostEntry Hosts = Dns.GetHostEntry(Dns.GetHostName());
            int iSize = Hosts.AddressList.Length;
            for (int i = 0; i < Hosts.AddressList.Length; i++)
            {
                if (Hosts.AddressList[i].AddressFamily == AddressFamily.InterNetwork)
                {
                    sIp = Hosts.AddressList[i].ToString();
                    break;
                }
            }
            return sIp;

        }

 		static public string GetMacAddress(string sIp)
		{
			string sMacAddress = "";
			try
			{
				System.Diagnostics.Process process = new System.Diagnostics.Process();
				process.StartInfo.FileName = "nbtstat";
				process.StartInfo.Arguments = "-A " + sIp;
				process.StartInfo.UseShellExecute = false;
				process.StartInfo.CreateNoWindow = true;
				process.StartInfo.RedirectStandardOutput = true;

				process.Start();
				string output = process.StandardOutput.ReadToEnd();
				int length = output.IndexOf("MAC Address = ");

				if (length > 0)
				{
					sMacAddress = output.Substring(length + 14,17);
				}
			
				process.WaitForExit();
			}
			catch(Exception e)
			{
				sMacAddress = e.Message;
			}

			sMacAddress = sMacAddress.ToUpper();

			return sMacAddress;
		}


		/// <summary>
		/// 判断输入的字符串是否都是数字
		/// </summary>
		public static bool IsNumber(string strNum)
		{
			if (strNum.Length ==0)  return false;

			for (int i=0;i<strNum.Length ;i++)
			{
				if (char.IsNumber(strNum,i) ==false) 
				{
					return false;
				}
			}
			return true;
		}

/*		
		/// <summary>
		/// 构造树
		/// </summary>
		static public string SetTree(TreeView myTree,string sSql,bool bCheck,bool bExpand,string sKey)
		{
			myTree.Nodes.Clear();
			DataTable dtList = null;
			string sError = CPublicFunction.GetList(sSql,ref dtList);
			if (sError == "" && dtList != null && dtList.Rows.Count > 0)
			{
				int iLevel = -1;
				Hashtable hIndex = new Hashtable();
				string sIndex = "";
				InitTree(ref dtList ,myTree.Nodes,dtList.Rows[0][1].ToString(),bCheck,bExpand,sKey,ref hIndex,ref iLevel,ref sIndex);
				if (sIndex != "")
				{
					if (!bExpand)
					{
						string[] sLevel = sIndex.Split(Convert.ToChar("."));
						if (sLevel.Length > 2)
						{
							string sTemp = sLevel[0];
							for (int i = 1; i < sLevel.Length - 1; i ++)
							{
								sTemp +=  "." + sLevel[i];
								myTree.GetNodeFromIndex(sTemp).Expanded = true;
							}
						}

					}
					myTree.SelectedNodeIndex = sIndex;
				}
			}
			if (dtList != null)
				dtList.Dispose();
			return sError;
		}

		/// <summary>
		/// 初始化树结构
		/// </summary>
		static private void InitTree(ref DataTable dtList, TreeNodeCollection Nds, string parentId, bool bCheck,bool bExpand,string sKey,ref Hashtable hIndex,ref int iLevel,ref string sIndex)
		{
			if (dtList == null || dtList.Rows.Count < 1)
				return;
			TreeNode tmpNd;
			DataRow[] rows = dtList.Select("PID='" + parentId + "'");
			iLevel ++;
			int iSort = -1;
			foreach(DataRow row in rows)
			{
				iSort ++;
				if (hIndex.ContainsKey(iLevel))
					hIndex[iLevel] = iSort;
				else
					hIndex.Add(iLevel,iSort);
				tmpNd = new TreeNode();
				tmpNd.ID = row["ID"].ToString();  
				tmpNd.Text = row["NAME"].ToString();
				tmpNd.Expanded = bExpand;
				if (!bExpand && Nds.Parent.GetType().ToString() == "Microsoft.Web.UI.WebControls.TreeView")
					tmpNd.Expanded = true;
				if (bCheck)
					tmpNd.CheckBox = true;
				if (tmpNd.ID == sKey)
				{
					if (!bExpand && Nds.Parent.GetType().ToString() == "Microsoft.Web.UI.WebControls.TreeNode")
					((TreeNode)Nds.Parent).Expanded = true;
					for (int i = 0; i <= iLevel; i ++)
					{
						if (i == 0)
							sIndex = hIndex[0].ToString();
						else
							sIndex += "." + hIndex[i].ToString();
					}

				}
				Nds.Add(tmpNd);
				InitTree(ref dtList,tmpNd.Nodes,tmpNd.ID,bCheck,bExpand,sKey,ref hIndex,ref iLevel,ref sIndex);
				iLevel --;
			}			
		}

		/// <summary>
		/// 构造树
		/// </summary>
		static public string SetTree(TreeView myTree,string sSql,bool bCheck,bool bExpand)
		{
			myTree.Nodes.Clear();
			DataTable dtList = null;
			string sError = CPublicFunction.GetList(sSql,ref dtList);
			if (sError == "" && dtList != null && dtList.Rows.Count > 0)
				InitTree(ref dtList ,myTree.Nodes,dtList.Rows[0][1].ToString(),bCheck,bExpand);
			if (dtList != null)
				dtList.Dispose();
			return sError;
		}

		/// <summary>
		/// 初始化树结构
		/// </summary>
		static private void InitTree(ref DataTable dtList, TreeNodeCollection Nds, string parentId, bool bCheck,bool bExpand)
		{
			if (dtList == null || dtList.Rows.Count < 1)
				return;
			TreeNode tmpNd;
			DataRow[] rows = dtList.Select("PID='" + parentId + "'");
			
			foreach(DataRow row in rows)
			{
				tmpNd = new TreeNode();
				tmpNd.ID = row["ID"].ToString();  
				tmpNd.Text = row["NAME"].ToString();
				tmpNd.Expanded = bExpand;
				if (!bExpand && Nds.Parent.GetType().ToString() == "Microsoft.Web.UI.WebControls.TreeView")
					tmpNd.Expanded = true;
				if (bCheck)
					tmpNd.CheckBox = true;
				Nds.Add(tmpNd);
				InitTree(ref dtList,tmpNd.Nodes,tmpNd.ID,bCheck,bExpand);
			}			
		}

		/// <summary>
		/// 初始化树结构
		/// </summary>
		static private void InitTree(ref DataSet dsList, TreeNodeCollection Nds, string parentId, bool bCheck,bool bExpand)
		{
			if (dsList == null || dsList.Tables.Count < 1 || dsList.Tables[0].Rows.Count < 1)
				return;
			TreeNode tmpNd;
			DataRow[] rows = dsList.Tables[0].Select("Fields1='" + parentId + "'");
			
			foreach(DataRow row in rows)
			{
				tmpNd = new TreeNode();
				tmpNd.ID = row["Fields0"].ToString();  
				tmpNd.Text = row["Fields2"].ToString();
				tmpNd.Expanded = bExpand;
				if (bCheck)
					tmpNd.CheckBox = true;
				Nds.Add(tmpNd);
				InitTree(ref dsList,tmpNd.Nodes,tmpNd.ID,bCheck,bExpand);
			}			
		}
		/// <summary>
		/// 
		/// </summary>
		static public void SetCombListData(DropDownList ddlt,string sId)
		{
			try
			{
				ddlt.SelectedValue = sId;
			}
			catch
			{
				ddlt.SelectedIndex = 0;
			}
		}
*/
		/// <summary>
		/// 设置字典DropDownList
		/// </summary>
		static public string SetCombListStd(DropDownList ddlt,string sDictType,bool bAddNull,short iType, string sSelected)
		{
			DataTable dtList = null;
			string sError = CPublicFunction.GetList("SELECT DMZ,DMMS FROM SYS_STANDERNOTE WHERE ZDLX = '" + sDictType + "' AND ZT = '0' ORDER BY DMZ",ref dtList);
			if (sError == "")
				sError = SetCombList(ddlt,dtList,bAddNull,iType,sSelected);
			if (dtList != null)
				dtList.Dispose();
			return sError;
		}

		static public string SetCombList(DropDownList ddlt,string sSql,bool bAddNull,short iType, string sSelected)
		{
			DataTable dtList = null;
			string sError = CPublicFunction.GetList(sSql,ref dtList);
			if (sError == "")
				sError = SetCombList(ddlt,dtList,bAddNull,iType,sSelected);
			if (dtList != null)
				dtList.Dispose();
			return sError;
		}

		static public string SetCombList(DropDownList ddlt,DataTable dtList,bool bAddNull,short iType,string sSelected)
		{
			string sError = "";
			ddlt.Items.Clear();
			int iLen = 0;
			if (dtList != null && dtList.Rows.Count > 0)
				iLen = dtList.Rows.Count;
            if (bAddNull)
				iLen += 1;
            if (iLen < 1)
                return "";
			try
			{
				ListItem[] ltiTemp = new ListItem[iLen];
				int i = 0;
				if (bAddNull)
				{
					i = 1;
					ltiTemp[0] = new ListItem();
					ltiTemp[0].Text = "";
					ltiTemp[0].Value = "";
				}
				int iAdd = i * -1;
				for (; i < iLen; i ++)
				{
					ltiTemp[i] = new ListItem();
					switch(iType)
					{
						case 1:
							ltiTemp[i].Text = dtList.Rows[i + iAdd][1].ToString();
							break;
						case 2:
							ltiTemp[i].Text = dtList.Rows[i + iAdd][0].ToString();
							break;
						default:
							ltiTemp[i].Text = dtList.Rows[i + iAdd][0].ToString() + ":" + dtList.Rows[i + iAdd][1].ToString();
							break;
					}
					ltiTemp[i].Value = dtList.Rows[i + iAdd][0].ToString();
				}
				ddlt.Items.AddRange(ltiTemp);
                ddlt.SelectedValue = sSelected;
			}
			catch (Exception ex)
			{
				sError = ex.Message;
			}
            if (ddlt.SelectedIndex < 0 && ddlt.Items.Count > 0)
                ddlt.SelectedIndex = 0;
			return sError;
		}

		static public void SetListBoxData(ListBox ddlt,string sId)
		{
			try
			{
				ddlt.SelectedValue = sId;
			}
			catch
			{
				ddlt.SelectedIndex = -1;
				if (ddlt.Items.Count > 0)
					ddlt.SelectedIndex = 0;
			}
		}

		/// <summary>
		/// 设置字典ListBox
		/// </summary>
		static public string SetNewListBox(ListBox ddlt,string sSql,short iType,string sSelected)
		{
			DataTable dtList = null;
			string sError = CPublicFunction.GetList(sSql,ref dtList);
			ddlt.Items.Clear();
			if (sError == "" && dtList != null && dtList.Rows.Count > 0)
			{
				ListItem[] ltiTemp = new ListItem[dtList.Rows.Count];
				for (int i = 0; i < dtList.Rows.Count; i ++)
				{
					ltiTemp[i] = new ListItem();
					switch(iType)
					{
						case 1:
							ltiTemp[i].Text = dtList.Rows[i][0].ToString();
							break;
						case 2:
							ltiTemp[i].Text = dtList.Rows[i][1].ToString();
							break;
						default:
							ltiTemp[i].Text = dtList.Rows[i][0].ToString() + ":" + dtList.Rows[i][1].ToString();
							break;
					}
					ltiTemp[i].Value = dtList.Rows[i][0].ToString();
				}

				ddlt.Items.AddRange(ltiTemp);
                ddlt.DataBind();
			}
			if (dtList != null)
				dtList.Dispose();
            SetListBoxData(ddlt, sSelected);
            if (ddlt.SelectedIndex < 0 && ddlt.Items.Count > 0)
                ddlt.SelectedIndex = 0;
			return sError;
		}

		static public void SetNewListBox(ListBox ddlt,DataTable dtList,short iType,string sSelected)
		{
			ddlt.Items.Clear();
			int iSize = 0;
			if (dtList != null && dtList.Rows.Count > 0)
				iSize = dtList.Rows.Count;
			if (iSize > 0)
			{
				ListItem[] ltiTemp = new ListItem[iSize];
				for (int i = 0; i < iSize; i ++)
				{
					ltiTemp[i] = new ListItem();
					switch(iType)
					{
						case 1:
							ltiTemp[i].Text = dtList.Rows[i][0].ToString();
							break;
						case 2:
							ltiTemp[i].Text = dtList.Rows[i][1].ToString();
							break;
						default:
							ltiTemp[i].Text = dtList.Rows[i][0].ToString() + ":" + dtList.Rows[i][1].ToString();
							break;
					}
					ltiTemp[i].Value = dtList.Rows[i][0].ToString();
				}

				ddlt.Items.AddRange(ltiTemp);
				ddlt.DataBind();
			}
            SetListBoxData(ddlt, sSelected);
            if (ddlt.SelectedIndex < 0 && ddlt.Items.Count > 0)
                ddlt.SelectedIndex = 0;
        }

        public static string MD5Encrypt(string sSource)
		{
			MD5 md5 = new MD5CryptoServiceProvider();
			byte[] t = md5.ComputeHash(Encoding.Default.GetBytes(sSource));
			StringBuilder sDistinct = new StringBuilder(32);
			for (int i = 0; i < t.Length; i++)
			{
				sDistinct.Append(t[i].ToString("x").PadLeft(2, '0'));
			}
			return sDistinct.ToString();
		}

		static public string GetTxtFile(string sFileName)
		{
			string sFile = "";
			StreamReader sr = null;
			try
			{
				sr = new StreamReader(sFileName,System.Text.Encoding.GetEncoding("GB2312"));
				while (true)
				{
					sFileName = sr.ReadLine();
					if (sFileName == null)
						break;
					sFile += sFileName;
					sFile += "\r\n";
				}
			}
			catch
			{
			}
			if (sr != null)
				sr.Close();
			return sFile;
		}

		public static void ClearCheck(System.Web.UI.Page oPage,string sCheck,int iLen,int iCheck)
		{
			System.Web.UI.Control chControl = null;
			for (int i = 1; i <= iLen; i ++)
			{
				chControl = oPage.FindControl(sCheck + i.ToString());
				if (chControl != null)
				{
					if (iCheck == i)
						((System.Web.UI.WebControls.CheckBox)chControl).Checked = true;
					else
						((System.Web.UI.WebControls.CheckBox)chControl).Checked = false;
				}
			}
		}

		public static int GetLoc(char[] sSource,char cValue)
		{
			int iLoc = 0;
			int iLen = sSource.Length;
			for (int i = 0; i < iLen; i ++)
			{
				if (sSource[i] == cValue)
				{
					iLoc = i;
					break;
				}
			}
			return iLoc;
		}

		public static int GetCheckLoc(string sValue)
		{
			if (sValue == "")
				return 0;
			return GetLoc(m_sCheck,Convert.ToChar(sValue.Substring(0,1)));
		}

		public static void SetMultiCheck(System.Web.UI.Page oPage,string sCheck,int iLen,string sValue)
		{
			ClearCheck(oPage,sCheck,iLen,0);
			System.Web.UI.Control chControl = null;
			int iVLen = sValue.Length;
			for (int i = 0; i < iVLen; i ++)
			{
				int iLoc = GetCheckLoc(sValue.Substring(i,1));
				chControl = oPage.FindControl(sCheck + iLoc.ToString());
				if (chControl != null)
					((System.Web.UI.WebControls.CheckBox)chControl).Checked = true;
			}
		}

		public static string GetSingalCheck(System.Web.UI.Page oPage,string sCheck,int iLen)
		{
			string sChecked = "";
			System.Web.UI.Control chControl = null;
			for (int i = 1; i <= iLen; i ++)
			{
				chControl = oPage.FindControl(sCheck + i.ToString());
				if (chControl != null && ((System.Web.UI.WebControls.CheckBox)chControl).Checked)
				{
					sChecked = m_sCheck[i].ToString();
					break;
				}
			}
			return sChecked;
		}

		public static string GetMultiCheck(System.Web.UI.Page oPage,string sCheck,int iLen)
		{
			string sChecked = "";
			System.Web.UI.Control chControl = null;
			for (int i = 1; i <= iLen; i ++)
			{
				chControl = oPage.FindControl(sCheck + i.ToString());
				if (chControl != null && ((System.Web.UI.WebControls.CheckBox)chControl).Checked)
					sChecked += m_sCheck[i].ToString();
			}
			return sChecked;
		}

		public static string GetColHtml(DataRow oRow,int iCol)
		{
			string sTemp = "";
			if (oRow != null && oRow.Table.Columns.Count > iCol)
				sTemp = oRow[iCol].ToString();
			if (sTemp == "")
				sTemp = " ";
			return sTemp.Replace(" ","&nbsp;");
		}

		public static string GetHtmlValue(string sValue)
		{
			string sTemp = sValue.Replace("&nbsp;"," ");
			if (sTemp == " ")
				sTemp = "";
			return sTemp;
		}

		public static string GetColStr(DataRow oRow,int iCol)
		{
			string sTemp = "";
			if (oRow != null && oRow.Table.Columns.Count > iCol)
				sTemp = oRow[iCol].ToString();
			return sTemp;
		}

		public static string AddTable(string sPre, int iOffset, int iLimmit, int iCols, DataTable dtList,ref string sFile, bool bHtml)
		{
			int iLen = 0;
			if (dtList != null)
				iLen = dtList.Rows.Count;
			for (int i = 0; i < iLimmit; i ++)
			{
				if (i < iLen)
					AddRow(sPre,iOffset,i,iCols,dtList.Rows[i],ref sFile,bHtml);
				else
					AddRow(sPre,iOffset,i,iCols,null,ref sFile,bHtml);
			}
			return sFile;
		}

		public static string AddView(string sPre, int iOffset, int iLimmit, int iCols, DataView dvList,ref string sFile, bool bHtml)
		{
			int iLen = 0;
			if (dvList != null)
				iLen = dvList.Count;
			for (int i = 0; i < iLimmit; i ++)
			{
				if (i < iLen)
					AddRow(sPre,iOffset,i,iCols,dvList[i].Row,ref sFile,bHtml);
				else
					AddRow(sPre,iOffset,i,iCols,null,ref sFile,bHtml);
			}
			return sFile;
		}

		public static string AddRow(string sPre, int iOffset, int iRow, int iCols, DataRow oRow,ref string sFile, bool bHtml)
		{
			for (int i = 0; i < iCols; i ++)
				AddData(sPre,iOffset,iRow,i,oRow,ref sFile,bHtml);
			return sFile;
		}

		public static void AddPageRow(System.Web.UI.Page oPage,string sPre, int iOffset, int iRow, int iCols, DataRow oRow)
		{
			System.Web.UI.Control oControl = null;
			for (int i = 0; i < iCols; i ++)
			{
				oControl = oPage.FindControl(sPre + iRow.ToString("00") + i.ToString("00"));
				if (oControl != null)
					((System.Web.UI.HtmlControls.HtmlGenericControl)oControl).InnerHtml = GetColHtml(oRow,iOffset + i);
			}
		}

		public static string MegerTable(DataTable dtList, int iOffset, int iCol, bool bHtml)
		{
			string sMeger = "";
			int iSize = 0;
			if (dtList != null && dtList.Rows.Count > 0)
				iSize = dtList.Rows.Count;
			for (int i = 0; i < iSize; i ++)
			{
				if (sMeger != "")
				{
					if (bHtml)
						sMeger += "<br>";
					else
						sMeger += "\r\n";
				}
				for (int j = 0; j < iCol; j ++)
				{
					if (bHtml)
					{
						if (j > 0)
							sMeger += "&nbsp;&nbsp;";
						sMeger += GetColHtml(dtList.Rows[i],iOffset + j);
					}
					else
					{
						if (j > 0)
							sMeger += "  ";
						sMeger += GetColStr(dtList.Rows[i],iOffset + j);
					}
				}
			}
			return sMeger;
		}

		public static void WriteXML(string sError,ref DataTable dtList,ref string sXML)
		{
			DataTable dtResult = new DataTable();
			dtResult.TableName = "head";
			dtResult.Columns.Add("result",System.Type.GetType("System.String"));
			dtResult.Columns.Add("message",System.Type.GetType("System.String"));
			dtResult.Columns.Add("count",System.Type.GetType("System.String"));

			int iSize = 0;
			if (dtList != null && dtList.Rows.Count > 0)
				iSize = dtList.Rows.Count;

			DataRow drResult = dtResult.NewRow();
			if (sError != "")
				drResult[0] = "0";
			else
				drResult[0] = "1";
			drResult[1] = sError;
			drResult[2] = iSize.ToString();

			dtResult.Rows.Add(drResult);

			DataSet dsList = new DataSet();
			dsList.DataSetName = "root";
			dsList.Tables.Add(dtResult);
			if (dtList != null && dtList.Rows.Count > 0)
				dsList.Tables.Add(dtList);

            sXML = WriteXML(ref dsList);
			dsList.Dispose();
		}

        public static string WriteXML(ref DataSet dsList)
        {
            string sResult = "";
            if (dsList == null || dsList.Tables.Count < 1)
                return "";
            System.IO.StringWriter oStream = new StringWriter();
            dsList.WriteXml(oStream);
            sResult = oStream.ToString();
            oStream.Close();
            return sResult;
        }

        public static string ReadXML(string sXML, ref DataSet dsList)
        {
            string sError = "";
            if (dsList != null)
            {
                dsList.Dispose();
                dsList = null;
            }
            if (sXML == "")
                return "";

            try
            {
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.LoadXml(sXML);
                XmlNodeReader oReader = new XmlNodeReader(xmlDoc);
                dsList = new DataSet();
                dsList.ReadXml(oReader);
            }
            catch (Exception e)
            {
                sError = e.Message;
            }
            return sError;
        }

        public static string AddData(string sPre, int iOffset, int iRow, int iCol, DataRow oRow, ref string sFile, bool bHtml)
		{
			if (bHtml)
				sFile = sFile.Replace(sPre + iRow.ToString("00") + iCol.ToString("00"),GetColHtml(oRow,iOffset + iCol));
			else
				sFile = sFile.Replace(sPre + iRow.ToString("00") + iCol.ToString("00"),GetColStr(oRow,iOffset + iCol));
			return sFile;
		}

		public static string AddCheck(string sPre,int iRow, int iCols,int iCheck,ref string sFile)
		{
			for (int i = 1; i <= iCols; i ++)
			{
				if (i == iCheck)
				{
					sFile = sFile.Replace(sPre + iRow.ToString("00") + i.ToString("00"),"<font style='FONT-FAMILY:Wingdings;'>&thorn;</font>");
				}
				else
					sFile = sFile.Replace(sPre + iRow.ToString("00") + i.ToString("00"),"□");
			}
			return sFile;
		}

		public static string AddMultiCheck(string sPre,int iRow, int iCols,string sValue,ref string sFile)
		{
			int iLen = sValue.Length;
			int i = 0;
			for (; i < iLen; i ++)
				sFile = sFile.Replace(sPre + iRow.ToString("00") + GetCheckLoc(sValue.Substring(i,1)).ToString("00"),"<font style='FONT-FAMILY:Wingdings;'>&thorn;</font>");
			for (i = 1; i <= iCols; i ++)
				sFile = sFile.Replace(sPre + iRow.ToString("00") + i.ToString("00"),"<font style='FONT-FAMILY:Wingdings;'>&yacute;</font>");
			return sFile;
		}

		public static string AddSplit(string sPre,int iRow, int iLimmit,string sSource,ref string sFile,bool bAdd)
		{
			for (int i = 0; i < iLimmit; i ++)
			{
				string sTemp = " ";
				if (i < sSource.Length)
					sTemp = sSource.Substring(i,1);
				if (bAdd)
					sTemp = " " + sTemp + " ";
				sFile = sFile.Replace(sPre + iRow.ToString("00") + i.ToString("00"),sTemp.Replace(" ","&nbsp;"));
			}
			return sFile;
		}

		static public string QStat(string sReport,string sSql,ref string sFileName,ref int iRows)
		{
			string sResult = "";
			sFileName ="";
			string[] saFile = null;
			DataTable dtList = null;
			int iRead = 0;
			int iReadEnd = 0;

			string sError = CPublicFunction.GetList("SELECT WJMC,WJMB,BTJS FROM REP_DEFINE WHERE BBXH ='" + sReport + "'",ref dtList);
			if (sError == "")
			{
				if (dtList != null && dtList.Rows.Count > 0)
				{
					sFileName = dtList.Rows[0][0].ToString();
					saFile = dtList.Rows[0][1].ToString().Split(Convert.ToChar("\n"));
					iReadEnd = GetInt(dtList.Rows[0][2].ToString());

					sError = CPublicFunction.GetList("SELECT SJLY,SJKS,SJJS,HJBJ,HBBJ,MHLS,MYHS FROM REP_ITEM WHERE BBXH ='" + sReport + "' ORDER BY SJKS",ref dtList);
				}
			}

			if (sError == "" && sFileName != "" && saFile.Length > 0)
			{
				int iSize = 0;
				if (dtList != null && dtList.Rows.Count > 0)
					iSize = dtList.Rows.Count;
				if (iSize == 0)
					iReadEnd = saFile.Length;
				//读取文件头
				for ( ; iRead < iReadEnd; iRead ++)
				{
					if (saFile.Length > iRead)
						sResult += saFile[iRead];
					else
						sResult += "\r";
					sResult += "\n";
				}

				for (int i = 0; i < iSize; i ++)
				{
					//读取表格头
					iReadEnd = GetInt(dtList.Rows[i][1].ToString());
					for ( ; iRead < iReadEnd; iRead ++)
					{
						if (saFile.Length > iRead)
							sResult += saFile[iRead];
						else
							sResult += "\r";
						sResult += "\n";
					}
				
					//读取数据模板
					string sTemplate = "";
					iReadEnd = GetInt(dtList.Rows[i][2].ToString());
					for ( ; iRead < iReadEnd; iRead ++)
					{
						if (saFile.Length > iRead)
							sTemplate += saFile[iRead];
						else
							sTemplate += "\r";
						sTemplate += "\n";
					}

					string sResult1 = "";
					iRows = GetInt(dtList.Rows[i][6].ToString());
					sError = WriteStatItem(sSql,sTemplate,dtList.Rows[i][3].ToString(),dtList.Rows[i][4].ToString(),GetInt(dtList.Rows[i][5].ToString()),ref iRows,ref sResult1);
					if (sError == "")
						sResult += sResult1;
					
				}

				for ( ; iRead < saFile.Length; iRead ++)
				{
					sResult += saFile[iRead];
					sResult += "\n";
				}
			}
			if (dtList != null)
				dtList.Dispose();
			return sResult;
		}

		static public string Stat(string sReport, string sOrganize, string sOrganizeName,string sPoint, string sPointName, string sBegin, string sEnd, ref string sFileName,ref int iRows)
		{
			string sResult = "";
			sFileName ="";
			string[] saFile = null;
			DataTable dtList = null;
			int iRead = 0;
			int iReadEnd = 0;

			string sError = CPublicFunction.GetList("SELECT WJMC,WJMB,BTJS FROM REP_DEFINE WHERE BBXH ='" + sReport + "'",ref dtList);
			if (sError == "")
			{
				if (dtList != null && dtList.Rows.Count > 0)
				{
					sFileName = dtList.Rows[0][0].ToString();
					saFile = dtList.Rows[0][1].ToString().Replace("|KSSJ", sBegin).Replace("|JSSJ", sEnd).Replace("|TJDW", sOrganizeName + " " + sPointName).Replace("|DWBH",sPoint).Replace("|BMBM",sOrganize).Split(Convert.ToChar("\n"));
					iReadEnd = GetInt(dtList.Rows[0][2].ToString());

					sError = CPublicFunction.GetList("SELECT SJLY,SJKS,SJJS,HJBJ,HBBJ,MHLS,MYHS FROM REP_ITEM WHERE BBXH ='" + sReport + "' ORDER BY SJKS",ref dtList);
				}
			}

			if (sError == "" && sFileName != "" && saFile.Length > 0)
			{
				int iSize = 0;
				if (dtList != null && dtList.Rows.Count > 0)
					iSize = dtList.Rows.Count;
				if (iSize == 0)
					iReadEnd = saFile.Length;
				//读取文件头
				for ( ; iRead < iReadEnd; iRead ++)
				{
					if (saFile.Length > iRead)
						sResult += saFile[iRead];
					else
						sResult += "\r";
					sResult += "\n";
				}
				sResult = sResult.Replace("|KSSJ",sBegin).Replace("|JSSJ",sEnd).Replace("|TJDW",sOrganizeName + " " + sPointName);

				for (int i = 0; i < iSize; i ++)
				{
					//读取表格头
					iReadEnd = GetInt(dtList.Rows[i][1].ToString());
					for ( ; iRead < iReadEnd; iRead ++)
					{
						if (saFile.Length > iRead)
							sResult += saFile[iRead];
						else
							sResult += "\r";
						sResult += "\n";
					}
				
					//读取数据模板
					string sTemplate = "";
					iReadEnd = GetInt(dtList.Rows[i][2].ToString());
					for ( ; iRead < iReadEnd; iRead ++)
					{
						if (saFile.Length > iRead)
							sTemplate += saFile[iRead];
						else
							sTemplate += "\r";
						sTemplate += "\n";
					}

					string sSql = dtList.Rows[i][0].ToString();
					sSql = sSql.Replace("|TJDW",sOrganize).Replace("|KSSJ",sBegin).Replace("|JSSJ", sEnd).Replace("|DWBH", sPoint);

					string sResult1 = ""; 
					iRows = GetInt(dtList.Rows[i][6].ToString());
					sError = WriteStatItem(sSql,sTemplate,dtList.Rows[i][3].ToString(),dtList.Rows[i][4].ToString(),GetInt(dtList.Rows[i][5].ToString()),ref iRows,ref sResult1);
					if (sError == "")
						sResult += sResult1;
					
				}

				for ( ; iRead < saFile.Length; iRead ++)
				{
					sResult += saFile[iRead];
					sResult += "\n";
				}
			}
			if (dtList != null)
				dtList.Dispose();
			return sResult;
		}
		
		static public string WriteStatItem(string sSql,string sTemplate,string sTotalFlag,string sTotalCalc,int iColNumber,ref int iLimmit,ref string sResult)
		{
			DataTable dtList = null;
			string sError = CPublicFunction.GetList(sSql,ref dtList);
			if (sError == "")
				sResult = WriteStatItem(ref dtList,sTemplate,sTotalFlag,sTotalCalc,iColNumber,ref iLimmit);
			if (dtList != null)
				dtList.Dispose();
			return sError;
		}

		/// <summary>
		/// 
		/// </summary>
		static public string WriteStatItem(ref DataTable dtList,string sTemplate,string sTotalFlag,string sTotalCalc,int iColNumber,ref int iLimmit)
		{
			DataRow drTotal = null;
			string sResult = "";
			int iNumber = 0;
			if (dtList != null && dtList.Rows.Count > 0)
			{
				if (sTotalFlag != "")
					drTotal = dtList.NewRow();
				iNumber = dtList.Rows.Count;
			}
			else
			{
				if (sTotalFlag != "")
					AddNullTotal(ref drTotal,sTotalFlag,iColNumber);
			}

			if (iLimmit == 0)
				iLimmit = iNumber;

			int i = 0;
			for (; i < iLimmit; i ++)
			{
				string sTempRow = sTemplate.Replace("|LXH",(i + 1).ToString());
				for (int j = 0; j < iColNumber; j ++)
				{
					if (i < iNumber)
					{
						sTempRow = sTempRow.Replace("|L" + j.ToString("000"),GetColHtml(dtList.Rows[i],j));
						if (j < dtList.Columns.Count && drTotal != null)
							AddTotalItem(ref drTotal,sTotalFlag,dtList.Rows[i][j].ToString(),i,j);
					}
					else
						sTempRow = sTempRow.Replace("|L" + j.ToString("000"),"&nbsp;");
				}
				sResult += sTempRow;
			}

			//写合计
			if (drTotal != null)
			{
				//计算横向比
				if (sTotalCalc != "")
					AddColScale(ref drTotal,sTotalCalc);

				string sTempRow = sTemplate.Replace("|LXH",i.ToString());
				for (int j = 0; j < iColNumber; j ++)
					sTempRow = sTempRow.Replace("|L" + j.ToString("000"),GetColHtml(drTotal,j));
				sResult += sTempRow;
			}
			if (drTotal != null)
				drTotal = null;
			iLimmit = iNumber;
			return sResult;
		}

		static private void AddNullTotal(ref DataRow drTotal,string sTotalFlag,int iColNumber)
		{
			DataTable dtTotal = new DataTable();
			for (int j = 0; j < iColNumber; j ++)
				dtTotal.Columns.Add("Fields" + j.ToString());
			drTotal = dtTotal.NewRow();

			for (int j = 0; j < iColNumber; j ++)
				AddTotalItem(ref drTotal,sTotalFlag,"0",0,j);
			dtTotal.Dispose();
		}

		static private void AddColScale(ref DataRow drTotal,string sTotalCalc)
		{
			string[] sCalc = sTotalCalc.Split(Convert.ToChar("|"));
			for (int i = 0; i < sCalc.Length; i ++)
			{
				string[] sCalcItem = sCalc[i].Split(Convert.ToChar(","));
				if (sCalcItem.Length > 2)
				{
					int iSubCol = GetInt(sCalcItem[0]);
					if (iSubCol < 0 || iSubCol >= drTotal.ItemArray.Length)
						continue;
					int iTotalCol = GetInt(sCalcItem[1]);
					if (iTotalCol < 0 || iTotalCol >= drTotal.ItemArray.Length || iTotalCol == iSubCol)
						continue;
					int iTotal = GetInt(sCalcItem[2]);
					if (iTotalCol < 0 || iTotalCol >= drTotal.ItemArray.Length || iTotalCol == iTotal || iTotal == iSubCol)
						continue;
					iSubCol = GetInt(drTotal[iSubCol].ToString());
					iTotalCol = GetInt(drTotal[iTotalCol].ToString());
					if (iTotalCol > 0)
					{
						float fTotal = (float)iSubCol/iTotalCol;
						int iType = 0;
						if (sCalcItem.Length > 3)
							iType = GetShort(sCalcItem[3]);
						switch (iType)
						{
							case 1:
							case 2:
								fTotal *= 100;
								break;
							case 3:
							case 4:
								fTotal *= 1000;
								break;
							default:
								break;
						}
						drTotal[iTotal] = fTotal.ToString("#0.00");
						if (iType == 3)
							drTotal[iTotal] += "‰";
						if (iType == 1)
							drTotal[iTotal] += "％";
					}
					else
						drTotal[iTotal] = "-";

				}
			}
		}

		static private void AddTotalItem(ref DataRow drTotal,string sTotalFlag,string sValue,int iRows,int iColNumber)
		{
			string sFlag = SubString(sTotalFlag,iColNumber,1);
			if (iRows == 0)
			{
				switch(sFlag)
				{
					case "1":
						drTotal[iColNumber] = "合计";
						break;
					case "2":
						drTotal[iColNumber] = sValue;
						break;
					case "3":
						drTotal[iColNumber] = "100.00%";
						break;
					case "4":
						drTotal[iColNumber] = "1000.00‰";
						break;
					default:
						drTotal[iColNumber] = "";
						break;
				}
			}
			else
			{
				if (sFlag == "2")
					drTotal[iColNumber] = Convert.ToString(GetInt(drTotal[iColNumber].ToString()) + GetInt(sValue));
			}
		}

        public static object GetHashValue(Hashtable hsResult, string sKey)
        {
            if (hsResult != null && hsResult.Contains(sKey))
                return hsResult[sKey];
            return null;
        }
        public static void SetHashValue(ref Hashtable hsResult, string sKey, object oValue)
        {
            if (hsResult == null)
                hsResult = new Hashtable();
            if (hsResult.Contains(sKey))
                hsResult[sKey] = oValue;
            else
                hsResult.Add(sKey, oValue);
        }
        private static string GetKey(string sJson, ref int iRead)
        {
            string sKey = "";
            short iJsonSplit = GetJsonSplit(sJson, ref iRead);
            if (iJsonSplit != 3 && iJsonSplit != 11)
                throw new Exception("Json格式不正确1！");
            if (iJsonSplit == 3)
            {
                sKey = GetJsonString(sJson, ref iRead);
                if (GetJsonSplit(sJson, ref iRead) != 4)
                    throw new Exception("Json格式不正确2！");
            }
            return sKey;
        }
        private static string GetJsonSimple(string sJson,ref int iRead)
        {
            int iStart = iRead - 1;
            while (IsJsonFlag(sJson.Substring(iRead, 1)) == 0)
                iRead ++;
            return sJson.Substring(iStart, iRead - iStart);
        }
        private static string GetJsonString(string sJson, ref int iRead)
        {
            int iStart = iRead;
            while (true)
            {
                if (IsJsonFlag(sJson.Substring(iRead, 1)) == 6)
                    iRead += 2;
                else
                {
                    iRead++;
                    if (IsJsonFlag(sJson.Substring(iRead - 1, 1)) == 3)
                        break;
                }
            }
            return sJson.Substring(iStart, iRead - iStart - 1).Replace("\\\"", "\"").Replace("\\\'", "\'").Replace("\\\\", "\\");
        }
        private static short IsJsonFlag(string sValue)
        {
            short iFlag = 0;
            switch(sValue)
            {
                case "{":
                    iFlag = 1;
                    break;
                case "}":
                    iFlag = 11;
                    break;
                case "[":
                    iFlag = 2;
                    break;
                case "]":
                    iFlag = 12;
                    break;
                case "\"":
                    iFlag = 3;
                    break;
                case ":":
                    iFlag = 4;
                    break;
                case ",":
                    iFlag = 5;
                    break;
                case "\\":
                    iFlag = 6;
                    break;
                case " ":
                case "\r":
                case "\n":
                case "\t":
                    iFlag = 7;
                    break;
            }
            return iFlag;
        }
        private static short GetJsonSplit(string sJson, ref int iRead)
        {
            short iFlag = 7;
            while (iFlag == 7)
            {
                iFlag = IsJsonFlag(sJson.Substring(iRead, 1));
                iRead++;
            }
            return iFlag;
        }
        private static object GetValue(string sJson,ref int iRead)
        {
            object oValue = null; 
            short iFlag = 5;
            switch (GetJsonSplit(sJson,ref iRead))
            {
                case 1:
                    Hashtable hJosn = new Hashtable();
                    while (iFlag == 5)
                    {
                        string sKey = GetKey(sJson, ref iRead);
                        if (sKey != "")
                        {
                            object oNote = GetValue(sJson, ref iRead);
                            hJosn.Add(sKey, oNote);
                            iFlag = GetJsonSplit(sJson, ref iRead);
                        }
                        else
                            iFlag = 11;
                    }
                    if (iFlag != 11)
                        throw new Exception("Json格式不正确3！");
                    oValue = hJosn;
                    break;
                case 2:
                    ArrayList arrJson = new ArrayList();
                    while (iFlag == 5)
                    {
                        object oNote = GetValue(sJson, ref iRead);
                        arrJson.Add(oNote);
                        iFlag = GetJsonSplit(sJson, ref iRead);
                    }
                    if (iFlag != 12)
                        throw new Exception("Json格式不正确4！");
                    oValue = arrJson;
                    break;
                case 3:
                    oValue = GetJsonString(sJson, ref iRead);
                    break;
                case 0:
                    string sValue = GetJsonSimple(sJson, ref iRead);
                    switch (sValue)
                    {
                        case "true":
                            oValue = true;
                            break;
                        case "false":
                            oValue = false;
                            break;
                        default:
                            oValue = CPublicFun.GetDouble(sValue);
                            break;
                    }
                    break;
                default:
                    throw new Exception("Json格式不正确5！");
                    break;
            }
            return oValue;
        }
        public static string ParserJson(string sJson,ref Hashtable hJson)
        {
            string sError = "";
            if (hJson != null)
                hJson.Clear();
            int iRead = 0;
            object oValue = null;
            try
            {
                oValue = GetValue(sJson, ref iRead);
            }
            catch(Exception e)
            {
                sError = e.Message;
            }
            if (oValue.GetType().FullName == "System.Collections.Hashtable")
                hJson = (Hashtable)oValue;
            else
                sError = "Json格式不正确！";
            return sError;
        }

        private static void AddJsonArrayValue(ArrayList oValue, ref string sJson)
        {
            sJson += "[";
            int iSize = (oValue).Count;
            for (int i = 0; i < iSize; i++)
            {
                AddJsonValue(oValue[i], ref sJson);
                if (i < iSize - 1)
                    sJson += ",";
            }
            sJson += "]";
        }
        private static void AddJsonString(string sValue, ref string sJson)
        {
            sJson += "\"" + sValue.Replace("\\", "\\\\").Replace("\'", "\\\'").Replace("\"", "\\\"") + "\"";
        }
        private static void AddJsonValue(object oValue,ref string sJson)
        {
            switch (oValue.GetType().FullName)
            {
                case "System.String": //字符型
                    AddJsonString((string)oValue, ref sJson);
                    break;
                case "System.Collections.Hashtable": //对象
                    AddJson((Hashtable)oValue, ref sJson);
                    break;
                case "System.Collections.ArrayList":
                    AddJsonArrayValue((ArrayList)oValue, ref sJson);
                    break;
                case "System.Boolean":
                    if ((bool)oValue)
                        sJson += "true";
                    else
                        sJson += "false";
                    break;
                default: //数值型 布尔型
                    sJson += oValue.ToString();
                    break;
            }
        }
        public static void AddJson(Hashtable hJson,ref string sJson)
        {
            sJson += "{";
            int iCount = 0;
            if (hJson != null)
                iCount = hJson.Count;
            if (iCount > 0)
            {
                IDictionaryEnumerator oEnumerator = hJson.GetEnumerator();
                while (oEnumerator.MoveNext())
                {
                    AddJsonString((string)oEnumerator.Key, ref sJson);
                    sJson += ":";
                    AddJsonValue(oEnumerator.Value,ref sJson);
                    if (iCount > 1)
                        sJson += ",";
                    iCount --;
                }
            }
            sJson += "}";
        }
    }
}
