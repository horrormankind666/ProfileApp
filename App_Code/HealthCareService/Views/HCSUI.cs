/*
=============================================
Author      : <ยุทธภูมิ ตวันนา>
Create date : <๒๖/๑๒/๒๕๕๙>
Modify date : <๑๓/๐๒/๒๕๖๓>
Description : <คลาสใช้งานเกี่ยวกับการใช้งานฟังก์ชั่นทั่วไป>
=============================================
*/

using System;
using System.Collections.Generic;
using System.Text;
using NUtil;

public class HCSUI
{
    public static StringBuilder GetFrmColumn(Dictionary<string, object> _contentFrmColumn)
    {
        StringBuilder _html = new StringBuilder();
        string _id = _contentFrmColumn["ID"].ToString();
        bool _highlight = (bool)_contentFrmColumn["HighLight"];
        string _titleTH = _contentFrmColumn["TitleTH"].ToString();
        string _fontSizeTitleTH = _contentFrmColumn["FontSizeTitleTH"].ToString();
        string _titleEN = _contentFrmColumn["TitleEN"].ToString();
        string _fontSizeTitleEN = _contentFrmColumn["FontSizeTitleEN"].ToString();
        string _discriptionTH = _contentFrmColumn["DiscriptionTH"].ToString();
        string _discriptionEN = _contentFrmColumn["DiscriptionEN"].ToString();
        bool _inputContentPaddingDown = (bool)_contentFrmColumn["InputContentPaddingDown"];
        string _inputContent = _contentFrmColumn["InputContent"].ToString();
        bool _require = (bool)_contentFrmColumn["Require"];
        bool _lastRow = (bool)_contentFrmColumn["LastRow"];
        int _i = 0;

        _html.AppendFormat("<div class='form-row {0} {1}' id='{2}-content'>", (_lastRow.Equals(true) ? "form-lastrow" : ""), (_highlight.Equals(true) ? "highlight-style3" : String.Empty), _id);
        _html.AppendLine("      <div class='form-col label-col'>");
        _html.AppendFormat("        <div class='lang lang-th font-family-th {0} black regular'>{1} {2}</div>", _fontSizeTitleTH, _titleTH, (_require.Equals(true) ? "<span class='glyphicon glyphicon-asterisk f11default red regular'></span>" : ""));
        _html.AppendFormat("        <div class='lang lang-en font-family-en {0} black regular'>{1} {2}</div>", _fontSizeTitleEN, _titleEN, (_require.Equals(true) ? "<span class='glyphicon glyphicon-asterisk f11default red regular'></span>" : ""));
        _html.AppendLine("      </div>");
        _html.AppendFormat("    <div class='form-col input-col {0}'>", (_inputContentPaddingDown.Equals(true) ? "form-inputcol-paddingbottom" : String.Empty));
        _html.AppendLine(           _inputContent);
        _html.AppendLine("          <div class='form-input-discription'>");
        _html.AppendFormat("            <div class='lang lang-th font-family-th f3 regular'>{0}</div>", _discriptionTH);
        _html.AppendFormat("            <div class='lang lang-en font-family-en f5 regular'>{0}</div>", _discriptionEN);
        _html.AppendLine("          </div>");
        _html.AppendLine("      </div>");
        _html.AppendLine("  </div>");

        return _html;
    } 
    
