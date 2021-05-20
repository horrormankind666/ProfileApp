/*
=============================================
Author      : <ยุทธภูมิ ตวันนา>
Create date : <๒๖/๑๒/๒๕๕๙>
Modify date : <๑๒/๐๒/๒๕๖๓>
Description : <คลาสใช้งานเกี่ยวกับการจัดการข้อมูลในฐานข้อมูล>
=============================================
*/

using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using NUtil;
using NFinServiceLogin;

public class HCSDB
{
    public static string _myTableTransactionLog = "hcsDownloadLog";

    public static int InsertDownloadLog(Dictionary<string, object> _paramSave)
    {
        string _cmdText = String.Empty;
        int _error = 0;

        try
        {
            Util.DBUtil.ExecuteCommandStoredProcedure("sp_hcsSetDownloadLog",
                new SqlParameter("@personId", (_paramSave.ContainsKey("PersonId").Equals(true) ? _paramSave["PersonId"] : String.Empty)),
                new SqlParameter("@registrationForm", (_paramSave.ContainsKey("RegistrationForm").Equals(true) ? _paramSave["RegistrationForm"] : String.Empty)),
                new SqlParameter("@by", (_paramSave.ContainsKey("By").Equals(true) ? _paramSave["By"] : String.Empty)),
                new SqlParameter("@ip", Util.GetIP())
            );
        }
        catch
        {
            _error = 1;
        }

        return _error;
    }

    public static DataSet GetStudentRecords(string _personId)
    {
        DataSet _ds = Util.DBUtil.ExecuteCommandStoredProcedure("sp_hcsGetPersonStudent",
            new SqlParameter("@userType", FinServiceLogin.USERTYPE_STUDENT),
            new SqlParameter("@personId", _personId)
        );

        return _ds;
    }

    public static DataSet GetListHospital(Dictionary<string, object> _paramSearch)
    {
        DataSet _ds = Util.DBUtil.ExecuteCommandStoredProcedure("sp_hcsGetListHospital",
            new SqlParameter("@id", (_paramSearch.ContainsKey("ID").Equals(true) ? _paramSearch["ID"] : String.Empty))
        );

        return _ds;
    }

    public static DataSet GetListWelfare(Dictionary<string, object> _paramSearch)
    {
        DataSet _ds = Util.DBUtil.ExecuteCommandStoredProcedure("sp_hcsGetListWelfare",
            new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
            new SqlParameter("@forPublicServant", (_paramSearch.ContainsKey("ForPublicServant").Equals(true) ? _paramSearch["ForPublicServant"] : String.Empty)),
            new SqlParameter("@workedStatus", (_paramSearch.ContainsKey("WorkedStatus").Equals(true) ? _paramSearch["WorkedStatus"] : String.Empty)),
            new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
            new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
            new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
        );

        return _ds;
    }

    public static DataSet GetRegistrationForm(string _id)
    {
        DataSet _ds = Util.DBUtil.ExecuteCommandStoredProcedure("sp_hcsGetRegistrationForm",
            new SqlParameter("@id", _id)
        );

        return _ds;
    }

    public static DataSet GetWelfareLog(string _personId)
    {
        DataSet _ds = Util.DBUtil.ExecuteCommandStoredProcedure("sp_hcsGetWelfareLog",
            new SqlParameter("@personId", _personId)
        );

        return _ds;
    }

    public static DataSet GetTermServiceHCSConsentRegistration(string _studentId)
    {
        DataSet _ds = Util.DBUtil.ExecuteCommandStoredProcedure("sp_stdGetListStudentTermService",
            new SqlParameter("@studentId", _studentId)
        );

        return _ds;
    }

    public static DataSet GetTermServiceHCSConsentOOCA(string _studentId)
    {
        DataSet _ds = Util.DBUtil.ExecuteCommandStoredProcedure("sp_stdGetListStudentTermService",
            new SqlParameter("@studentId", _studentId)
        );

        return _ds;
    }
}