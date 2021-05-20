/*
=============================================
Author      : <ยุทธภูมิ ตวันนา>
Create date : <๑๖/๐๕/๒๕๖๒>
Modify date : <๑๓/๐๒/๒๕๖๓>
Description : <คลาสใช้งานเกี่ยวกับการใช้งานแสดงผลในส่วนของการแสดงความยินยอมให้ข้อมูลสำหรับการรับบริการปรึกษาออนไลน์>
=============================================
*/

using System;
using System.Collections.Generic;
using System.Text;

public class HCSTermServiceConsentOOCAUI
{
    public static StringBuilder GetSection(Dictionary<string, object> _infoLogin, string _section, string _sectionAction, string _id)
    {
        StringBuilder _html = new StringBuilder();
        StringBuilder _content = new StringBuilder();
        StringBuilder _contentTH = new StringBuilder();
        StringBuilder _contentEN = new StringBuilder();
        bool _exist = HCSUtil.ChkExistStudentTermServiceHCSConsentOOCA(_id);
        int _userError = int.Parse(_infoLogin["UserError"].ToString());

        switch (_section)
        {
            case "MAIN":
                if (!_exist)
                    _html = SectionMainUI.GetMain(_id);
                else
                {
                    Dictionary<string, object> _termServiceHCSConsentOOCAResult = HCSUtil.GetTermServiceHCSConsentOOCA(_id);


                    if (!String.IsNullOrEmpty(_termServiceHCSConsentOOCAResult["TermServiceStatusHCSConsentOOCA"].ToString()))
                    {
                        _contentTH.AppendFormat(
                            "<center>" +
                            "   <span class='f8'>นักศึกษาเคยแสดงความประสงค์ว่า</span><br />" +
                            "   <span class='f7 bold underline'>\"{0}\"</span><br />" +
                            "   <span class='f9'>ให้ข้อมูลสำหรับการรับบริการปรึกษาออนไลน์สำหรับนักศึกษา มหาวิทยาลัยมหิดลไว้แล้ว</span>" +
                            "</center>" +
                            "<p class='br'></p>" +
                            "<div class='red'>" +
                            "   <span class='bold'>หมายเหตุ</span><br />กรณีต้องการแจ้งเปลี่ยนแปลงความประสงค์ หรือต้องการรายละเอียดเพิ่มเติมติดต่อสอบถามได้ที่ กองกิจการนักศึกษา โทร. 0 2849 4538 ในวันและเวลาราชการ หรือติดต่อได้ที่ Inbox ของ FB Fanpage : @MahidolFriends" +
                            "</div>", (_termServiceHCSConsentOOCAResult["TermServiceStatusHCSConsentOOCA"].Equals("Y") ? "ยินยอม" : "ไม่ยินยอม")
                        );

                        _contentEN.AppendFormat(
                            "<center>" +
                            "   <span class='f8'>You have already decided to</span><br />" +
                            "   <span class='f7 bold underline'>\"{0}\"</span><br />" +
                            "   <span class='f9'>provides information for receiving online counseling services<br />for Mahidol University’ students</span>" +                                        
                            "</center>" +
                            "<p class='br'></p>" +
                            "<div class='red'>" +
                            "   <span class='bold'>Note</span><br />In case of changing your decision, please contact the Mahidol University Counseling Center ( MU Friends, Counseling Center ) Division of Student Affairs, tel. 0 2849 4538 or FB Fanpage: @mahidolfriends" +
                            "</div>", (_termServiceHCSConsentOOCAResult["TermServiceStatusHCSConsentOOCA"].Equals("Y") ? "Agree" : "Disagree")
                        );

                        _html.AppendFormat("<div class='view usererror{0}' id='{1}-panel'>", _userError, HCSUtil.ID_SECTION_TERMSERVICEHCSCONSENTOOCA_INFO.ToLower());
                        _html.AppendLine("      <div class='panel panel-info'>");
                        _html.AppendLine("          <div class='panel-body'>");
                        _html.AppendFormat("            <div class='lang lang-th font-family-th regular {0}'>{1}</div>", "f10", _contentTH);
                        _html.AppendFormat("            <div class='lang lang-en font-family-en regular {0}'>{1}</div>", "f10", _contentEN);
                        _html.AppendLine("          </div>");
                        _html.AppendLine("      </div>");
                        _html.AppendLine("  </div>");
                    }    
                }

                break;
        }

        return _html;
    }