    public static StringBuilder GetTopMenuBar(Dictionary<string, object> _infoLogin, int _pageError, string _page)
    {
        StringBuilder _html = new StringBuilder();
        int _cookieError = int.Parse(_infoLogin["CookieError"].ToString());
        int _userError = int.Parse(_infoLogin["UserError"].ToString());
        string _studentCode = _infoLogin["StudentCode"].ToString();
        string _fullnameTH = _infoLogin["FullnameTH"].ToString();
        string _fullnameEN = _infoLogin["FullnameEN"].ToString();
        int _i = 0;
        int _j = 0;

        _html.AppendLine("<div>");

        if (_cookieError.Equals(0) /*&& _userError.Equals(0)*/)
        {            
            //if (_userError.Equals(0))
            //{
                _html.AppendLine("<div class='float-left'>");
                _html.AppendFormat("<div class='lang lang-th font-family-th black regular f10'>สวัสดี, {0} ( {1} )</div>", _fullnameTH, (!String.IsNullOrEmpty(_studentCode) ? _studentCode : "XXXXXXX"));
                _html.AppendFormat("<div class='lang lang-en font-family-en black regular f10'>Hi, {0} ( {1} )</div>", _fullnameEN, (!String.IsNullOrEmpty(_studentCode) ? _studentCode : "XXXXXXX"));
                _html.AppendLine("</div>");
            //}
        }

        _html.AppendFormat("<div class='float-right'>");
        _html.AppendFormat("    <div class='float-right'>{0}</div>", Util.GetComboboxLanguage(HCSUtil.ID_SECTION_MAIN.ToLower() + "-language"));
        _html.AppendFormat("    <div class='float-right'>");

        if (_cookieError.Equals(0) && _userError.Equals(0) && _pageError.Equals(0))
        {
            if (!_page.Equals(HCSUtil.PAGE_STUDENTRECORDSSTUDENTCV_MAIN))
            {
                _html.AppendFormat("<a class='lang lang-th font-family-th black regular f7default' href='javascript:void(0)' data-toggle='tooltip' data-placement='bottom' title='{0}' id='{1}-link-{2}'><span class='glyphicon glyphicon-user'></span></a>", HCSUtil._menu[0, 0], HCSUtil.ID_SECTION_MAIN.ToLower(), HCSUtil._menu[0, 2].ToLower());
                _html.AppendFormat("<a class='lang lang-en font-family-en black regular f7default' href='javascript:void(0)' data-toggle='tooltip' data-placement='bottom' title='{0}' id='{1}-link-{2}'><span class='glyphicon glyphicon-user'></span></a>", HCSUtil._menu[0, 1], HCSUtil.ID_SECTION_MAIN.ToLower(), HCSUtil._menu[0, 2].ToLower());
            }

            /*
            if (_page.Equals(HCSUtil.PAGE_DOWNLOADREGISTRATIONFORM_MAIN))
            {
                _html.AppendFormat("<a class='lang lang-th font-family-th black regular f7default' href='javascript:void(0)' data-toggle='tooltip' data-placement='bottom' title='{0}' id='{1}-link-{2}'><span class='glyphicon glyphicon-download-alt'></span></a>", HCSUtil._menu[1, 0], HCSUtil.ID_SECTION_MAIN.ToLower(), HCSUtil._menu[1, 2].ToLower());
                _html.AppendFormat("<a class='lang lang-en font-family-en black regular f7default' href='javascript:void(0)' data-toggle='tooltip' data-placement='bottom' title='{0}' id='{1}-link-{2}'><span class='glyphicon glyphicon-download-alt'></span></a>", HCSUtil._menu[1, 1], HCSUtil.ID_SECTION_MAIN.ToLower(), HCSUtil._menu[1, 2].ToLower());
            }
            */

            _html.AppendLine("      <span class='dropdown'>");
            _html.AppendFormat("        <a class='dropdown-toggle' href='javascript:void(0)' data-toggle='dropdown' aria-haspopup='true' aria-expanded='false' id='{0}-link-{1}'>", HCSUtil.ID_SECTION_MAIN.ToLower(), HCSUtil._menu[2, 2].ToLower());
            _html.AppendLine("              <div class='lang lang-th font-family-th black regular f7default'><span class='glyphicon glyphicon-exclamation-sign' ></span></div>");
            _html.AppendLine("              <div class='lang lang-en font-family-en black regular f7default'><span class='glyphicon glyphicon-exclamation-sign' ></span></div>");
            _html.AppendLine("          </a>");
            _html.AppendFormat("        <ul class='dropdown-menu pull-right' aria-labelledby='{0}-link-{1}'>", HCSUtil.ID_SECTION_MAIN.ToLower(), HCSUtil._menu[2, 2].ToLower());
            _html.AppendLine("              <li>");
            _html.AppendFormat("                <a href='javascript:void(0)' id='{0}-link-{1}'>", HCSUtil.ID_SECTION_MAIN.ToLower(), HCSUtil._submenu[0, 2].ToLower());
            _html.AppendFormat("                    <div class='lang lang-th font-family-th black regular f10'>{0}</div>", HCSUtil._submenu[0, 0]);
            _html.AppendFormat("                    <div class='lang lang-en font-family-en black regular f10'>{0}</div>", HCSUtil._submenu[0, 1]);
            _html.AppendLine("                  </a>");
            _html.AppendLine("              </li>");
            _html.AppendLine("              <li>");
            _html.AppendFormat("                <a href='javascript:void(0)' id='{0}-link-{1}'>", HCSUtil.ID_SECTION_MAIN.ToLower(), HCSUtil._submenu[1, 2].ToLower());
            _html.AppendFormat("                    <div class='lang lang-th font-family-th black regular f10'>{0}</div>", HCSUtil._submenu[1, 0]);
            _html.AppendFormat("                    <div class='lang lang-en font-family-en black regular f10'>{0}</div>", HCSUtil._submenu[1, 1]);
            _html.AppendLine("                  </a>");
            _html.AppendLine("              </li>");
            _html.AppendLine("          </ul>");
            _html.AppendLine("      </span>");
        }
        _html.AppendLine("      </div>");
        _html.AppendLine("  </div>");
        _html.AppendLine("</div>");
        _html.AppendLine("<div class='clear'></div>");
        
        return _html;
    }
}