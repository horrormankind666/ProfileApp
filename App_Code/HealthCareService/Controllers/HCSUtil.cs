/*
=============================================
Author      : <ยุทธภูมิ ตวันนา>
Create date : <๒๖/๑๒/๒๕๕๙>
Modify date : <๐๖/๐๑/๒๕๖๔>
Description : <คลาสใช้งานเกี่ยวกับการใช้งานฟังก์ชั่นทั่วไป>
=============================================
*/

using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using NUtil;
using NFinServiceLogin;

public class HCSUtil
{
    public const string SUBJECT_SECTION_MAIN = "Main";
    public const string SUBJECT_SECTION_STUDENTRECORDS = "StudentRecords";
    public const string SUBJECT_SECTION_STUDENTRECORDSSTUDENTCV = (SUBJECT_SECTION_STUDENTRECORDS + "StudentCV");
    public const string SUBJECT_SECTION_TERMSERVICEHCSCONSENTREGISTRATION = "TermServiceHCSConsentRegistration";
    public const string SUBJECT_SECTION_TERMSERVICEHCSCONSENTREGISTRATIONSELECTHOSPITAL = (SUBJECT_SECTION_TERMSERVICEHCSCONSENTREGISTRATION + "SelectHospital");
    public const string SUBJECT_SECTION_TERMSERVICEHCSCONSENTOOCA = "TermServiceHCSConsentOOCA";
    public const string SUBJECT_SECTION_DOWNLOADREGISTRATIONFORM = "DownloadRegistrationForm";
    public const string SUBJECT_SECTION_DOWNLOADREGISTRATIONFORMSTUDENTRECORDS = (SUBJECT_SECTION_DOWNLOADREGISTRATIONFORM + SUBJECT_SECTION_STUDENTRECORDS);
    public const string SUBJECT_SECTION_DOWNLOADREGISTRATIONFORMSELECTWELFARE = (SUBJECT_SECTION_DOWNLOADREGISTRATIONFORM + "SelectWelfare");
    public const string SUBJECT_SECTION_HELP = "Help";
    public const string SUBJECT_SECTION_CONTACTUS = "ContactUs";
    public const string SUBJECT_SECTION_ALLOWPOPUP = "AllowPopup";
    public const string SUBJECT_SECTION_HELPCONTACTUS = (SUBJECT_SECTION_HELP + SUBJECT_SECTION_CONTACTUS);
    public const string SUBJECT_SECTION_HELPALLOWPOPUP = (SUBJECT_SECTION_HELP + SUBJECT_SECTION_ALLOWPOPUP);    

    public const string ID_SECTION_MAIN = "Main";
    public const string ID_SECTION_TERMSERVICEHCSCONSENTREGISTRATION_MAIN = ("Main-" + SUBJECT_SECTION_TERMSERVICEHCSCONSENTREGISTRATION);
    public const string ID_SECTION_TERMSERVICEHCSCONSENTREGISTRATION_INFO = ("Info-" + SUBJECT_SECTION_TERMSERVICEHCSCONSENTREGISTRATION);
    public const string ID_SECTION_TERMSERVICEHCSCONSENTREGISTRATIONSELECTHOSPITAL_DIALOG = ("Dialog-" + SUBJECT_SECTION_TERMSERVICEHCSCONSENTREGISTRATIONSELECTHOSPITAL);
    public const string ID_SECTION_TERMSERVICEHCSCONSENTOOCA_MAIN = ("Main-" + SUBJECT_SECTION_TERMSERVICEHCSCONSENTOOCA);
    public const string ID_SECTION_TERMSERVICEHCSCONSENTOOCA_INFO = ("Info-" + SUBJECT_SECTION_TERMSERVICEHCSCONSENTOOCA);
    public const string ID_SECTION_DOWNLOADREGISTRATIONFORM_MAIN = ("Main-" + SUBJECT_SECTION_DOWNLOADREGISTRATIONFORM);
    public const string ID_SECTION_DOWNLOADREGISTRATIONFORMSTUDENTRECORDS_MAIN = ("Main-" + SUBJECT_SECTION_DOWNLOADREGISTRATIONFORMSTUDENTRECORDS);
    public const string ID_SECTION_DOWNLOADREGISTRATIONFORMSELECTWELFARE_DIALOG = ("Dialog-" + SUBJECT_SECTION_DOWNLOADREGISTRATIONFORMSELECTWELFARE);

