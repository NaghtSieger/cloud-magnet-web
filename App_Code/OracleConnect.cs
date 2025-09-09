using System;
using System.Data;
using System.Data.OracleClient;
using System.Web;


namespace CloudMagnetWeb
{
	public class OracleConnect
	{
		private static string msConnString = "";
		public static string ConnString
		{
			get
			{
				return msConnString;
			}
			set
			{
				msConnString = value;
				miState = 0;
			}
		}

		//连接数量
		private static int miConnect = 0;
		public static int ConnNumber
		{
			get
			{
				return miConnect;
			}
		}

		private static int miState = 0;
		public static int State
		{
			get
			{
				return miState;
			}
		}

		private OracleConnection conn = null;

		public string Connect()
		{
			return Connect(ref conn);
		}

		private static string msConnLock = "msConnLock";
		public static string Connect(ref OracleConnection oConn)
		{
			if (oConn != null)
				return "";
			string sError = "";
			lock(msConnLock)
			{
				try
				{
					if (msConnString == "")
					{
						if (HttpContext.Current.Application["Connect"] != null)
							msConnString = HttpContext.Current.Application["Connect"].ToString();
					}
					oConn = new OracleConnection(msConnString);
					oConn.Open();
				}
				catch (Exception ec)
				{
					oConn = null;
					sError = ec.Message;
				}
				if (sError == "")
				{
					miState = 1;
					miConnect++;
				}
				else
				{
					miState = 0;
				}
			}
			return sError;
		}

		public void Close()
		{
			Close(ref conn);
		}

		public static void Close(ref OracleConnection oConn)
		{
			lock(msConnLock)
			{
				try
				{
					if (oConn != null)
					{
						if (miConnect > 0)
							miConnect --;
						oConn.Close();
					}
				}
				catch
				{
				}
			}
			oConn = null;
		}

		public static string ExecSSql(string sSql, OracleParameter[] parms)
		{
			OracleConnection oConn = null;
			string sError = ExecSql(ref oConn, sSql, parms);
			Close(ref oConn);
			return sError;
		}

		public string ExecSql(string sSql, OracleParameter[] parms)
		{
			return ExecSql(ref conn, sSql, parms);
		}

		private static string ExecSql(ref OracleConnection oConn,string sOracle, OracleParameter[] parms)
		{
			string sError = Connect(ref oConn);
			OracleCommand command = null;
			if (sError == "")
			{
				try
				{
					command = new OracleCommand(sOracle, oConn);
					command.CommandType = CommandType.Text;
					int iLen = 0;
					if (parms != null)
						iLen = parms.Length;
					for (int i = 0; i < iLen; i ++)
						command.Parameters.Add(parms[i]);
					command.ExecuteNonQuery();
				}
				catch (Exception ce)
				{
					sError = ce.Message;
				}
			}
			if (command != null)
				command.Dispose();
			return sError;
		}

		public static string GetSList(string sSql, ref DataTable dataTable)
		{
			OracleConnection oConn = null;
			string sError = GetList(ref oConn, sSql, ref dataTable);
			Close(ref oConn);
			return sError;
		}

		public string GetList(string sSql, ref DataTable dataTable)
		{
			return GetList(ref conn, sSql, ref dataTable);
		}

		private static string GetList(ref OracleConnection oConn,string sOracle, ref DataTable dataTable)
		{
			if (dataTable != null)
			{
				dataTable.Dispose();
				dataTable = null;
			}
			string sError = Connect(ref oConn);
			OracleCommand command = null;
			OracleDataReader dataReader = null;
			if (sError == "")
			{
				try
				{
					command = new OracleCommand(sOracle, oConn);
					command.CommandType = CommandType.Text;
					dataReader = command.ExecuteReader();//CommandBehavior.CloseConnection
					dataTable = ConvertDataReaderToDataTable(dataReader);
				}
				catch (Exception ce)
				{
					sError = ce.Message;
				}
			}
			if (dataReader != null)
			{
				dataReader.Close();
				dataReader.Dispose();
			}
			if (command != null)
				command.Dispose();
			return sError;
		}

		private static DataTable ConvertDataReaderToDataTable(OracleDataReader dataReader)
		{
			if (!dataReader.HasRows)
				return null;
			DataTable datatable = new DataTable();
			try
			{
				DataTable schemaTable = dataReader.GetSchemaTable();
				//添加字段
				foreach (DataRow row in schemaTable.Rows)
				{
					DataColumn dataColumn = new DataColumn();
					dataColumn.DataType = System.Type.GetType(row[5].ToString());
					dataColumn.ColumnName = row[0].ToString();
					datatable.Columns.Add(dataColumn);
				}

				//添加数据
				while (dataReader.Read())
				{
					DataRow row = datatable.NewRow();
					for (int i = 0; i < schemaTable.Rows.Count; i++)
					{
						row[i] = dataReader[i];
					}
					datatable.Rows.Add(row);
				}
			}
			catch
			{
				datatable = null;
			}
			return datatable;
		}

