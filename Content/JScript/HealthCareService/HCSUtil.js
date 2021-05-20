/*
=============================================
Author      : <ยุทธภูมิ ตวันนา>
Create date : <๒๖/๑๒/๒๕๕๙>
Modify date : <๐๖/๐๑/๒๕๖๔>
Description : <รวมรวบฟังก์ชั่นใช้งานทั่วไปของระบบ>
=============================================
*/

var HCSUtil = {
    tdf: null,
    pathProject: "HealthCareService",
    urlHandler: "../../../Content/Handler/HealthCareService/HCSHandler.ashx",

    subjectSectionStudentRecordsStudentCV: "StudentRecordsStudentCV",
    subjectTermServiceHCSConsentRegistration: "TermServiceHCSConsentRegistration",
    subjectTermServiceHCSConsentOOCA: "TermServiceHCSConsentOOCA",
    subjectSectionDownloadRegistrationForm: "DownloadRegistrationForm",
    subjectSectionHelp: "Help",
    subjectSectionHelpContactUs: "HelpContactUs",
    subjectSectionHelpAllowPopup: "HelpAllowPopup",

    idSectionMain: "Main",
    idSectionTermServiceHCSConsentRegistrationMain: "Main-TermServiceHCSConsentRegistration",
    idSectionTermServiceHCSConsentRegistrationSelectHospitalDialog: "Dialog-TermServiceHCSConsentRegistrationSelectHospital",
    idSectionTermServiceHCSConsentOOCAMain: "Main-TermServiceHCSConsentOOCA",
    idSectionDownloadRegistrationFormMain: "Main-DownloadRegistrationForm",
    idSectionDownloadRegistrationFormSelectWelfareDialog: "Dialog-DownloadRegistrationFormSelectWelfare",

    pageStudentRecordsStudentCVMain: "StudentRecordsStudentCVMain",
    pageTermServiceHCSConsentRegistrationMain: "TermServiceHCSConsentRegistrationMain",
    pageTermServiceHCSConsentRegistrationSelectHospitalDialog: "TermServiceHCSConsentRegistrationSelectHospitalDialog",
    pageTermServiceHCSConsentOOCAMain: "TermServiceHCSConsentOOCAMain",
    pageDownloadRegistrationFormMain: "DownloadRegistrationFormMain",
    pageDownloadRegistrationFormSelectWelfareDialog: "DownloadRegistrationFormSelectWelfareDialog",

    initMenuBar: function () {
        var _this = this;

        $(function () {
            $(".navbar-top a").click(function () {
                var _idLink = $(this).attr("id");

                Util.dialogMessageClose();

                if (_idLink == (_this.idSectionMain.toLowerCase() + "-link-" + _this.subjectSectionStudentRecordsStudentCV.toLowerCase()))
                    Util.gotoPage({
                        page: ("index.aspx?p=" + _this.pageStudentRecordsStudentCVMain),
                        target: "_blank"
                    });

                if (_idLink == (_this.idSectionMain.toLowerCase() + "-link-" + _this.subjectSectionDownloadRegistrationForm.toLowerCase()))
                    Util.tut.tdf.sectionMain.validateDownload();

                if (_idLink == (_this.idSectionMain.toLowerCase() + "-link-" + _this.subjectSectionHelpContactUs.toLowerCase()))
                    Util.gotoElement({
                        anchorName: ("footer"),
                        top: ($("main .sticky").height())
                    });

                if (_idLink == (_this.idSectionMain.toLowerCase() + "-link-" + _this.subjectSectionHelpAllowPopup.toLowerCase()))
                    Util.gotoPage({
                        page: ("HCSDownloadFile.aspx?f=" + _this.subjectSectionHelpAllowPopup),
                        target: "frame-util"
                    });
            });
        });
    },
    getErrorMsg: function (_param) {
        _param.signinYN = (_param.signinYN == undefined || _param.signinYN == "" ? "N" : _param.signinYN);
        _param.pageError = (_param.pageError == undefined || _param.pageError == "" ? 0 : _param.pageError);
        _param.cookieError = (_param.cookieError == undefined || _param.cookieError == "" ? 0 : _param.cookieError);
        _param.userError = (_param.userError == undefined || _param.userError == "" ? 0 : _param.userError);
        _param.saveError = (_param.saveError == undefined || _param.saveError == "" ? 0 : _param.saveError);

        var _error = false;
        var _msgTH;
        var _msgEN;
        var _status = (_param.signinYN + _param.cookieError + _param.userError + _param.saveError);
        
        if (_error == false && _param.pageError == 1) {
            _error = true;
            _msgTH = "ไม่พบหน้านี้";
            _msgEN = "Page not found.";
        }

        if (_error == false && _param.pageError == 2) {
            _error = true;
            _msgTH = "ไม่พบข้อมูล";
            _msgEN = "Data not found.";
        }

        if (_error == false && _status == "Y100") {
            _error = true;
            _msgTH = "กรุณาเข้าระบบนักศึกษา";
            _msgEN = "Please sign in student portal.";
        }
        /*
        if (_error == false && _status == "Y100") {
            _error = true;
            _msgTH = "กรุณาเข้าระบบระเบียนประวัตินักศึกษา";
            _msgEN = "Please sign in student records.";
        }
        */
        if (_error == false && _status == "Y010") {
            _error = true;
            _msgTH = "ไม่พบนักศึกษา";
            _msgEN = "Students not found.";
        }
        /*
        if (_error == false && _status == "Y020") {
            _error = true;
            _msgTH = "นักศึกษาไม่ได้สังกัดในส่วนงานที่ขึ้นทะเบียน โปรดติดต่อหน่วยงานของท่าน";
            _msgEN = "Student not be under agency registered. Please contact your agency.";
        }
        */
        if (_error == false && _status == "Y020") {
            _error = true;
            _msgTH = "นักศึกษาดำเนินการขึ้นทะเบียนสิทธิหลักประกันสุขภาพแห่งชาติ ตามกำหนดการของคณะ / วิทยาลัยที่เข้าศึกษาต่อ";
            _msgEN = "Students apply for health insurance registration. The schedule of the Faculty / College to study.";
        }

        if (_error == false && _status == "Y030") {
            _error = true;
            _msgTH = "นักศึกษาไม่ได้เข้าระบบระเบียนประวัตินักศึกษา";
            _msgEN = "Student not logged in student records.";
        }

        if (_error == false && _status == "Y040") {
            _error = true;
            _msgTH = "ระบบยังไม่เปิดทำการ";
            _msgEN = "The system is not open.";
        }
        /*
        if (_error == false && _status == "Y050") {
            _error = true;
            _msgTH = "ระบบปิดทำการ";
            _msgEN = "Close system.";
        }
        */
        if (_error == false && _status == "Y060") {
            _error = true;
            _msgTH = "นักศึกษาไม่มีสิทธิ์เข้าใช้ระบบ";
            _msgEN = "No permission students.";
        }

        if (_error == false && _status == "Y070") {
            _error = true;
            _msgTH = "เฉพาะนักศึกษาระดับปริญญาตรี";
            _msgEN = "Student bachelor's degree only.";
        }

        if (_error == false && _status == "Y001") {
            _error = true;
            _msgTH = "บันทึกข้อมูลไม่สำเร็จ";
            _msgEN = "Save was not successful.";
        }

        if (_error == true && _msgTH.length > 0 && _msgEN.length > 0)
            Util.dialogMessageError({
                content: ("<div class='lang lang-th font-family-th " + Util.dialogFormFontTHSize + " black regular'>" + _msgTH + "</div>" +
                          "<div class='lang lang-en font-family-en " + Util.dialogFormFontENSize + " black regular'>" + _msgEN + "</div>"),
            });

        return _error;
    },
    loadPage: function (_callBackFunc) {
        var _this = this;
        var _error;
        var _page = ($("#page").html().length > 0 ? $("#page").html() : _this.pageDownloadRegistrationFormMain);
        var _data = {};
        _data.action = "page";
        _data.page = _page;
        _data.id = "";
        
        Util.clearPage();

        Util.msgPreloading = "Loading...";
        
        Util.loadAjax({
            url: _this.urlHandler,
            method: "POST",
            data: _data,
            showPreloadingInline: false
        }, function (_result) {
            _page = _result.Page;
            $("#page").html(_result.Page);
            
            _error = _this.getErrorMsg({
                signinYN: _result.SignInYN,
                pageError: _result.PageError,
                cookieError: _result.CookieError,
                userError: _result.UserError
            });

            Util.lang = _result.Language;

            $("main .navbar-top").show();
            $("main .navbar-top .container").html(_result.TopMenuBarContent);
            $("main .navbar-header").show();

            _this.initMenuBar();
            _this.sectionMain.initMain();
            _this.sectionMain.resetMain();

            if (_error == false) {
                if (_page == _this.pageStudentRecordsStudentCVMain) {
                    $("body").css("background-image", "none");
                    $("main nav.navbar .navbar-header").css("background", "#2A3B86");
                    $("main nav.navbar .navbar-header").addClass("errorpage");
                    $("main header").hide();
                    $("main section").css("padding", "0px").show();
                    $("main section .container").html(_result.MainContent);
                }
                else
                {
                    $("main section").show();
                    $("main section .container").html(_result.MainContent);

                    if (_page == _this.pageTermServiceHCSConsentRegistrationMain) {
                        //$("main nav.navbar .navbar-header").addClass("nosystemname");
                        $("main nav.navbar .navbar-header .navbar-brand.float-right.ooca").hide();
                        $("main nav.navbar .navbar-header .systemname .ooca").hide();
                        Util.tut.tcr.sectionMain.initMain();
                    }

                    if (_page == _this.pageTermServiceHCSConsentOOCAMain) {
                        //$("main nav.navbar .navbar-header").addClass("nosystemname");
                        $("main nav.navbar .navbar-header .navbar-brand.float-right.registration").hide();
                        $("main nav.navbar .navbar-header .systemname .registration").hide();
                        Util.tut.tct.sectionMain.initMain();
                    }

                    if (_page == _this.pageDownloadRegistrationFormMain) {
                        /*
                        $("main nav.navbar .navbar-header").removeClass("nosystemname");
                        $("main nav.navbar .navbar-header .navbar-brand.float-right").show();
                        */
                        $("main nav.navbar .navbar-header .navbar-brand.float-right.ooca").hide();
                        $("main nav.navbar .navbar-header .systemname .ooca").hide();
                        Util.tut.tdf.sectionMain.initMain();
                    }
                }
            }
            else
            {
                $("main nav.navbar .navbar-header").addClass("errorpage");

                if (_page == _this.pageDownloadRegistrationFormMain) {
                    $("main section").show();
                    $("main section .container").html(_result.MainContent);
                }
            }

            $("footer").show();
            $("footer .container").removeClass("hidden");
            
            Util.setLanguage({});
            Util.setTopMenuBarLayout();
            Util.setHeaderLayout();
            Util.setSectionLayout();
            Util.setFooterLayout();

            Util.initTextSelect();
            Util.initTooltip();
            Util.gotoTopElement();

            _callBackFunc();
        });
    },
    setSelectCombobox: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.value = (_param.value == undefined ? "" : _param.value);

        var _this = this;
        var _cmd;
        var _idContent;
        var _idCombobox;
        var _idContainer;
        var _idRadiobox;
        var _idCheckbox;
        var _idTextbox;
        var _valueParam = {};
        var _valueDefault;
        var _valueArray;
        var _widthInput;
        var _heightInput;
        var _fontTHSizeCombobox = "f10default";
        var _fontENSizeCombobox = "f10default";
        var _page;

        if (_param.id == ("#" + this.idSectionMain.toLowerCase() + "-language")) {
            Util.lang = _param.value;
            Util.setLanguageOnAllCombobox({
                fontSizeCombobox: (Util.lang == "TH" ? _fontTHSizeCombobox : _fontENSizeCombobox)
            });
            Util.setLanguage({});
            Util.setHeaderLayout();
            Util.setSectionLayout();
            Util.setFooterLayout();
        }
    },
    setSelectDefaultCombobox: function (_param, _callBackFunc) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.value = (_param.value == undefined ? "" : _param.value);

        var _this = this;
        var _cmd;
        var _idContent;
        var _idCombobox;
        var _idCheckbox;
        var _idContainer;
        var _valueParam = {};
        var _valueDefault;
        var _valueArray;
        var _widthInput;
        var _heightInput;
        var _fontTHSizeCombobox = "f10default";
        var _fontENSizeCombobox = "f10default";

        _callBackFunc();
    },
    sectionMain: {
        initMain: function () {
            var _this = Util.tut;
            var _fontTHSizeCombobox = "f10default";
            var _fontENSizeCombobox = "f10default";

            Util.initCombobox({
                id: ("#" + _this.idSectionMain.toLowerCase() + "-language"),
                width: 50,
                height: 28,
                fontSizeCombobox: (Util.lang == "TH" ? _fontTHSizeCombobox : _fontENSizeCombobox),
                searchDropDown: false
            });
        },
        resetMain: function () {
            var _this = Util.tut;

            Util.comboboxSetValue({
                id: ("#" + _this.idSectionMain.toLowerCase() + "-language"),
                value: Util.lang
            });
        }
    }
}