    public class SectionMainUI
    {
        private static string _idSectionMain = HCSUtil.ID_SECTION_TERMSERVICEHCSCONSENTOOCA_MAIN.ToLower();

        public static StringBuilder GetMain(string _id)
        {
            StringBuilder _html = new StringBuilder();
            StringBuilder _contentTH = new StringBuilder();
            StringBuilder _contentEN = new StringBuilder();
            string _fontTHSize = "f11";
            string _fontENSize = "f11";

            _contentTH.AppendFormat(
                "<p>มหาวิทยาลัยมหิดล ได้จัดบริการการรับการปรึกษาออนไลน์กับจิตแพทย์ หรือนักจิตวิทยา บนระบบการให้คำปรึกษาออนไลน์ ผ่านช่องทางวิดีโอคอล กับผู้เชี่ยวชาญ ได้แก่ จิตแพทย์ นักจิตวิทยา เป็นต้น</p>" +
                "<p class='br'></p>" +
                "<p>ทั้งนี้ สำหรับนักศึกษามหาวิทยาลัยมหิดล ซึ่งประสงค์รับบริการดังกล่าว จำเป็นต้องยินยอมให้มหาวิทยาลัยใช้ ที่อยู่อีเมล์ของนักศึกษามหาวิทยาลัยมหิดล ( E-mail address of Mahidol University's Student ) เพื่อเป็นการยืนยันตัวตน โดย" +
                "การ Activate เข้ารับบริการผ่านระบบให้คำปรึกษาออนไลน์เท่านั้น โดย นักศึกษาสามารถยินยอม หรือไม่ยินยอมให้ใช้ข้อมูลดังกล่าวข้างต้น โดยขอให้แสดงความประสงค์ผ่านแบบแสดงความยินยอมนี้</p>" +
                "<p class='br'></p>" +
                "<p>หลังจากนักศึกษาแสดงความยินยอม มหาวิทยาลัยจะส่งข้อมูล ได้แก่ อีเมลของนักศึกษามหาวิทยาลัยมหิดล ( name.sur@student.mahidol.ac.th ) รหัสนักศึกษา ชื่อส่วนงาน และชั้นปี ไปยัง บริษัท เทเลเมดิก้า จำกัด ซึ่งเป็นเจ้าของระบบดังกล่าว</p>" +
                "<p class='br'></p>" +
                "<p>ในการนี้ ข้อมูลส่วนตัว ได้แก่ รหัสนักศึกษา ชื่อส่วนงาน ชั้นปี เป็นข้อมูลซึ่งเก็บไว้ในฐานข้อมูล ถือเป็นความลับ และการเปิดเผยข้อมูลส่วนตัวต่อมหาวิทยาลัยหรือผู้เกี่ยวข้อง จะกระทำได้เฉพาะกรณีจำเป็นด้วยเหตุผลด้านความเสี่ยง หรือมีภาวะเสี่ยง อัน" +
                "ได้แก่ มีสัญญาณที่จะก่อให้เกิดอันตรายทั้งต่อตนเองและผู้อื่นเท่านั้น</p>" +
                "<p class='br'></p>" +
                "<div class='red'>" +
                "   <span class='bold'>หมายเหตุ</span><br />ข้อมูลต่าง ๆ ดังกล่าวข้างต้นจะไม่ได้นำไปใช้ในเชิงพาณิชย์ใด ๆ ทั้งสิ้น" +
                "</div>" +
                "<p class='br'></p>" +
                "<div class='text-center'>*************</div>" +
                "<p class='br'></p>" +
                "<p>ข้าพเจ้าได้ทราบรายละเอียด และวัตถุประสงค์ของนำข้อมูลที่อยู่อีเมล์นักศึกษาของมหาวิทยาลัยมหิดล ( E-mail address of Mahidol University's Student ) เข้าใช้งานระบบการให้คำปรึกษาออนไลน์ มหาวิทยาลัยมหิดล ตลอดจนประโยชน์ที่" +
                "จะเกิดขึ้นต่อข้าพเจ้าแล้ว และยินยอมให้ข้อมูลที่อยู่อีเมล์นักศึกษาของมหาวิทยาลัยมหิดล ( E-mail address of Mahidol University's Student ) เพื่อการเข้าถึงการรับบริการปรึกษาออนไลน์ข้างต้น รวมถึงข้อมูลส่วนตัว ได้แก่ รหัสนักศึกษา ชื่อส่วนงาน" +
                "และชั้นปี เป็นฐานข้อมูลในระบบดังกล่าว และข้าพเจ้าจะเข้ารับบริการ หรือไม่ก็ได้ โดยไม่มีผลกระทบต่อสวัสดิการด้านการรักษาพยาบาลที่ข้าพเจ้าพึงได้รับจากมหาวิทยาลัย นอกจากนี้ กรณีที่มีการรับบริการจะไม่มีการนำข้อมูลส่วนตัวของข้าพเจ้า ทั้งใน" +
                "รูปแบบเสียง ลายลักษณ์อักษร หรือรูปแบบอื่นใด ไปกระทำการอันก่อให้เกิดความเสียหายแก่ข้าพเจ้า</p>" +
                "<p class='br'></p>" +
                "<p>ข้อมูลเฉพาะเกี่ยวกับตัวข้าพเจ้าเป็นความลับ และการเปิดเผยข้อมูลเกี่ยวกับตัวข้าพเจ้าต่อผู้เกี่ยวข้อง จะกระทำได้เฉพาะกรณีจำเป็นด้วยเหตุผลด้านความเสี่ยง หรือมีภาวะเสี่ยง อันได้แก่ มีสัญญาณที่จะก่อให้เกิดอันตรายทั้งต่อตนเองและผู้อื่นเท่านั้น</p>" +
                "<div class='red'>" +
                "   <span class='bold'>หมายเหตุ</span><br />ที่อยู่อีเมล์ ( E-mail address ) ดังกล่าวจะไม่ได้นำไปใช้ในเชิงพาณิชย์ใด ๆ ทั้งสิ้น" +
                "</div>" +
                "<p class='br'></p>" +
                "<p>ข้าพเจ้ารับทราบรายละเอียดข้างต้น และยินยอมให้นำข้อมูลที่อยู่อีเมล์นักศึกษาของมหาวิทยาลัยมหิดล ( E-mail address of Mahidol University's Student ) ไปใช้เพื่อการรับบริการผ่านระบบการให้คำปรึกษาออนไลน์ได้</p>" +
                "<p class='br'></p>" +
                "<div class='btn-command text-center'>" +
                "   <a class='btn btn-success' id='{0}-buttonconsentto'><div class='regular f10'>ยินยอม</div></a>" +
                "   <a class='btn btn-danger' id='{0}-buttondonotconsent'><div class='regular f10'>ไม่ยินยอม</div></a>" +
                "</div>" +
                "<p class='br'></p>" +
                "<div class='red'>" +
                "   <span class='bold'>หมายเหตุ</span><br />กรณีต้องการเปลี่ยนแปลงความประสงค์ กรุณาติดต่อ ศูนย์ให้คำปรึกษามหาวิทยาลัยมหิดล ( MU Friends, Counseling Center ) กองกิจการนักศึกษา โทร. 0 2849 4538 หรือ FB Fanpage : @mahidolfriends" +
                "</div>", _idSectionMain
            );

            _contentEN.AppendFormat(
                "<p>University has provided online counseling services to psychiatrists or psychologists on an online counseling system ( OOCA ) via video call with psychiatrists, psychologists, etc.</p>" +
                "<p class='br'></p>" +
                "<p>For Mahidol University students which wishes to receive services need to allow the university to use Mahidol University's student e-mail address in order to verify the identity by activating " +
                "the service through the online consultation system or do not consent to the use of the Mahidol University's student e-mail address by requesting to express their intention through this consent form</p>" +
                "<p class='br'></p>" +
                "<p>The university will send information Mahidol including the email of Mahidol University students ( name.sur@student.mahidol.ac.th ) student ID, Faculty Name, and Academic year to Tele Medica Company ( OOCA ), " +
                "which owns the system.</p>" +
                "<p class='br'></p>" +
                "<p>For this purpose, personal information such as student ID, Faculty Name, Academic year, is the information which is stored in the database ( back office ). The information is considered confidential. " +
                "Disclosure of personal information to universities or related parties can be done only if necessary for risk reasons, including signs that will cause danger to both themselves and others only.</p>" +
                "<p class='br'></p>" +
                "<div class='red'>" +
                "   <span class='bold'>Note</span><br />The above information will not be used for any commercial purposes at all." +
                "</div>" +
                "<p class='br'></p>" +
                "<div class='text-center'>*************</div>" +
                "<p class='br'></p>" +
                "<p>I know the details and purpose of the information contained in the e-mail address of Mahidol University's student to access system for online counseling system Mahidol University ( OOCA ). I know the benefits. " +
                "I consent to the information of the the e-mail address of Mahidol University's student for access to the online counseling services, and I will be accepted or not be able to receive the service, without " +
                "affecting the welfare, medical care I receive from the university. In addition, in the case of receiving services My personal information will not be Both in audio format written form or any other form to do any damage to me.</p>" +
                "<p class='br'></p>" +
                "<p>The specific information about me is confidential and disclosure of information about me to those involved can be done only if necessary for reasons of risk such a signal would pose a danger both to themselves and others.</p>" +
                "<p class='br'></p>" +
                "<div class='red'>" +
                "   <span class='bold'>Note</span><br />E-mail address will not be used for any commercial purposes." +
                "</div>" +
                "<p class='br'></p>" +
                "<p>I Acknowledge the above details and agree that information and email address of Mahidol University's Student to receive services through the online counseling system.</p>" +
                "<p class='br'></p>" +
                "<div class='btn-command text-center'>" +
                "   <a class='btn btn-success' id='{0}-buttonconsentto'><div class='regular f10'>Agree</div></a>" +
                "   <a class='btn btn-danger' id='{0}-buttondonotconsent'><div class='regular f10'>Disagree</div></a>" +
                "</div>" +
                "<p class='br'></p>" +
                "<div class='red'>" +
                "   <span class='bold'>Note</span><br />In case of changing your decision, please contact the Mahidol University Counseling Center ( MU Friends, Counseling Center ) Division of Student Affairs, tel. 0 2849 4538 or FB Fanpage: @mahidolfriends" +
                "</div>", _idSectionMain
            );

            _html.AppendFormat("<div class='view' id='{0}-panel'>", _idSectionMain);
            _html.AppendLine("      <div class='panel'>");
            _html.AppendLine("          <div class='panel-heading text-center'>");
            _html.AppendFormat("            <div class='lang lang-th font-family-th black bold {0}'>{1}</div>", "f9", "การแสดงความยินยอมให้ข้อมูลสำหรับการรับบริการปรึกษาออนไลน์สำหรับนักศึกษา มหาวิทยาลัยมหิดล");
            _html.AppendFormat("            <div class='lang lang-en font-family-en black bold {0}'>{1}</div>", "f8", "Consent provides information for receiving online counseling services for Mahidol University’ students.");
            _html.AppendLine("          </div>");
            _html.AppendLine("          <div class='panel-body'>");
            _html.AppendFormat("            <div class='lang lang-th font-family-th black regular {0}'>{1}</div>", _fontTHSize, _contentTH);
            _html.AppendFormat("            <div class='lang lang-en font-family-en black regular {0}'>{1}</div>", _fontENSize, _contentEN);
            _html.AppendLine("          </div>");
            _html.AppendLine("      </div>");
            _html.AppendLine("  </div>");

            return _html;
        }
    }
}