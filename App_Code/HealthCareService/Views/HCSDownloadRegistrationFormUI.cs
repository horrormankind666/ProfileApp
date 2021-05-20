/*
=============================================
Author      : <ยุทธภูมิ ตวันนา>
Create date : <๒๘/๑๒/๒๕๕๙>
Modify date : <๓๐/๐๔/๒๕๖๓>
Description : <คลาสใช้งานเกี่ยวกับการใช้งานแสดงผลในส่วนของการดาว์นโหลดแบบฟอร์มประกันสุขภาพของนักศึกษา>
=============================================
*/

using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using NUtil;

public class HCSDownloadRegistrationFormUI
{    
    public static StringBuilder GetSection(Dictionary<string, object> _infoLogin, string _section, string _sectionAction, string _id)
    {
        StringBuilder _html = new StringBuilder();
        StringBuilder _content = new StringBuilder();

        int _userError = int.Parse(_infoLogin["UserError"].ToString());

        switch (_section)
        {
            case "MAIN":
                Dictionary<string, object> _termServiceHCSConsentRegistrationResult = HCSUtil.GetTermServiceHCSConsentRegistration(_infoLogin["StudentId"].ToString());

                if (!String.IsNullOrEmpty(_termServiceHCSConsentRegistrationResult["TermServiceStatusHCSConsentRegistration"].ToString()))
                {
                    _content.AppendFormat(
                        "<center>" +
                        "   <span class='f8'>นักศึกษาเคยแสดงความประสงค์ว่า</span><br />" +
                        "   <span class='f7 bold underline'>\"{0}\"</span><br />" +
                        "   <span class='f9'>ให้มหาวิทยาลัยมหิดลขึ้นทะเบียนสิทธิหลักประกันสุขภาพแห่งชาติ<br />กับโรงพยาบาลสังกัดมหาวิทยาลัยมหิดลไว้แล้ว</span>" +
                        "</center>" +
                        "<p class='br'></p>" +
                        "<div class='red'>" +
                        "   <span class='bold'>หมายเหตุ</span><br />กรณีที่นักศึกษามีข้อสงสัย หรือต้องการเปลี่ยนแปลงความประสงค์สามารถติดต่อสอบถามได้ที่ กองกิจการนักศึกษา โทร. 0 2849 4514 ในวันและเวลาราชการ หรือติดต่อได้ที่ Inbox ของ FB Fanpage : @MahidolHealth" +
                        "</div>", (_termServiceHCSConsentRegistrationResult["TermServiceStatusHCSConsentRegistration"].Equals("Y") ? "ยินยอม" : "ไม่ยินยอม")
                    );

                    _html.AppendFormat("<div class='view usererror{0}' id='{1}-panel'>", _userError, HCSUtil.ID_SECTION_TERMSERVICEHCSCONSENTREGISTRATION_INFO.ToLower());
                    _html.AppendLine("      <div class='panel panel-info'>");
                    _html.AppendLine("          <div class='panel-body'>");
                    _html.AppendFormat("            <div class='lang lang-th lang-en font-family-th regular {0}'>{1}</div>", "f10", _content);
                    _html.AppendLine("          </div>");
                    _html.AppendLine("      </div>");
                    _html.AppendLine("  </div>");
                }

                if (_userError.Equals(0))
                    _html.AppendFormat("{0}", SectionMainUI.GetMain(_id, _termServiceHCSConsentRegistrationResult));

                break;
            case "DIALOG": 
                if (_sectionAction.Equals(HCSUtil.SUBJECT_SECTION_DOWNLOADREGISTRATIONFORMSELECTWELFARE))
                    _html = SectionDialogUI.SelectWelfareUI.GetMain();

                break;
        }

        return _html;
    }

    public class SectionMainUI
    {
        private static string _idSectionMain = HCSUtil.ID_SECTION_DOWNLOADREGISTRATIONFORM_MAIN.ToLower();

