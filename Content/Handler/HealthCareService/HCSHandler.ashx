<%@ WebHandler Language="C#" Class="HCSHandler" %>

/*
=============================================
Author      : <ยุทธภูมิ ตวันนา>
Create date : <๒๖/๑๒/๒๕๕๙>
Modify date : <๓๐/๐๔/๒๕๖๓>
Description : <คลาสใช้งานเกี่ยวกับการใช้งานฟังก์ชั่นที่ถูกเรียกใช้งานจาก javascript>
=============================================
*/

using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;
using NUtil;

public class HCSHandler : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext _context)
    {
        _context.Response.ContentType = "application/json";
        bool _error = false;

        if (_error.Equals(false))
        {
            string _action = _context.Request["action"];

            GetContentAction(_action, _context);
        }
    }

    private void GetContentAction(string _action, HttpContext _c)
    {
        switch (_action)
        {
            case "page":
                ShowPage(_c);
                break;
            case "form":
                ShowForm(_c);
                break;
            case "download":
            case "save":
                ShowTask(_c);
                break;
            case "resizeimage":
                ShowResizeImage(_c);
                break;
            case "image2stream":
                ShowImage2Stream(_c);
                break;
        }
    }

    private void ShowPage(HttpContext _c)
    {
        string _page = _c.Request["page"];
        string _id = _c.Request["id"];
        JavaScriptSerializer _json = new JavaScriptSerializer();
        Dictionary<string, object> _pageResult = new Dictionary<string, object>();

        _pageResult = HCSUtil.GetPage(_page, _id);

        _c.Response.Write(_json.Serialize(_pageResult));
    }

    private void ShowForm(HttpContext _c)
    {
        string _form = _c.Request["form"];
        string _id = _c.Request["id"];
        JavaScriptSerializer _json = new JavaScriptSerializer();
        Dictionary<string, object> _formResult = new Dictionary<string, object>();

        _formResult = HCSUtil.GetForm(_form, _id);

        _json.MaxJsonLength = Int32.MaxValue;

        _c.Response.Write(_json.Serialize(_formResult));
    }

    private void ShowTask(HttpContext _c)
    {
        string _action = _c.Request["action"];
        string _page = _c.Request["page"];
        Dictionary<string, object> _loginResult = HCSUtil.GetLogin(_page, "");
        int _cookieError = int.Parse(_loginResult["CookieError"].ToString());
        int _userError = int.Parse(_loginResult["UserError"].ToString());
        bool _exist = true;
        JavaScriptSerializer _json = new JavaScriptSerializer();
        Dictionary<string, object> _taskResult = new Dictionary<string, object>();

        if (_page.Equals(HCSUtil.PAGE_TERMSERVICEHCSCONSENTREGISTRATION_MAIN) ||
            _page.Equals(HCSUtil.PAGE_TERMSERVICEHCSCONSENTOOCA_MAIN))
        {
            if (_page.Equals(HCSUtil.PAGE_TERMSERVICEHCSCONSENTREGISTRATION_MAIN))
                _exist = HCSUtil.ChkExistStudentTermServiceHCSConsentRegistration(_loginResult["StudentId"].ToString());

            if (_page.Equals(HCSUtil.PAGE_TERMSERVICEHCSCONSENTOOCA_MAIN))
                _exist = HCSUtil.ChkExistStudentTermServiceHCSConsentOOCA(_loginResult["StudentId"].ToString());

            if (!_exist)
            {
                _userError = 0;
                _loginResult["UserError"] = _userError;
            }
        }

        _taskResult.Clear();
        _taskResult.Add("CookieError", _cookieError.ToString());
        _taskResult.Add("UserError", _userError.ToString());
        _taskResult.Add("SaveError", "");
        _taskResult.Add("DownloadPath", "");
        _taskResult.Add("DownloadFile", "");

        if (_cookieError.Equals(0) && _userError.Equals(0))
        {
            if (_action.Equals("download") && _page.Equals(HCSUtil.PAGE_DOWNLOADREGISTRATIONFORM_MAIN))
            {
                Dictionary<string, object> _downloadResult = HCSDownloadRegistrationFormUtil.GetDownload(_c, _loginResult);

                _taskResult["SaveError"] = _downloadResult["SaveError"];
                _taskResult["DownloadPath"] = _downloadResult["DownloadPath"];
                _taskResult["DownloadFile"] = _downloadResult["DownloadFile"];
            }

            if (_action.Equals("save"))
            {
                if (_page.Equals(HCSUtil.PAGE_TERMSERVICEHCSCONSENTREGISTRATION_MAIN) || _page.Equals(HCSUtil.PAGE_TERMSERVICEHCSCONSENTOOCA_MAIN))
                {
                    string _termType = String.Empty;
                    string _note = String.Empty;
                    StringBuilder _xmlData = new StringBuilder();

                    if (_page.Equals(HCSUtil.PAGE_TERMSERVICEHCSCONSENTREGISTRATION_MAIN))
                    {
                        DataSet _ds1 =  HCSDB.GetStudentRecords(_loginResult["PersonId"].ToString());
                        DataRow _dr1 = null;

                        if (_ds1.Tables[0].Rows.Count > 0)
                            _dr1 = _ds1.Tables[0].Rows[0];

                        _termType = "HCS_CONSENT_REGISTRATION";

                        if (_c.Request["consentStatus"].Equals("Y"))
                            _note = (_dr1 != null && !String.IsNullOrEmpty(_dr1["hcsHospitalId"].ToString()) ? _dr1["hcsHospitalId"].ToString() : String.Empty);

                        _ds1.Dispose();

                    }

                    if (_page.Equals(HCSUtil.PAGE_TERMSERVICEHCSCONSENTOOCA_MAIN))
                        _termType = "HCS_CONSENT_OOCA";

                    _xmlData.Append(
                        "<table>" +
                        "<row>" +
                        ("<studentId>" + _loginResult["StudentId"] + "</studentId>") +
                        ("<termType>" + _termType + "</termType>") +
                        ("<termStatus>" + _c.Request["consentStatus"] + "</termStatus>") +
                        //(!String.IsNullOrEmpty(_c.Request["note"]) ? ("<note>" + _c.Request["note"] + "</note>") : String.Empty) +
                        (!String.IsNullOrEmpty(_note) ? ("<note>" + _note + "</note>") : String.Empty) +
                        ("<ip>" + Util.GetIP() + "</ip>") +
                        ("<createdBy>u" +_loginResult["StudentCode"] + "</createdBy>") +
                        "</row>" +
                        "</table>"
                    );

                    DataSet _ds2 = Util.DBUtil.ExecuteCommandStoredProcedure("sp_stdSetStudentTermService",
                        new SqlParameter("@xmlData", _xmlData.ToString())
                    );

                    DataRow _dr2 = _ds2.Tables[0].Rows[0];
                    int _saveError = (_dr2["resMsg"].ToString().Equals("success") ? 0 : 1);

                    _taskResult["SaveError"] = _saveError;

                    _ds2.Dispose();
                }
            }
        }

        _c.Response.Write(_json.Serialize(_taskResult));
    }

    private void ShowResizeImage(HttpContext _c)
    {
        MemoryStream _ms = Util.ImageProcessUtil.ResizeImage(_c.Request["f"], int.Parse(_c.Request["w"]), int.Parse(_c.Request["h"]));

        _ms.WriteTo(HttpContext.Current.Response.OutputStream);
        HttpContext.Current.Response.End();
    }

    private void ShowImage2Stream(HttpContext _c)
    {
        MemoryStream _ms = Util.ImageProcessUtil.ImageToStream(Util.DecodeFromBase64(_c.Request["f"]), "png");

        _ms.WriteTo(HttpContext.Current.Response.OutputStream);
        HttpContext.Current.Response.End();
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}