		public static OracleParameter MakeParm(string sParmName, OracleType dbType, int iSize, object value)
		{
			OracleParameter parm;
			if (iSize > 0)
				parm = new OracleParameter(sParmName, dbType, iSize);
			else
				parm = new OracleParameter(sParmName, dbType);
			parm.Direction = ParameterDirection.Input;
			parm.Value = value;
			return parm;
		}

		public static OracleParameter MakeParm(string sParmName, string sType, int iSize, object value)
		{
			OracleParameter parm;
			switch(sType)
			{
				case "B":
					parm = new OracleParameter(sParmName, OracleType.Blob);
					if (value == null)
						parm.Value = OracleLob.Null;
					iSize = 0;
					break;
				case "D":
					parm = new OracleParameter(sParmName, OracleType.DateTime);
					if (value == null)
						parm.Value = OracleDateTime.Null;
					iSize = 0;
					break;
				case "S":
					parm = new OracleParameter(sParmName, OracleType.Clob);
					if (value == null)
						parm.Value = OracleLob.Null;
					iSize = 0;
					break;
				case "N":
					parm = new OracleParameter(sParmName, OracleType.Int32);
					if (value == null)
						parm.Value = OracleNumber.Null;
					break;
				default:
					parm = new OracleParameter(sParmName, OracleType.VarChar);
					if (value == null)
						parm.Value = OracleString.Null;
					break;
			}
			parm.Direction = ParameterDirection.Input;
			if (iSize > 0)
				parm.Size = iSize;
			if (value != null)
				parm.Value = value;
			return parm;
		}

		public static OracleParameter MakeParm(string sParmName, RowItem oItem)
		{
			OracleParameter parm;
			switch(oItem.DataType)
			{
				case "B":
					parm = new OracleParameter(sParmName, OracleType.Blob);
					if (oItem.DataValue == null)
						parm.Value = OracleLob.Null;
					break;
				case "D":
					parm = new OracleParameter(sParmName, OracleType.DateTime);
					if (oItem.DataValue == null)
						parm.Value = OracleDateTime.Null;
					break;
				case "S":
					parm = new OracleParameter(sParmName, OracleType.Clob);
					if (oItem.DataValue == null)
						parm.Value = OracleLob.Null;
					break;
				case "N":
					parm = new OracleParameter(sParmName, OracleType.Number);
					if (oItem.DataValue == null)
						parm.Value = OracleNumber.Null;
					parm.Size = oItem.Len;
					break;
				default:
					parm = new OracleParameter(sParmName, OracleType.VarChar);
					if (oItem.DataValue == null)
						parm.Value = OracleString.Null;
					parm.Size = oItem.Len;
					break;
			}
			parm.Direction = ParameterDirection.Input;
			if (oItem.DataValue != null)
				parm.Value = oItem.DataValue;
			return parm;
		}

		public static OracleParameter MakeParm(string sParmName, DataRow drItem)
		{
			OracleParameter parm;
			int iLen = CPublicFun.GetInt(drItem[1].ToString());
			string sValue = drItem[2].ToString();
			switch(drItem[0].ToString())
			{
				case "B":
					parm = new OracleParameter(sParmName, OracleType.Blob);
					if (sValue == "")
						parm.Value = OracleLob.Null;
					iLen = 0;
					break;
				case "D":
					parm = new OracleParameter(sParmName, OracleType.DateTime);
					if (sValue == "")
						parm.Value = OracleDateTime.Null;
					iLen = 0;
					break;
				case "S":
					parm = new OracleParameter(sParmName, OracleType.Clob);
					if (sValue == "")
						parm.Value = OracleLob.Null;
					iLen = 0;
					break;
				case "N":
					parm = new OracleParameter(sParmName, OracleType.Number);
					if (sValue == "")
						parm.Value = OracleNumber.Null;
					if (iLen < 1)
						iLen = 10;
					break;
				default:
					parm = new OracleParameter(sParmName, OracleType.VarChar);
					if (sValue == "")
						parm.Value = OracleString.Null;
					if (iLen < 1)
						iLen = 128;
					break;
			}
			parm.Size = iLen;
			parm.Direction = ParameterDirection.Input;
			if (sValue != "")
			{
				if (drItem[0].ToString() == "B")
					parm.Value = Convert.FromBase64String(sValue);
				else
					parm.Value = sValue;
			}
			return parm;
		}	
	}
}