    public const string PAGE_STUDENTRECORDSSTUDENTCV_MAIN = (SUBJECT_SECTION_STUDENTRECORDSSTUDENTCV + "Main");
    public const string PAGE_TERMSERVICEHCSCONSENTREGISTRATION_MAIN = (SUBJECT_SECTION_TERMSERVICEHCSCONSENTREGISTRATION + "Main");
    public const string PAGE_TERMSERVICEHCSCONSENTREGISTRATIONSELECTHOSPITAL_DIALOG = (SUBJECT_SECTION_TERMSERVICEHCSCONSENTREGISTRATIONSELECTHOSPITAL + "Dialog");
    public const string PAGE_TERMSERVICEHCSCONSENTOOCA_MAIN = (SUBJECT_SECTION_TERMSERVICEHCSCONSENTOOCA + "Main");
    public const string PAGE_DOWNLOADREGISTRATIONFORM_MAIN = (SUBJECT_SECTION_DOWNLOADREGISTRATIONFORM + "Main");
    public const string PAGE_DOWNLOADREGISTRATIONFORMSTUDENTRECORDS_MAIN = (SUBJECT_SECTION_DOWNLOADREGISTRATIONFORMSTUDENTRECORDS + "Main");
    public const string PAGE_DOWNLOADREGISTRATIONFORMSELECTWELFARE_DIALOG = (SUBJECT_SECTION_DOWNLOADREGISTRATIONFORMSELECTWELFARE + "Dialog");

    public static string _myURLPictureStudent = System.Configuration.ConfigurationManager.AppSettings["urlPictureStudent"].ToString();
    public static string _myFileDownloadPath = System.Configuration.ConfigurationManager.AppSettings["hcsFileDownloadPath"].ToString();
    public static string _myPDFFormTemplate = System.Configuration.ConfigurationManager.AppSettings["hcsPDFFormTemplate"].ToString();
    public static string _myPDFFontNormal = System.Configuration.ConfigurationManager.AppSettings["hcsPDFFontNormal"].ToString();
    public static string _myPDFFontBold = System.Configuration.ConfigurationManager.AppSettings["hcsPDFFontBold"].ToString();
    public static string _myPDFFontBarcode = System.Configuration.ConfigurationManager.AppSettings["hcsPDFFontBarcode"].ToString();
    public static string _myHandlerPath = System.Configuration.ConfigurationManager.AppSettings["hcsHandlerPath"].ToString();

    public static string[,] _menu = new string[,]
    {
        { "ข้อมูลส่วนตัว", "Profile", SUBJECT_SECTION_STUDENTRECORDSSTUDENTCV, "", "" },
        { "ดาว์นโหลดแบบฟอร์มประกันสุขภาพ", "Download Registration Form", SUBJECT_SECTION_DOWNLOADREGISTRATIONFORM, "", "" },
        { "ช่วยเหลือ", "Help", SUBJECT_SECTION_HELP, "", "" }
    };

    public static string[,] _submenu = new string[,]
    {
        { "ติดต่อสอบถาม", "Contact Us", SUBJECT_SECTION_HELPCONTACTUS },
        { "วิธีการปลดบล็อคป๊อปอัพของบราวเซอร์ต่าง ๆ", "How to Allow Pop ups on Browsers", SUBJECT_SECTION_HELPALLOWPOPUP }
    };

