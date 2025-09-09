using System;

namespace CloudMagnetWeb
{
	/// <summary>
	/// RowItem 的摘要说明。
	/// </summary>
	public class RowItem
	{
		private string msType = "C";
		public string DataType
		{
			get 
			{
				return msType;
			}
			set
			{
				if (value != "")
					msType = value;
				else
					msType = "C";
			}
		}

		private int miLen = 128;
		public int Len
		{
			get 
			{
				return miLen;
			}
			set
			{
				if (value > 0)
					miLen = value;
				else
					miLen = 128;
			}
		}

		private object moValue = null;
		public object DataValue
		{
			get 
			{
				return moValue;
			}
			set
			{
				moValue = value;
				if (msType != "B" && moValue != null)
				{
					if (moValue.ToString() == "")
						moValue = null;
					else if (msType == "D" && CPublicFun.IsDate(moValue.ToString()) == -1000000000)
						moValue = null;
				}
			}
		}

		public object DataValue1
		{
			get 
			{
				if ((msType == "S" || msType == "C") && moValue == null)
					return "";
				return moValue;
			}
		}

		public RowItem()
		{

			//
			// TODO: 在此处添加构造函数逻辑
			//
		}

		public void SetData(string sType,int iLength,object oValue)
		{
			DataType = sType;
			Len = iLength;
			DataValue = oValue;
		}
		
	}
}
