/*
=============================================
Author      : <ยุทธภูมิ ตวันนา>
Create date : <๒๘/๑๒/๒๕๕๙>
Modify date : <๑๗/๐๕/๒๕๖๒>
Description : <รวมรวบฟังก์ชั่นใช้งานทั่วไปในส่วนของการดาว์นโหลดแบบฟอร์มประกันสุขภาพของนักศึกษา>
=============================================
*/

var HCSDownloadRegistrationForm = {    
    sectionMain: {
        idSectionMain: HCSUtil.idSectionDownloadRegistrationFormMain.toLowerCase(),
        initMain: function () {
            var _this1 = Util.tut;
            var _this2 = _this1.tdf;
            var _this3 = this;

            $("#" + _this3.idSectionMain + "-panel .btn-command .btn").click(function () {
                var _idContent = $(this).attr("id");

                if (_idContent == (_this3.idSectionMain + "-buttondownload"))
                    _this2.sectionMain.validateDownload();
            });

            this.resetMain();
        },
        resetMain: function () {
            var _this1 = Util.tut;
            var _this2 = _this1.tdf;
            var _this3 = this;

            if ($("#" + _this3.idSectionMain + "-studentpicture-hidden").val().length > 0) {
                $("#" + _this3.idSectionMain + "-panel .avatar .watermark").show();
                $("#" + _this3.idSectionMain + "-panel .profilepicture img").prop({ "src": $("#" + _this3.idSectionMain + "-studentpicture-hidden").val() }).show();
            }
            else
            {
                $("#" + _this3.idSectionMain + "-panel .avatar .watermark").hide();
                $("#" + _this3.idSectionMain + "-panel .profilepicture img").hide();
            }
        },
        validateDownload: function () {
            var _this1 = Util.tut;
            var _this2 = _this1.tdf;
            var _this3 = this;

            if ($("#" + _this1.idSectionDownloadRegistrationFormSelectWelfareDialog.toLowerCase() + "-panel").is(":visible") == false) {
                if (Util.chkStudentRecordsFillComplete({
                    idContainer: _this3.idSectionMain,
                    personal: true,
                    addressPermanent: true,
                    addressCurrent: true,
                    educationPrimarySchool: true,
                    educationJuniorHighSchool: true,
                    educationHighSchool: true,
                    educationUniversity: true,
                    educationAdmissionScores: true,
                    talent: true,
                    healthy: true,
                    work: true,
                    financial: true,
                    familyFatherPersonal: true,
                    familyMotherPersonal: true,
                    familyParentPersonal: true,
                    familyFatherAddressPermanent: true,
                    familyMotherAddressPermanent: true,
                    familyParentAddressPermanent: true,
                    familyFatherAddressCurrent: true,
                    familyMotherAddressCurrent: true,
                    familyParentAddressCurrent: true,
                    familyFatherWork: true,
                    familyMotherWork: true,
                    familyparentwork: true
                }) == true)
                    _this3.getWelfareDialog();
            }
        },
        getWelfareDialog: function () {
            var _this1 = Util.tut;
            var _this2 = _this1.tdf;
            var _this3 = this;

            Util.loadForm({
                name: _this1.pageDownloadRegistrationFormSelectWelfareDialog,
                dialog: true
            }, function (_result, _e) {
                if (_e != "close")
                    _this2.sectionDialog.selectWelfare.initMain();
            });
        },
        getValue: function () {
            var _this1 = Util.tut;
            var _this2 = _this1.tdf;
            var _this3 = this;
            var _data = {};

            _data.hospital = $("#" + _this3.idSectionMain + "-hospital-hidden").val();
            _data.welfare = Util.getSelectionIsSelect({
                id: (_this2.sectionDialog.selectWelfare.idSectionDialog + "-welfare"),
                type: "radio",
                valueTrue: Util.checkGetValue(_this2.sectionDialog.selectWelfare.idSectionDialog + "-welfare")
            });

            return _data;
        },
        getDownload: function () {
            var _this1 = Util.tut;
            var _this2 = _this1.tdf;
            var _this3 = this;
            var _data = {};
            var _signinYN = "Y";
            var _error;

            _data = _this3.getValue();
            _data.signinYN = _signinYN;

            Util.msgPreloading = "Downloading...";

            Util.actionTask({
                action: "download",
                page: _this1.pageDownloadRegistrationFormMain,
                data: _data
            }, function (_result) {
                _error = _this1.getErrorMsg({
                    signinYN: _signinYN,
                    pageError: 0,
                    cookieError: _result.CookieError,
                    userError: _result.UserError,
                    saveError: _result.SaveError
                });

                if (_error == false) {
                    _this3.setValueDataRecorded({
                        data: _data
                    });

                    $("#" + Util.dialogForm).modal("hide");
                    Util.gotoTopElement();

                    Util.dialogMessageBox({
                        content: ("<div class='lang lang-th font-family-th black regular " + Util.dialogFormFontTHSize + "'>กรุณารอสักครู่ เพื่อทำการบันทึกไฟล์</div>" +
                                  "<div class='lang lang-en font-family-en black regular " + Util.dialogFormFontENSize + "'>Please wait to save file.</div>"),
                    });
                    Util.gotoPage({
                        page: ("HCSDownloadFile.aspx?f=" + _this1.subjectSectionDownloadRegistrationForm + "&path=" + _result.DownloadPath + "&file=" + _result.DownloadFile),
                        target: "frame-util"
                    });
                }
            });
        },
        setValueDataRecorded: function (_param) {
            _param.data = (_param.data == undefined || _param.data == "" ? {} : _param.data);

            var _this1 = Util.tut;
            var _this2 = _this1.tdf;
            var _this3 = this;

            $("#" + _this3.idSectionMain + "-welfare-hidden").val(_param.data.welfare);
        },
    },
    sectionDialog: {
        selectWelfare: {
            idSectionDialog: HCSUtil.idSectionDownloadRegistrationFormSelectWelfareDialog.toLowerCase(),
            initMain: function () {
                var _this1 = Util.tut;
                var _this2 = _this1.tdf;
                var _this3 = this;

                Util.initCheck({
                    id: (_this3.idSectionDialog + "-welfare")
                });

                $("#" + _this3.idSectionDialog + "-panel .btn-command .btn").click(function () {
                    var _idContent = $(this).attr("id");

                    if (_idContent == (_this3.idSectionDialog + "-buttondownload")) {
                        if (_this3.validateSelect())
                            _this2.sectionMain.getDownload();
                    }
                });

                this.resetMain();
            },
            resetMain: function () {
                var _this1 = Util.tut;
                var _this2 = _this1.tdf;
                var _this3 = this;
                var _workedStatus = $("#" + _this2.sectionMain.idSectionMain + "-workedstatus-hidden").val();
                var _workedStatusNameTH = $("#" + _this2.sectionMain.idSectionMain + "-workedstatusnameth-hidden").val();
                var _workedStatusNameEN = $("#" + _this2.sectionMain.idSectionMain + "-workedstatusnameen-hidden").val();
                
                $("#" + _this3.idSectionDialog + "-workedstatus-content .form-col.input-col .lang-th:eq(0)").html(_workedStatusNameTH);
                $("#" + _this3.idSectionDialog + "-workedstatus-content .form-col.input-col .lang-en:eq(0)").html(_workedStatusNameEN);

                if (_workedStatus == "Y") {
                    $("#" + _this3.idSectionDialog + "-welfareworkedstatusy-content").show();
                    $("#" + _this3.idSectionDialog + "-welfareworkedstatusn-content").hide();
                }

                if (_workedStatus == "N") {
                    $("#" + _this3.idSectionDialog + "-welfareworkedstatusy-content").hide();
                    $("#" + _this3.idSectionDialog + "-welfareworkedstatusn-content").show();
                }

                Util.checkSetValue({
                    id: (_this3.idSectionDialog + "-welfare"),
                    value: $("#" + _this2.sectionMain.idSectionMain + "-welfare-hidden").val()
                });
            },
            validateSelect: function () {
                var _this1 = Util.tut;
                var _this2 = _this1.tdf;
                var _this3 = this;
                var _error = new Array();
                var _i = 0;

                if (Util.checkGetValue(_this3.idSectionDialog + "-welfare").length == 0) {
                    _error[_i] = ("กรุณาเลือกสิทธิการรักษาพยาบาล;Please select the right to medical care.;");
                    _i++;
                }

                Util.dialogListMessageError({
                    content: _error
                });

                return (_i > 0 ? false : true);
            }
        }
    }
}