    public static Dictionary<string, object> GetLogin(string _page, string _id)
    {
        Dictionary<string, object> _loginResult = GetInfoLogin();
        DataSet _ds = new DataSet();
        int _systemError = Util.DBUtil.ChkSystemPermissionStudent(_loginResult);
        int _cookieError = 0;
        int _userError = 0;
        string _personId = _loginResult["PersonId"].ToString();
        string _nationality = _loginResult["Nationality"].ToString();

        if (!String.IsNullOrEmpty(_personId))
            _ds = HCSDB.GetStudentRecords(_personId);

        _systemError = (_systemError.Equals(4) ? 0 : _systemError);
        _systemError = (_systemError.Equals(5) ? 0 : _systemError);
        _systemError = (_systemError.Equals(0) ? (_ds.Tables[0].Rows.Count > 0 ? 0 : 6) : _systemError);
        _systemError = (_systemError.Equals(0) ? (_nationality.Equals("TH") ? 0 : 6) : _systemError);

        switch (_systemError)
        {
            case 1:
                _cookieError = 1;
                break;
            case 2:
                _userError = 1;
                break;
            case 6:
                _userError = 2;
                break;
            case 3:
                _userError = 4;
                break;
            /*
            case 4:
                _userError = 5;
                break;
            case 5:
                _userError = 6;
                break;
            */
        }

        _loginResult["CookieError"] = _cookieError.ToString();
        _loginResult.Add("UserError", _userError.ToString());

        return _loginResult;
    }

    public static Dictionary<string, object> GetInfoLogin()
    {
        Dictionary<string, object> _loginResult = FinServiceLogin.GetFinServiceLogin(FinServiceLogin.USERTYPE_STUDENT, "e-Profile");

        return _loginResult;
    }

    public static Dictionary<string, object> GetTermServiceHCSConsentRegistration(string _studentId)
    {
        Dictionary<string, object> _termServiceResult = new Dictionary<string, object>();
        DataSet _ds = new DataSet();
        string _termServiceType = String.Empty;
        string _termServiceDate = String.Empty;
        string _termServiceTime = String.Empty;
        string _termServiceStatus = String.Empty;
        string _termServiceNote = String.Empty;
        string _termServiceHospitalNameTH = String.Empty;
        string _termServiceHospitalNameEN = String.Empty;


        if (!String.IsNullOrEmpty(_studentId))
        {
            _ds = HCSDB.GetTermServiceHCSConsentRegistration(_studentId);

            if (_ds.Tables[0].Rows.Count > 0)
            {
                DataRow _dr = _ds.Tables[0].Rows[0];

                if (_dr["termTypeHCSConsentRegistration"].ToString().Equals("HCS_CONSENT_REGISTRATION"))
                {
                    _termServiceType = _dr["termTypeHCSConsentRegistration"].ToString();
                    _termServiceDate = _dr["cTermDateHCSConsentRegistration"].ToString();
                    _termServiceTime = _dr["cTermTimeHCSConsentRegistration"].ToString();
                    _termServiceStatus = _dr["termStatusHCSConsentRegistration"].ToString();
                    _termServiceNote = _dr["noteHCSConsentRegistration"].ToString();
                    _termServiceHospitalNameTH = _dr["termHCSConsentRegistrationHospitalNameTH"].ToString();
                    _termServiceHospitalNameEN = _dr["termHCSConsentRegistrationHospitalNameEN"].ToString();
                }
            }            
        }

        _ds.Dispose();

        _termServiceResult.Add("TermServiceTypeHCSConsentRegistration", _termServiceType);
        _termServiceResult.Add("TermServiceDateHCSConsentRegistration", _termServiceDate);
        _termServiceResult.Add("TermServiceTimeHCSConsentRegistration", _termServiceTime);
        _termServiceResult.Add("TermServiceStatusHCSConsentRegistration", _termServiceStatus);
        _termServiceResult.Add("TermServiceNoteHCSConsentRegistration", _termServiceNote);
        _termServiceResult.Add("TermServiceHospitalNameTHHCSConsentRegistration", _termServiceHospitalNameTH);
        _termServiceResult.Add("TermServiceHospitalNameENHCSConsentRegistration", _termServiceHospitalNameEN);

        return _termServiceResult;
    }

