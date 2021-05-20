/*
=============================================
Author      : <ยุทธภูมิ ตวันนา>
Create date : <๑๗/๐๕/๒๕๖๒>
Modify date : <๐๗/๐๒/๒๕๖๓>
Description : <รวมรวบฟังก์ชั่นใช้งานทั่วไปในส่วนของการแสดงความยินยอมให้ข้อมูลสำหรับการรับบริการปรึกษาออนไลน์>
=============================================
*/

var HCSTermServiceConsentOOCA = {
    sectionMain: {
        idSectionMain: HCSUtil.idSectionTermServiceHCSConsentOOCAMain.toLowerCase(),
        initMain: function () {
            var _this1 = Util.tut;
            var _this2 = _this1.tct;
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
            });

            this.resetMain();
        },
        resetMain: function () {
            var _this1 = Util.tut;
            var _this2 = _this1.tct;
            var _this3 = this;
        },
        getSave: function (_param) {
            _param["consentStatus"] = (_param["consentStatus"] == undefined ? "" : _param["consentStatus"]);

            var _this1 = Util.tut;
            var _this2 = _this1.tct;
            var _this3 = this;
            var _data = {};
            var _signinYN = "Y";
            var _error;

            _data.signinYN = _signinYN;
            _data.consentStatus = _param["consentStatus"];

            Util.msgPreloading = "Saving...";

            Util.actionTask({
                action: "save",
                page: _this1.pageTermServiceHCSConsentOOCAMain,
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
                        page: ("index.aspx?p=" + HCSUtil.pageTermServiceHCSConsentOOCAMain)
                    });
                }
            });
        }
    }
}