        public static StringBuilder GetValueDataRecorded(Dictionary<string, object> _valueDataRecorded)
        {
            StringBuilder _html = new StringBuilder();
            Dictionary<string, object> _dataRecorded = (_valueDataRecorded != null ? (Dictionary<string, object>)_valueDataRecorded["DataRecorded" + HCSUtil.SUBJECT_SECTION_DOWNLOADREGISTRATIONFORMSTUDENTRECORDS] : null);

            _html.AppendFormat("<input type='hidden' id='{0}-studentcode-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentCode", _dataRecorded["StudentCode"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentpicture-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentPicture", _dataRecorded["StudentPicture"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-hospital-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "Hospital", _dataRecorded["Hospital"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-workedstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "WorkedStatus", _dataRecorded["WorkedStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-workedstatusnameth-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "WorkedStatusNameTH", _dataRecorded["WorkedStatusNameTH"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-workedstatusnameen-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "WorkedStatusNameEN", _dataRecorded["WorkedStatusNameEN"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordspersonalstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsPersonalStatus", _dataRecorded["StudentRecordsPersonalStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordsaddresspermanentstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsAddressPermanentStatus", _dataRecorded["StudentRecordsAddressPermanentStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordsaddresscurrentstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsAddressCurrentStatus", _dataRecorded["StudentRecordsAddressCurrentStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordseducationprimaryschoolstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsEducationPrimarySchoolStatus", _dataRecorded["StudentRecordsEducationPrimarySchoolStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordseducationjuniorhighschoolstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsEducationJuniorHighSchoolStatus", _dataRecorded["StudentRecordsEducationJuniorHighSchoolStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordseducationhighschoolstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsEducationHighSchoolStatus", _dataRecorded["StudentRecordsEducationHighSchoolStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordseducationuniversitystatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsEducationUniversityStatus", _dataRecorded["StudentRecordsEducationUniversityStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordseducationadmissionscoresstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsEducationAdmissionScoresStatus", _dataRecorded["StudentRecordsEducationAdmissionScoresStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordstalentstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsTalentStatus", _dataRecorded["StudentRecordsTalentStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordshealthystatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsHealthyStatus", _dataRecorded["StudentRecordsHealthyStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordsworkstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsWorkStatus", _dataRecorded["StudentRecordsWorkStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordsfinancialstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsFinancialStatus", _dataRecorded["StudentRecordsFinancialStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordsfamilyfatherpersonalstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsFamilyFatherPersonalStatus", _dataRecorded["StudentRecordsFamilyFatherPersonalStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordsfamilymotherpersonalstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsFamilyMotherPersonalStatus", _dataRecorded["StudentRecordsFamilyMotherPersonalStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordsfamilyparentpersonalstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsFamilyParentPersonalStatus", _dataRecorded["StudentRecordsFamilyParentPersonalStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordsfamilyfatheraddresspermanentstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsFamilyFatherAddressPermanentStatus", _dataRecorded["StudentRecordsFamilyFatherAddressPermanentStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordsfamilymotheraddresspermanentstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsFamilyMotherAddressPermanentStatus", _dataRecorded["StudentRecordsFamilyMotherAddressPermanentStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordsfamilyparentaddresspermanentstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsFamilyParentAddressPermanentStatus", _dataRecorded["StudentRecordsFamilyParentAddressPermanentStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordsfamilyfatheraddresscurrentstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsFamilyFatherAddressCurrentStatus", _dataRecorded["StudentRecordsFamilyFatherAddressCurrentStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordsfamilymotheraddresscurrentstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsFamilyMotherAddressCurrentStatus", _dataRecorded["StudentRecordsFamilyMotherAddressCurrentStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordsfamilyparentaddresscurrentstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsFamilyParentAddressCurrentStatus", _dataRecorded["StudentRecordsFamilyParentAddressCurrentStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordsfamilyfatherworkstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsFamilyFatherWorkStatus", _dataRecorded["StudentRecordsFamilyFatherWorkStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordsfamilymotherworkstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsFamilyMotherWorkStatus", _dataRecorded["StudentRecordsFamilyMotherWorkStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-studentrecordsfamilyparentworkstatus-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "StudentRecordsFamilyParentWorkStatus", _dataRecorded["StudentRecordsFamilyParentWorkStatus"], Util._valueTextDefault) : Util._valueTextDefault));
            _html.AppendFormat("<input type='hidden' id='{0}-welfare-hidden' value='{1}' />", _idSectionMain, (_dataRecorded != null ? Util.GetValueDataDictionary(_dataRecorded, "Welfare", _dataRecorded["Welfare"], Util._valueTextDefault) : Util._valueTextDefault));

            return _html;
        }
        
        public static StringBuilder GetMain(string _id, Dictionary<string, object> _termService)
        {
            StringBuilder _html = new StringBuilder();
            StringBuilder _contentTemp = new StringBuilder();
            Dictionary<string, Dictionary<string, object>> _contentFrmColumn = new Dictionary<string, Dictionary<string, object>>();
            Dictionary<string, object>[] _contentFrmColumnDetail = new Dictionary<string, object>[5];
            Dictionary<string, object> _valueDataRecorded = HCSUtil.SetValueDataRecorded(HCSUtil.PAGE_DOWNLOADREGISTRATIONFORMSTUDENTRECORDS_MAIN, _id);
            Dictionary<string, object> _dataRecorded = (Dictionary<string, object>)_valueDataRecorded["DataRecorded" + HCSUtil.SUBJECT_SECTION_DOWNLOADREGISTRATIONFORMSTUDENTRECORDS];            
            string _fontTHSize = "f9";
            string _fontENSize = "f9";
            int _i = 0;
            
            _contentTemp.Clear();
            _contentTemp.AppendFormat("<div class='lang lang-th font-family-th blue regular {0}'>{1}</div>", _fontTHSize, _dataRecorded["StudentCode"]);
            _contentTemp.AppendFormat("<div class='lang lang-en font-family-en blue regular {0}'>{1}</div>", _fontENSize, _dataRecorded["StudentCode"]);

            _contentFrmColumnDetail[_i] = new Dictionary<string, object>();
            _contentFrmColumnDetail[_i].Add("ID", (_idSectionMain + "-studentid"));
            _contentFrmColumnDetail[_i].Add("HighLight", false);
            _contentFrmColumnDetail[_i].Add("TitleTH", "รหัสนักศึกษา");
            _contentFrmColumnDetail[_i].Add("FontSizeTitleTH", _fontTHSize);
            _contentFrmColumnDetail[_i].Add("TitleEN", "Student ID");
            _contentFrmColumnDetail[_i].Add("FontSizeTitleEN", _fontENSize);
            _contentFrmColumnDetail[_i].Add("DiscriptionTH", String.Empty);
            _contentFrmColumnDetail[_i].Add("DiscriptionEN", String.Empty);
            _contentFrmColumnDetail[_i].Add("InputContentPaddingDown", false);
            _contentFrmColumnDetail[_i].Add("InputContent", _contentTemp.ToString());
            _contentFrmColumnDetail[_i].Add("Require", false);
            _contentFrmColumnDetail[_i].Add("LastRow", false);
            _contentFrmColumn.Add("StudentID", _contentFrmColumnDetail[_i]);
            _i++;

            _contentTemp.Clear();
            _contentTemp.AppendFormat("<div class='lang lang-th font-family-th blue regular {0}'>{1}</div>", _fontTHSize, Util.GetFullName(_dataRecorded["TitleInitialsTH"].ToString(), _dataRecorded["TitleFullNameTH"].ToString(), _dataRecorded["FirstName"].ToString(), _dataRecorded["MiddleName"].ToString(), _dataRecorded["LastName"].ToString()));
            _contentTemp.AppendFormat("<div class='lang lang-en font-family-en blue regular {0}'>{1}</div>", _fontENSize, Util.GetFullName(_dataRecorded["TitleInitialsEN"].ToString(), _dataRecorded["TitleFullNameEN"].ToString(), _dataRecorded["FirstNameEN"].ToString(), _dataRecorded["MiddleNameEN"].ToString(), _dataRecorded["LastNameEN"].ToString()).ToUpper());

            _contentFrmColumnDetail[_i] = new Dictionary<string, object>();
            _contentFrmColumnDetail[_i].Add("ID", (_idSectionMain + "-studentname"));
            _contentFrmColumnDetail[_i].Add("HighLight", false);
            _contentFrmColumnDetail[_i].Add("TitleTH", "ชื่อ - นามสกุล");
            _contentFrmColumnDetail[_i].Add("FontSizeTitleTH", _fontTHSize);
            _contentFrmColumnDetail[_i].Add("TitleEN", "Full Name");
            _contentFrmColumnDetail[_i].Add("FontSizeTitleEN", _fontENSize);
            _contentFrmColumnDetail[_i].Add("DiscriptionTH", String.Empty);
            _contentFrmColumnDetail[_i].Add("DiscriptionEN", String.Empty);
            _contentFrmColumnDetail[_i].Add("InputContentPaddingDown", false);
            _contentFrmColumnDetail[_i].Add("InputContent", _contentTemp.ToString());
            _contentFrmColumnDetail[_i].Add("Require", false);
            _contentFrmColumnDetail[_i].Add("LastRow", false);
            _contentFrmColumn.Add("FullName", _contentFrmColumnDetail[_i]);
            _i++;

            _contentTemp.Clear();            
            _contentTemp.AppendFormat("<div class='lang lang-th font-family-th blue regular {0}'>{1}</div>", _fontTHSize, _dataRecorded["FacultyNameTH"]);
            _contentTemp.AppendFormat("<div class='lang lang-en font-family-en blue regular {0}'>{1}</div>", _fontENSize, Util.UppercaseFirst(_dataRecorded["FacultyNameEN"].ToString()));

            _contentFrmColumnDetail[_i] = new Dictionary<string, object>();
            _contentFrmColumnDetail[_i].Add("ID", (_idSectionMain + "-faculty"));
            _contentFrmColumnDetail[_i].Add("HighLight", false);
            _contentFrmColumnDetail[_i].Add("TitleTH", "คณะ");
            _contentFrmColumnDetail[_i].Add("FontSizeTitleTH", _fontTHSize);
            _contentFrmColumnDetail[_i].Add("TitleEN", "Faculty");
            _contentFrmColumnDetail[_i].Add("FontSizeTitleEN", _fontENSize);
            _contentFrmColumnDetail[_i].Add("DiscriptionTH", String.Empty);
            _contentFrmColumnDetail[_i].Add("DiscriptionEN", String.Empty);
            _contentFrmColumnDetail[_i].Add("InputContentPaddingDown", false);
            _contentFrmColumnDetail[_i].Add("InputContent", _contentTemp.ToString());
            _contentFrmColumnDetail[_i].Add("Require", false);
            _contentFrmColumnDetail[_i].Add("LastRow", false);
            _contentFrmColumn.Add("Faculty", _contentFrmColumnDetail[_i]);
            _i++;

            _contentTemp.Clear();
            _contentTemp.AppendFormat("<div class='lang lang-th font-family-th blue regular {0}'>{1}</div>", _fontTHSize, _dataRecorded["ProgramNameTH"]);
            _contentTemp.AppendFormat("<div class='lang lang-en font-family-en blue regular {0}'>{1}</div>", _fontENSize, Util.UppercaseFirst(_dataRecorded["ProgramNameEN"].ToString()));

            _contentFrmColumnDetail[_i] = new Dictionary<string, object>();
            _contentFrmColumnDetail[_i].Add("ID", (_idSectionMain + "-program"));
            _contentFrmColumnDetail[_i].Add("HighLight", false);
            _contentFrmColumnDetail[_i].Add("TitleTH", "หลักสูตร");
            _contentFrmColumnDetail[_i].Add("FontSizeTitleTH", _fontTHSize);
            _contentFrmColumnDetail[_i].Add("TitleEN", "Program");
            _contentFrmColumnDetail[_i].Add("FontSizeTitleEN", _fontENSize);
            _contentFrmColumnDetail[_i].Add("DiscriptionTH", String.Empty);
            _contentFrmColumnDetail[_i].Add("DiscriptionEN", String.Empty);
            _contentFrmColumnDetail[_i].Add("InputContentPaddingDown", false);
            _contentFrmColumnDetail[_i].Add("InputContent", _contentTemp.ToString());
            _contentFrmColumnDetail[_i].Add("Require", false);
            _contentFrmColumnDetail[_i].Add("LastRow", false);
            _contentFrmColumn.Add("Program", _contentFrmColumnDetail[_i]);
            _i++;
            /*
            _contentTemp.Clear();
            _contentTemp.AppendFormat("<div class='lang lang-th font-family-th blue regular {0}'>{1}</div>", _fontTHSize, _dataRecorded["HospitalNameTH"]);
            _contentTemp.AppendFormat("<div class='lang lang-en font-family-en blue regular {0}'>{1}</div>", _fontENSize, Util.UppercaseFirst(_dataRecorded["HospitalNameEN"].ToString()));

            _contentFrmColumnDetail[_i] = new Dictionary<string, object>();
            _contentFrmColumnDetail[_i].Add("ID", (_idSectionMain + "-hospital"));
            _contentFrmColumnDetail[_i].Add("HighLight", false);
            _contentFrmColumnDetail[_i].Add("TitleTH", "หน่วยบริการสุขภาพ");
            _contentFrmColumnDetail[_i].Add("FontSizeTitleTH", _fontTHSize);
            _contentFrmColumnDetail[_i].Add("TitleEN", "Hospital");
            _contentFrmColumnDetail[_i].Add("FontSizeTitleEN", _fontENSize);
            _contentFrmColumnDetail[_i].Add("DiscriptionTH", String.Empty);
            _contentFrmColumnDetail[_i].Add("DiscriptionEN", String.Empty);
            _contentFrmColumnDetail[_i].Add("InputContentPaddingDown", false);
            _contentFrmColumnDetail[_i].Add("InputContent", _contentTemp.ToString());
            _contentFrmColumnDetail[_i].Add("Require", false);
            _contentFrmColumnDetail[_i].Add("LastRow", false);
            _contentFrmColumn.Add("Hospital", _contentFrmColumnDetail[_i]);
            */
            _contentTemp.Clear();
            _contentTemp.AppendFormat("<div class='lang lang-th font-family-th blue regular {0}'>{1}</div>", _fontTHSize, _termService["TermServiceHospitalNameTHHCSConsentRegistration"]);
            _contentTemp.AppendFormat("<div class='lang lang-en font-family-en blue regular {0}'>{1}</div>", _fontENSize, Util.UppercaseFirst(_termService["TermServiceHospitalNameENHCSConsentRegistration"].ToString()));

            _contentFrmColumnDetail[_i] = new Dictionary<string, object>();
            _contentFrmColumnDetail[_i].Add("ID", (_idSectionMain + "-hospital"));
            _contentFrmColumnDetail[_i].Add("HighLight", false);
            _contentFrmColumnDetail[_i].Add("TitleTH", "หน่วยบริการสุขภาพ");
            _contentFrmColumnDetail[_i].Add("FontSizeTitleTH", _fontTHSize);
            _contentFrmColumnDetail[_i].Add("TitleEN", "Hospital");
            _contentFrmColumnDetail[_i].Add("FontSizeTitleEN", _fontENSize);
            _contentFrmColumnDetail[_i].Add("DiscriptionTH", String.Empty);
            _contentFrmColumnDetail[_i].Add("DiscriptionEN", String.Empty);
            _contentFrmColumnDetail[_i].Add("InputContentPaddingDown", false);
            _contentFrmColumnDetail[_i].Add("InputContent", _contentTemp.ToString());
            _contentFrmColumnDetail[_i].Add("Require", false);
            _contentFrmColumnDetail[_i].Add("LastRow", false);
            _contentFrmColumn.Add("Hospital", _contentFrmColumnDetail[_i]);
            
            _html.AppendLine(GetValueDataRecorded(_valueDataRecorded).ToString());

            _html.AppendFormat("<div class='view' id='{0}-panel'>", _idSectionMain);
            _html.AppendLine("      <div class='panel'>");
            _html.AppendLine("          <div class='panel-heading text-center'>");
            _html.AppendLine("              <div class='avatar profilepicture'>");
            _html.AppendLine("                  <div class='watermark'></div>");
            _html.AppendLine("                  <img />");
            _html.AppendLine("              </div>");
            _html.AppendLine("          </div>");
            _html.AppendLine("          <div class='panel-body'>");
            _html.AppendLine("              <div class='form'>");
            _html.AppendLine(                   HCSUI.GetFrmColumn(_contentFrmColumn["StudentID"]).ToString());
            _html.AppendLine(                   HCSUI.GetFrmColumn(_contentFrmColumn["FullName"]).ToString());
            _html.AppendLine(                   HCSUI.GetFrmColumn(_contentFrmColumn["Faculty"]).ToString());
            _html.AppendLine(                   HCSUI.GetFrmColumn(_contentFrmColumn["Program"]).ToString());

            if (_termService["TermServiceStatusHCSConsentRegistration"].Equals("Y"))
                _html.AppendLine(               HCSUI.GetFrmColumn(_contentFrmColumn["Hospital"]).ToString());

            _html.AppendLine("              </div>");
            /*
            _html.AppendLine("              <div class='btn-command text-center'>");
            _html.AppendFormat("                <a class='btn btn-block btn-success' id='{0}-buttondownload'>", _idSectionMain);
            _html.AppendFormat("                    <div class='lang lang-th font-family-th {0} regular'>ดาวน์โหลดแบบฟอร์มประกันสุขภาพ</div>", _fontTHSize);
            _html.AppendFormat("                    <div class='lang lang-en font-family-en {0} regular'>Download Registration Form</div>", _fontENSize);
            _html.AppendLine("                  </a>");
            _html.AppendLine("              </div>");
            */
            _html.AppendLine("          </div>");
            _html.AppendLine("      </div>");
            _html.AppendLine("  </div>");

            return _html;
        }
    }