    public static bool ChkExistStudentTermServiceHCSConsentRegistration(string _studentId)
    {
        Dictionary<string, object> _termServiceHCSConsentRegistrationResult = new Dictionary<string, object>();
        bool _exist = true;

        if (!String.IsNullOrEmpty(_studentId))
        {
            _termServiceHCSConsentRegistrationResult = GetTermServiceHCSConsentRegistration(_studentId);

            if (String.IsNullOrEmpty(_termServiceHCSConsentRegistrationResult["TermServiceTypeHCSConsentRegistration"].ToString()) &&
                String.IsNullOrEmpty(_termServiceHCSConsentRegistrationResult["TermServiceDateHCSConsentRegistration"].ToString()) &&
                String.IsNullOrEmpty(_termServiceHCSConsentRegistrationResult["TermServiceTimeHCSConsentRegistration"].ToString()) &&
                String.IsNullOrEmpty(_termServiceHCSConsentRegistrationResult["TermServiceStatusHCSConsentRegistration"].ToString()))
                _exist = false;
            else
                _exist = true;
        }

        return _exist;
    }

    public static Dictionary<string, object> GetTermServiceHCSConsentOOCA(string _studentId)
    {
        Dictionary<string, object> _termServiceResult = new Dictionary<string, object>();
        DataSet _ds = new DataSet();
        string _termServiceType = String.Empty;
        string _termServiceDate = String.Empty;
        string _termServiceTime = String.Empty;
        string _termServiceStatus = String.Empty;

        if (!String.IsNullOrEmpty(_studentId))
        {
            _ds = HCSDB.GetTermServiceHCSConsentOOCA(_studentId);

            if (_ds.Tables[0].Rows.Count > 0)
            {
                DataRow _dr = _ds.Tables[0].Rows[0];

                if (_dr["termTypeHCSConsentOOCA"].ToString().Equals("HCS_CONSENT_OOCA"))
                {
                    _termServiceType = _dr["termTypeHCSConsentOOCA"].ToString();
                    _termServiceDate = _dr["cTermDateHCSConsentOOCA"].ToString();
                    _termServiceTime = _dr["cTermTimeHCSConsentOOCA"].ToString();
                    _termServiceStatus = _dr["termStatusHCSConsentOOCA"].ToString();
                }
            }
        }

        _ds.Dispose();

        _termServiceResult.Add("TermServiceTypeHCSConsentOOCA", _termServiceType);
        _termServiceResult.Add("TermServiceDateHCSConsentOOCA", _termServiceDate);
        _termServiceResult.Add("TermServiceTimeHCSConsentOOCA", _termServiceTime);
        _termServiceResult.Add("TermServiceStatusHCSConsentOOCA", _termServiceStatus);

        return _termServiceResult;
    }

    public static bool ChkExistStudentTermServiceHCSConsentOOCA(string _studentId)
    {
        Dictionary<string, object> _termServiceHCSConsentOOCAResult = new Dictionary<string, object>();
        bool _exist = true;

        if (!String.IsNullOrEmpty(_studentId))
        {
            _termServiceHCSConsentOOCAResult = GetTermServiceHCSConsentOOCA(_studentId);

            if (String.IsNullOrEmpty(_termServiceHCSConsentOOCAResult["TermServiceTypeHCSConsentOOCA"].ToString()) &&
                String.IsNullOrEmpty(_termServiceHCSConsentOOCAResult["TermServiceDateHCSConsentOOCA"].ToString()) &&
                String.IsNullOrEmpty(_termServiceHCSConsentOOCAResult["TermServiceTimeHCSConsentOOCA"].ToString()) &&
                String.IsNullOrEmpty(_termServiceHCSConsentOOCAResult["TermServiceStatusHCSConsentOOCA"].ToString()))
                _exist = false;
            else
                _exist = true;
        }

        return _exist;
    }

