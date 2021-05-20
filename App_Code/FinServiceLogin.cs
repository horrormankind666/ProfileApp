/*
=============================================
Author      : <ยุทธภูมิ ตวันนา>
Create date : <๑๙/๑๒/๒๕๕๗>
Modify date : <๐๖/๐๑/๒๕๖๔>
Description : <คลาสใช้งานเกี่ยวกับการใช้งานตรวจสอบการเข้าระบบนักศึกษา>
=============================================
*/

using System;
using System.Collections.Generic;
using System.Web;
using System.Data;
using FinService;
using NUtil;

namespace NFinServiceLogin
{
    public class FinServiceLogin
    {
        public const string USERTYPE_STAFF = "STAFF";
        public const string USERTYPE_STUDENT = "STUDENT";
        public const string USERLEVEL_ADMIN = "ADMIN";
        public const string USERLEVEL_ADMINUSER = "ADMINUSER";
        public const string USERLEVEL_SUPERUSER = "SUPERUSER";
        public const string USERLEVEL_USER = "USER";
        public const string USERLEVEL_GUEST = "GUEST";
        
        public static Dictionary<string, object> GetFinServiceLogin(string _usertype, string _systemGroup)
        {
            Dictionary<string, object> _loginResult = new Dictionary<string, object>();
            string _personId = String.Empty;
            string _studentId = String.Empty;
            string _studentCode = String.Empty;
            string _username = String.Empty;
            string _fullnameEN = String.Empty;
            string _fullnameTH = String.Empty;
            string _degree = String.Empty;
            string _entranceTypeId = String.Empty;
            string _facultyId = String.Empty;
            string _programId = String.Empty;
            string _yearEntry = String.Empty;
            string _depId = String.Empty;
            string _userlevel = String.Empty;
            string _nationality = String.Empty;
            int _cookieError = 0;

            _cookieError = Util.ChkCookie(_usertype);
    
            if (_cookieError.Equals(0))
            {
                HttpCookie _cookieFinServiceObj = Util.GetCookie(_usertype);

                Finservice _finServiceAuthen = new Finservice();
                DataSet _ds1 = _finServiceAuthen.info(_cookieFinServiceObj["result"]);

                if (_ds1.Tables[0].Rows.Count > 0)
                {
                    DataRow _dr1 = _ds1.Tables[0].Rows[0];

                    _personId = _dr1["uid"].ToString();
                    _studentId = _dr1["studentid"].ToString();
                    _username = _dr1["username"].ToString();
                    _depId = _dr1["depcode"].ToString();

                    if (_usertype.Equals(USERTYPE_STUDENT))
                    {
                        DataSet _ds2 = Util.DBUtil.GetUserStudent(_personId);

                        if (_ds2.Tables[0].Rows.Count > 0)
                        {
                            DataRow _dr2 = _ds2.Tables[0].Rows[0];

                            _studentCode = _dr2["studentCode"].ToString();
                            _fullnameTH = Util.GetFullName(_dr2["titlePrefixInitialsTH"].ToString(), _dr2["titlePrefixFullNameTH"].ToString(), _dr2["firstName"].ToString(), _dr2["middleName"].ToString(), _dr2["lastName"].ToString());
                            _fullnameEN = Util.GetFullName(Util.UppercaseFirst(_dr2["titlePrefixInitialsEN"].ToString()), Util.UppercaseFirst(_dr2["titlePrefixFullNameEN"].ToString()), Util.UppercaseFirst(_dr2["firstNameEN"].ToString()), Util.UppercaseFirst(_dr2["middleNameEN"].ToString()), Util.UppercaseFirst(_dr2["lastNameEN"].ToString()));
                            _degree = _dr2["degree"].ToString();
                            _entranceTypeId = _dr2["perEntranceTypeId"].ToString();
                            _facultyId = _dr2["facultyId"].ToString();
                            _programId = _dr2["programId"].ToString();
                            _yearEntry = _dr2["yearEntry"].ToString();
                            _nationality = _dr2["isoNationalityName2Letter"].ToString();
                        }

                        _ds2.Dispose();
                    }
                    
                    if (_usertype.Equals(USERTYPE_STAFF))
                    {
                        DataSet _ds2 = Util.DBUtil.GetUserStaff(_username, _userlevel, _systemGroup);

                        if (_ds2.Tables[0].Rows.Count > 0)
                        {
                            DataRow _dr2 = _ds2.Tables[0].Rows[0];

                            _fullnameEN = _dr1["fullnameen"].ToString();
                            _fullnameTH = _dr1["fullnameth"].ToString();
                            _userlevel  = _dr2["level"].ToString();

                            foreach (DataRow _dr3 in _ds2.Tables[0].Rows)
                            {
                                _facultyId = (!String.IsNullOrEmpty(_dr3["facultyId"].ToString()) ? (_facultyId + _dr3["facultyId"].ToString() + ", ") : String.Empty);
                                _programId = (!String.IsNullOrEmpty(_dr3["programId"].ToString()) ? (_programId + _dr3["programId"].ToString() + ", ") : String.Empty);
                            }
                        }

                        _facultyId = (!String.IsNullOrEmpty(_facultyId) ? _facultyId.Substring(0, (_facultyId.Length - 2)) : String.Empty);
                        _programId = (!String.IsNullOrEmpty(_programId) ? _programId.Substring(0, (_programId.Length - 2)) : String.Empty);

                        _ds2.Dispose();
                    }
                }
                else
                    _cookieError = 1;

                _ds1.Dispose();
            }

            _loginResult.Add("CookieError", _cookieError.ToString());
            _loginResult.Add("PersonId", _personId);
            _loginResult.Add("StudentId", _studentId);
            _loginResult.Add("StudentCode", _studentCode);
            _loginResult.Add("Username", _username);
            _loginResult.Add("FullnameEN", _fullnameEN);
            _loginResult.Add("FullnameTH", _fullnameTH);
            _loginResult.Add("Degree", _degree);
            _loginResult.Add("EntranceType", _entranceTypeId);
            _loginResult.Add("FacultyId", _facultyId);
            _loginResult.Add("ProgramId", _programId);
            _loginResult.Add("YearEntry", _yearEntry);
            _loginResult.Add("Nationality", _nationality);
            _loginResult.Add("Language", (_nationality.Equals("TH") || String.IsNullOrEmpty(_nationality) ? "TH" : "EN"));
            _loginResult.Add("DepId", _depId);
            _loginResult.Add("Userlevel", _userlevel.ToUpper());
            _loginResult.Add("SystemGroup", _systemGroup);
            
            return _loginResult;
        }
    }
}