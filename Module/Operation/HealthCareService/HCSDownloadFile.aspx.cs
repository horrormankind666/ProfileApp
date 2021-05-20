/*
=============================================
Author      : <ยุทธภูมิ ตวันนา>
Create date : <๓๐/๑๒/๒๕๕๙>
Modify date : <๐๖/๐๑/๒๕๖๐>
Description : <คลาสใช้งานเกี่ยวกับการดาวน์โหลดไฟล์>
=============================================
*/

using System;
using System.Web.UI;
using NUtil;

public partial class HCSDownloadFile : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string _f = Request.QueryString["f"];
        string _filePath = String.Empty;
        string _fileName = String.Empty;
        int _error = 0;

        if (_f.Equals(HCSUtil.SUBJECT_SECTION_HELPALLOWPOPUP))
        {
            _filePath = "../../../Content/FileDownload/HealthCareService";
            _fileName = "AllowPopup.pdf";

            Util.ViewFile(_filePath, _fileName);
        }

        if (_f.Equals(HCSUtil.SUBJECT_SECTION_DOWNLOADREGISTRATIONFORM))
        {
            _filePath = Request.QueryString["path"];
            _fileName = Request.QueryString["file"];
            _error = Util.ViewFile(_filePath, _fileName);

            if (!_error.Equals(0))
                Response.Redirect(_filePath + "/" + _fileName);
        }
    }
}