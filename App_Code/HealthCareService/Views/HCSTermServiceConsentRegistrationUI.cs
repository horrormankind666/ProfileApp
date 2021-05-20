/*
=============================================
Author      : <ยุทธภูมิ ตวันนา>
Create date : <๐๗/๐๒/๒๕๖๓>
Modify date : <๑๑/๐๒/๒๕๖๓>
Description : <คลาสใช้งานเกี่ยวกับการใช้งานแสดงผลในส่วนของการแสดงความยินยอมให้ข้อมูลสำหรับการขึ้นทะเบียนสิทธิรักษาพยาบาล>
=============================================
*/

using System;
using System.Collections.Generic;
using System.Data;
using System.Text;

public class HCSTermServiceConsentRegistrationUI
{
    public static StringBuilder GetSection(Dictionary<string, object> _infoLogin, string _section, string _sectionAction, string _id)
    { 
        StringBuilder _html = new StringBuilder();

        switch (_section)
        {
            case "MAIN":
                _html = SectionMainUI.GetMain(_id);
                break;
            case "DIALOG":
                _html = SectionDialogUI.SelectHospitalUI.GetMain();
                break;
        }

        return _html;
    }

    public class SectionMainUI
    {
        private static string _idSectionMain = HCSUtil.ID_SECTION_TERMSERVICEHCSCONSENTREGISTRATION_MAIN.ToLower();