    public static Dictionary<string, object> GetPage(string _page, string _id)
    {        
        Dictionary<string, object> _loginResult = GetLogin(_page, _id);
        Dictionary<string, object> _pageResult = new Dictionary<string, object>();
        bool _exist = true;
        int _pageError = 0;
        int _cookieError = int.Parse(_loginResult["CookieError"].ToString());
        int _userError = int.Parse(_loginResult["UserError"].ToString());
        string _signinYN = String.Empty;
        string _personId = _loginResult["PersonId"].ToString();
        string _studentId = _loginResult["StudentId"].ToString();
        string _degree = _loginResult["Degree"].ToString();
        string _lang = _loginResult["Language"].ToString();
        StringBuilder _menutopContent = new StringBuilder();
        StringBuilder _headerContent = new StringBuilder();
        StringBuilder _mainContent = new StringBuilder();

        _pageError = 1;
        _signinYN = String.Empty;
        _menutopContent = null;
        _headerContent = null;
        _mainContent = null;

        if (_page.Equals(PAGE_TERMSERVICEHCSCONSENTREGISTRATION_MAIN) ||
            _page.Equals(PAGE_DOWNLOADREGISTRATIONFORM_MAIN))
        {
            if (_userError.Equals(4) || _userError.Equals(5) || _userError.Equals(6))
                _userError = (_lang.Equals("TH") ? 0 : 6);
        
            if (_userError.Equals(0))
            {
                _exist = ChkExistStudentTermServiceHCSConsentRegistration(_studentId);

                if (!_exist)
                {
                    _page = PAGE_TERMSERVICEHCSCONSENTREGISTRATION_MAIN;
                    _loginResult["UserError"] = _userError;
                }
                else
                    _page = PAGE_DOWNLOADREGISTRATIONFORM_MAIN;
            }
        }

        if (_userError.Equals(4) || _userError.Equals(5) || _userError.Equals(6))
            _page = ((_page.Equals(PAGE_STUDENTRECORDSSTUDENTCV_MAIN) || _page.Equals(PAGE_TERMSERVICEHCSCONSENTOOCA_MAIN)) ? _page : PAGE_DOWNLOADREGISTRATIONFORM_MAIN);
        
        if (_page.Equals(PAGE_STUDENTRECORDSSTUDENTCV_MAIN))
        {
            _pageError = 0;
            _signinYN = "Y";
            _userError = 0;
            _loginResult["UserError"] = _userError;
            _mainContent = (_cookieError.Equals(0) ? Util.GetStudentRecordsToStudentCV(_personId) : null);
        }

        if (_page.Equals(PAGE_TERMSERVICEHCSCONSENTREGISTRATION_MAIN))
        {
            _pageError = 0;
            _signinYN = "Y";
            _loginResult["UserError"] = _userError;
            _mainContent = (_cookieError.Equals(0) && _userError.Equals(0) ? HCSTermServiceConsentRegistrationUI.GetSection(_loginResult, "MAIN", "", _studentId) : null);
        }

        if (_page.Equals(PAGE_TERMSERVICEHCSCONSENTOOCA_MAIN))
        {                  
            _pageError = 0;
            _signinYN = "Y";
            _userError = (_degree.Equals("B") ? 0 : 7);
            _loginResult["UserError"] = _userError;
            _mainContent = (_cookieError.Equals(0) && _userError.Equals(0) ? HCSTermServiceConsentOOCAUI.GetSection(_loginResult, "MAIN", "", _studentId) : null);
        }

        if (_page.Equals(PAGE_DOWNLOADREGISTRATIONFORM_MAIN))
        {
            _pageError = 0;
            _signinYN = "Y";
            _loginResult["UserError"] = _userError;
            _mainContent = (_cookieError.Equals(0) && _userError.Equals(0) ? HCSDownloadRegistrationFormUI.GetSection(_loginResult, "MAIN", "", _personId) : null);
        }

        _pageResult.Add("Page", _page);
        _pageResult.Add("PageError", _pageError.ToString());
        _pageResult.Add("SignInYN", _signinYN);
        _pageResult.Add("CookieError", _cookieError.ToString());
        _pageResult.Add("UserError", _userError.ToString());        
        _pageResult.Add("Language", _lang);
        _pageResult.Add("TopMenuBarContent", HCSUI.GetTopMenuBar(_loginResult, _pageError, _page).ToString());
        _pageResult.Add("HeaderContent", (_headerContent != null ? _headerContent.ToString() : String.Empty));
        _pageResult.Add("BottomMenuBarContent", String.Empty);
        _pageResult.Add("MainContent", (_mainContent != null ? _mainContent.ToString() : String.Empty));

        return _pageResult;
    }

