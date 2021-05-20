/*
=============================================
Author      : <ยุทธภูมิ ตวันนา>
Create date : <๐๗/๐๒/๒๕๖๓>
Modify date : <๓๐/๐๔/๒๕๖๓>
Description : <รวมรวบฟังก์ชั่นใช้งานทั่วไปในส่วนของการแสดงความยินยอมให้ข้อมูลสำหรับการขึ้นทะเบียนสิทธิรักษาพยาบาล>
=============================================
*/

var HCSTermServiceConsentRegistration = {    
    sectionMain: {
        idSectionMain: HCSUtil.idSectionTermServiceHCSConsentRegistrationMain.toLowerCase(),
        initMain: function () {
            var _this1 = Util.tut;
            var _this2 = _this1.tcr;
            var _this3 = this;
            var _consentStatus;

            $("#" + _this3.idSectionMain + "-panel .btn-command .btn").click(function () {
                var _idContent = $(this).attr("id");

                if (_idContent == (_this3.idSectionMain + "-buttonconsentto"))
                    _consentStatus = "Y";

                if (_idContent == (_this3.idSectionMain + "-buttondonotconsent"))
                    _consentStatus = "N";

                _this3.getSave({
                    consentStatus: _consentStatus
                });

                /*
                if (_consentStatus == "Y") {
                    Util.loadForm({
                        name: _this1.pageTermServiceHCSConsentRegistrationSelectHospitalDialog,
                        dialog: true
                    }, function (_result, _e) {
                        if (_e != "close")
                            _this2.sectionDialog.selectHospital.initMain();
                    });
                }

                if (_consentStatus == "N")
                    _this3.getSave({
                        consentStatus: _consentStatus
                    });
                */
            });

            this.resetMain();
        },
        resetMain: function () {
            var _this1 = Util.tut;
            var _this2 = _this1.tcr;
            var _this3 = this;
        },
        getSave: function (_param) {
            _param["consentStatus"] = (_param["consentStatus"] == undefined ? "" : _param["consentStatus"]);
            //_param["note"] = (_param["note"] == undefined ? "" : _param["note"]);

            var _this1 = Util.tut;
            var _this2 = _this1.tcr;
            var _this3 = this;
            var _data = {};
            var _signinYN = "Y";
            var _error;

            _data.signinYN = _signinYN;
            _data.consentStatus = _param["consentStatus"];
            //_data.note = _param["note"];
            
            Util.msgPreloading = "Saving...";

            Util.actionTask({
                action: "save",
                page: _this1.pageTermServiceHCSConsentRegistrationMain,
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
                    Util.gotoPage({
                        page: ("index.aspx?p=" + HCSUtil.pageDownloadRegistrationFormMain)
                    });
                }
            });
        }
    },
    sectionDialog: {
        selectHospital: {
            idSectionDialog: HCSUtil.idSectionTermServiceHCSConsentRegistrationSelectHospitalDialog.toLowerCase(),
            initMain: function () {
                var _this1 = Util.tut;
                var _this2 = _this1.tcr;
                var _this3 = this;
                
                Util.initCheck({
                    id: (_this3.idSectionDialog + "-hospital")
                });
                
                $("#" + _this3.idSectionDialog + "-panel .btn-command .btn").click(function () {
                    var _idContent = $(this).attr("id");

                    if (_idContent == (_this3.idSectionDialog + "-buttonsave")) {
                        if (_this3.validateSelect())
                            _this2.sectionMain.getSave({
                                consentStatus: "Y",
                                note: Util.checkGetValue(_this3.idSectionDialog + "-hospital")
                            });
                    }
                });
                
                this.resetMain();
            },
            resetMain: function () {
                var _this1 = Util.tut;
                var _this2 = _this1.tcr;
                var _this3 = this;

                Util.checkSetValue({
                    id: (_this3.idSectionDialog + "-hospital"),
                    value: ""
                });
            },
            validateSelect: function () {
                var _this1 = Util.tut;
                var _this2 = _this1.tcr;
                var _this3 = this;
                var _error = new Array();
                var _i = 0;

                if (Util.checkGetValue(_this3.idSectionDialog + "-hospital").length == 0) {
                    _error[_i] = ("กรุณาเลือกสถานพยาบาล;Please select hospital of health care service.;");
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