        public static StringBuilder GetMain(string _id)
        {
            StringBuilder _html = new StringBuilder();
            StringBuilder _content = new StringBuilder();
            string _fontSize = "f11";

            _content.AppendFormat(
                "<p>มหาวิทยาลัย ได้จัดบริการสุขภาพสำหรับนักศึกษาโดยใช้สิทธิพื้นฐานส่วนบุคคล ได้แก่ สิทธิกรมบัญชีกลาง สิทธิหลักประกันสุขภาพแห่งชาติ เป็นต้น ร่วมกับสวัสดิการของมหาวิทยาลัยมหิดล เพื่อให้นักศึกษาได้รับความสะดวกตลอดจนประโยขน์ต่าง ๆ ในการรับบริการ</p>" +
                "<p class='br'></p>" +
                "<p class='mb-0'>ทั้งนี้ การขึ้นทะเบียนสิทธิหลักประกันสุขภาพแห่งชาติ มุ่งเน้นให้นักศึกษาได้รับประโยชน์ในการเข้ารับบริการสุขภาพในขณะที่ศึกษาอยู่ที่มหาวิทยาลัยมหิดล ในการนี้นักศึกษามีสิทธิในการตัดสินใจยินยอม หรือปฏิเสธการให้มหาวิทยาลัยมหิดลเปลี่ยนหน่วยบริการประจำ ทั้งนี้ขอให้ศึกษาเงื่อนไขผลประโยชน์และ" +
                "ข้อมูลที่จำเป็นก่อนแสดงความยินยอม ตามรายละเอียด ดังนี้</p>" +
                "<div class='order-list'>" +
                "   <ol>" +
                "       <li>" +
                "มหาวิทยาลัยมหิดลจะส่งข้อมูลของนักศึกษาประกอบด้วย <span class='underline'><span class='bold'>รหัสนักศึกษา, ชื่อ-นามสกุล, เลขบัตรประจำตัวประชาชน และวันเดือนปีเกิด</span> ของนักศึกษาที่<span class='bold'>ยินยอม</span></span>" +
                "ให้มหาวิทยาลัยมหิดลเปลี่ยนหน่วยบริการประจำให้แก่โรงพยาบาลศิริราช หรือ โรงพยาบาลรามาธิบดี เพื่อขึ้นทะเบียนสิทธิหลักประกันสุขภาพแห่งชาติ โดยระยะเวลาการเปลี่ยนหน่วยบริการประจำเป็นไปตามรอบเวลาของการเปลี่ยนสิทธิของสำนักงานหลักประกันสุขภาพแห่งชาติ และการดำเนินการของมหาวิทยาลัยมหิดล" +
                "       </li>" +
                "       <li>" +
                "นักศึกษาที่ใช้สิทธิของกรมบัญชีกลาง สิทธิข้าราชการส่วนท้องถิ่น หรือสิทธิอื่นใด ที่ไม่สามารถเปลี่ยนหน่วยบริการได้ ณ วันที่ยินยอม มหาวิทยาลัยมหิดล จะดำเนินการส่งรายชื่อนักศึกษาที่<span class='bold'>ยินยอม</span>ให้มหาวิทยาลัยเปลี่ยนหน่วยบริการประจำให้แก่โรงพยาบาลศิริราช หรือ โรงพยาบาลรามาธิบดี" +
                "<span class='underline'>ภายหลังจากที่นักศึกษามีอายุครบ 20 ปีบริบูรณ์</span> <span class='bold underline'>ยกเว้น</span> นักศึกษาที่มีสิทธิประกันสังคม ให้นักศึกษาติดต่อกองกิจการนักศึกษาเพื่อดำเนินการหลังจากที่ปลดสิทธิประกันสังคมเรียบร้อยแล้ว" +
                "       </li>" +
                "       <li>" +
                "การเปลี่ยนหน่วยบริการประจำครั้งนี้ ถือเป็นการชั่วคราวเพื่อความสะดวกในการเข้ารับบริการสุขภาพ ในขณะที่ศึกษาอยู่ที่มหาวิทยาลัยมหิดลเท่่านั้น" +
                "       </li>" +
                "       <li>" +
                "เมื่อนักศึกษาพ้นสภาพการเป็นนักศึกษาตามข้อบังคับมหาวิทยาลัยมหิดล มหาวิทยาลัยมหิดลจะส่งรายชื่อนักศึกษาให้แก่สำนักงานหลักประกันสุขภาพแห่งชาติ เพื่อ \"เปลี่ยนหน่วยบริการประจำไปยังหน่วยบริการเดิมที่นักศึกษาเคยมีสิทธิอยู่อย่างไม่มีเงื่อนไขใด ๆ\"" +
                "       </li>" +
                "       <li>" +
                "หลังจากวันที่นักศึกษาแสดงความยินยอมแล้ว หากภายหลังนักศึกษามีการเปลี่ยนหน่วยบริการประจำไปยังโรงพยาบาลอื่น และประสงค์เปลี่ยนหน่วยบริการประจำกลับมายังโรงพยาบาลศิริราช หรือ โรงพยาบาลรามาธิบดี ให้นักศึกษาติดต่อกองกิจการนักศึกษา เพื่อดำเนินการต่อไป" +
                "       </li>" +
                "       <li>" +
                "สำหรับนักศึกษาที่ <span class='bold'>\"<span class='underline'>ไม่ยินยอม</span>\"</span> การให้มหาวิทยาลัยมหิดลเปลี่ยนหน่วยบริการประจำ หากมีความประสงค์ในภายหลัง ให้นักศึกษาติดต่อกองกิจการนักศึกษาเพื่อดำเนินการต่อไป" +
                "       </li>" +
                "   </ol>" +
                "</div>" +
                "<p class='br'></p>" +
                "<p>ข้าพเจ้าได้ทราบเงื่อนไข รายละเอียดของการขึ้นทะเบียนสิทธิหลักประกันสุขภาพแห่งชาติ ตลอดจนประโยชน์ที่จะเกิดขึ้นต่อข้าพเจ้าแล้ว และยินยอมให้มหาวิทยาลัยมหิดลจัดส่งข้อมูลของข้าพเจ้าให้แก่โรงพยาบาลศิริราช หรือ โรงพยาบาลรามาธิบดี เพื่อเปลี่ยนหน่วยบริการประจำต่อไป</p>" +
                "<p class='br'></p>" +
                "<div class='btn-command text-center'>" +
                "   <a class='btn btn-success' id='{0}-buttonconsentto'><div class='regular f10'>ยินยอม</div></a>" +
                "   <a class='btn btn-danger' id='{0}-buttondonotconsent'><div class='regular f10'>ไม่ยินยอม</div></a>" +
                "</div>" +
                "<p class='br'></p>" +
                "<div class='red'>" +
                "   <span class='bold'>หมายเหตุ</span>" +
                "   <div class='error-list'>" +
                "       <ul>" +
                "           <li>สถานพยาบาลปลายทางนักศึกษา เป็นไปตามส่วนงาน/หลักสูตรที่มหาวิทยาลัยกำหนด</li>" +
                "           <li>นักศึกษาสามารถแสดงความประสงค์ผ่านระบบขึ้นทะเบียนสิทธิรักษาพยาบาลได้เพียงครั้งเดียว</li>" +
                "           <li>กรณีต้องการเปลี่ยนแปลงความประสงค์ กรุณาติดต่อได้ที่ กองกิจการนักศึกษา โทร. 0 2849 4514 หรือติดต่อได้ที่ FB Fanpage: @MahidolHealth </li>" +
                "           <li>กรุณาทำรายการ เพื่อดำเนินการในขั้นตอนต่อไป</li>" +
                "      </ul>" +
                "   </div>" +
                "</div>", _idSectionMain
            );

            _html.AppendFormat("<div class='view' id='{0}-panel'>", _idSectionMain);
            _html.AppendLine("      <div class='panel'>");
            _html.AppendLine("          <div class='panel-heading text-center'>");
            _html.AppendFormat("            <div class='lang lang-th lang-en font-family-th black bold {0}'>{1}</div>", "f9", "การแสดงความยินยอมให้มหาวิทยาลัยมหิดล<br />ขึ้นทะเบียนสิทธิหลักประกันสุขภาพแห่งชาติกับโรงพยาบาลสังกัดมหาวิทยาลัยมหิดล");
            _html.AppendLine("          </div>");
            _html.AppendLine("          <div class='panel-body'>");
            _html.AppendFormat("            <div class='lang lang-th lang-en font-family-th black regular {0}'>{1}</div>", _fontSize, _content);
            _html.AppendLine("          </div>");
            _html.AppendLine("      </div>");
            _html.AppendLine("  </div>");

            return _html;
        }
    }