    public static Dictionary<string, object> GetForm(string _form, string _id)
    {
        Dictionary<string, object> _loginResult = GetLogin(_form, _id);
        Dictionary<string, object> _formResult = new Dictionary<string, object>();
        int _formError = 0;
        int _cookieError = int.Parse(_loginResult["CookieError"].ToString());
        int _userError = int.Parse(_loginResult["UserError"].ToString());
        int _width = 0;
        int _height = 0;
        string _signinYN = String.Empty;
        string _personId = _loginResult["PersonId"].ToString();
        string _titleContent = String.Empty;
        StringBuilder _mainContent = new StringBuilder();

        _formError = 1;
        _mainContent = null;

        if (_form.Equals(PAGE_TERMSERVICEHCSCONSENTREGISTRATIONSELECTHOSPITAL_DIALOG))
        {
            _formError = 0;
            _signinYN = "Y";
            _width = 500;
            _titleContent = "เลือกสถานพยาบาล:Please Select Hospital of Health Care Service";
            _mainContent = (_cookieError.Equals(0) && _userError.Equals(0) ? HCSTermServiceConsentRegistrationUI.GetSection(_loginResult, "DIALOG", SUBJECT_SECTION_TERMSERVICEHCSCONSENTREGISTRATIONSELECTHOSPITAL, "") : null);
        }

        if (_form.Equals(PAGE_DOWNLOADREGISTRATIONFORMSELECTWELFARE_DIALOG))
        {
            _formError = 0;
            _signinYN = "Y";
            _width = 850;
            _titleContent = "สิทธิการรักษาพยาบาล:The Right to Medical Care";
            _mainContent = (_cookieError.Equals(0) && _userError.Equals(0) ? HCSDownloadRegistrationFormUI.GetSection(_loginResult, "DIALOG", SUBJECT_SECTION_DOWNLOADREGISTRATIONFORMSELECTWELFARE, "") : null);
        }

        _formResult.Add("FormError", _formError.ToString());
        _formResult.Add("SignInYN", _signinYN);
        _formResult.Add("CookieError", _cookieError.ToString());
        _formResult.Add("UserError", _userError.ToString());
        _formResult.Add("Width", _width.ToString());
        _formResult.Add("Height", _height.ToString());
        _formResult.Add("TitleContent", _titleContent);
        _formResult.Add("MainContent", (_mainContent != null ? _mainContent.ToString() : String.Empty));        

        return _formResult;
    }

    public static Dictionary<string, object> SetValueDataRecorded(string _page, string _id)
    {
        Dictionary<string, object> _valueDataRecordedResult = new Dictionary<string, object>();
        Dictionary<string, object> _dataRecorded = new Dictionary<string, object>();
        DataSet _ds = new DataSet();

        if (_page.Equals(PAGE_DOWNLOADREGISTRATIONFORMSTUDENTRECORDS_MAIN))
            _ds = HCSDB.GetStudentRecords(_id);
        
        if (_ds.Tables.Count > 0)
        {
            if (_page.Equals(PAGE_DOWNLOADREGISTRATIONFORMSTUDENTRECORDS_MAIN))
                _dataRecorded = HCSDownloadRegistrationFormUtil.StudentRecordsUtil.SetValueDataRecorded(_dataRecorded, _ds);
        }

        _ds.Dispose();

        if (_page.Equals(PAGE_DOWNLOADREGISTRATIONFORMSTUDENTRECORDS_MAIN))
            _valueDataRecordedResult.Add(("DataRecorded" + SUBJECT_SECTION_DOWNLOADREGISTRATIONFORMSTUDENTRECORDS), _dataRecorded);
        
        return _valueDataRecordedResult;               
    }
}