    public class SectionDialogUI
    {
        public class SelectWelfareUI
        {
            private static string _idSectionDialog = HCSUtil.ID_SECTION_DOWNLOADREGISTRATIONFORMSELECTWELFARE_DIALOG.ToLower();

            public static StringBuilder GetMain()
            {
                StringBuilder _html = new StringBuilder();
                StringBuilder _contentTemp = new StringBuilder();
                Dictionary<string, Dictionary<string, object>> _contentFrmColumn = new Dictionary<string, Dictionary<string, object>>();
                Dictionary<string, object>[] _contentFrmColumnDetail = new Dictionary<string, object>[3];
                Dictionary<string, object> _paramSearch = new Dictionary<string, object>();
                DataSet _ds = new DataSet();
                string _fontTHSize = "f10";
                string _fontENSize = "f10";
                int _i = 0;

                _contentTemp.Clear();
                _contentTemp.AppendFormat("<div class='lang lang-th font-family-th black light {0}'></div>", _fontTHSize);
                _contentTemp.AppendFormat("<div class='lang lang-en font-family-en black light {0}'></div>", _fontENSize);

                _contentFrmColumnDetail[_i] = new Dictionary<string, object>();
                _contentFrmColumnDetail[_i].Add("ID", (_idSectionDialog + "-workedstatus"));
                _contentFrmColumnDetail[_i].Add("HighLight", false);
                _contentFrmColumnDetail[_i].Add("TitleTH", "สถานะการทำงานของนักศึกษา");
                _contentFrmColumnDetail[_i].Add("FontSizeTitleTH", _fontTHSize);
                _contentFrmColumnDetail[_i].Add("TitleEN", "Worked Status");
                _contentFrmColumnDetail[_i].Add("FontSizeTitleEN", _fontENSize);
                _contentFrmColumnDetail[_i].Add("DiscriptionTH", "");
                _contentFrmColumnDetail[_i].Add("DiscriptionEN", "");
                _contentFrmColumnDetail[_i].Add("InputContentPaddingDown", false);
                _contentFrmColumnDetail[_i].Add("InputContent", _contentTemp.ToString());
                _contentFrmColumnDetail[_i].Add("Require", false);
                _contentFrmColumnDetail[_i].Add("LastRow", false);
                _contentFrmColumn.Add("WorkedStatus", _contentFrmColumnDetail[_i]);
                _i++;

                _paramSearch.Clear();
                _paramSearch.Add("WorkedStatus", "Y");
                _paramSearch.Add("CancelledStatus", "N");
                
                _ds = HCSDB.GetListWelfare(_paramSearch);

                _contentTemp.Clear();

                foreach (DataRow _dr1 in _ds.Tables[0].Rows)
                {
                    _contentTemp.AppendLine("<div class='radio-row'>");
                    _contentTemp.AppendLine("   <ul>");
                    _contentTemp.AppendLine("       <li class='radio-col input-col'>");
                    _contentTemp.AppendFormat("         <input class='inputradio' type='radio' name='{0}-welfare' value='{1}' />", _idSectionDialog, _dr1["id"]);
                    _contentTemp.AppendLine("       </li>");
                    _contentTemp.AppendLine("       <li class='radio-col label-col'>");
                    _contentTemp.AppendFormat("         <div class='lang lang-th font-family-th black light {0}'>{1}</div>", _fontTHSize, _dr1["nameTH"]);
                    _contentTemp.AppendFormat("         <div class='lang lang-en font-family-en black light {0}'>{1}</div>", _fontENSize, _dr1["nameEN"]);
                    _contentTemp.AppendLine("       </li>");
                    _contentTemp.AppendLine("   </ul>");
                    _contentTemp.AppendLine("</div>");
                }

                _ds.Dispose();

                _contentFrmColumnDetail[_i] = new Dictionary<string, object>();
                _contentFrmColumnDetail[_i].Add("ID", (_idSectionDialog + "-welfareworkedstatusy"));
                _contentFrmColumnDetail[_i].Add("HighLight", false);
                _contentFrmColumnDetail[_i].Add("TitleTH", "สวัสดิการจากที่ทำงาน");
                _contentFrmColumnDetail[_i].Add("FontSizeTitleTH", _fontTHSize);
                _contentFrmColumnDetail[_i].Add("TitleEN", "From Welfare to Work");
                _contentFrmColumnDetail[_i].Add("FontSizeTitleEN", _fontENSize);
                _contentFrmColumnDetail[_i].Add("DiscriptionTH", "");
                _contentFrmColumnDetail[_i].Add("DiscriptionEN", "");
                _contentFrmColumnDetail[_i].Add("InputContentPaddingDown", false);
                _contentFrmColumnDetail[_i].Add("InputContent", _contentTemp.ToString());
                _contentFrmColumnDetail[_i].Add("Require", false);
                _contentFrmColumnDetail[_i].Add("LastRow", false);
                _contentFrmColumn.Add("WelfareWorkedStatusY", _contentFrmColumnDetail[_i]);
                _i++;

                _paramSearch.Clear();
                _paramSearch.Add("WorkedStatus", "N");
                _paramSearch.Add("CancelledStatus", "N");
                
                _ds = HCSDB.GetListWelfare(_paramSearch);

                _contentTemp.Clear();

                foreach (DataRow _dr2 in _ds.Tables[0].Rows)
                {
                    _contentTemp.AppendLine("<div class='radio-row'>");
                    _contentTemp.AppendLine("   <ul>");
                    _contentTemp.AppendLine("       <li class='radio-col input-col'>");
                    _contentTemp.AppendFormat("         <input class='inputradio' type='radio' name='{0}-welfare' value='{1}' />", _idSectionDialog, _dr2["id"]);
                    _contentTemp.AppendLine("       </li>");
                    _contentTemp.AppendLine("       <li class='radio-col label-col'>");
                    _contentTemp.AppendFormat("         <div class='lang lang-th font-family-th black light {0}'>{1}</div>", _fontTHSize, _dr2["nameTH"]);
                    _contentTemp.AppendFormat("         <div class='lang lang-en font-family-en black light {0}'>{1}</div>", _fontENSize, _dr2["nameEN"]);
                    _contentTemp.AppendLine("       </li>");
                    _contentTemp.AppendLine("   </ul>");
                    _contentTemp.AppendLine("</div>");
                }

                _ds.Dispose();

                _contentFrmColumnDetail[_i] = new Dictionary<string, object>();
                _contentFrmColumnDetail[_i].Add("ID", (_idSectionDialog + "-welfareworkedstatusn"));
                _contentFrmColumnDetail[_i].Add("HighLight", false);
                _contentFrmColumnDetail[_i].Add("TitleTH", "ปัจจุบันเบิกค่ารักษาพยาบาลอย่างไร");
                _contentFrmColumnDetail[_i].Add("FontSizeTitleTH", _fontTHSize);
                _contentFrmColumnDetail[_i].Add("TitleEN", "Reimbursement of Medical Expenses");
                _contentFrmColumnDetail[_i].Add("FontSizeTitleEN", _fontENSize);
                _contentFrmColumnDetail[_i].Add("DiscriptionTH", "");
                _contentFrmColumnDetail[_i].Add("DiscriptionEN", "");
                _contentFrmColumnDetail[_i].Add("InputContentPaddingDown", false);
                _contentFrmColumnDetail[_i].Add("InputContent", _contentTemp.ToString());
                _contentFrmColumnDetail[_i].Add("Require", false);
                _contentFrmColumnDetail[_i].Add("LastRow", false);
                _contentFrmColumn.Add("WelfareWorkedStatusN", _contentFrmColumnDetail[_i]);

                _html.AppendFormat("<div class='dialog' id='{0}-panel'>", _idSectionDialog);
                _html.AppendLine("      <div class='panel panel-transparent'>");
                _html.AppendLine("          <div class='panel-body'>");
                _html.AppendLine("              <div class='form horizontal'>");
                _html.AppendLine(                   HCSUI.GetFrmColumn(_contentFrmColumn["WorkedStatus"]).ToString());
                _html.AppendLine(                   HCSUI.GetFrmColumn(_contentFrmColumn["WelfareWorkedStatusY"]).ToString());
                _html.AppendLine(                   HCSUI.GetFrmColumn(_contentFrmColumn["WelfareWorkedStatusN"]).ToString());
                _html.AppendLine("              </div>");
                _html.AppendLine("              <div class='btn-command text-center'>");
                _html.AppendFormat("                <a class='btn btn-block btn-info' id='{0}-buttondownload'>", _idSectionDialog);
                _html.AppendFormat("                    <div class='lang lang-th font-family-th {0} regular'>เริ่มดาวน์โหลด</div>", _fontTHSize);
                _html.AppendFormat("                    <div class='lang lang-en font-family-en {0} regular'>Start Download</div>", _fontENSize);
                _html.AppendLine("                  </a>");
                _html.AppendLine("              </div>");
                _html.AppendLine("          </div>");
                _html.AppendLine("      </div>");
                _html.AppendLine("  </div>");

                return _html;
            }
        }
    }
}