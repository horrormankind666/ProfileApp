/*
=============================================
Author      : <ยุทธภูมิ ตวันนา>
Create date : <๑๘/๐๙/๒๕๕๗>
Modify date : <๒๘/๑๑/๒๕๖๐>
Description : <คลาสใช้งานเกี่ยวกับการใช้งานฟังก์ชั่นทั่วไป>
=============================================
*/

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Globalization;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace NUtil
{
    public class Util
    {
        public static string[,] _longMonth = new string[,]
        {
            { "มกราคม", "ม.ค." },
            { "กุมภาพันธ์", "ก.พ." },
            { "มีนาคม", "มี.ค." },
            { "เมษายน", "เม.ย." },
            { "พฤษภาคม", "พ.ค." },
            { "มิถุนายน", "มิ.ย." },
            { "กรกฎาคม", "ก.ค." },
            { "สิงหาคม", "ส.ค." },
            { "กันยายน", "ก.ย." },
            { "ตุลาคม", "ต.ค." },
            { "พฤศจิกายน", "พ.ย." },
            { "ธันวาคม", "ธ.ค." }
        };
        public static string _valueTextDefault = String.Empty;
        public static string _valueComboboxDefault = "0";
        
        public static string GetBlank(string _str, string _strReplace)
        {
            string _strBlank = "----------**********.........0.0000000000000000000??????????";

            if (String.IsNullOrEmpty(_str))
                return _strReplace;
            else
            {
                if (_strBlank.IndexOf(_str) != -1)
                    return _strReplace;
                else
                    return _str;
            }
        }

        public static string CurrentDate(string _format)
        {
            return (DateTime.Today.ToString(_format));
        }

        public static string ConvertDateTH(string _dateEN)
        {
            if (!String.IsNullOrEmpty(_dateEN))
            {
                return DateTime.Parse(_dateEN).ToString("dd/MM/yyyy", new CultureInfo("th-TH"));
            }
            else
                return _dateEN;
        }

        public static string ConvertTimeTH(string _dateEN)
        {
            if (!String.IsNullOrEmpty(_dateEN))
            {
                return DateTime.Parse(_dateEN).ToString("HH:mm", new CultureInfo("th-TH"));
            }
            else
                return _dateEN;
        }

        public static string ConvertDateEN(string _dateTH)
        {
            if (!String.IsNullOrEmpty(_dateTH))
            {
                DateTime _dt = DateTime.Parse(_dateTH.Substring(6, 4) + "/" + _dateTH.Substring(3, 2) + "/" + _dateTH.Substring(0, 2));

                return (int.Parse(_dt.ToString("yyyy")) - 543).ToString() + "/" + _dt.Month + "/" + _dt.ToString("dd");
            }
            else
                return _dateTH;
        }

        public static string ThaiLongDate(string _dateEN)
        {
            if (!String.IsNullOrEmpty(_dateEN))
            {
                DateTime _dt = DateTime.Parse(_dateEN);

                return ((int.Parse(_dt.ToString("dd"))).ToString() + " " + _longMonth[_dt.Month - 1, 0] + " " + (_dt.Year + 543).ToString());
            }
            else
                return _dateEN;
        }

        public static string ThaiLongDateWithNumberTH(string _dateEN)
        {
            if (!String.IsNullOrEmpty(_dateEN))
            {
                DateTime _dt = DateTime.Parse(_dateEN);

                return (NumberArabicToThai((int.Parse(_dt.ToString("dd"))).ToString()) + " " + _longMonth[_dt.Month - 1, 0] + " พ.ศ. " + NumberArabicToThai((_dt.Year + 543).ToString()));
            }
            else
                return _dateEN;
        }

        public static string LongDateTH(string _dateTH)
        {
            if (!String.IsNullOrEmpty(_dateTH))
            {
                return (int.Parse(_dateTH.Substring(0, 2)) + " " + _longMonth[int.Parse(_dateTH.Substring(3, 2)) - 1, 0] + " " + _dateTH.Substring(6, 4));
            }
            else
                return _dateTH;
        }

        public static string ShortDateTH(string _dateTH)
        {
            if (!String.IsNullOrEmpty(_dateTH))
            {
                return (int.Parse(_dateTH.Substring(0, 2)) + " " + _longMonth[int.Parse(_dateTH.Substring(3, 2)) - 1, 1] + " " + _dateTH.Substring(8, 2));
            }
            else
                return _dateTH;
        }

        public static string GetOrdinal(string _num)
        {
            try
            {
                int _number = int.Parse(_num);

                switch (_number % 100)
                {
                    case 11:
                    case 12:
                    case 13:
                        return "th";
                }

                switch (_number % 10)
                {
                    case 1:
                        return "st";
                    case 2:
                        return "nd";
                    case 3:
                        return "rd";
                    default:
                        return "th";
                }
            }
            catch
            {
                return String.Empty;
            }
        }

        public static double RoundStang(double _number)
        {
            double _roundNumber;
            string _roundNumberStr;
            string _numberStr = _number.ToString();
            string _delimiter = ".";
            int _index;
            string _intNumberStr;
            long _intNumber;
            string _decNumberStr;
            byte _decNumber;

            _roundNumber = _number;
            _numberStr = _number.ToString("###0.00");
            _index = _numberStr.IndexOf(_delimiter);

            if (_index > 0)
            {
                _intNumberStr = _numberStr.Substring(0, _index);
                _intNumber = long.Parse(_intNumberStr);
                _decNumberStr = _numberStr.Substring(_index + 1, 2);
                _decNumber = byte.Parse(_decNumberStr);

                if ((_decNumber > 0) && (_decNumber <= 25))
                {
                    _decNumber = 25;
                }
                else
                    if ((_decNumber > 25) && (_decNumber <= 50))
                    {
                        _decNumber = 50;
                    }
                    else
                        if ((_decNumber > 50) && (_decNumber <= 75))
                        {
                            _decNumber = 75;
                        }
                        else
                            if (_decNumber > 75)
                            {
                                _intNumber = _intNumber + 1;
                                _decNumber = 0;
                            }

                _roundNumberStr = _intNumber.ToString() + "." + _decNumber.ToString();
                _roundNumber = double.Parse(_roundNumberStr);
            }

            return _roundNumber;
        }

        public static double[] CalAge(DateTime _startDate, DateTime _endDate)
        {
            double[] _result = new double[3];
            int _y = _endDate.Year - _startDate.Year;
            int _m = 0;
            int _d = 0;

            if (_endDate < _startDate.AddYears(_y) && _y != 0)
                _y--;

            _startDate = _startDate.AddYears(_y);

            if (_startDate.Year == _endDate.Year)
            {
                _m = _endDate.Month - _startDate.Month;
            }
            else
            {
                _m = (12 - _startDate.Month) + _endDate.Month;
            }

            if (_endDate < _startDate.AddMonths(_m) && _m != 0)
                _m--;

            _startDate = _startDate.AddMonths(_m);

            _d = (_endDate - _startDate).Days;

            _result[0] = _y;
            _result[1] = _m;
            _result[2] = _d;

            return _result;
        }

        public static double[] CalcDate(DateTime _startDate, DateTime _endDate)
        {
            double[] _result = new double[6];
            int _tempYear = 0;
            int _tempMonth = 0;

            if (_endDate >= _startDate)
            {
                _endDate = _endDate.AddDays(1);

                //กี่วัน
                _result[0] = (_endDate - _startDate).TotalDays;

                if (_startDate.Month < _endDate.Month)
                {
                    _tempYear = _endDate.Year - _startDate.Year;
                }
                else
                {
                    if (_startDate.Month > _endDate.Month)
                    {
                        _tempYear = _endDate.Year - _startDate.Year - 1;
                    }
                    else
                    {
                        if (_startDate.Day <= _endDate.Day)
                        {
                            _tempYear = _endDate.Year - _startDate.Year;
                        }
                        else
                        {
                            _tempYear = _endDate.Year - _startDate.Year - 1;
                        }
                    }
                }

                //กี่เดือน กี่วัน
                _tempMonth = (_endDate.Month - _startDate.Month) + (12 * (_endDate.Year - _startDate.Year));

                if (_startDate.Day > _endDate.Day)
                {
                    _tempMonth = _tempMonth - 1;
                }

                _result[1] = _tempMonth;
                _result[2] = (_endDate - _startDate.AddMonths(_tempMonth)).TotalDays;

                //เหลือเศษวันนับเป็นหนี่งเดือน
                if (_result[2] > 0)
                    _tempMonth = _tempMonth + 1;

                _result[3] = _tempMonth;

                //กี่ปี กี่วัน
                _result[4] = _tempYear;
                _result[5] = (_endDate - _startDate.AddYears(_tempYear)).TotalDays;
            }

            return _result;
        }

        public static string FindNumeric(string _str)
        {
            char[] _ch = _str.ToCharArray();
            string _numberStr = String.Empty;

            for (int _i = 0; _i < _ch.Length; _i++)
            {
                if (char.IsNumber(_ch[_i]))
                {
                    _numberStr += _ch[_i];
                }
            }

            return _numberStr;
        }

        public static string PhoneNumber(string _value)
        {
            if (_value.Length == 9)
                return (_value.Substring(0, 2).Equals("02") ? Convert.ToInt64(_value).ToString("0#-#######") : Convert.ToInt64(_value).ToString("0##-######"));

            if (_value.Length == 10)
                return Convert.ToInt64(_value).ToString("0##-#######");

            if (_value.Length > 10)
                return Convert.ToInt64(_value).ToString("0##-####### " + new String('#', (_value.Length - 10)));

            return _value;
        }

        public static int FindIndexArray1D(Array _array, string _value)
        {
            int _indexArray = 0;

            for (int _i = 0; _i < _array.GetLength(0); _i++)
            {
                if (_array.GetValue(_i).Equals(_value))
                {
                    _indexArray = _i + 1;
                    break;
                }
            }

            return _indexArray;
        }

        public static int FindIndexArray2D(int _dimension, Array _array, string _value)
        {
            int _indexArray = 0;

            for (int _i = 0; _i < _array.GetLength(0); _i++)
            {
                if (_array.GetValue(_i, _dimension).Equals(_value))
                {
                    _indexArray = _i + 1;
                    break;
                }
            }

            return _indexArray;
        }

        public static int FindIndexArray3D(int _dimension, Array _array, string _value)
        {
            int _indexArray = 0;

            if (_array.GetLength(1) == 0)
            {
                for (int _i = 0; _i < _array.GetLength(0); _i++)
                {
                    if (_array.GetValue(_i, 0, _dimension).Equals(_value))
                    {
                        _indexArray = _i + 1;
                        break;
                    }
                }
            }

            if (_array.GetLength(1) > 0)
            {
                for (int _i = 0; _i < _array.GetLength(0); _i++)
                {
                    for (int _j = 0; _j < _array.GetLength(1); _j++)
                    {
                        if (_array.GetValue(_i, _j, _dimension).Equals(_value))
                        {
                            _indexArray = _j + 1;
                            break;
                        }
                    }
                }
            }

            return _indexArray;
        }

        public static void SendMail(string _server, int _port, string _username, string _password, string _mailFrom, string[] _mailTo, string _mailSubject, string _mailMsg)
        {
            MailMessage mailMsg = new MailMessage();
            SmtpClient _smtpServer = new SmtpClient(_server);
            _smtpServer.Port = _port;
            _smtpServer.Credentials = new NetworkCredential(_username, _password);

            MailMessage _myMail = new MailMessage();
            _myMail.Sender = new MailAddress(_username);
            _myMail.From = new MailAddress(_mailFrom);

            for (int _i = 0; _i < _mailTo.GetLength(0); _i++)
            {
                _myMail.To.Add(_mailTo[_i]);
            }

            _myMail.Subject = _mailSubject;
            _myMail.IsBodyHtml = true;
            _myMail.Body = _mailMsg;

            try
            {
                _smtpServer.Send(_myMail);
            }
            catch (Exception _ex)
            {
                string _msgError = _ex.Message;
            }
        }

        public static string[] BrowserCapabilities()
        {
            string[] _result = new string[19];

            HttpBrowserCapabilities _browser = HttpContext.Current.Request.Browser;

            _result[0] = _browser.Type;
            _result[1] = _browser.Browser;
            _result[2] = _browser.Version;
            _result[3] = _browser.MajorVersion.ToString();
            _result[4] = _browser.MinorVersion.ToString();
            _result[5] = _browser.Platform;
            _result[6] = _browser.Beta.ToString();
            _result[7] = _browser.Crawler.ToString();
            _result[8] = _browser.AOL.ToString();
            _result[9] = _browser.Win16.ToString();
            _result[10] = _browser.Win32.ToString();
            _result[11] = _browser.Frames.ToString();
            _result[12] = _browser.Tables.ToString();
            _result[13] = _browser.Cookies.ToString();
            _result[14] = _browser.VBScript.ToString();
            _result[15] = _browser.EcmaScriptVersion.ToString();
            _result[16] = _browser.JavaApplets.ToString();
            _result[17] = _browser.ActiveXControls.ToString();
            _result[18] = _browser["JavaScriptVersion"];

            return _result;
        }

        public static string GetIP()
        {
            string _ip = String.Empty;

            if (HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] != null)
                _ip = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
            else
                if (!String.IsNullOrWhiteSpace(HttpContext.Current.Request.UserHostAddress))
                    _ip = HttpContext.Current.Request.UserHostAddress;

            if (_ip == "::1")
                _ip = "127.0.0.1";

            return _ip;
        }

        public static string NumberArabicToThai(string _number)
        {
            string _digit = String.Empty; ;
            string _result = String.Empty;

            _number = _number.Trim();

            CultureInfo _ct = new CultureInfo("th-TH");
            string[] _thDigit = _ct.NumberFormat.NativeDigits;

            for (int _i = 0; _i < _number.Length; _i++)
            {
                try
                {
                    _digit = _number.Substring(_i, 1);
                    _result += _thDigit[int.Parse(_digit)];
                }
                catch
                {
                    _result += _digit;
                }
            }

            return _result;
        }

        public static string UppercaseFirst(string _s)
        {
            string[] _strPass = new string[] { "of", "for", "the", "is", "by", "in" };
            string[] _strArray;

            _s = _s.Trim();

            if (!String.IsNullOrEmpty(_s))
            {
                _s = _s.ToLower();
                _strArray = _s.Split(' ');
                _s = String.Empty;

                try
                {
                    for (int _i = 0; _i < _strArray.Length; _i++)
                    {
                        if (!Array.IndexOf(_strPass, _strArray[_i].ToLower()).Equals(-1))
                            _s += (_i.Equals(0) ? (char.ToUpper((_strArray[_i])[0]) + (_strArray[_i].Substring(1)).ToLower()) : (_strArray[_i].ToLower()));
                        else
                            _s += char.ToUpper((_strArray[_i])[0]) + (_strArray[_i].Substring(1)).ToLower();

                        _s += " ";
                    }
                }
                catch
                {
                    _s += "";
                }
            }

            return _s.Trim();
        }

        public static string ThaiBaht(string _m)
        {
            string _bahtTxt, _n, _bahtTH = String.Empty;
            double _amount;

            try
            {
                _amount = Convert.ToDouble(_m);
            }
            catch
            {
                _amount = 0;
            }

            _bahtTxt = _amount.ToString("####.00");

            string[] _num = { "ศูนย์", "หนึ่ง", "สอง", "สาม", "สี่", "ห้า", "หก", "เจ็ด", "แปด", "เก้า", "สิบ" };
            string[] _rank = { "", "สิบ", "ร้อย", "พัน", "หมื่น", "แสน", "ล้าน" };
            string[] _temp = _bahtTxt.Split('.');
            string _intVal = _temp[0];
            string _decVal = _temp[1];

            if (Convert.ToDouble(_bahtTxt) == 0)
                _bahtTH = "ศูนย์บาทถ้วน";
            else
            {
                for (int _i = 0; _i < _intVal.Length; _i++)
                {
                    _n = _intVal.Substring(_i, 1);

                    if (!_n.Equals("0"))
                    {
                        if (_i.Equals(_intVal.Length - 1) && _n.Equals("1"))
                            _bahtTH += "เอ็ด";
                        else
                            if (_i.Equals(_intVal.Length - 2) && _n.Equals("2"))
                                _bahtTH += "ยี่";
                            else
                                if (_i.Equals(_intVal.Length - 2) && _n.Equals("1"))
                                    _bahtTH += "";
                                else
                                    _bahtTH += _num[Convert.ToInt32(_n)];

                        _bahtTH += _rank[(_intVal.Length - _i) - 1];
                    }
                }

                _bahtTH += "บาท";

                if (_decVal.Equals("00"))
                    _bahtTH += "ถ้วน";
                else
                {
                    for (int _i = 0; _i < _decVal.Length; _i++)
                    {
                        _n = _decVal.Substring(_i, 1);

                        if (!_n.Equals("0"))
                        {
                            if (_i.Equals(_decVal.Length - 1) && _n.Equals("1"))
                                _bahtTH += "เอ็ด";
                            else
                                if (_i.Equals(_decVal.Length - 2) && _n.Equals("2"))
                                    _bahtTH += "ยี่";
                                else
                                    if (_i.Equals(_decVal.Length - 2) && _n.Equals("1"))
                                        _bahtTH += "";
                                    else
                                        _bahtTH += _num[Convert.ToInt32(_n)];

                            _bahtTH += _rank[(_decVal.Length - _i) - 1];
                        }
                    }

                    _bahtTH += "สตางค์";
                }
            }

            return _bahtTH;
        }

        public static string ThaiNum(string _m)
        {
            string _numTxt, _n, _numTH = String.Empty;
            double _amount;

            try
            {
                _amount = Convert.ToDouble(_m);
            }
            catch
            {
                _amount = 0;
            }

            _numTxt = _amount.ToString("####.00");

            string[] _num = { "ศูนย์", "หนึ่ง", "สอง", "สาม", "สี่", "ห้า", "หก", "เจ็ด", "แปด", "เก้า", "สิบ" };
            string[] _rank = { "", "สิบ", "ร้อย", "พัน", "หมื่น", "แสน", "ล้าน" };
            string[] _temp = _numTxt.Split('.');
            string _intVal = _temp[0];
            string _decVal = _temp[1];

            if (Convert.ToDouble(_numTxt) == 0)
                _numTH = "ศูนย์";
            else
            {
                for (int _i = 0; _i < _intVal.Length; _i++)
                {
                    _n = _intVal.Substring(_i, 1);

                    if (!_n.Equals("0"))
                    {
                        if (_i.Equals(_intVal.Length - 1) && _n.Equals("1"))
                            _numTH += "เอ็ด";
                        else
                            if (_i.Equals(_intVal.Length - 2) && _n.Equals("2"))
                                _numTH += "ยี่";
                            else
                                if (_i.Equals(_intVal.Length - 2) && _n.Equals("1"))
                                    _numTH += "";
                                else
                                    _numTH += _num[Convert.ToInt32(_n)];

                        _numTH += _rank[(_intVal.Length - _i) - 1];
                    }
                }

                if (!_decVal.Equals("00"))
                {
                    for (int _i = 0; _i < _decVal.Length; _i++)
                    {
                        _n = _decVal.Substring(_i, 1);
                        _numTH += _num[Convert.ToInt32(_n)];
                    }

                    _numTH += "จุด" + _numTH;
                }
            }

            return _numTH;
        }

        public static string GetApplicationPath()
        {
            string _appPath = String.Empty;

            HttpContext _context = HttpContext.Current;

            if (_context != null)
            {
                _appPath = string.Format("{0}://{1}{2}{3}",
                    _context.Request.Url.Scheme,
                    _context.Request.Url.Host,
                    _context.Request.Url.Port == 80 ? string.Empty : ":" + _context.Request.Url.Port,
                    _context.Request.ApplicationPath
                );
            }

            return _appPath;
        }

        public static bool ConvertStrToDouble(string _m)
        {
            try
            {
                Convert.ToDouble(_m);
                return true;
            }
            catch
            {
                return false;
            }
        }

        public static bool FileSiteExist(string _file)
        {
            bool _result = true;

            try
            {
                HttpWebRequest _request = (HttpWebRequest)HttpWebRequest.Create(new Uri(_file));
                _result = (_request.GetResponse().ContentLength > 0) ? true : false;
            }
            catch
            {
                _result = false;
            }

            return _result;
        }

        public static bool FileExist(string _fileName)
        {
            return File.Exists(HttpContext.Current.Server.MapPath(_fileName));
        }

        public static string GeneratePasscode(int _lenChars, int _lenNonAlphaNumericChars)
        {
            string _allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            string _allowedNonAlphaNum = "!@#$%^&()_-+=[{]};";

            Random _rd = new Random();

            if (_lenNonAlphaNumericChars > _lenChars || _lenChars <= 0 || _lenNonAlphaNumericChars < 0)
                throw new ArgumentOutOfRangeException();

            char[] _pass = new char[_lenChars];
            int[] _pos = new int[_lenChars];
            int _i = 0, _j = 0, _temp = 0;
            bool _flag = false;

            while (_i < (_lenChars - 1))
            {
                _j = 0;
                _flag = false;
                _temp = _rd.Next(0, _lenChars);

                for (_j = 0; _j < _lenChars; _j++)
                {
                    if (_temp == _pos[_j])
                    {
                        _flag = true;
                        _j = _lenChars;
                    }
                }

                if (!_flag)
                {
                    _pos[_i] = _temp;
                    _i++;
                }
            }

            for (_i = 0; _i < (_lenChars - _lenNonAlphaNumericChars); _i++)
                _pass[_i] = _allowedChars[_rd.Next(0, _allowedChars.Length)];

            for (_i = (_lenChars - _lenNonAlphaNumericChars); _i < _lenChars; _i++)
                _pass[_i] = _allowedNonAlphaNum[_rd.Next(0, _allowedNonAlphaNum.Length)];

            char[] _sorted = new char[_lenChars];

            for (_i = 0; _i < _lenChars; _i++)
                _sorted[_i] = _pass[_pos[_i]];

            string _resultPass = new String(_sorted);

            return _resultPass;
        }

        public static string GetFullName(string _titleName, string _titleNameOther, string _firstName, string _middleName, string _lastName)
        {
            _titleName = (!String.IsNullOrEmpty(_titleName) ? _titleName : _titleNameOther);
            _middleName = (!String.IsNullOrEmpty(_middleName) ? (_middleName + " ") : String.Empty);

            return (_titleName + _firstName + " " + _middleName + _lastName);
        }

        public static HttpCookie GetCookie(string _cookieName)
        {
            HttpCookie _cookieObj = new HttpCookie(_cookieName);
            _cookieObj = HttpContext.Current.Request.Cookies[_cookieName];

            return _cookieObj;
        }

        public static void SetAddCookie(string _cookieName, StringBuilder _cookieValue)
        {
            string[] _cookieValueArray = _cookieValue.ToString().Split(',');
            int _i = 0;

            HttpCookie _cookieObj = new HttpCookie(_cookieName);

            for (_i = 0; _i < _cookieValueArray.GetLength(0); _i++)
            {
                string[] _cookieValueSubArray = _cookieValueArray[_i].Split(':');

                _cookieObj.Values.Add(_cookieValueSubArray[0], _cookieValueSubArray[1]);
            }

            HttpContext.Current.Response.Cookies.Add(_cookieObj);
        }

        public static void SetUpdateCookie(string _cookieName, StringBuilder _cookieValue)
        {
            string[] _cookieValueArray = _cookieValue.ToString().Split(',');
            int _i = 0;

            HttpCookie _cookieObj = GetCookie(_cookieName);

            for (_i = 0; _i < _cookieValueArray.GetLength(0); _i++)
            {
                string[] _cookieValueSubArray = _cookieValueArray[_i].Split(':');

                _cookieObj.Values.Set(_cookieValueSubArray[0], _cookieValueSubArray[1]);
            }

            HttpContext.Current.Response.Cookies.Set(_cookieObj);
        }

        public static int ChkCookie(string _cookieName)
        {
            int _cookieError = 0;

            HttpCookie _cookieObj = GetCookie(_cookieName);

            if (_cookieObj == null)
                _cookieError = 1;

            return _cookieError;
        }

        public static int ViewFile(string _filePath, string _fileName)
        {
            int _error = 0;
            bool _fileExist = FileExist(_filePath + "/" + _fileName);

            if (_fileExist.Equals(true))
            {
                try
                {
                    if (!String.IsNullOrEmpty(_fileName))
                    {
                        _error = 0;

                        string[] _viewFileArray = _fileName.Split('.');
                        string _fileExtension = _viewFileArray[_viewFileArray.GetLength(0) - 1];

                        FileStream _sourceFile = new FileStream(HttpContext.Current.Server.MapPath(_filePath + "/" + _fileName), FileMode.Open);
                        float _fileSize = _sourceFile.Length;
                        byte[] _getContent = new byte[(int)_fileSize];
                        _sourceFile.Read(_getContent, 0, (int)_sourceFile.Length);
                        _sourceFile.Close();

                        HttpContext.Current.Response.ClearContent();
                        HttpContext.Current.Response.ClearHeaders();
                        HttpContext.Current.Response.Buffer = true;
                        HttpContext.Current.Response.ContentType = GetHeaderContentType(_fileExtension.ToLower());
                        HttpContext.Current.Response.AddHeader("Content-Length", _getContent.Length.ToString());
                        HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment; filename=" + _fileName);
                        HttpContext.Current.Response.BinaryWrite(_getContent);
                        HttpContext.Current.Response.Flush();
                        HttpContext.Current.Response.End();
                    }
                    else
                        _error = 1;
                }
                catch
                {
                    _error = 2;
                }
            }
            else
                _error = 1;

            return _error;
        }

        public static string GetHeaderContentType(string _fileExtension)
        {
            switch (_fileExtension)
            {
                case "txt":
                    return "text/plain";
                case "doc":
                    return "application/ms-word";
                case "xls":
                    return "application/vnd.ms-excel";
                case "gif":
                    return "image/gif";
                case "jpg":
                case "jpeg":
                    return "image/jpeg";
                case "bmp":
                    return "image/bmp";
                case "wav":
                    return "audio/wav";
                case "ppt":
                    return "application/mspowerpoint";
                case "dwg":
                    return "image/vnd.dwg";
                case "zip":
                    return "application/zip";
                case "pdf":
                    return "application/pdf";
                default:
                    return "application/octet-stream";
            }
        }

        public static int[] CalNavPage(int _recordCount, int _currentPage, int _rowPerPage)
        {
            int _totalPage;
            int _diffPage;
            int[] _calNavPageResult = new int[2];

            if (_recordCount > 0)
            {
                _totalPage = 1;

                if (_recordCount > _rowPerPage)
                {
                    _totalPage = (_recordCount / _rowPerPage);
                    _totalPage = ((_recordCount % _rowPerPage).Equals(0) ? _totalPage : (_totalPage + 1));
                }

                if ((String.IsNullOrEmpty(_currentPage.ToString())) || (_currentPage.Equals(0)))
                    _currentPage = 1;
                else
                {
                    if (_currentPage < 1)
                        _currentPage = 1;

                    if (_currentPage > _totalPage)
                        _currentPage = _totalPage;

                    _diffPage = _currentPage - _totalPage;

                    if (_diffPage.Equals(1))
                        _currentPage = _totalPage;
                }
            }
            else
            {
                _currentPage = 0;
                _totalPage = 0;
            }

            _calNavPageResult[0] = _currentPage;
            _calNavPageResult[1] = _totalPage;

            return _calNavPageResult;
        }

        public static StringBuilder GetPanelNavPage(int _recordCount, int[] _calNavPage, string _section, int _rowPerPage)
        {
            StringBuilder _html = new StringBuilder();
            int _distance = 10;
            int _pageCenter;
            int _startPage = 0;
            int _endPage = 0;
            int _i;

            _html.AppendLine("<div class='navpage'>");
            _html.AppendLine("  <div class='navpage-layout'>");
            _html.AppendLine("      <div class='navpage-content'>");
            _html.AppendLine("          <ul>");
            _html.AppendFormat("            <li><a class='en-label' href='javascript:void(0)' onclick=Util.gotoNavPage('{0}',{1},{2},{3})>&lt;&lt;</a></li>", _section, 1, 1, _rowPerPage);
            _html.AppendFormat("            <li><a class='en-label' href='javascript:void(0)' onclick=Util.gotoNavPage('{0}',{1},{2},{3})>&lt;</a></li>", _section, (_calNavPage[0] - 1), ((_calNavPage[0] - 1).Equals(0) ? 1 : ((((_calNavPage[0] - 1) * _rowPerPage) + 1) - _rowPerPage)), ((_calNavPage[0] - 1).Equals(0) ? _rowPerPage : ((_calNavPage[0] - 1) * _rowPerPage)));

            _pageCenter = (_distance / 2);
            _pageCenter = ((_distance % 2).Equals(0) ? _pageCenter : (_pageCenter + 1));

            if (_calNavPage[1] <= _distance)
            {
                _startPage = 1;
                _endPage = _calNavPage[1];
            }
            else
            {
                if (_calNavPage[0].Equals(1))
                {
                    _startPage = 1;
                    _endPage = _distance;
                }

                if (_calNavPage[0].Equals(_calNavPage[1]))
                {
                    _startPage = (_calNavPage[1] - (_distance - 1));
                    _endPage = _calNavPage[1];
                }

                if (!_calNavPage[0].Equals(1) && !_calNavPage[0].Equals(_calNavPage[1]))
                {
                    _startPage = (_calNavPage[0] - _pageCenter);
                    _endPage = ((_startPage + _distance) - 1);

                    if (_endPage > _calNavPage[1])
                    {
                        _startPage = ((_calNavPage[1] - _distance) + 1);
                        _endPage = _calNavPage[1];
                    }

                    if (!(_endPage - _startPage).Equals(_distance) && !_endPage.Equals(_calNavPage[1]))
                    {
                        _startPage = _startPage + 1;

                        if (_startPage <= 0) _startPage = 1;

                        _endPage = (_startPage + _distance) - 1;

                        if (_endPage > _calNavPage[1]) _endPage = _calNavPage[1];
                    }
                }
            }

            for (_i = _startPage; _i <= _endPage; _i++)
            {
                if (_i.Equals(_calNavPage[0]))
                    _html.AppendFormat("    <li class='active'><div class='en-label'>{0}</div></li>", _i.ToString("#,##0"));
                else
                    _html.AppendFormat("    <li><a class='en-label' href='javascript:void(0)' onclick=Util.gotoNavPage('{0}',{1},{2},{3})>{4}</a></li>", _section, _i, (((_i * _rowPerPage) + 1) - _rowPerPage), (_i * _rowPerPage), _i.ToString("#,##0"));
            }

            _html.AppendFormat("            <li><a class='en-label' href='javascript:void(0)' onclick=Util.gotoNavPage('{0}',{1},{2},{3})>&gt;</a></li>", _section, (_calNavPage[0] + 1), ((_calNavPage[0] + 1) > _calNavPage[1] ? (((_calNavPage[1] * _rowPerPage) + 1) - _rowPerPage) : ((((_calNavPage[0] + 1) * _rowPerPage) + 1) - _rowPerPage)), ((_calNavPage[0] + 1) > _calNavPage[1] ? (_calNavPage[1] * _rowPerPage) : ((_calNavPage[0] + 1) * _rowPerPage)));
            _html.AppendFormat("            <li><a class='en-label' href='javascript:void(0)' onclick=Util.gotoNavPage('{0}',{1},{2},{3})>&gt;&gt;</a></li>", _section, _calNavPage[1], (((_calNavPage[1] * _rowPerPage) + 1) - _rowPerPage), (_calNavPage[1] * _rowPerPage));
            _html.AppendFormat("            <li><div class='en-label'>&nbsp;of&nbsp;{0}</div></li>", _calNavPage[1].ToString("#,##0"));
            _html.AppendLine("          </ul>");
            _html.AppendLine("      </div>");
            _html.AppendLine("      <div class='clear'></div>");
            _html.AppendLine("  </div>");
            _html.AppendLine("</div>");

            return _html;
        }

        public static StringBuilder GetPanelNavPageNew(int _recordCount, int[] _calNavPage, string _section, int _rowPerPage)
        {
            StringBuilder _html = new StringBuilder();
            string _callFunc = String.Empty;
            int _distance = 10;
            int _pageCenter;
            int _startPage = 0;
            int _endPage = 0;
            int _i;

            _html.AppendLine("<div class='navpage'>");
            _html.AppendLine("  <div class='navpage-layout'>");
            _html.AppendLine("      <div class='navpage-content'>");
            _html.AppendLine("          <ul>");

            _callFunc = "Util.gotoNavPage({" +
                        "page:'" + _section + "'," +
                        "currentPage:1," +
                        "startRow:1," +
                        "endRow:"+ _rowPerPage +
                        "})";

            _html.AppendFormat("            <li><a class='en-label' href='javascript:void(0)' onclick={0}>&lt;&lt;</a></li>", _callFunc);

            _callFunc = "Util.gotoNavPage({" +
                        "page:'" + _section + "'," +
                        "currentPage:" + (_calNavPage[0] - 1) + "," +
                        "startRow:" + ((_calNavPage[0] - 1).Equals(0) ? 1 : ((((_calNavPage[0] - 1) * _rowPerPage) + 1) - _rowPerPage)) + "," +
                        "endRow:" + ((_calNavPage[0] - 1).Equals(0) ? _rowPerPage : ((_calNavPage[0] - 1) * _rowPerPage)) +
                        "})";

            _html.AppendFormat("            <li><a class='en-label' href='javascript:void(0)' onclick={0}>&lt;</a></li>", _callFunc);

            _pageCenter = (_distance / 2);
            _pageCenter = ((_distance % 2).Equals(0) ? _pageCenter : (_pageCenter + 1));

            if (_calNavPage[1] <= _distance)
            {
                _startPage = 1;
                _endPage = _calNavPage[1];
            }
            else
            {
                if (_calNavPage[0].Equals(1))
                {
                    _startPage = 1;
                    _endPage = _distance;
                }

                if (_calNavPage[0].Equals(_calNavPage[1]))
                {
                    _startPage = (_calNavPage[1] - (_distance - 1));
                    _endPage = _calNavPage[1];
                }

                if (!_calNavPage[0].Equals(1) && !_calNavPage[0].Equals(_calNavPage[1]))
                {
                    _startPage = (_calNavPage[0] - _pageCenter);
                    _endPage = ((_startPage + _distance) - 1);

                    if (_endPage > _calNavPage[1])
                    {
                        _startPage = ((_calNavPage[1] - _distance) + 1);
                        _endPage = _calNavPage[1];
                    }

                    if (!(_endPage - _startPage).Equals(_distance) && !_endPage.Equals(_calNavPage[1]))
                    {
                        _startPage = _startPage + 1;

                        if (_startPage <= 0) _startPage = 1;

                        _endPage = (_startPage + _distance) - 1;

                        if (_endPage > _calNavPage[1]) _endPage = _calNavPage[1];
                    }
                }
            }

            for (_i = _startPage; _i <= _endPage; _i++)
            {
                if (_i.Equals(_calNavPage[0]))
                    _html.AppendFormat("    <li class='active'><div class='en-label'>{0}</div></li>", _i.ToString("#,##0"));
                else
                {
                    _callFunc = "Util.gotoNavPage({" +
                                "page:'" + _section + "'," +
                                "currentPage:" + _i + "," +
                                "startRow:" + (((_i * _rowPerPage) + 1) - _rowPerPage) + "," +
                                "endRow:" + (_i * _rowPerPage) +
                                "})";

                    _html.AppendFormat("    <li><a class='en-label' href='javascript:void(0)' onclick={0}>{1}</a></li>", _callFunc, _i.ToString("#,##0"));
                }
            }

            _callFunc = "Util.gotoNavPage({" +
                        "page:'" + _section + "'," +
                        "currentPage:" + (_calNavPage[0] + 1) + "," +
                        "startRow:" + ((_calNavPage[0] + 1) > _calNavPage[1] ? (((_calNavPage[1] * _rowPerPage) + 1) - _rowPerPage) : ((((_calNavPage[0] + 1) * _rowPerPage) + 1) - _rowPerPage)) + "," +
                        "endRow:" + ((_calNavPage[0] + 1) > _calNavPage[1] ? (_calNavPage[1] * _rowPerPage) : ((_calNavPage[0] + 1) * _rowPerPage)) +
                        "})";

            _html.AppendFormat("            <li><a class='en-label' href='javascript:void(0)' onclick={0}>&gt;</a></li>", _callFunc);

            _callFunc = "Util.gotoNavPage({" +
                        "page:'" + _section + "'," +
                        "currentPage:" + _calNavPage[1] + "," +
                        "startRow:" + (((_calNavPage[1] * _rowPerPage) + 1) - _rowPerPage) + "," +
                        "endRow:" + (_calNavPage[1] * _rowPerPage) +
                        "})";

            _html.AppendFormat("            <li><a class='en-label' href='javascript:void(0)' onclick={0}>&gt;&gt;</a></li>", _callFunc);
            _html.AppendFormat("            <li><div class='en-label'>&nbsp;of&nbsp;{0}</div></li>", _calNavPage[1].ToString("#,##0"));
            _html.AppendLine("          </ul>");
            _html.AppendLine("      </div>");
            _html.AppendLine("      <div class='clear'></div>");
            _html.AppendLine("  </div>");
            _html.AppendLine("</div>");

            return _html;
        }

        public static StringBuilder GetNavPage(int _recordCount, int _currentPage, string _page, int _rowPerPage)
        {
            StringBuilder _html = new StringBuilder();
            int _curPage = (!String.IsNullOrEmpty(_currentPage.ToString()) ? _currentPage : 0);
            int _recCount = (!String.IsNullOrEmpty(_recordCount.ToString()) ? _recordCount : 0);
            int[] _calNavPage = new int[2];

            if (_recCount > 0)
            {
                _calNavPage = CalNavPage(_recCount, _curPage, _rowPerPage);

                _html.AppendLine(GetPanelNavPage(_recCount, _calNavPage, _page, _rowPerPage).ToString());
            }

            return _html;
        }

        public static StringBuilder GetNavPageNew(int _recordCount, int _currentPage, string _page, int _rowPerPage)
        {
            StringBuilder _html = new StringBuilder();
            int _curPage = (!String.IsNullOrEmpty(_currentPage.ToString()) ? _currentPage : 0);
            int _recCount = (!String.IsNullOrEmpty(_recordCount.ToString()) ? _recordCount : 0);
            int[] _calNavPage = new int[2];

            if (_recCount > 0)
            {
                _calNavPage = CalNavPage(_recCount, _curPage, _rowPerPage);

                _html.AppendLine(GetPanelNavPageNew(_recCount, _calNavPage, _page, _rowPerPage).ToString());
            }

            return _html;
        }

        public static string EncodeToBase64(string _str)
        {
            try
            {
                string _strEncode = String.Empty;
                byte[] _encDataByte = new byte[_str.Length];

                _encDataByte = Encoding.UTF8.GetBytes(_str);
                _strEncode = Convert.ToBase64String(_encDataByte);

                return _strEncode;
            }
            catch
            {
                return String.Empty;
            }
        }

        public static string DecodeFromBase64(string _strEncode)
        {
            UTF8Encoding _encoder = new UTF8Encoding();
            Decoder _utf8Decode = _encoder.GetDecoder();
            byte[] _todecodeByte = Convert.FromBase64String(_strEncode);
            int _charCount = _utf8Decode.GetCharCount(_todecodeByte, 0, _todecodeByte.Length);
            char[] _decodedChar = new char[_charCount];
            string _strDecode = String.Empty;

            _utf8Decode.GetChars(_todecodeByte, 0, _todecodeByte.Length, _decodedChar, 0);
            _strDecode = new String(_decodedChar);

            return _strDecode;
        }

        public static StringBuilder GetCombobox(string _idCombobox, string _title, string[] _value, string[] _text)
        {
            StringBuilder _html = new StringBuilder();
            int _i = 0;

            _html.AppendLine("<div class='combobox'>");
            _html.AppendFormat("<select id='{0}'>", _idCombobox);

            if (!String.IsNullOrEmpty(_title))
                _html.AppendFormat("<option value='0'>{0}</option>", _title);

            for (_i = 0; _i < _value.GetLength(0); _i++)
            {
                _html.AppendFormat("<option value='{0}'>{1}</option>", _value[_i], _text[_i]);
            }

            _html.AppendLine("  </select>");
            _html.AppendLine("</div>");

            return _html;
        }

        public static StringBuilder GetSelect(string _idCombobox, string _title, string[] _value, string[] _text)
        {
            StringBuilder _html = new StringBuilder();
            int _i = 0;

            _html.AppendFormat("<div class='combobox' id='{0}'>", _idCombobox);
            _html.AppendLine("      <select>");

            if (!String.IsNullOrEmpty(_title))
                _html.AppendFormat("    <option value='0'>{0}</option>", _title);

            for (_i = 0; _i < _value.GetLength(0); _i++)
            {
                _html.AppendFormat("    <option value='{0}'>{1}</option>", _value[_i], _text[_i]);
            }

            _html.AppendLine("      </select>");
            _html.AppendLine("  </div>");

            return _html;
        }

        public static StringBuilder GetComboboxLanguage(string _idCombobox)
        {
            StringBuilder _html = new StringBuilder();
            int _i = 0;

            string[] _language = new string[]
            {
                "TH",
                "EN"
            };

            string[] _optionValue = new string[_language.GetLength(0)];
            string[] _optionText = new string[_language.GetLength(0)];

            for (_i = 0; _i < _language.GetLength(0); _i++)
            {
                _optionValue[_i] = _language[_i];
                _optionText[_i] = _language[_i];
            }

            _html = Util.GetSelect(_idCombobox, "", _optionValue, _optionText);

            return _html;
        }

        public static string GetStudentRecordsToHTML(string _personId)
        {
            StringBuilder _html = new StringBuilder();

            DataSet _ds = DBUtil.GetStudentRecordsToStudentCV(_personId);
            DataRow _dr = _ds.Tables[0].Rows[0];

            try
            {
                _html.AppendLine(
                    _dr["formStyle"].ToString() +
                    _dr["formOpen"].ToString() +
                    _dr["formHead"].ToString() +
                    _dr["formStudent"].ToString() +
                    _dr["formPersonal"].ToString() +
                    _dr["formPermanentAddress"].ToString() +
                    _dr["formCurrentAddress"].ToString() +
                    _dr["formPrimaryEducation"].ToString() +
                    _dr["formJuniorEducation"].ToString() +
                    _dr["formHighSchoolEducation"].ToString() +
                    _dr["formMUEducational"].ToString() +
                    _dr["formAdmissionScores"].ToString() +
                    _dr["formTalent"].ToString() +
                    _dr["formHealth"].ToString() +
                    _dr["formWorker"].ToString() +
                    _dr["formFinance"].ToString() +
                    _dr["formPersonalFather"].ToString() +
                    _dr["formPermanentAddressFather"].ToString() +
                    _dr["formCurrentAddressFather"].ToString() +
                    _dr["formWorkerFather"].ToString() +
                    _dr["formPersonalMother"].ToString() +
                    _dr["formPermanentAddressMother"].ToString() +
                    _dr["formCurrentAddressMother"].ToString() +
                    _dr["formWorkerMother"].ToString() +
                    _dr["formPersonalParent"].ToString() +
                    _dr["formPermanentAddressParent"].ToString() +
                    _dr["formCurrentAddressParent"].ToString() +
                    _dr["formWorkerParent"].ToString() +
                    _dr["formClose"].ToString()
                );
            }
            catch
            {
            }

            return _html.ToString();
        }

        public static StringBuilder GetStudentRecordsToStudentCV(string _personId)
        {
            StringBuilder _html = new StringBuilder();
            
            _html.AppendLine(GetStudentRecordsToHTML(_personId));

            return _html;
        }

        public static int RemoveSingleFile(string _sourceDir, string _sourceFile)
        {
            int _error = 0;

            try
            {
                _sourceFile = HttpContext.Current.Server.MapPath(_sourceDir + "/" + _sourceFile);
                _error = (File.Exists(_sourceFile) ? 0 : 2);

                if (_error.Equals(0))
                {
                    FileInfo _file = new FileInfo(_sourceFile);
                    _file.Delete();
                }
            }
            catch
            {
                _error = 1;
            }

            return _error;
        }

        public static int RemoveMultipleFiles(string _sourcePath, string _keyword)
        {
            int _error = 0;
            string[] _fileList;

            try
            {
                _sourcePath = HttpContext.Current.Server.MapPath(_sourcePath);
                _fileList = Directory.GetFiles(_sourcePath, _keyword);

                foreach (string _f in _fileList)
                {
                    File.Delete(_f);
                }
            }
            catch
            {
                _error = 1;
            }

            return _error;
        }

        public static int ExecuteCommand(string _command, int _timeOut)
        {
            int _exitCode = 0;

            try
            {
                ProcessStartInfo _processInfo = new ProcessStartInfo("cmd.exe", "/C" + _command);
                _processInfo.CreateNoWindow = true;
                _processInfo.UseShellExecute = false;
                _processInfo.WorkingDirectory = "C:\\";

                Process _process = Process.Start(_processInfo);
                _process.WaitForExit(_timeOut);

                _exitCode = _process.ExitCode;

                _process.Close();
            }
            catch
            {
                _exitCode = 1;
            }

            return _exitCode;
        }

        public static int ConnectServerToServer(string _sourceServerPath, string _sourceServerUserName, string _sourceServerPassword, string _destServerPath, string _destServerUsername, string _destServerPassword)
        {
            string _command = String.Empty;
            int _errorCommand1 = -1;
            int _errorCommand2 = -1;
            int _error = 0;
            int _timeOut = 30000;

            _command = "NET USE " + _sourceServerPath + (!String.IsNullOrEmpty(_sourceServerUserName) ? (" /USER:" + _sourceServerUserName + " " + _sourceServerPassword) : String.Empty);
            _errorCommand1 = ExecuteCommand(_command, _timeOut);
            
            if (_errorCommand1.Equals(0))
            {
                /*
                _command = "NET USE " + _destServerPath + (!String.IsNullOrEmpty(_destServerUsername) ? (" /USER:" + _destServerUsername + " " + _destServerPassword) : String.Empty);
                _errorCommand2 = ExecuteCommand(_command, _timeOut);

                _error = (_errorCommand2.Equals(0) ? 0 : 2);
                */
            }
            else
                _error = 1;
            
            return _error;
        }

        public static int CopyFileServerToServer(string _sourceServerPath, string _sourceServerFile, string _destServerPath, string _destServerFile)
        {
            string _command = String.Empty;
            int _errorCommand = -1;
            int _timeOut = 30000;
            int _error = 0;

            _command = "COPY \"" + (_sourceServerPath + "\\" + _sourceServerFile) + "\" \"" + (_destServerPath + "\\" + _destServerFile) + "\"";
            _errorCommand = ExecuteCommand(_command, _timeOut);

            _error = (_errorCommand.Equals(0) ? 0 : 1);

            return _error;
        }

        public static string GetFolderNameFromStudentId(string _studentId)
        {
            try
            {
                Double _pi = 3.142857;
                Double _dStdId = Convert.ToDouble(_studentId);
                Double _result = _dStdId * _pi;
                string _str = _result.ToString();
                _str = _str.Substring(0, (_dStdId * _pi).ToString().LastIndexOf("."));
                int _len = _str.Length;

                return _str.Substring(_len - 2, 2);
            }
            catch (Exception _ex)
            {
                return ("Error " + _ex.Message);
            }
        }

        public static string EncodeToMD5(string _str)
        {
            MD5CryptoServiceProvider MD5 = new MD5CryptoServiceProvider();
            byte[] _infoByte = Encoding.ASCII.GetBytes(_str);
            byte[] _encrytInfo = MD5.ComputeHash(_infoByte);
            string _strEncode = Convert.ToBase64String(_encrytInfo);

            _strEncode = _strEncode.Replace(@"/", "_");
            _strEncode = _strEncode.Replace(@"\", "_");
            _strEncode = _strEncode.Replace(@"+", "_");

            return _strEncode;
        }

        public static object GetValueDataDictionary(Dictionary<string, object> _dataDict, string _containsKey, object _valueTrue, object _valueFalse)
        {
            object _valueResult;

            try
            {
                _valueResult = (_dataDict.ContainsKey(_containsKey).Equals(true) ? (!String.IsNullOrEmpty(_dataDict[_containsKey].ToString()) ? _valueTrue : _valueFalse) : _valueFalse);
            }
            catch
            {
                _valueResult = _valueFalse;
            }

            return _valueResult;
        }

        public class ImageProcessUtil
        {
            public static MemoryStream ResizeImage(string _fileSite, int _width, int _height)
            {
                Image _oThumbNail;
                Graphics _oGraphic;
                
                try
                {
                    HttpWebRequest _request = (HttpWebRequest)HttpWebRequest.Create(_fileSite);
                    HttpWebResponse _response = (HttpWebResponse)_request.GetResponse();
                    Image _sourceImage = Image.FromStream(_response.GetResponseStream());

                    _oThumbNail = new Bitmap(_sourceImage, _width, _height);
                    _oGraphic = Graphics.FromImage(_oThumbNail);
                    _oGraphic.CompositingQuality = CompositingQuality.HighQuality;
                    _oGraphic.SmoothingMode = SmoothingMode.HighQuality;
                    _oGraphic.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    Rectangle _oRectangle = new Rectangle(0, 0, _width, _height);
                    _oGraphic.DrawImage(_sourceImage, _oRectangle);
                    _oGraphic.Dispose();
                }
                catch
                {
                    _oThumbNail = new Bitmap(_width, _height);
                    _oGraphic = Graphics.FromImage(_oThumbNail);
                    _oGraphic.FillRectangle(Brushes.White, 0, 0, _width, _height);
                    _oGraphic.Dispose();
                }

                MemoryStream _ms = new MemoryStream();
                Bitmap _bmp = new Bitmap(_oThumbNail);

                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.ContentType = "image/png";

                _bmp.Save(_ms, ImageFormat.Png);

                return _ms;
            }

            public static MemoryStream ImageToStream(string _fileSite, string _fileFormat)
            {
                MemoryStream _ms = new MemoryStream();

                try
                {
                    HttpWebRequest _request = (HttpWebRequest)HttpWebRequest.Create(_fileSite);
                    HttpWebResponse _response = (HttpWebResponse)_request.GetResponse();
                    Image _sourceImage = Image.FromStream(_response.GetResponseStream());

                    Bitmap _bmp = new Bitmap(_sourceImage);
                    _bmp.Save(_ms, GetImageFormat(_fileFormat));
                }
                catch
                {
                }

                return _ms;
            }

            public static MemoryStream ImageFileToStream(string _filePath)
            {
                byte[] _imageArray = File.ReadAllBytes(HttpContext.Current.Server.MapPath(_filePath));

                MemoryStream _ms = new MemoryStream(_imageArray);

                return _ms;
            }

            public static void CopyImage(string _destPath, string _destFile, string _fileSite, string _fileFormat)
            {
                HttpWebRequest _request = (HttpWebRequest)HttpWebRequest.Create(_fileSite);
                HttpWebResponse _response = (HttpWebResponse)_request.GetResponse();
                Image _sourceImage = Image.FromStream(_response.GetResponseStream());

                MemoryStream _ms = new MemoryStream();
                Bitmap _bmp = new Bitmap(_sourceImage);
                _bmp.Save((_destPath + "\\" + _destFile), GetImageFormat(_fileFormat));
            }

            public static ImageFormat GetImageFormat(string _fileFormat)
            {
                switch (_fileFormat.ToLower())
                {
                    case "jpg":
                    case "jpeg":
                    case ".jpg":
                    case ".jpeg":
                        return ImageFormat.Jpeg;
                    case "gif":
                    case ".gif":
                        return ImageFormat.Gif;
                    case "bmp":
                    case ".bmp":
                        return ImageFormat.Bmp;
                    case "png":
                    case ".png":
                        return ImageFormat.Png;
                    default:
                        return null;
                }
            }

            public static int CropAndSaveFile(string _sourceDir, string _sourceFile, string _destDir, string _destFile, string _destFileFormat, int _destWidth, int _destHeight, int _cropX, int _cropY)
            {
                int _error = 0;
                string _fileName = String.Empty;
                string _fileExtension = String.Empty;
                string _sourceFileFullPath = String.Empty;
                string _destFileFullPath = String.Empty;
                ImageFormat _imageFormat = GetImageFormat(_destFileFormat.ToLower());

                try
                {
                    _sourceFileFullPath = HttpContext.Current.Server.MapPath(_sourceDir + (!String.IsNullOrEmpty(_sourceDir) ? "/" : "") + _sourceFile);
                    _destFileFullPath = HttpContext.Current.Server.MapPath(_destDir + (!String.IsNullOrEmpty(_destDir) ? "/" : "") + _destFile);
                    _error = (File.Exists(_sourceFileFullPath) ? 0 : 2);
                    
                    if (_error.Equals(0))
                    {
                        Bitmap _sourceImage = new Bitmap(_sourceFileFullPath);
                        Bitmap _destImage = new Bitmap(_destWidth, _destHeight);
                        _destImage.SetResolution(_destImage.HorizontalResolution, _destImage.VerticalResolution);

                        Graphics _objGraphic = Graphics.FromImage(_destImage);
                        _objGraphic.SmoothingMode = SmoothingMode.AntiAlias;
                        _objGraphic.InterpolationMode = InterpolationMode.HighQualityBicubic;
                        _objGraphic.PixelOffsetMode = PixelOffsetMode.HighQuality;

                        _objGraphic.DrawImage(_sourceImage, new Rectangle(0, 0, _destImage.Width, _destImage.Height), _cropX, _cropY, _destImage.Width, _destImage.Height, GraphicsUnit.Pixel);
                        _destImage.Save(_destFileFullPath, _imageFormat);

                        _sourceImage.Dispose();
                        _destImage.Dispose();
                        _objGraphic.Dispose();
                    }
                }
                catch
                {
                    _error = 1;
                }

                return _error;
            }
        }

        public class DBUtil
        {
            public static string _myConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["infinityConnectionString"].ConnectionString;

            public static SqlConnection ConnectDB(string _connString)
            {
                SqlConnection _conn = new SqlConnection(_connString);

                return _conn;
            }


            public static DataSet ExecuteCommandStoredProcedure(string _procName, params SqlParameter[] _values)
            {
                SqlConnection _conn = ConnectDB(_myConnectionString);
                SqlCommand _cmd = new SqlCommand(_procName, _conn);
                DataSet _ds = new DataSet();
                                
                _cmd.CommandType = CommandType.StoredProcedure;
                _cmd.CommandTimeout = 1000;

                if (_values != null && _values.Length > 0)
                    _cmd.Parameters.AddRange(_values);

                try
                {
                    _conn.Open();

                    SqlDataAdapter _da = new SqlDataAdapter(_cmd);

                    _ds = new DataSet();
                    _da.Fill(_ds);
                }
                finally
                {
                    _cmd.Dispose();
                    
                    _conn.Close();
                    _conn.Dispose();
                }

                return _ds;
            }

            public static void ExecuteCommandText(string _cmdText)
            {
                SqlConnection _conn = ConnectDB(_myConnectionString);
                SqlCommand _cmd = new SqlCommand(_cmdText, _conn);

                _cmd.CommandType = CommandType.Text;
                _cmd.CommandTimeout = 1000;

                try
                {
                    _conn.Open();

                    SqlTransaction _trans = _conn.BeginTransaction();
                    _cmd.Transaction = _trans;
                    _cmd.ExecuteNonQuery();
                    _trans.Commit();
                }
                finally
                {
                    _cmd.Dispose();
                    
                    _conn.Close();
                    _conn.Dispose();
                }
            }

            public static int InsertTransactionLog(string _tableTransactionLog, string _tableErrorLog, string _logAction, string _logValue, string _logActionBy)
            {
                int _error = 0;
                string _cmdText = String.Empty;

                try
                {
                    _cmdText += "INSERT INTO " + _tableTransactionLog + " " +
                                "(logDatabase, logAction, logValue, logActionDate, logActionBy, logCreateDate, logCreateBy, logIp) " +
                                "VALUES " +
                                "(" +
                                "DB_NAME(), " +
                                "'" + _logAction + "', " +
                                "'" + _logValue + "' ," +
                                "GETDATE(), " +
                                (!String.IsNullOrEmpty(_logActionBy) ? ("'" + _logActionBy + "'") : "NULL") + ", " +
                                "GETDATE(), " +
                                "SYSTEM_USER, " +
                                "'" + GetIP() + "'" +
                                ")";

                    ExecuteCommandText(_cmdText);
                }
                catch
                {
                    _error = 1;
                }

                return _error;
            }

            public static DataSet GetSystemPermission(string _systemGroup)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_sysGetDateEvent",
                    new SqlParameter("@sysName", _systemGroup),
                    new SqlParameter("@sysEvent", _systemGroup)
                );

                return _ds;
            }

            public static DataSet GetSystemDateEvent(string _systemGroup)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_sysGetSystemDateEvent",
                    new SqlParameter("@sysName", _systemGroup),
                    new SqlParameter("@sysEvent", _systemGroup)
                );

                return _ds;
            }

            public static DataSet GetUserStudent(string _personId)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetPersonStudent",
                    new SqlParameter("@personId", _personId)
                );

                return _ds;
            }

            public static DataSet GetUserStudentWithAuthenStaff(string _username, string _userlevel, string _systemGroup, string _personId)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetPersonStudentWithAuthenStaff",
                    new SqlParameter("@username", _username),
                    new SqlParameter("@userlevel", _userlevel),
                    new SqlParameter("@systemGroup", _systemGroup),
                    new SqlParameter("@personId", _personId)
                );

                return _ds;
            }

            public static int ChkUserStudent(string _personId)
            {
                DataSet _ds = GetUserStudent(_personId);
                int _recordCount = _ds.Tables[0].Rows.Count;
                int _userError = 0;

                if (_recordCount <= 0)
                    _userError = 1;

                _ds.Dispose();

                return _userError;
            }

            public static int ChkUserStudentWithAuthenStaff(string _username, string _userlevel, string _systemGroup, string _personId)
            {
                DataSet _ds = GetUserStudentWithAuthenStaff(_username, _userlevel, _systemGroup, _personId);
                int _recordCount = _ds.Tables[0].Rows.Count;
                int _userError = 0;

                if (_recordCount <= 0)
                    _userError = 1;

                _ds.Dispose();

                return _userError;
            }

            public static int ChkSystemPermissionStudent(Dictionary<string, object> _finServiceLogin)
            {
                int _cookieError = int.Parse(_finServiceLogin["CookieError"].ToString());
                int _systemError = 0;
                string _personId = _finServiceLogin["PersonId"].ToString();
                string _studentId = _finServiceLogin["StudentId"].ToString();
                string _entranceTypeId = _finServiceLogin["EntranceType"].ToString();
                string _facultyId = _finServiceLogin["FacultyId"].ToString();
                string _programId = _finServiceLogin["ProgramId"].ToString();
                string _yearEntry = _finServiceLogin["YearEntry"].ToString();
                string _systemGroup = _finServiceLogin["SystemGroup"].ToString();
                DateTime _dtNow = DateTime.Now;

                if (_cookieError.Equals(0))
                {
                    if (!String.IsNullOrEmpty(_studentId))
                    {
                        DataSet _ds = GetSystemPermission(_systemGroup);

                        if (_ds.Tables.Count > 0 && _ds.Tables[0].Rows.Count > 0)
                        {
                            DataRow _dr = _ds.Tables[0].Rows[0];
                            DateTime _startDate = DateTime.Parse(_dr["startDate"].ToString());
                            DateTime _endDate = DateTime.Parse(_dr["endDate"].ToString());
                            string _systemYearEntry = _dr["yearEntry"].ToString();
                            string _systemEntranceType = _dr["entranceType"].ToString();
                            string _systemFacultyProgram = _dr["facultyprogram"].ToString();

                            if (_systemError.Equals(0) && DateTime.Compare(_dtNow, _startDate) >= 0 && DateTime.Compare(_dtNow, _endDate) <= 0)
                                _systemError = 0;

                            if (_systemError.Equals(0) && DateTime.Compare(_dtNow, _startDate) < 0)
                                _systemError = 3;

                            if (_systemError.Equals(0) && DateTime.Compare(_dtNow, _endDate) > 0)
                                _systemError = 4;

                            if (_systemError.Equals(0) && !String.IsNullOrEmpty(_systemYearEntry))
                            {
                                if (_systemYearEntry.IndexOf(_yearEntry).Equals(-1))
                                    _systemError = 5;
                            }

                            if (_systemError.Equals(0) && !String.IsNullOrEmpty(_systemEntranceType))
                            {
                                if (_systemEntranceType.IndexOf(_entranceTypeId).Equals(-1))
                                    _systemError = 5;
                            }

                            if (_systemError.Equals(0) && !String.IsNullOrEmpty(_systemFacultyProgram))
                            {

                                if (_systemFacultyProgram.IndexOf(_facultyId).Equals(-1))
                                    _systemError = 5;

                                if (_systemError.Equals(0) && (_systemFacultyProgram.IndexOf(_facultyId + "*").Equals(-1)))
                                {
                                    if (_systemFacultyProgram.IndexOf(_programId).Equals(-1))
                                        _systemError = 5;
                                }
                            }

                        }

                        _ds.Dispose();
                    }
                    else
                        _systemError = 2;
                }
                else
                    _systemError = 1;

                return _systemError;
            }

            public static DataSet GetUserStaff(string _username, string _userlevel, string _systemGroup)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_autUserAccessProgram",
                    new SqlParameter("@username", _username),
                    new SqlParameter("@userlevel", _userlevel),
                    new SqlParameter("@systemGroup", _systemGroup)
                );

                return _ds;
            }

            public static int ChkUserStaff(string _username, string _userlevel, string _systemGroup)
            {
                DataSet _ds = GetUserStaff(_username, _userlevel, _systemGroup);
                int _recordCount = _ds.Tables[0].Rows.Count;
                int _userError = 0;
                    
                if (_recordCount <= 0)
                    _userError = 1;

                _ds.Dispose();

                return _userError;
            }

            public static int ChkSystemPermissionStaff(Dictionary<string, object> _finServiceLogin)
            {
                int _cookieError = int.Parse(_finServiceLogin["CookieError"].ToString());
                int _systemError = 0;

                if (_cookieError.Equals(0))
                {
                }
                else
                    _systemError = 1;

                return _systemError;
            }

            public static DataSet GetListYearEntry()
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetListYearEntryPersonStudent", null);

                return _ds;
            }

            public static DataSet GetRecordCountPerson(string _personId)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetRecordCountPerson",
                    new SqlParameter("@personId", _personId)
                );

                return _ds;
            }

            public static DataSet GetStudentRecords(string _personId)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetPersonStudent",
                    new SqlParameter("@personId", _personId)
                );

                return _ds;
            }

            public static DataSet GetPersonRecordsPersonal(string _personId)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetPerson",
                    new SqlParameter("@personId", _personId)
                );

                return _ds;
            }

            public static DataSet GetPersonRecordsAddress(string _personId)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetAddress",
                    new SqlParameter("@personId", _personId));

                return _ds;
            }

            public static DataSet GetPersonRecordsEducation(string _personId)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetEducation",
                    new SqlParameter("@personId", _personId)
                );

                return _ds;
            }

            public static DataSet GetPersonRecordsActivity(string _personId)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetActivity",
                    new SqlParameter("@personId", _personId)
                );

                return _ds;
            }

            public static DataSet GetPersonRecordsHealthy(string _personId)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetHealthy",
                    new SqlParameter("@personId", _personId)
                );

                return _ds;
            }

            public static DataSet GetPersonRecordsWork(string _personId)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetWork",
                    new SqlParameter("@personId", _personId)
                );

                return _ds;
            }

            public static DataSet GetPersonRecordsFinancial(string _personId)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetFinancial",
                    new SqlParameter("@personId", _personId)
                );

                return _ds;
            }
            
            public static DataSet GetPersonRecordsFamily(string _personId)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetParent",
                    new SqlParameter("@personId", _personId)
                );

                return _ds;
            }

            public static DataSet GetStudentRecordsToStudentCV(string _personId)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_stdStudentCV",
                    new SqlParameter("@personId", _personId)
                );

                return _ds;
            }

            public static DataSet GetListTitlePrefix(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetListTitlePrefix",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@gender", (_paramSearch.ContainsKey("Gender").Equals(true) ? _paramSearch["Gender"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListGender(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetListGender",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListNationality(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetListNationality",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListReligion(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetListReligion",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListBloodGroup(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetListBloodType",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListMaritalStatus(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetListMaritalStatus",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListRelationship(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetListRelationship",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@gender", (_paramSearch.ContainsKey("Gender").Equals(true) ? _paramSearch["Gender"] : String.Empty)),
                    new SqlParameter("@relationship", (_paramSearch.ContainsKey("Relationship").Equals(true) ? _paramSearch["Relationship"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListAgency(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetListAgency",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListEducationalLevel(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetListEducationalLevel",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListEducationalBackground(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetListEducationalBackground",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@educationalLevel", (_paramSearch.ContainsKey("DegreeLevel").Equals(true) ? _paramSearch["DegreeLevel"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListEducationalMajor(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetListEducationalMajor",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListEntranceType(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetListEntranceType",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListStudentStatus(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_stdGetListStudentStatus",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListCountry(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_plcGetListCountry",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListProvince(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_plcGetListProvince",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@country", (_paramSearch.ContainsKey("Country").Equals(true) ? _paramSearch["Country"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListDistrict(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_plcGetListDistrict",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@country", (_paramSearch.ContainsKey("Country").Equals(true) ? _paramSearch["Country"] : String.Empty)),
                    new SqlParameter("@province", (_paramSearch.ContainsKey("Province").Equals(true) ? _paramSearch["Province"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListSubdistrict(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_plcGetListSubdistrict",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@country", (_paramSearch.ContainsKey("Country").Equals(true) ? _paramSearch["Country"] : String.Empty)),
                    new SqlParameter("@province", (_paramSearch.ContainsKey("Province").Equals(true) ? _paramSearch["Province"] : String.Empty)),
                    new SqlParameter("@district", (_paramSearch.ContainsKey("District").Equals(true) ? _paramSearch["District"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListInstitute(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetListInstitute",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@country", (_paramSearch.ContainsKey("Country").Equals(true) ? _paramSearch["Country"] : String.Empty)),
                    new SqlParameter("@province", (_paramSearch.ContainsKey("Province").Equals(true) ? _paramSearch["Province"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetInstitute(string _id)
            {
                DataSet _ds = Util.DBUtil.ExecuteCommandStoredProcedure("sp_perGetInstitute",
                    new SqlParameter("@id", _id)
                );

                return _ds;
            }

            public static DataSet GetListDiseases(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetListDiseases",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListImpairments(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetListImpairments",
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@cancelledStatus", (_paramSearch.ContainsKey("CancelledStatus").Equals(true) ? _paramSearch["CancelledStatus"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListDegreeLevel()
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_stdGetListDegreeLevel", null);

                return _ds;
            }

            public static DataSet GetListFaculty(string _username, string _systemGroup, Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_autGetListFacultyAccess",
                    new SqlParameter("@username", _username),
                    new SqlParameter("@systemGroup", _systemGroup),
                    new SqlParameter("@faculty", (_paramSearch.ContainsKey("Faculty").Equals(true) ? _paramSearch["Faculty"] : String.Empty)),
                    new SqlParameter("@distinction", (_paramSearch.ContainsKey("Distinction").Equals(true) ? _paramSearch["Distinction"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListProgram(string _username, string _systemGroup, Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_autGetListProgramAccess",
                    new SqlParameter("@username", _username),
                    new SqlParameter("@systemGroup", _systemGroup),
                    new SqlParameter("@degreeLevel", (_paramSearch.ContainsKey("DegreeLevel").Equals(true) ? _paramSearch["DegreeLevel"] : String.Empty)),
                    new SqlParameter("@faculty", (_paramSearch.ContainsKey("Faculty").Equals(true) ? _paramSearch["Faculty"] : String.Empty)),
                    new SqlParameter("@program", (_paramSearch.ContainsKey("Program").Equals(true) ? _paramSearch["Program"] : String.Empty)),
                    new SqlParameter("@distinction", (_paramSearch.ContainsKey("Distinction").Equals(true) ? _paramSearch["Distinction"] : String.Empty))
                );
                
                return _ds;
            }

            public static DataSet GetProgram(Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_acaGetProgram",
                    new SqlParameter("@programId", (_paramSearch.ContainsKey("Program").Equals(true) ? _paramSearch["Program"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListStudentRecords(string _username, string _userlevel, string _systemGroup, string _reportName, Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetListPersonStudentWithAuthenStaff",
                    new SqlParameter("@username", _username),
                    new SqlParameter("@userlevel", _userlevel),
                    new SqlParameter("@systemGroup", _systemGroup),
                    new SqlParameter("@reportName", _reportName),
                    new SqlParameter("@keyword", (_paramSearch.ContainsKey("Keyword").Equals(true) ? _paramSearch["Keyword"] : String.Empty)),
                    new SqlParameter("@degreeLevelId", (_paramSearch.ContainsKey("DegreeLevel").Equals(true) ? _paramSearch["DegreeLevel"] : String.Empty)),
                    new SqlParameter("@facultyId", (_paramSearch.ContainsKey("Faculty").Equals(true) ? _paramSearch["Faculty"] : String.Empty)),
                    new SqlParameter("@programId", (_paramSearch.ContainsKey("Program").Equals(true) ? _paramSearch["Program"] : String.Empty)),
                    new SqlParameter("@yearEntry", (_paramSearch.ContainsKey("YearEntry").Equals(true) ? _paramSearch["YearEntry"] : String.Empty)),
                    new SqlParameter("@yearGraduate", (_paramSearch.ContainsKey("YearGraduate").Equals(true) ? _paramSearch["YearGraduate"] : String.Empty)),
                    new SqlParameter("@class", (_paramSearch.ContainsKey("Class").Equals(true) ? _paramSearch["Class"] : String.Empty)),
                    new SqlParameter("@entranceTypeId", (_paramSearch.ContainsKey("EntranceType").Equals(true) ? _paramSearch["EntranceType"] : String.Empty)),
                    new SqlParameter("@studentStatusTypeId", (_paramSearch.ContainsKey("StudentStatus").Equals(true) ? _paramSearch["StudentStatus"] : String.Empty)),
                    new SqlParameter("@studentStatusTypeGroup", (_paramSearch.ContainsKey("StudentStatusGroup").Equals(true) ? _paramSearch["StudentStatusGroup"] : String.Empty)),
                    new SqlParameter("@studentRecordsStatus", (_paramSearch.ContainsKey("StudentRecordsStatus").Equals(true) ? _paramSearch["StudentRecordsStatus"] : String.Empty)),
                    new SqlParameter("@distinctionStatus", (_paramSearch.ContainsKey("Distinction").Equals(true) ? _paramSearch["Distinction"] : String.Empty)),
                    new SqlParameter("@joinProgram", (_paramSearch.ContainsKey("JoinProgram").Equals(true) ? _paramSearch["JoinProgram"] : String.Empty)),
                    new SqlParameter("@joinProgramStatus", (_paramSearch.ContainsKey("JoinProgramStatus").Equals(true) ? _paramSearch["JoinProgramStatus"] : String.Empty)),
                    new SqlParameter("@startAcademicYear", (_paramSearch.ContainsKey("StartAcademicYear").Equals(true) ? _paramSearch["StartAcademicYear"] : String.Empty)),
                    new SqlParameter("@endAcademicYear", (_paramSearch.ContainsKey("EndAcademicYear").Equals(true) ? _paramSearch["EndAcademicYear"] : String.Empty)),
                    new SqlParameter("@genderId", (_paramSearch.ContainsKey("Gender").Equals(true) ? _paramSearch["Gender"] : String.Empty)),
                    new SqlParameter("@nationalityId", (_paramSearch.ContainsKey("Nationality").Equals(true) ? _paramSearch["Nationality"] : String.Empty)),
                    new SqlParameter("@sortOrderBy", (_paramSearch.ContainsKey("SortOrderBy").Equals(true) ? _paramSearch["SortOrderBy"] : String.Empty)),
                    new SqlParameter("@sortExpression", (_paramSearch.ContainsKey("SortExpression").Equals(true) ? _paramSearch["SortExpression"] : String.Empty))
                );

                return _ds;
            }

            public static DataSet GetListTransactionLog(string _username, string _userlevel, string _systemGroup, string _reportName, Dictionary<string, object> _paramSearch)
            {
                DataSet _ds = ExecuteCommandStoredProcedure("sp_perGetListTransactionLog",
                    new SqlParameter("@username", _username),
                    new SqlParameter("@userlevel", _userlevel),
                    new SqlParameter("@systemGroup", _systemGroup),
                    new SqlParameter("@reportName", _reportName),
                    new SqlParameter("@personId", (_paramSearch.ContainsKey("PersonId").Equals(true) ? _paramSearch["PersonId"] : String.Empty))
                );

                return _ds;
            }
        }

        public class ChartUtil
        {
            private static string _type;
            private static string _renderTo;
            private static string _backgroundColor;
            private static string _title;
            private static string _legendTitle;

            private static string _level1XAxisTitle;
            private static string _level1YAxisTitle;
            private static List<object> _level1SeriesName;
            private static List<object> _level1SeriesColor;
            private static bool _level1SeriesColorByPoint;
            private static List<object> _level1SeriesDataName;
            private static List<object> _level1SeriesDataColor;
            private static List<object> _level1SeriesDataValue;
            private static List<object> _level1SeriesDataDrillDown;

            private static string _level2XAxisTitle;
            private static string _level2YAxisTitle;
            private static List<object> _level2SeriesId;
            private static List<object> _level2SeriesName;
            private static bool _level2SeriesColorByPoint;
            private static List<object> _level2SeriesDataName;
            private static List<object> _level2SeriesDataColor;
            private static List<object> _level2SeriesDataValue;
            private static List<object> _level2SeriesDataDrillDown;

            private static string _level3XAxisTitle;
            private static string _level3YAxisTitle;
            private static List<object> _level3SeriesId;
            private static List<object> _level3SeriesName;
            private static bool _level3SeriesColorByPoint;
            private static List<object> _level3SeriesDataName;
            private static List<object> _level3SeriesDataColor;
            private static List<object> _level3SeriesDataValue;
            private static List<object> _level3SeriesDataDrillDown;

            private static string _level4XAxisTitle;
            private static string _level4YAxisTitle;
            private static List<object> _level4SeriesId;
            private static List<object> _level4SeriesName;
            private static bool _level4SeriesColorByPoint;
            private static List<object> _level4SeriesDataName;
            private static List<object> _level4SeriesDataColor;
            private static List<object> _level4SeriesDataValue;
            private static List<object> _level4SeriesDataDrillDown;

            public static string Type
            {
                get { return _type; }
                set { _type = value; }
            }

            public static string RenderTo
            {
                get { return _renderTo; }
                set { _renderTo = value; }
            }

            public static string BackgroundColor
            {
                get { return _backgroundColor; }
                set { _backgroundColor = value; }
            }

            public static string Title
            {
                get { return _title; }
                set { _title = value; }
            }

            public static string LegendTitle
            {
                get { return _legendTitle; }
                set { _legendTitle = value; }
            }
  
            public static string Level1XAxisTitle
            {
                get { return _level1XAxisTitle; }
                set { _level1XAxisTitle = value; }
            }

            public static string Level1YAxisTitle
            {
                get { return _level1YAxisTitle; }
                set { _level1YAxisTitle = value; }
            }

            public static List<object> Level1SeriesName
            {
                get { return _level1SeriesName; }
                set { _level1SeriesName = value; }
            }

            public static List<object> Level1SeriesColor
            {
                get { return _level1SeriesColor; }
                set { _level1SeriesColor = value; }
            }

            public static bool Level1SeriesColorByPoint
            {
                get { return _level1SeriesColorByPoint; }
                set { _level1SeriesColorByPoint = value; }
            }

            public static List<object> Level1SeriesDataName
            {
                get { return _level1SeriesDataName; }
                set { _level1SeriesDataName = value; }
            }

            public static List<object> Level1SeriesDataColor
            {
                get { return _level1SeriesDataColor; }
                set { _level1SeriesDataColor = value; }
            }

            public static List<object> Level1SeriesDataValue
            {
                get { return _level1SeriesDataValue; }
                set { _level1SeriesDataValue = value; }
            }

            public static List<object> Level1SeriesDataDrillDown
            {
                get { return _level1SeriesDataDrillDown; }
                set { _level1SeriesDataDrillDown = value; }
            }

            public static string Level2XAxisTitle
            {
                get { return _level2XAxisTitle; }
                set { _level2XAxisTitle = value; }
            }

            public static string Level2YAxisTitle
            {
                get { return _level2YAxisTitle; }
                set { _level2YAxisTitle = value; }
            }

            public static List<object> Level2SeriesId
            {
                get { return _level2SeriesId; }
                set { _level2SeriesId = value; }
            }

            public static List<object> Level2SeriesName
            {
                get { return _level2SeriesName; }
                set { _level2SeriesName = value; }
            }

            public static bool Level2SeriesColorByPoint
            {
                get { return _level2SeriesColorByPoint; }
                set { _level2SeriesColorByPoint = value; }
            }

            public static List<object> Level2SeriesDataName
            {
                get { return _level2SeriesDataName; }
                set { _level2SeriesDataName = value; }
            }

            public static List<object> Level2SeriesDataColor
            {
                get { return _level2SeriesDataColor; }
                set { _level2SeriesDataColor = value; }
            }

            public static List<object> Level2SeriesDataValue
            {
                get { return _level2SeriesDataValue; }
                set { _level2SeriesDataValue = value; }
            }

            public static List<object> Level2SeriesDataDrillDown
            {
                get { return _level2SeriesDataDrillDown; }
                set { _level2SeriesDataDrillDown = value; }
            }

            public static string Level3XAxisTitle
            {
                get { return _level3XAxisTitle; }
                set { _level3XAxisTitle = value; }
            }

            public static string Level3YAxisTitle
            {
                get { return _level3YAxisTitle; }
                set { _level3YAxisTitle = value; }
            }

            public static List<object> Level3SeriesId
            {
                get { return _level3SeriesId; }
                set { _level3SeriesId = value; }
            }

            public static List<object> Level3SeriesName
            {
                get { return _level3SeriesName; }
                set { _level3SeriesName = value; }
            }

            public static bool Level3SeriesColorByPoint
            {
                get { return _level3SeriesColorByPoint; }
                set { _level3SeriesColorByPoint = value; }
            }

            public static List<object> Level3SeriesDataName
            {
                get { return _level3SeriesDataName; }
                set { _level3SeriesDataName = value; }
            }

            public static List<object> Level3SeriesDataColor
            {
                get { return _level3SeriesDataColor; }
                set { _level3SeriesDataColor = value; }
            }

            public static List<object> Level3SeriesDataValue
            {
                get { return _level3SeriesDataValue; }
                set { _level3SeriesDataValue = value; }
            }

            public static List<object> Level3SeriesDataDrillDown
            {
                get { return _level3SeriesDataDrillDown; }
                set { _level3SeriesDataDrillDown = value; }
            }

            public static string Level4XAxisTitle
            {
                get { return _level4XAxisTitle; }
                set { _level4XAxisTitle = value; }
            }

            public static string Level4YAxisTitle
            {
                get { return _level4YAxisTitle; }
                set { _level4YAxisTitle = value; }
            }

            public static List<object> Level4SeriesId
            {
                get { return _level4SeriesId; }
                set { _level4SeriesId = value; }
            }

            public static List<object> Level4SeriesName
            {
                get { return _level4SeriesName; }
                set { _level4SeriesName = value; }
            }

            public static bool Level4SeriesColorByPoint
            {
                get { return _level4SeriesColorByPoint; }
                set { _level4SeriesColorByPoint = value; }
            }

            public static List<object> Level4SeriesDataName
            {
                get { return _level4SeriesDataName; }
                set { _level4SeriesDataName = value; }
            }

            public static List<object> Level4SeriesDataColor
            {
                get { return _level4SeriesDataColor; }
                set { _level4SeriesDataColor = value; }
            }

            public static List<object> Level4SeriesDataValue
            {
                get { return _level4SeriesDataValue; }
                set { _level4SeriesDataValue = value; }
            }

            public static List<object> Level4SeriesDataDrillDown
            {
                get { return _level4SeriesDataDrillDown; }
                set { _level4SeriesDataDrillDown = value; }
            }

            public static StringBuilder GetChart()
            {
                StringBuilder _html = new StringBuilder();
                List<object> _seriesNameTemp = new List<object>();
                List<object> _seriesColorTemp = new List<object>();
                List<object> _seriesValueTemp = new List<object>();
                List<object> _seriesDrillDownTemp = new List<object>();
                int _i = 0;
                int _j = 0;

                _html.AppendLine("<script type='text/javascript'>");
                _html.AppendFormat("var _legendTitle = '{0}';", _legendTitle);
                _html.AppendLine("  var _drilldownTitle = '';");

                _html.AppendLine("  Highcharts.setOptions({");
                _html.AppendLine("      lang: {");
                _html.AppendLine("          loading: '',");
                _html.AppendLine("          decimalPoint: '.',");
                _html.AppendLine("          thousandsSep: ',',");
                _html.AppendLine("          drillUpText: '<b>Go Back" + (_type.Equals("pie") ? " #{series.name}" : "") + "</b>'");
                _html.AppendLine("      }");
                _html.AppendLine("  });");

                _html.AppendLine("  $('#" + _renderTo + "').highcharts({");
                _html.AppendLine("      chart: {");
                _html.AppendFormat("        renderTo: '{0}',", _renderTo);
                _html.AppendFormat("        backgroundColor: '{0}',", _backgroundColor);
                _html.AppendLine("          plotBackgroundColor: null,");
                _html.AppendLine("          plotBorderWidth: null,");
                _html.AppendLine("          plotShadow: false,");
                _html.AppendLine("          spacing: [0, 0, 0, 0],");
                _html.AppendFormat("        type: '{0}',", _type);
                _html.AppendLine("          events: {");
                _html.AppendLine("              drilldown: function (_e) {");
                _html.AppendLine("                  _i = 0;");

                if (_type.Equals("pie"))
                    _html.AppendLine("              this.legend.title.attr({ text: _drilldownTitle + _e.seriesOptions.name });");
                
                if (_type.Equals("column") || _type.Equals("bar"))
                {
                    /*
                    _html.AppendLine("              this.xAxis[0].setTitle({ text: '" + _level2XAxisTitle + "' });");
                    _html.AppendLine("              this.yAxis[0].setTitle({ text: '" + _level2YAxisTitle + "' });");

                    _html.AppendLine("              if (_e.seriesOptions.id.split('#')[0] == '1') {");
                    _html.AppendLine("                  _drilldownLevelOld = 1;");
                    _html.AppendLine("                  _drilldownLevel = 1;");
                    _html.AppendLine("                  _drilldownLevel1Title = '( ' + _e.seriesOptions.id.split('#')[1] + ' )';");
                    _html.AppendLine("                  this.xAxis[0].setTitle({ text: '" + _level2XAxisTitle + "<br /> ' + _drilldownLevel1Title });");
                    _html.AppendLine("                  this.yAxis[0].setTitle({ text: '" + _level2YAxisTitle + "' });");
                    _html.AppendLine("              }");

                    _html.AppendLine("              if (_e.seriesOptions.id.split('#')[0] == '2') {");
                    _html.AppendLine("                  _drilldownLevelOld = 2;");
                    _html.AppendLine("                  _drilldownLevel = 2;");
                    _html.AppendLine("                  _drilldownLevel2Title = '( ' + _e.seriesOptions.id.split('#')[1] + ' )';");
                    _html.AppendLine("                  this.xAxis[0].setTitle({ text: '" + _level3XAxisTitle + "<br /> ' + _drilldownLevel2Title });");
                    _html.AppendLine("                  this.yAxis[0].setTitle({ text: '" + _level3YAxisTitle + "' });");
                    _html.AppendLine("              }");
                    */
                }

                _html.AppendLine("              },");
                _html.AppendLine("              drillup: function(_e) {");
                
                if (_type.Equals("pie"))
                    _html.AppendLine("              this.legend.title.attr({ text: _drilldownTitle + _e.seriesOptions.name });");
                
                if (_type.Equals("column") || _type.Equals("bar"))
                {
                    /*
                    _html.AppendLine("              this.xAxis[0].setTitle({ text: '" + _level1XAxisTitle + "' });");
                    _html.AppendLine("              this.yAxis[0].setTitle({ text: '" + _level1YAxisTitle + "' });");

                    _html.AppendLine("              if (_drilldownLevel == 1) {");
                    _html.AppendLine("                  this.xAxis[0].setTitle({ text: '" + _level1XAxisTitle + "' });");
                    _html.AppendLine("                  this.yAxis[0].setTitle({ text: '" + _level1YAxisTitle + "' });");
                    _html.AppendLine("              }");

                    _html.AppendLine("              if (_drilldownLevel == 2) {");
                    _html.AppendLine("                  this.xAxis[0].setTitle({ text: '" + _level2XAxisTitle + "<br /> ' + _drilldownLevel1Title });");
                    _html.AppendLine("                  this.yAxis[0].setTitle({ text: '" + _level2YAxisTitle + "' });");
                    _html.AppendLine("              }");     
                    */
                }
                
                _html.AppendLine("              }");
                _html.AppendLine("          }");
                _html.AppendLine("      },");
                _html.AppendLine("      navigation: {");
                _html.AppendLine("          buttonOptions: {");
                _html.AppendFormat("            y: {0}", (!String.IsNullOrEmpty(_title) ? 31 : 0));
                _html.AppendLine("          }");
                _html.AppendLine("      },");
                _html.AppendLine("      title: {");
                _html.AppendFormat("        text: '{0}',", (!String.IsNullOrEmpty(_title) ? _title : "n/a"));
                _html.AppendFormat("        margin: {0},", (_title.IndexOf("<br />") != -1 ? 27 : 43));
                _html.AppendLine("          style: {");
                _html.AppendFormat("            fontSize: '{0}px',", (!String.IsNullOrEmpty(_title) ? 14 : 1));
                _html.AppendLine("              fontFamily: 'Corbel, Tahoma, Verdana, Arial, sans-serif',");
                _html.AppendLine("              fontWeight: 'bold',");
                _html.AppendFormat("            color: '{0}'", (!String.IsNullOrEmpty(_title) ? "#000000" : _backgroundColor));
                _html.AppendLine("          },");
                _html.AppendLine("          y: 14");
                _html.AppendLine("      },");
                _html.AppendLine("      legend: {");

                if (_type.Equals("pie"))
                {
                    _html.AppendLine("      title: {");
                    _html.AppendLine("          text: _legendTitle,");
                    _html.AppendLine("          style: {");
                    _html.AppendLine("              fontSize: '14px',");
                    _html.AppendLine("              fontFamily: 'Corbel, Tahoma, Verdana, Arial, sans-serif',");
                    _html.AppendLine("              fontWeight: 'bold',");
                    _html.AppendLine("              color: '#000000'");
                    _html.AppendLine("          }");
                    _html.AppendLine("      },");
                    _html.AppendLine("      align: 'right',");
                    _html.AppendLine("      itemStyle: {");
                    _html.AppendLine("          fontSize: '12px',");
                    _html.AppendLine("          fontFamily: 'Corbel, Tahoma, Verdana, Arial, sans-serif',");
                    _html.AppendLine("          fontWeight: 'normal',");
                    _html.AppendLine("          color: '#000000'");
                    _html.AppendLine("      },");
                    _html.AppendLine("      layout: 'vertical',");
                    _html.AppendLine("      verticalAlign: 'top',");
                    _html.AppendLine("      x: 0,");
                    _html.AppendLine("      y: 61,");
                }

                if (_type.Equals("column"))
                {
                    _html.AppendLine("      align: 'center',");
                    _html.AppendLine("      itemStyle: {");
                    _html.AppendLine("          fontSize: '12px',");
                    _html.AppendLine("          fontFamily: 'Corbel, Tahoma, Verdana, Arial, sans-serif',");
                    _html.AppendLine("          fontWeight: 'normal',");
                    _html.AppendLine("          color: '#000000'");
                    _html.AppendLine("      },");
                    _html.AppendLine("      layout: 'horizontal',");
                    _html.AppendLine("      verticalAlign: 'bottom',");
                    _html.AppendLine("      x: 0,");
                    _html.AppendLine("      y: 0,");
                }

                if (_type.Equals("bar"))
                {
                    _html.AppendLine("      align: 'center',");
                    _html.AppendLine("      itemStyle: {");
                    _html.AppendLine("          fontSize: '12px',");
                    _html.AppendLine("          fontFamily: 'Corbel, Tahoma, Verdana, Arial, sans-serif',");
                    _html.AppendLine("          fontWeight: 'normal',");
                    _html.AppendLine("          color: '#000000'");
                    _html.AppendLine("      },");
                    _html.AppendLine("      layout: 'horizontal',");
                    _html.AppendLine("      verticalAlign: 'bottom',");
                    _html.AppendLine("      x: 0,");
                    _html.AppendLine("      y: 0,");
                }

                _html.AppendLine("          backgroundColor: '#F5F5F5',");
                _html.AppendLine("          borderWidth: 1,");
                _html.AppendLine("          floating: false,");
                _html.AppendLine("          margin: 12,");
                _html.AppendLine("          maxHeight: 228,");
                _html.AppendLine("          itemMarginTop: 3,");
                _html.AppendLine("          itemMarginBottom: 3,");
	            _html.AppendLine("          navigation: {");
	            _html.AppendLine("              arrowSize: 12,");
	            _html.AppendLine("              style: {");
	            _html.AppendLine("                  fontSize: '14px',");
	            _html.AppendLine("                  fontFamily: 'Corbel, Tahoma, Verdana, Arial, sans-serif',");
	            _html.AppendLine("                  fontWeight: 'bold',");
	            _html.AppendLine("                  color: '#000000'");
	            _html.AppendLine("              }");
	            _html.AppendLine("          },");
                _html.AppendLine("          useHTML: true");
                _html.AppendLine("      },");
                _html.AppendLine("      series: [");

                for (_i = 0; _i < _level1SeriesName.Count; _i++)
                {
                    _html.AppendLine("      {");
                    _html.AppendFormat("        name: '{0}',", _level1SeriesName[_i]);
                    _html.AppendFormat("        color: '{0}',", _level1SeriesColor[_i]);
                    _html.AppendFormat("        colorByPoint: false,");
                    _html.AppendLine("          data: [");

                    _seriesNameTemp = (List<object>)_level1SeriesDataName[_i];
                    _seriesColorTemp = (List<object>)_level1SeriesDataColor[_i];
                    _seriesValueTemp = (List<object>)_level1SeriesDataValue[_i];
                    _seriesDrillDownTemp = (List<object>)_level1SeriesDataDrillDown[_i];
                        
                    for (_j = 0; _j < _seriesNameTemp.Count; _j++)
                    {
                        _html.AppendLine("          {");
                        _html.AppendFormat("            name: '<div style=\"height:16px;font-family:Corbel, Tahoma, Verdana, Arial, sans-serif\">{0}</div>',", _seriesNameTemp[_j]);
                        _html.AppendFormat("            color: '{0}',", _seriesColorTemp[_j]);
                        _html.AppendFormat("            y: {0},", _seriesValueTemp[_j]);

                        if (!String.IsNullOrEmpty(_seriesDrillDownTemp[_j].ToString()))
                            _html.AppendFormat("        drilldown: '{0}'", _seriesDrillDownTemp[_j]);

                        _html.AppendLine("          },");
                    }

                    _html.AppendLine("          ]");
                    _html.AppendLine("      },");
                }

                _html.AppendLine("      ],");
                _html.AppendLine("      drilldown: {");
                _html.AppendLine("          drillUpButton: {");
                _html.AppendLine("              relativeTo: 'spacingBox',");
                _html.AppendLine("              position: {");
                _html.AppendLine("                  x: -32,");
                _html.AppendFormat("                y: {0},", (!String.IsNullOrEmpty(_title) ? 28 : 0));
                _html.AppendLine("              },");
                _html.AppendLine("              theme: {");
                _html.AppendLine("                  fill: null,");
                _html.AppendLine("                  'stroke-width': null,");
                _html.AppendLine("                  r: 0,");
                _html.AppendLine("                  states: {");
                _html.AppendLine("                      hover: {");
                _html.AppendLine("                          fill: null,");
                _html.AppendLine("                      }");
                _html.AppendLine("                  },");
                _html.AppendLine("                  style: {");
                _html.AppendLine("                      color: '#000000',");
                _html.AppendLine("                      fontSize: '14px',");
                _html.AppendLine("                      fontFamily: 'Corbel, Tahoma, Verdana, Arial, sans-serif',");
                _html.AppendLine("                      cursor: 'pointer'");
                _html.AppendLine("                  }");
                _html.AppendLine("              }");
                _html.AppendLine("          },");

                if (_level2SeriesId.Count > 0)
                {
                    _html.AppendLine("      series: [");

                    for (_i = 0; _i < _level2SeriesId.Count; _i++)
                    {
                        _html.AppendLine("      {");
                        _html.AppendFormat("        id: '{0}',", _level2SeriesId[_i]);
	                    _html.AppendFormat("        name: '{0}',", _level2SeriesName[_i]);
	                    _html.AppendLine("          data: [");

                        _seriesNameTemp = (List<object>)_level2SeriesDataName[_i];
                        _seriesColorTemp = (List<object>)_level2SeriesDataColor[_i];
                        _seriesValueTemp = (List<object>)_level2SeriesDataValue[_i];
                        _seriesDrillDownTemp = (List<object>)_level2SeriesDataDrillDown[_i];
                        
                        for (_j = 0; _j < _seriesNameTemp.Count; _j++)
                        {
                            _html.AppendLine("          {");
                            _html.AppendFormat("            name: '<div style=\"height:16px;font-family:Corbel, Tahoma, Verdana, Arial, sans-serif\">{0}</div>',", _seriesNameTemp[_j]);

                            if (_level2SeriesColorByPoint.Equals(false))
                                _html.AppendFormat("        color: '{0}',", _seriesColorTemp[_j]);

                            _html.AppendFormat("            y: {0},", _seriesValueTemp[_j]);

                            if (!String.IsNullOrEmpty(_seriesDrillDownTemp[_j].ToString()))
                                _html.AppendFormat("        drilldown: '{0}'", _seriesDrillDownTemp[_j]);

                            _html.AppendLine("          },");
                        }
                        
                        _html.AppendLine("          ]");
                        _html.AppendLine("      },");
                    }
                    
                    if (_level3SeriesId.Count > 0)
                    {
                        for (_i = 0; _i < _level3SeriesId.Count; _i++)
                        {
                            _html.AppendLine("  {");
                            _html.AppendFormat("    id: '{0}',", _level3SeriesId[_i]);   
	                        _html.AppendFormat("    name: '{0}',", _level3SeriesName[_i]);
	                        _html.AppendLine("      data: [");

                            _seriesNameTemp = (List<object>)_level3SeriesDataName[_i];
                            _seriesColorTemp = (List<object>)_level3SeriesDataColor[_i];
                            _seriesValueTemp = (List<object>)_level3SeriesDataValue[_i];
                            _seriesDrillDownTemp = (List<object>)_level3SeriesDataDrillDown[_i];
                        
                            for (_j = 0; _j < _seriesNameTemp.Count; _j++)
                            {
                                _html.AppendLine("      {");
                                _html.AppendFormat("        name: '<div style=\"height:16px;font-family:Corbel, Tahoma, Verdana, Arial, sans-serif\">{0}</div>',", _seriesNameTemp[_j]);

                                if (_level3SeriesColorByPoint.Equals(false))
                                    _html.AppendFormat("    color: '{0}',", _seriesColorTemp[_j]);

                                _html.AppendFormat("        y: {0},", _seriesValueTemp[_j]);

                                if (!String.IsNullOrEmpty(_seriesDrillDownTemp[_j].ToString()))
                                    _html.AppendFormat("    drilldown: '{0}'", _seriesDrillDownTemp[_j]);

                                _html.AppendLine("      },");
                            }
                        
                            _html.AppendLine("      ]");
                            _html.AppendLine("  },");
                        }
                        
                        if (_level4SeriesId.Count > 0)
                        {
                            for (_i = 0; _i < _level4SeriesId.Count; _i++)
                            {
                                _html.AppendLine("{");
                                _html.AppendFormat("id: '{0}',", _level4SeriesId[_i]);   
	                            _html.AppendFormat("name: '{0}',", _level4SeriesName[_i]);
                                
	                            _html.AppendLine("  data: [");

                                _seriesNameTemp = (List<object>)_level4SeriesDataName[_i];
                                _seriesColorTemp = (List<object>)_level4SeriesDataColor[_i];
                                _seriesValueTemp = (List<object>)_level4SeriesDataValue[_i];
                                _seriesDrillDownTemp = (List<object>)_level4SeriesDataDrillDown[_i];
                        
                                for (_j = 0; _j < _seriesNameTemp.Count; _j++)
                                {
                                    _html.AppendLine("  {");
                                    _html.AppendFormat("    name: '<div style=\"height:16px;font-family:Corbel, Tahoma, Verdana, Arial, sans-serif\">{0}</div>',", _seriesNameTemp[_j].ToString());
                                    if (_level4SeriesColorByPoint.Equals(false)) _html.AppendFormat("color: '{0}',", _seriesColorTemp[_j]);
                                    _html.AppendFormat("    y: {0},", _seriesValueTemp[_j]);
                                    if (!String.IsNullOrEmpty(_seriesDrillDownTemp[_j].ToString())) _html.AppendFormat("drilldown: '{0}'", _seriesDrillDownTemp[_j]);
                                    _html.AppendLine("  },");
                                }
                        
                                _html.AppendLine("  ]");
                                _html.AppendLine("},");
                            }
                        }
                    }

                    _html.AppendLine("      ]");
                }
                
                _html.AppendLine("      },");
                _html.AppendLine("      exporting: {");
                _html.AppendLine("          filename: 'ExportChart'");
                _html.AppendLine("      },");
                
                if (_type.Equals("pie")) 
                    _html.AppendLine(GetPieChart().ToString());

                if (_type.Equals("column"))
                    _html.AppendLine(GetColumnChart().ToString());

                if (_type.Equals("bar"))
                    _html.AppendLine(GetBarChart().ToString());
                
                _html.AppendLine("  });");
                _html.AppendLine("</script>");
                _html.AppendFormat("<div class='chart-container' id='{0}'></div>", _renderTo);

                return _html;
            }
            
            private static StringBuilder GetPieChart()
            {
                StringBuilder _html = new StringBuilder();

                _html.AppendLine("tooltip: {");
                _html.AppendLine("  headerFormat: '<span>{point.key}</span><br />',");
                _html.AppendLine("  pointFormat: '<b>{point.y:,.0f} : {point.percentage:.1f} %</b>',");
                _html.AppendLine("  shadow: false,");
                _html.AppendLine("  style: {");
                _html.AppendLine("      fontSize: '14px',");
                _html.AppendLine("      fontFamily: 'Corbel, Tahoma, Verdana, Arial, sans-serif',");
                _html.AppendLine("      fontWeight: 'bold',");
                _html.AppendLine("      color: '#000000'");
                _html.AppendLine("  }");
                _html.AppendLine("},");
                _html.AppendLine("plotOptions: {");
                _html.AppendLine("  pie: {");
                _html.AppendLine("      allowPointSelect: true,");
                _html.AppendLine("      cursor: 'pointer',");
                _html.AppendLine("      dataLabels: {");
                _html.AppendLine("          enabled: true,");
                _html.AppendLine("          format: '<b>{point.y:,.0f} : {point.percentage:.1f} %</b>',");
                _html.AppendLine("          style: {");
                _html.AppendLine("              color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black',");
                _html.AppendLine("              fontSize: '10px',");
                _html.AppendLine("              fontFamily: 'Tahoma, Verdana, Arial, sans-serif'");
                _html.AppendLine("          }");
                _html.AppendLine("      },");
                _html.AppendLine("      showInLegend: true");
                _html.AppendLine("  }");
                _html.AppendLine("},");

                return _html;
            }
            
            public static StringBuilder GetColumnChart()
            {
                StringBuilder _html = new StringBuilder();
                int _i = 0;

                _html.AppendLine("tooltip: {");
		        _html.AppendLine("  headerFormat: '<span style=\"color:#000000;font-family:Corbel, Tahoma, Verdana, Arial, sans-serif;font-weight:bold;font-size:14px;\">{point.key}</span><table>',");
		        _html.AppendLine("  pointFormat: '<tr style=\"font-family:Corbel, Tahoma, Verdana, Arial, sans-serif;font-weight:bold;font-size:14px;\">' +");
                _html.AppendLine("               '  <td style=\"color:#000000;padding-left:10px;\">{series.name}</td>' +");
                _html.AppendLine("               '  <td style=\"width:10px;\"></td>' +");
                _html.AppendLine("               '  <td style=\"text-align:right;\"><b>{point.y:,.0f}</b></td>' +");
                _html.AppendLine("               '</tr>',");
		        _html.AppendLine("  footerFormat: '</table>',");
                _html.AppendLine("  crosshairs: true,");
                _html.AppendLine("  shadow: false,");
		        _html.AppendLine("  shared: true,");
		        _html.AppendLine("  useHTML: true");
		        _html.AppendLine("},");
                _html.AppendLine("xAxis: {");
                _html.AppendLine("  title: {");
                _html.AppendLine("      margin: 10,");
                _html.AppendLine("      style: {");
                _html.AppendLine("          fontSize: '13px',");
                _html.AppendLine("          fontFamily: 'Corbel, Tahoma, Verdana, Arial, sans-serif',");
                _html.AppendLine("          fontWeight: 'bold',");
                _html.AppendLine("          lineHeight: '20px'");
                _html.AppendLine("      },");
                _html.AppendLine("      x: -38");
                _html.AppendLine("  },");
                _html.AppendLine("  type: 'category',");
                _html.AppendLine("  labels: {");
                _html.AppendLine("      autoRotation: [-90],");
                //_html.AppendLine("      autoRotationLimit: 40,");
                _html.AppendLine("      style: {");
                _html.AppendLine("          fontSize: '13px',");
                _html.AppendLine("          fontFamily: 'Corbel, Tahoma, Verdana, Arial, sans-serif',");
                _html.AppendLine("          fontWeight: 'bold',");
                _html.AppendLine("          color: '#000000'");
                _html.AppendLine("      },");
                _html.AppendLine("      overflow: 'justify'");
                _html.AppendLine("  }");
                _html.AppendLine("},");
		        _html.AppendLine("yAxis: {");
		        _html.AppendLine("  title: {");
		        _html.AppendFormat("    text: '{0}',", _level1YAxisTitle);
		        _html.AppendLine("      margin: 18,");
		        _html.AppendLine("      style: {");
		        _html.AppendLine("          fontSize: '13px',");
		        _html.AppendLine("          fontFamily: 'Corbel, Tahoma, Verdana, Arial, sans-serif',");
		        _html.AppendLine("          fontWeight: 'bold',");
                _html.AppendLine("          lineHeight: '20px'");
		        _html.AppendLine("      },");
                _html.AppendLine("      x: -22");
		        _html.AppendLine("  },");
		        _html.AppendLine("  min: 0,");
		        _html.AppendLine("  labels: {");
                _html.AppendLine("      formatter: function () { return Highcharts.numberFormat(this.value, 0); },");
		        _html.AppendLine("      style: {");
		        _html.AppendLine("          fontSize: '14px',");
		        _html.AppendLine("          fontFamily: 'Corbel, Tahoma, Verdana, Arial, sans-serif',");
		        _html.AppendLine("          fontWeight: 'bold',");
		        _html.AppendLine("          color: '#000000'");
		        _html.AppendLine("      }");
		        _html.AppendLine("  }");
                _html.AppendLine("},");
		        _html.AppendLine("plotOptions: {");
		        _html.AppendLine("  series: {");
		        _html.AppendLine("      dataLabels: {");
		        _html.AppendLine("          enabled: true,");
                _html.AppendLine("          align: 'center',");
		        _html.AppendLine("          format: '{point.y:,.0f}',");
		        _html.AppendLine("          style: {");
		        _html.AppendLine("              fontSize: '10px',");
                _html.AppendLine("              fontFamily: 'Tahoma, Verdana, Arial, sans-serif',");
		        _html.AppendLine("              fontWeight: 'bold',");
		        _html.AppendLine("              color: '#000000',");
                _html.AppendLine("              textShadow: 0,");
                _html.AppendLine("          }");
		        _html.AppendLine("      },");
                _html.AppendLine("      groupPadding: 0,");
                _html.AppendLine("      borderWidth: 0,");
                _html.AppendLine("  }");
		        _html.AppendLine("},");

                return _html;
            }

            public static StringBuilder GetBarChart()
            {
                StringBuilder _html = new StringBuilder();
                int _i = 0;

                _html.AppendLine("tooltip: {");
		        _html.AppendLine("  headerFormat: '<span style=\"color:#000000;font-family:Corbel, Tahoma, Verdana, Arial, sans-serif;font-weight:bold;font-size:14px;\">{point.key}</span><table>',");
		        _html.AppendLine("  pointFormat: '<tr style=\"font-family:Corbel, Tahoma, Verdana, Arial, sans-serif;font-weight:bold;font-size:14px;\">' +");
                _html.AppendLine("               '  <td style=\"color:#000000;padding-left:10px;\">{series.name}</td>' +");
                _html.AppendLine("               '  <td style=\"width:10px;\"></td>' +");
                _html.AppendLine("               '  <td style=\"text-align:right;\"><b>{point.y:,.0f}</b></td>' +");
                _html.AppendLine("               '</tr>',");
		        _html.AppendLine("  footerFormat: '</table>',");
                _html.AppendLine("  crosshairs: true,");
                _html.AppendLine("  shadow: false,");
		        _html.AppendLine("  shared: true,");
		        _html.AppendLine("  useHTML: true");
		        _html.AppendLine("},");
                _html.AppendLine("xAxis: {");
                _html.AppendLine("  title: {");
                _html.AppendFormat("    text: '{0}',", _level1XAxisTitle);
                _html.AppendLine("      margin: 20,");
                _html.AppendLine("      style: {");
                _html.AppendLine("          fontSize: '13px',");
                _html.AppendLine("          fontFamily: 'Corbel, Tahoma, Verdana, Arial, sans-serif',");
                _html.AppendLine("          fontWeight: 'bold'");
                _html.AppendLine("      }");
                _html.AppendLine("  },");
                _html.AppendLine("  type: 'category',");
                _html.AppendLine("  labels: {");
                _html.AppendLine("      autoRotation: [-90],");
                _html.AppendLine("      style: {");
                _html.AppendLine("          fontSize: '13px',");
                _html.AppendLine("          fontFamily: 'Corbel, Tahoma, Verdana, Arial, sans-serif',");
                _html.AppendLine("          fontWeight: 'bold',");                
                _html.AppendLine("          color: '#000000'");
                _html.AppendLine("      },");
                _html.AppendLine("      overflow: 'justify'");
                _html.AppendLine("  }");
                _html.AppendLine("},");
		        _html.AppendLine("yAxis: {");
		        _html.AppendLine("  title: {");
		        _html.AppendFormat("    text: '{0}',", _level1YAxisTitle);
		        _html.AppendLine("      margin: 18,");
		        _html.AppendLine("      style: {");
		        _html.AppendLine("          fontSize: '13px',");
		        _html.AppendLine("          fontFamily: 'Corbel, Tahoma, Verdana, Arial, sans-serif',");
		        _html.AppendLine("          fontWeight: 'bold',");
                _html.AppendLine("          lineHeight: '20px'");
		        _html.AppendLine("      },");
                _html.AppendLine("      x: -22");
		        _html.AppendLine("  },");
		        _html.AppendLine("  min: 0,");
		        _html.AppendLine("  labels: {");
                _html.AppendLine("      formatter: function () { return Highcharts.numberFormat(this.value, 0); },");
		        _html.AppendLine("      style: {");
		        _html.AppendLine("          fontSize: '14px',");
		        _html.AppendLine("          fontFamily: 'Corbel, Tahoma, Verdana, Arial, sans-serif',");
		        _html.AppendLine("          fontWeight: 'bold',");
		        _html.AppendLine("          color: '#000000'");
		        _html.AppendLine("      }");
		        _html.AppendLine("  }");
                _html.AppendLine("},");
		        _html.AppendLine("plotOptions: {");
		        _html.AppendLine("  series: {");
		        _html.AppendLine("      dataLabels: {");
		        _html.AppendLine("          enabled: true,");
                _html.AppendLine("          align: 'right',");
		        _html.AppendLine("          format: '{point.y:,.0f}',");
		        _html.AppendLine("          style: {");
		        _html.AppendLine("              fontSize: '10px',");
                _html.AppendLine("              fontFamily: 'Tahoma, Verdana, Arial, sans-serif',");
		        _html.AppendLine("              fontWeight: 'bold',");
		        _html.AppendLine("              color: '#000000',");
                _html.AppendLine("              textShadow: 0,");
                _html.AppendLine("          }");
		        _html.AppendLine("      },");
                _html.AppendLine("      groupPadding: 0,");
                _html.AppendLine("      borderWidth: 0");
		        _html.AppendLine("  }");
		        _html.AppendLine("},");

                return _html;
            }
        }
    }
}