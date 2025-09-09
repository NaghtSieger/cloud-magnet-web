using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Collections;
using System.Web;

namespace CloudMagnetWeb
{
	/// <summary>
	/// MysqlConnect 的摘要说明。
	/// </summary>
	public class MysqlConnect
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
            }
        }

        private static int mlPool = 100;
        private static MySqlConnection[] conn = null;
        //未连接队列
        private static Queue mQNot = new Queue();
        //空闲队列
        private static Queue mQIndle = new Queue();

        private static Object sLockConn = new Object();
        //初始化连接池
        private static void InitPool()
        {
            lock (sLockConn)
            {
                if (conn == null)
                {
                    conn = new MySqlConnection[mlPool];
                    for (int i = 0; i < mlPool; i++)
                    {
                        conn[i] = null;
                        mQNot.Enqueue(i);
                    }
                }
            }
        }
        //清理连接池
        private static void ClearIndle()
        {
            lock (sLockConn)
            {
                int iSize = mQIndle.Count;
                for (int i = 0; i < iSize; i++)
                {
                    int iLoc = (int)mQIndle.Dequeue();
                    Close(ref conn[iLoc]);
                    mQNot.Enqueue(iLoc);
                }
            }
        }
        //关闭连接池
        public static void ClosePool()
        {
            lock (sLockConn)
            {
                int iSize = mQIndle.Count;
                for (int i = 0; i < mlPool; i++)
                    Close(ref conn[(int)mQIndle.Dequeue()]);
                conn = null;

                mQIndle.Clear();
                mQNot.Clear();
            }
        }
        //锁定数据库连接
        public static string LockConn(ref int iLoc)
        {
            string sError = "";
            if (conn == null)
                InitPool();

            lock (sLockConn)
            {
                if (iLoc < 0)
                {
                    if (mQIndle.Count > 0)
                        iLoc = (int)mQIndle.Dequeue();
                    else
                    {
                        if (mQNot.Count > 0)
                        {
                            iLoc = (int)mQNot.Dequeue();
                            sError = Connect(ref conn[iLoc]);
                            if (sError != "")
                                iLoc = -1;
                        }
                        else
                            sError = "数据库连接忙,请稍候再试";
                    }

                }
            }
            return sError;
        }
        //释放数据库连接
        public static void UnLockConn(ref int iLoc)
        {
            if (iLoc < 0)
                return;
            lock (sLockConn)
            {
                mQIndle.Enqueue(iLoc);
                iLoc = -1;
            }
        }

        public static string Connect(ref MySqlConnection oConn)
		{
			if (oConn != null)
				return "";
			string sError = "";
			try
			{
				if (msConnString == "")
				{
					if (System.Web.HttpContext.Current.Application["Connect"] != null)
						msConnString = System.Web.HttpContext.Current.Application["Connect"].ToString();
				}
				oConn = new MySqlConnection(msConnString);
				oConn.Open();
			}
			catch (Exception ec)
			{
				oConn = null;
				sError = ec.Message;
			}
			return sError;
		}

		public static void Close(ref MySqlConnection oConn)
		{
			try
			{
				if (oConn != null)
					oConn.Close();
			}
			catch
			{
			}
			oConn = null;
		}

		public static string ExecSql(string sSql, MySqlParameter[] parms)
		{
            /*
            int iLoc = -1;
            string sError = LockConn(ref iLoc);
                if (sError == "")
                sError = ExecSql(ref oConn[iLoc], sSql, parms);
            UnLockConn(ref iLoc);
            */
            MySqlConnection oConn = null;
            string sError = Connect(ref oConn);
            if (sError == "")
                sError = ExecSql(ref oConn, sSql, parms);
            Close(ref oConn);
            return sError;
        }

        public static string ExecSql(ref MySqlConnection oConn,string sMySql, MySqlParameter[] parms)
		{
			string sError = Connect(ref oConn);
			MySqlCommand command = null;
			if (sError == "")
			{
				try
				{
					command = new MySqlCommand(sMySql, oConn);
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

		public static string GetList(string sSql, ref DataTable dataTable)
		{
            /*
            int iLoc = -1;
            string sError = LockConn(ref iLoc);
            if (sError == "")
                sError = GetList(ref conn[iLoc], sSql, ref dataTable);
            UnLockConn(ref iLoc);
            */
            MySqlConnection oConn = null;
            string sError = Connect(ref oConn);
            if (sError == "")
                sError = GetList(ref oConn, sSql, ref dataTable);
            Close(ref oConn);
            return sError;
        }

        public static string GetList(ref MySqlConnection oConn,string sMySql, ref DataTable dataTable)
		{
			if (dataTable != null)
			{
				dataTable.Dispose();
				dataTable = null;
			}
			string sError = Connect(ref oConn);
			MySqlCommand command = null;
			MySqlDataReader dataReader = null;
			if (sError == "")
			{
				try
				{
					command = new MySqlCommand(sMySql, oConn);
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
			}
			if (command != null)
				command.Dispose();
			return sError;
		}

		private static DataTable ConvertDataReaderToDataTable(MySqlDataReader dataReader)
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
					dataColumn.DataType = System.Type.GetType(row[11].ToString());
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

		public static MySqlParameter MakeParm(string sParmName, MySqlDbType dbType, int iSize, object value)
		{
			MySqlParameter parm;
			if (iSize > 0)
				parm = new MySqlParameter(sParmName, dbType, iSize);
			else
				parm = new MySqlParameter(sParmName, dbType);
			parm.Direction = ParameterDirection.Input;
			if (value != null)
				parm.Value = value;
			else
				parm.Value = DBNull.Value;
			return parm;
		}

		public static MySqlParameter MakeParm(string sParmName, string sType, int iSize, object value)
		{
			MySqlDbType dType;
			switch(sType)
			{
				case "B":
					dType = MySqlDbType.Blob;
					iSize = 0;
					break;
				case "D":
					dType = MySqlDbType.Datetime;
					iSize = 0;
					break;
				case "S":
					dType = MySqlDbType.Text;
					iSize = 0;
					break;
				case "N":
					dType = MySqlDbType.Decimal;
					break;
				default:
					dType = MySqlDbType.VarChar;
					break;
			}
			return MakeParm(sParmName,dType,iSize,value);
		}

		public static MySqlParameter MakeParm(string sParmName, RowItem oItem)
		{
			MySqlDbType dType;
			int iSize = oItem.Len;
			switch(oItem.DataType)
			{
				case "B":
					dType = MySqlDbType.Blob;
					iSize = 0;
					break;
				case "D":
					dType = MySqlDbType.Datetime;
					iSize = 0;
					break;
				case "S":
					dType = MySqlDbType.Text;
					iSize = 0;
					break;
				case "N":
					dType = MySqlDbType.Decimal;
					break;
				default:
					dType = MySqlDbType.VarChar;
					break;
			}
			return MakeParm(sParmName,dType,iSize,oItem.DataValue);
		}	

		public static MySqlParameter MakeParm(string sParmName, DataRow drItem)
		{
			int iSize = CPublicFun.GetInt(drItem[1].ToString());
			object oValue = drItem[2].ToString();
			MySqlDbType dType;
			switch(drItem[0].ToString())
			{
				case "B":
					dType = MySqlDbType.Blob;
					oValue = Convert.FromBase64String(oValue.ToString());
					iSize = 0;
					break;
				case "D":
					dType = MySqlDbType.Datetime;
					iSize = 0;
					break;
				case "S":
					dType = MySqlDbType.Text;
					iSize = 0;
					break;
				case "N":
					dType = MySqlDbType.Decimal;
					break;
				default:
					dType = MySqlDbType.VarChar;
					break;
			}
			return MakeParm(sParmName,dType,iSize,oValue);
		}	
	}
}