    public class SectionDialogUI
    {
        public class SelectHospitalUI
        {
            private static string _idSectionDialog = HCSUtil.ID_SECTION_TERMSERVICEHCSCONSENTREGISTRATIONSELECTHOSPITAL_DIALOG.ToLower();

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

                _paramSearch.Clear();
                _paramSearch.Add("ID", "RA, SI");
                _paramSearch.Add("CancelledStatus", "N");
                
                _ds = HCSDB.GetListHospital(_paramSearch);

                _contentTemp.Clear();

                foreach (DataRow _dr1 in _ds.Tables[0].Rows)
                {
                    _contentTemp.AppendLine("<div class='radio-row'>");
                    _contentTemp.AppendLine("   <ul>");
                    _contentTemp.AppendLine("       <li class='radio-col input-col'>");
                    _contentTemp.AppendFormat("         <input class='inputradio' type='radio' name='{0}-hospital' value='{1}' />", _idSectionDialog, _dr1["id"]);
                    _contentTemp.AppendLine("       </li>");
                    _contentTemp.AppendLine("       <li class='radio-col label-col'>");
                    _contentTemp.AppendFormat("         <div class='lang lang-th font-family-th black light {0}'>{1}</div>", _fontTHSize, _dr1["hospitalNameTH"]);
                    _contentTemp.AppendFormat("         <div class='lang lang-en font-family-en black light {0}'>{1}</div>", _fontENSize, _dr1["hospitalNameEN"]);
                    _contentTemp.AppendLine("       </li>");
                    _contentTemp.AppendLine("   </ul>");
                    _contentTemp.AppendLine("</div>");
                }

                _ds.Dispose();

                _contentFrmColumnDetail[_i] = new Dictionary<string, object>();
                _contentFrmColumnDetail[_i].Add("ID", (_idSectionDialog + "-hospital"));
                _contentFrmColumnDetail[_i].Add("HighLight", false);
                _contentFrmColumnDetail[_i].Add("TitleTH", String.Empty);
                _contentFrmColumnDetail[_i].Add("FontSizeTitleTH", String.Empty);
                _contentFrmColumnDetail[_i].Add("TitleEN", String.Empty);
                _contentFrmColumnDetail[_i].Add("FontSizeTitleEN", String.Empty);
                _contentFrmColumnDetail[_i].Add("DiscriptionTH", String.Empty);
                _contentFrmColumnDetail[_i].Add("DiscriptionEN", String.Empty);
                _contentFrmColumnDetail[_i].Add("InputContentPaddingDown", false);
                _contentFrmColumnDetail[_i].Add("InputContent", _contentTemp.ToString());
                _contentFrmColumnDetail[_i].Add("Require", false);
                _contentFrmColumnDetail[_i].Add("LastRow", false);
                _contentFrmColumn.Add("Hospital", _contentFrmColumnDetail[_i]);

                _html.AppendFormat("<div class='dialog' id='{0}-panel'>", _idSectionDialog);
                _html.AppendLine("      <div class='panel panel-transparent'>");
                _html.AppendLine("          <div class='panel-body'>");
                _html.AppendLine("              <div class='form horizontal'>");
                _html.AppendLine(                   HCSUI.GetFrmColumn(_contentFrmColumn["Hospital"]).ToString());
                _html.AppendLine("              </div>");
                _html.AppendLine("              <div class='btn-command text-center'>");
                _html.AppendFormat("                <a class='btn btn-block btn-info' id='{0}-buttonsave'>", _idSectionDialog);
                _html.AppendFormat("                    <div class='lang lang-th font-family-th {0} regular'>บันทึก</div>", _fontTHSize);
                _html.AppendFormat("                    <div class='lang lang-en font-family-en {0} regular'>Save</div>", _fontENSize);
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