<%@ Page Language="C#" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="format-detection" content="telephone=no" />
	<title>ระบบขึ้นทะเบียนสิทธิรักษาพยาบาลของนักศึกษา : System of Health Care Service</title>
    <link rel="icon" type="image/png" href= "../../../Content/Image/HealthCareService/MUIcon.png" />    
    <link rel="stylesheet" type="text/css" href="../../../Content/jQuery/HealthCareService/jquery-ui.css" />
    <link rel="stylesheet" type="text/css" href="../../../Content/Select2/HealthCareService/dist/css/select2.css" />    
    <link rel="stylesheet" type="text/css" href="../../../Content/iCheck/HealthCareService/skins/all.css" />    
    <link rel="stylesheet" type="text/css" href="../../../Content/Bootstrap/HealthCareService/css/bootstrap.css" />   
    <link rel="stylesheet" type="text/css" href="../../../Content/Bootstrap/HealthCareService/css/bootstrap-dialog.css" />
    <link rel="stylesheet" type="text/css" href="../../../Content/CSS/HealthCareService/CSS.css" />
    <script type="text/javascript" src="../../../Content/jQuery/HealthCareService/external/jquery/jquery.js"></script>
    <script type="text/javascript" src="../../../Content/jQuery/HealthCareService/jquery-ui.js"></script>
    <script type="text/javascript" src="../../../Content/Select2/HealthCareService/dist/js/select2.js"></script>   
    <script type="text/javascript" src="../../../Content/iCheck/HealthCareService/icheck.js"></script> 
    <script type="text/javascript" src="../../../Content/Bootstrap/HealthCareService/js/bootstrap.js"></script>
    <script type="text/javascript" src="../../../Content/Bootstrap/HealthCareService/js/bootstrap-dialog.js"></script>
    <script type="text/javascript" src="../../../Content/JScript/BrowserDetect.js"></script>    
    <script type="text/javascript" src="../../../Content/JScript/Util.js"></script>    
    <script type="text/javascript" src="../../../Content/JScript/HealthCareService/HCSUtil.js"></script>    
    <script type="text/javascript" src="../../../Content/JScript/HealthCareService/HCSTermServiceConsentRegistration.js"></script>
    <script type="text/javascript" src="../../../Content/JScript/HealthCareService/HCSTermServiceConsentOOCA.js"></script>
    <script type="text/javascript" src="../../../Content/JScript/HealthCareService/HCSDownloadRegistrationForm.js"></script>
</head>
<body>
<main>
    <div class="sticky">
        <nav class="navbar navbar-top">
		    <div class="container"></div>
	    </nav>
        <nav class="navbar">
		    <div class="container">
			    <div class="navbar-header">
                    <div class="container">
                        <div class="panel panel-transparent systemname">
                            <div class="panel-body text-center registration">
                                <div class="lang lang-th font-family-th white regular f7">ระบบขึ้นทะเบียนสิทธิรักษาพยาบาลของนักศึกษา</div>
                                <div class="lang lang-en font-family-en white regular f7">System of Health Care Service</div>
                            </div>
                            <div class="panel-body text-center ooca">
                                <div class="lang lang-th font-family-th white regular f7">การรับบริการปรึกษาออนไลน์สำหรับนักศึกษา<br />( OOCA )</div>
                                <div class="lang lang-en font-family-en white regular f7">Receiving Online Counseling Services<br />( OOCA )</div>
                            </div>
                        </div>
                        <div class="navbar-brand float-left">
                            <div class="lang lang-th"></div>
                            <div class="lang lang-en"></div>
                        </div>
                        <div class="navbar-brand float-right registration">
                            <div class="lang lang-th"></div>
                            <div class="lang lang-en"></div>
                        </div>
                        <div class="navbar-brand float-right ooca">
                            <div class="lang lang-th"></div>
                            <div class="lang lang-en"></div>
                        </div>
                    </div>
                    <div class="clear"></div>
                </div>
		    </div>
	    </nav>
    </div>
    <header class="text-center">
        <div class="container"></div>
    </header>
    <section>
        <div class="container"></div> 
    </section>
    <footer class="text-center">
        <div class="container">
            <div class="lang lang-th font-family-th f9 white regular">กรณีนักศึกษามีข้อสงสัย สามารถสอบถามข้อมูลเพิ่มเติมได้ที่ 02-849-4503 นายถาวร เหล่าวนิชชานนท์</div>
            <div class="lang lang-th font-family-th f10 white regular">&copy; สงวนลิขสิทธิ์ พ.ศ.2559 มหาวิทยาลัยมหิดล, พัฒนาโดย กองเทคโนโลยีสารสนเทศ</div>
            <div class="lang lang-en font-family-en f9 white regular">For more information please contact Mr. THAWORN LAOWANITCHANONT, Tel. 02-849-4503</div>
            <div class="lang lang-en font-family-en f10 white regular">&copy; 2016 Mahidol University. All Rights Reserved. Developed by Division of Information Technology.</div>            
        </div>
    </footer>
</main>
<iframe class="frame-util hidden" id="frame-util" name="frame-util"></iframe>
<div class="hidden" id="page"><% Response.Write(Request.QueryString["p"]); %></div>
</body>
<script type="text/javascript">
    $(function () {
        $.fn.modal.Constructor.prototype.enforceFocus = function () { };
    });

    $(window).resize(function () {
        try  {
            Util.setTopMenuBarLayout();
            Util.setHeaderLayout();
            Util.setSectionLayout();
            Util.setFooterLayout();

            if ($(".select2-dropdown").is(":visible"))
                $("select").select2("close");
        }
        catch (_e)
        {
        }
    });

    $(window).scroll(function () {
        try
        {
            if ($(".select2-dropdown").is(":visible"))
                $("select").select2("close");
        }
        catch (_e)
        {
        }
    });

    try
    {
        Util.tut = HCSUtil;
        Util.tut.tdf = HCSDownloadRegistrationForm;
        Util.tut.tcr = HCSTermServiceConsentRegistration;
        Util.tut.tct = HCSTermServiceConsentOOCA;
        Util.getPage();
    }
    catch (_e)
    {
        Util.dialogMessageError({
            content: ("<div class='lang lang-th font-family-th black " + Util.dialogFormFontTHSize + "'>ประมวลผลไม่สำเร็จ</div>" +
                      "<div class='lang lang-en font-family-en black " + Util.dialogFormFontENSize + "'>Processing was not successful.</div>")
        });
    }
</script>
</html>
