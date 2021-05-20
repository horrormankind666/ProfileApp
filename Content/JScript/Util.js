var Util = {
    tut: null,
    timer: 0,
    offsetTop: 0,
    dialogPreloading: "dialog-preloading",
    dialogBox: "dialog-box",
    dialogError: "dialog-error",
    dialogConfirm: "dialog-confirm",
    dialogForm: "dialog-form",
    dialogFormFontTHSize: "f8",
    dialogFormFontENSize: "f8",
    msgPreloading: "",
    lang: "TH",
    dialogMessageClose: function () {
        if ($("#" + Util.dialogError).is(":visible"))
            $("#" + Util.dialogError).modal("hide");
    },
    dialogMessagePreloading: function () {
        var _dialog = new BootstrapDialog({
            id: Util.dialogPreloading,
            type: BootstrapDialog.TYPE_DEFAULT,
            message: ("<div class='dialog-preloading font-family-en black bold f11default'>" + Util.msgPreloading + "</div>"),
            animate: false,
            closable: true,
            closeByBackdrop: false,
            closeByKeyboard: false,
            draggable: false
        });

        _dialog.realize();
        _dialog.getModalDialog().css({
            width: "auto"
        });
        _dialog.getModalContent().css({
            background: "transparent",
            border: "0px"
        });
        _dialog.getModalHeader().hide();
        _dialog.getModalFooter().hide();

        _dialog.open();
    },
    dialogMessageError: function (_param) {
        _param.content = (_param.content == undefined ? "" : _param.content);
        
        if (_param.content.length > 0) {
            BootstrapDialog.show({
                id: Util.dialogError,
                size: BootstrapDialog.SIZE_LARGE,
                type: BootstrapDialog.TYPE_DANGER,
                message: _param.content,
                animate: false,
                closable: true,
                closeByBackdrop: false,
                closeByKeyboard: false,
                draggable: true,
                buttons: [{
                    label: ("<div class='lang lang-th font-family-th regular " + Util.dialogFormFontTHSize + "'>ปิด</div>" +
                            "<div class='lang lang-en font-family-en regular " + Util.dialogFormFontENSize + "'>CLOSE</div>"),
                    cssClass: "btn-danger",
                    action: function (_dialog) {
                        _dialog.close();
                    }
                }],
            });

            Util.setLanguageOnForm({
                id: ("#" + Util.dialogError)
            });
        }
    },
    dialogMessageBox: function (_param) {
        _param.content = (_param.content == undefined ? "" : _param.content);

        if (_param.content.length > 0) {
            BootstrapDialog.show({
                id: Util.dialogBox,
                size: BootstrapDialog.SIZE_LARGE,
                type: BootstrapDialog.TYPE_SUCCESS,
                message: _param.content,
                animate: false,
                closable: true,
                closeByBackdrop: false,
                closeByKeyboard: false,
                draggable: true,
                buttons: [{
                    label: ("<div class='lang lang-th font-family-th regular " + Util.dialogFormFontTHSize + "'>ปิด</div>" +
                            "<div class='lang lang-en font-family-en regular " + Util.dialogFormFontENSize + "'>CLOSE</div>"),
                    cssClass: "btn-success",
                    action: function (_dialog) {
                        _dialog.close();
                    }
                }],
            });

            Util.setLanguageOnForm({
                id: ("#" + Util.dialogBox)
            });
        }
    },
    dialogMessageConfirm: function (_param, _callBackFunc) {
        _param.content = (_param.content == undefined ? "" : _param.content);

        if (_param.content.length > 0) {
            BootstrapDialog.confirm({
                id: Util.dialogConfirm,
                size: BootstrapDialog.SIZE_NORMAL,
                type: BootstrapDialog.TYPE_PRIMARY,
                message: _param.content,
                animate: false,
                closable: true,
                closeByBackdrop: false,
                closeByKeyboard: false,
                draggable: true,
                btnCancelLabel: ("<div class='lang lang-th font-family-th white regular " + Util.dialogFormFontTHSize + "'>ยกเลิก</div>" +
                                 "<div class='lang lang-en font-family-en white regular " + Util.dialogFormFontENSize + "'>CANCEL</div>"),
                btnOKLabel: ("<div class='lang lang-th font-family-th white regular " + Util.dialogFormFontTHSize + "'>ตกลง</div>" +
                             "<div class='lang lang-en font-family-en white regular " + Util.dialogFormFontENSize + "'>OK</div>"),
                btnCancelClass: "btn-primary",
                btnOKClass: "btn-primary",
                callback: function (_result) {
                    _callBackFunc(_result);
                }
            });

            Util.setLanguageOnForm({
                id: ("#" + Util.dialogConfirm)
            });
        }
    },
    dialogListMessageError: function (_param) {
        _param.content = (_param.content == undefined ? "" : _param.content);

        var _this1 = this;
        var _i;
        var _msgArray;
        var _content = "";
        var _outerHeight = 0;
        var _callFunc;

        if (_param.content.length > 0) {
            _outerHeight = (_outerHeight + ($(".tabbar").length > 0 ? $(".tabbar").outerHeight() : 0));
            _outerHeight = (_outerHeight + ($(".subtabbar").length > 0 ? $(".tabbar").outerHeight() : 0));
            _outerHeight = (_outerHeight + ($("main nav.navbar .navbar-menu.bottom-menu").length > 0 ? 19 : 0));

            _content += "<div class='error-list'>" +
                        "   <ul>";

            for (_i = 0; (_i < _param.content.length && _i < 5); _i++) {
                _msgArray = _param.content[_i].split(";");
                _callFunc = "Util.gotoElement({" +
                            "anchorName:('#" + _msgArray[2] + "')," +
                            "top:" + (this.offsetTop + _outerHeight) +
                            "});"

                _content += "   <li class='" + _this1.dialogFormFontTHSize + "'>" +
                            "       <div>" + (_msgArray[2].length > 0 ? ("<a class='lang lang-th font-family-th black regular " + _this1.dialogFormFontTHSize + "' href='javascript:void(0)' onclick=" + _callFunc + ">" + _msgArray[0] + "</a>") : ("<div class='lang lang-th font-family-th black regular " + _this1.dialogFormFontTHSize + "'>" + _msgArray[0] + "</div>")) + "</div>" +
                            "       <div>" + (_msgArray[2].length > 0 ? ("<a class='lang lang-en font-family-en black regular " + _this1.dialogFormFontENSize + "' href='javascript:void(0)' onclick=" + _callFunc + ">" + _msgArray[1] + "</a>") : ("<div class='lang lang-en font-family-en black regular " + _this1.dialogFormFontENSize + "'>" + _msgArray[1] + "</div>")) + "</div>" +
                            "   </li>";
            }

            _content += "   </ul>" +
                        "</div>";

            _this1.dialogMessageError({
                content: _content
            });
        }
    },
    dialogMessageForm: function (_param, _callBackFunc) {
        _param.title = (_param.title == undefined ? "" : _param.title);        
        _param.content = (_param.content == undefined ? "" : _param.content);
        _param.width = (_param.width == undefined || _param.width == "" || _param.width == 0 ? 800 : _param.width);
        _param.height = (_param.height == undefined || _param.height == "" || _param.height == 0 ? "auto" : _param.height);
        _param.idActive = (_param.idActive == undefined ? "" : _param.idActive);

        var _this = this;
        var _title;

        if (_param.content.length > 0) {
            if (_param.title.length > 0)
                _title = _param.title.split(":");

            if (_param.idActive.length > 0)
                $("#" + _param.idActive).addClass("active");

            BootstrapDialog.show({
                id: Util.dialogForm,
                size: BootstrapDialog.SIZE_LARGE,
                type: BootstrapDialog.TYPE_INFO,
                title: ("<div class='lang lang-th font-family-th white regular f8'>" + _title[0] + "</div>" +
                        "<div class='lang lang-en font-family-en white regular f8'>" + _title[1] + "</div>"),
                message: _param.content,
                animate: false,
                closable: true,
                closeByBackdrop: false,
                closeByKeyboard: false,
                draggable: true,
                onhidden: function(_d) {
                    if (_param.idActive.length > 0)
                        $("#" + _param.idActive).removeClass("active");

                    _callBackFunc("close");
                }
            });

            Util.setLanguageOnForm({
                id: ("#" + Util.dialogForm)
            });

            _this.setDialogFormLayout({
                width: _param.width
            });

            $(window).resize(function () {
                try {
                    _this.setDialogFormLayout({
                        width: _param.width
                    });
                }
                catch (_e) {
                }
            });
        }

        _callBackFunc();
    },
    trim: function (_id) {
        return $("#" + _id).val($.trim($("#" + _id).val()));
    },
    blockNonEnglish: function (_obj, _e) {
        var _key;
        var _isCtrl = false;
        var _keychar;
        var _reg;

        if (window.event) {
            _key = _e.keyCode;
            _isCtrl = window.event.ctrlKey
        }
        else {
            if (_e.which) {
                _key = _e.which;
                _isCtrl = _e.ctrlKey;
            }
        }

        if (isNaN(_key))
            return true;

        _keychar = String.fromCharCode(_key);

        if (_key == 8 || _isCtrl)
            return true;

        _reg = /^[A-Za-z .-]$/;

        return _reg.test(_keychar);
    },
    blockEnglish: function (_obj, _e) {
        var _key;
        var _isCtrl = false;
        var _keychar;
        var _reg;

        if (window.event) {
            _key = _e.keyCode;
            _isCtrl = window.event.ctrlKey
        }
        else {
            if (_e.which) {
                _key = _e.which;
                _isCtrl = _e.ctrlKey;
            }
        }

        if (isNaN(_key))
            return true;

        _keychar = String.fromCharCode(_key);

        if (_key == 8 || _isCtrl)
            return true;

        _reg = /^[A-Za-z]$/;

        return (_reg.test(_keychar) ? false : true);
    },
    blockNonEnglishAndNumeric: function (_obj, _e) {
        var _key;
        var _isCtrl = false;
        var _keychar;
        var _reg;

        if (window.event) {
            _key = _e.keyCode;
            _isCtrl = window.event.ctrlKey
        }
        else {
            if (_e.which) {
                _key = _e.which;
                _isCtrl = _e.ctrlKey;
            }
        }

        if (isNaN(_key))
            return true;

        _keychar = String.fromCharCode(_key);

        if (_key == 8 || _isCtrl)
            return true;

        _reg = /^[A-Za-z0-9-\/? ]$/;

        return _reg.test(_keychar);
    },
    blockNonNumbers: function (_obj, _e, _allowDecimal, _allowNegative) {
        var _key;
        var _isCtrl = false;
        var _keychar;
        var _reg;

        if (window.event) {
            _key = _e.keyCode;
            _isCtrl = window.event.ctrlKey
        }
        else {
            if (_e.which) {
                _key = _e.which;
                _isCtrl = _e.ctrlKey;
            }
        }

        if (isNaN(_key))
            return true;

        _keychar = String.fromCharCode(_key);

        if (_key == 8 || _isCtrl)
            return true;

        _reg = /\d/;

        var _isFirstN = (_allowNegative ? _keychar == "-" && _obj.value.indexOf("-") == -1 : false);
        var _isFirstD = (_allowDecimal ? _keychar == "." && _obj.value.indexOf(".") == -1 : false);

        return _isFirstN || _isFirstD || _reg.test(_keychar);
    },
    blockNonZipPostalCode: function (_obj, _e) {
        var _key;
        var _isCtrl = false;
        var _keychar;
        var _reg;

        if (window.event) {
            _key = _e.keyCode;
            _isCtrl = window.event.ctrlKey
        }
        else {
            if (_e.which) {
                _key = _e.which;
                _isCtrl = _e.ctrlKey;
            }
        }

        if (isNaN(_key))
            return true;

        _keychar = String.fromCharCode(_key);

        if (_key == 8 || _isCtrl)
            return true;

        _reg = /^[A-Z0-9a-z-]$/;

        return _reg.test(_keychar);
    },
    blockNonPhoneNumber: function (_obj, _e) {
        var _key;
        var _isCtrl = false;
        var _keychar;
        var _reg;

        if (window.event) {
            _key = _e.keyCode;
            _isCtrl = window.event.ctrlKey
        }
        else {
            if (_e.which) {
                _key = _e.which;
                _isCtrl = _e.ctrlKey;
            }
        }

        if (isNaN(_key))
            return true;

        _keychar = String.fromCharCode(_key);

        if (_key == 8 || _isCtrl)
            return true;

        //_reg = /^(?:(?:\(?(?:00|\+)([1-4]\d\d|[1-9]\d?)\)?)?[\-\.\ \\\/]?)?((?:\(?\d{1,}\)?[\-\.\ \\\/]?){0,})(?:[\-\.\ \\\/]?(?:#|ext\.?|extension|x)[\-\.\ \\\/]?(\d+))?$/i;
        _reg = /^[A-Z0-9a-z-?, ]$/;

        return _reg.test(_keychar);
    },
    blockCharNotWanted: function (_msg) {
        var _tempTxt = _msg;
        var _reg = "----------**********..........00000000000000000000.00";

        if (_reg.indexOf(_tempTxt) >= 0)
            _msg = "";

        return _msg;
    },
    blockAccount: function (_msg) {
        var _reg = /^(?!.*[^0-9A-Za-z]).{0,}$/;

        return _reg.test(_msg);
    },
    toUpperCaseFirst: function (_msg) {
        var _strPass = ["Of", "For", "The", "Is", "By"];
        var _strPassReplace = ["of", "for", "the", "is", "by"];

        _msg = _msg.toLowerCase().replace(/\b[a-z]/g, function (_letter) {
            return _letter.toUpperCase();
        });

        _msg = _msg.replace(_strPass[0], _strPassReplace[0]);
        _msg = _msg.replace(_strPass[1], _strPassReplace[1]);
        _msg = _msg.replace(_strPass[2], _strPassReplace[2]);
        _msg = _msg.replace(_strPass[3], _strPassReplace[3]);
        _msg = _msg.replace(_strPass[4], _strPassReplace[4]);

        return _msg;
    },
    isEnglishCharacter: function (_msg) {
        var _strValidChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        var _chr;
        var _isResult = true;

        if (_msg.length == 0)
            return false;

        for (_i = 0; _i < _msg.length && _isResult == true; _i++) {
            _chr = _msg.charAt(_i);

            if (_strValidChars.indexOf(_chr) == -1)
                _isResult = false;
        }

        return _isResult;
    },
    isNumeric: function (_msg) {
        var _strValidChars = "0123456789";
        var _chr;
        var _isResult = true;

        if (_msg.length == 0)
            return false;

        for (_i = 0; _i < _msg.length && _isResult == true; _i++) {
            _chr = _msg.charAt(_i);

            if (_strValidChars.indexOf(_chr) == -1)
                _isResult = false;
        }

        return _isResult;
    },
    isEmail: function (_msg) {
        var _emailPat = /^(.+)@(.+)$/;
        var _specialChars = "\\(\\)<>@,;:\\\\\\\"\\.\\[\\]";
        var _validChars = "\[^\\s" + _specialChars + "\]";
        var _quotedUser = "(\"[^\"]*\")";
        var _ipDomainPat = /^\[(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})\]$/;
        var _atom = _validChars + '+';
        var _word = "(" + _atom + "|" + _quotedUser + ")";
        var _userPat = new RegExp("^" + _word + "(\\." + _word + ")*$");
        var _domainPat = new RegExp("^" + _atom + "(\\." + _atom + ")*$");
        var _matchArray = _msg.match(_emailPat);

        if (_matchArray == null)
            return false;

        var _user = _matchArray[1];
        var _domain = _matchArray[2];

        if (_user.match(_userPat) == null)
            return false;

        var _ipArray = _domain.match(_ipDomainPat);

        if (_ipArray != null) {
            for (var _i = 1; _i <= 4; _i++) {
                if (_ipArray[i] > 255)
                    return false;
            }

            return true;
        }

        var _domainArray = _domain.match(_domainPat);

        if (_domainArray == null)
            return false;

        var _atomPat = new RegExp(_atom, "g");
        var _domArr = _domain.match(_atomPat);
        var _len = _domArr.length;

        if (_domArr[_domArr.length - 1].length < 2 || _domArr[_domArr.length - 1].length > 3)
            return false;

        if (_len < 2)
            return false

        return true;
    },
    isURL: function (_msg) {
        var _regExp = /^(([\w]+:)?\/\/)?(([\d\w]|%[a-fA-f\d]{2,2})+(:([\d\w]|%[a-fA-f\d]{2,2})+)?@)?([\d\w][-\d\w]{0,253}[\d\w]\.)+[\w]{2,4}(:[\d]+)?(\/([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)*(\?(&?([-+_~.\d\w]|%[a-fA-f\d]{2,2})=?)*)?(#([-+_~.\d\w]|%[a-fA-f\d]{2,2})*)?$/;

        return _regExp.test(_msg);
    },
    isDate: function (_param) {
        _param.day = (_param.day == undefined || _param.day == "" || _param.day == 0 ? "1" : _param.day);
        _param.month = (_param.month == undefined || _param.month == "" || _param.month == 0 ? "1" : _param.month);
        _param.year = (_param.year == undefined || _param.year == "" || _param.year == 0 ? "2000" : _param.year);

        var _daysInMonth = this.daysArray(12);
        var _date = (_param.day + "-" + _param.month + "-" + _param.year);

        if (_date != "00-00-0000") {
            if (_param.day == "00")
                return false;

            if (_param.month == "00")
                return false;

            if (_param.year == "0000")
                return false;

            if (((parseInt(_param.month) == 2) && (_param.day > this.daysInFebruary(_param.year))) || (_param.day > _daysInMonth[parseInt(_param.month)]))
                return false;
        }

        return true;
    },
    daysArray: function (_numberOfMonths) {
        _numberOfMonths = (_numberOfMonths == "" || _numberOfMonths == 0 ? 12 : _numberOfMonths);

        for (var _i = 1; _i <= _numberOfMonths; _i++) {
            this[_i] = 31;

            if (_i == 4 || _i == 6 || _i == 9 || _i == 11)
                this[_i] = 30;

            if (_i == 2)
                this[_i] = 29;
        }

        return this;
    },
    daysInFebruary: function (_year) {
        _year = (_year == "" || _year == 0 ? "2000" : _year);

        return (((_year % 4 == 0) && ((!(_year % 100 == 0)) || (_year % 400 == 0))) ? 29 : 28);
    },
    dateDiff: function (_date1, _date2, _interval) {
        var _second = 1000;
        var _minute = _second * 60;
        var _hour = _minute * 60;
        var _day = _hour * 24;
        var _week = _day * 7;

        _date1 = new Date(_date1);
        _date2 = new Date(_date2);

        var _timeDiff = (_date2 - _date1);

        if (isNaN(_timeDiff))
            return NaN;

        switch (_interval)
        {
            case "years":
                return (_date2.getFullYear() - _date1.getFullYear());
            case "months":
                return ((_date2.getFullYear() * 12 + _date2.getMonth()) - (_date1.getFullYear() * 12 + _date1.getMonth()));
            case "weeks":
                return Math.floor(_timeDiff / _week);
            case "days":
                return Math.floor(_timeDiff / _day);
            case "hours":
                return Math.floor(_timeDiff / _hour);
            case "minutes":
                return Math.floor(_timeDiff / _minute);
            case "seconds":
                return Math.floor(_timeDiff / _second);
            default:
                return undefined;
        }
    },
    extractNumber: function (_obj, _decimalPlaces, _allowNegative) {
        var _temp = _obj.value;
        var _reg0Str = "[0-9]*";

        if (_decimalPlaces > 0)
            _reg0Str += "\\.?[0-9]{0," + _decimalPlaces + "}";
        else
            if (_decimalPlaces < 0)
                _reg0Str += "\\.?[0-9]*";

        _reg0Str = _allowNegative ? "^-?" + _reg0Str : "^" + _reg0Str;
        _reg0Str = _reg0Str + "$";

        var _reg0 = new RegExp(_reg0Str);

        if (_reg0.test(_temp))
            return true;

        var _reg1Str = "[^0-9" + (_decimalPlaces != 0 ? "." : "") + (_allowNegative ? "-" : "") + "]";
        var _reg1 = new RegExp(_reg1Str, "g");

        _temp = _temp.replace(_reg1, "");

        if (_allowNegative) { 
            var _hasNegative = _temp.length > 0 && _temp.charAt(0) == "-";
            var _reg2 = /-/g;

            _temp = _temp.replace(_reg2, "");

            if (_hasNegative)
                _temp = "-" + _temp;
        }

        if (_decimalPlaces != 0) {
            var _reg3 = /\./g;
            var _reg3Array = _reg3.exec(_temp);

            if (_reg3Array != null) {
                var _reg3Right = _temp.substring(_reg3Array.index + _reg3Array[0].length);

                _reg3Right = _reg3Right.replace(_reg3, "");
                _reg3Right = _decimalPlaces > 0 ? _reg3Right.substring(0, _decimalPlaces) : _reg3Right;
                _temp = _temp.substring(0, _reg3Array.index) + "." + _reg3Right;
            }
        }

        _obj.value = _temp;
    },
    addCommas: function (_id, _decimalPlaces) {
        $("#" + _id).val(this.blockCharNotWanted($("#" + _id).val()));

        var _msg = parseFloat(this.delCommas(_id).length > 0 ? this.delCommas(_id) : "0").toString();

        _msg += "";

        var _x = _msg.split(".");
        var _i, _j;

        _x1 = _x[0];

        var _x2 = _x.length > 1 ? "." + _x[1] : "";

        if (_x2.length > 0)
            _x1 = _x1.length == 0 ? "0" : _x1;

        if (parseInt(_x1) == 0)
            _x1 = "0";

        if (_x1.length > 0 && _decimalPlaces != null && _decimalPlaces != 0) {
            if (_x2.length > 0) {
                if (_x[1].length < _decimalPlaces) {
                    _i = _decimalPlaces - _x[1].length;

                    for (_j = 0; _j < _i; _j++) {
                        _x[1] = _x[1] + "0";
                    }
                }

                _x2 = "." + _x[1];
            }
            else {
                _x2 = ".";

                for (_i = 0; _i < _decimalPlaces; _i++) {
                    _x2 = _x2 + "0";
                }
            }
        }

        var _rgx = /(\d+)(\d{3})/;

        while (_rgx.test(_x1)) {
            _x1 = _x1.replace(_rgx, "$1" + "," + "$2");
        }

        $("#" + _id).val(_x1 + _x2);

        return _x1 + _x2;
    },
    delCommas: function (_id) {
        var _msg = $("#" + _id).val();

        _msg += "";

        for (var _i = 0; _i < _msg.length; _i++)
            _msg = _msg.replace(",", "");

        return _msg;
    },
    removeCommas: function (_msg) {
        return _msg.replace(",", "");;
    },
    resetForm: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);

        $("#" + _param.id + " input:text").val("");
        $("#" + _param.id + " input:password").val("");
        $("#" + _param.id + " input:radio").prop("checked", false);
        $("#" + _param.id + " input:checkbox").prop("checked", false);
        $("#" + _param.id + " input:text, #" + _param.id + " input:password, #" + _param.id + " .textareabox").css({
            borderWidth: "2px",
            borderColor: "#BDC3C7"
        });
    },
    gotoElement: function (_param) {
        _param.anchorName = (_param.anchorName == undefined ? "" : _param.anchorName);
        _param.inputName = (_param.inputName == undefined ? "" : _param.inputName);
        _param.top = (_param.top == undefined ? 0 : _param.top);

        var _anchor = $(_param.anchorName);
        var _input  = $(_param.inputName);
        var _offset = _anchor.offset();
        
        if (_param.anchorName.length > 0 && _anchor.length > 0) {
            $("html, body").animate({
                scrollTop: ((_offset.top) - _param.top)
            }, 500);

            if (_param.inputName.length > 0 && _input.length > 0)
                _input.animate({
                    borderWidth: "2px",
                    borderColor: "#E74C3C"
                }, "fast");
        }
    },
    gotoTopElement: function () {
        $("html, body").animate({
            scrollTop: 0
        }, 500);
    },
    gotoNavPage: function (_param) {
        _param.page = (_param.page == undefined ? "" : _param.page);
        _param.currentPage = (_param.currentPage == undefined ? 1 : _param.currentPage);
        _param.startRow = (_param.startRow == undefined ? 1 : _param.startRow);
        _param.endRow = (_param.endRow == undefined ? 1 : _param.endRow);

        var _this = this;
        var _data = this.tut.tse.getValueSearch({
            page: _param.page
        });
        var _paramSearch = _data.paramSearch;
        _paramSearch.currentPage = _param.currentPage;
        _paramSearch.startRow = _param.startRow;
        _paramSearch.endRow = _param.endRow;

        this.msgPreloading = "Loading...";

        this.tut.tse.actionSearch({
            pageMain: _data.pageMain,
            pageSearch: _data.pageSearch,
            idChart: _data.chart,
            idTable: _data.table,
            data: _paramSearch,
        });
    },
    gotoTab: function (_param, _callBackFunc) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.idContent = (_param.idContent == undefined ? "" : _param.idContent);
        _param.showContentByTab = (_param.showContentByTab == undefined || _param.showContentByTab == "" ? true : _param.showContentByTab);
        _param.idLink = (_param.idLink == undefined ? "" : _param.idLink);
        _param.classActive = (_param.classActive == undefined || _param.classActive == "" ? "active" : _param.classActive);
        _param.classNoActive = (_param.classNoActive == undefined || _param.classNoActive == "" ? "noactive" : _param.classNoActive);
        
        var _idContent = $("#" + _param.idLink).attr("alt");

        $(_param.id + " ul li a").removeClass(_param.classActive).addClass(_param.classNoActive);
        $("#" + _param.idLink).removeClass(_param.classNoActive).addClass(_param.classActive);

        if (_param.showContentByTab == true) {
            $(_param.idContent + " ." + _param.classActive).removeClass(_param.classActive).addClass(_param.classNoActive);
            $("#" + _idContent).removeClass(_param.classNoActive).addClass(_param.classActive);
            
            $(_param.idContent + " ." + _param.classNoActive).hide();
            $(_param.idContent + " ." + _param.classActive).show();
        }

        _callBackFunc(_idContent);
    },
    gotoPage: function (_param) {
        _param.page = (_param.page == undefined ? "" : _param.page);
        _param.target = (_param.target == undefined || _param.target == "" ? "_top" : _param.target);

        var _w

        if (_param.page.length > 0) {
            try {
                _w = window.open(_param.page, _param.target);
            }
            catch(_error) {
                _w = window.open(_page, "_top");
            }
        }

        return _w;
    },
    getBlank: function (_msg) {
        return (_msg.length == 0 ? "-" : _msg);
    },
    clearContentIFrame: function (_id) {
        $(_id).contents().empty();
    },
    initTextSelect: function () {
        var _this = this;

        $(function () {
            $(function () {
                $("input:text, input:password, textarea").focus(function () {
                    if ($(this).is(":disabled") == false) {
                        if ($(this).closest(".textareabox").length == 0) {
                            $(this).css({
                                borderWidth: "2px",
                                borderColor: "#5CB85C"
                            });
                        }

                        $(this).closest(".textareabox").css({
                            borderWidth: "2px",
                            borderColor: "#5CB85C"
                        });
                    }

                    if ($(this).hasClass("textbox-numeric") == true)
                        $(this).val(_this.delCommas($(this).attr("id")));
                });

                $("input:text, input:password, textarea").mouseup(function (_e) {
                    if ($(this).is(":disabled") == false)
                        _e.preventDefault();
                });

                $("input:text, input:password, textarea").blur(function () {
                    if ($(this).closest(".textareabox").length == 0) {
                        $(this).css({
                            borderWidth: "2px",
                            borderColor: "#BDC3C7"
                        });
                    }

                    $(this).closest(".textareabox").css({
                        borderWidth: "2px",
                        borderColor: "#BDC3C7"
                    });

                    _this.trim($(this).attr("id"));
                    
                    $(this).val(_this.blockCharNotWanted($(this).val()));
                });

                $(".inputcalendar").keydown(function (_e) {
                    var _keyCode = _e.keyCode || _e.which;
                    
                    if (_e.keyCode != 8 && _e.keyCode != 46 && _e.keyCode != 9 && _e.keyCode != 37 && _e.keyCode != 39)
                        return false;
                    else
                        return true;
                });

                $(".inputcalendar").change(function () {
                    if ($(this).val().length < 10)
                        $(this).val("");
                });
            });
        });
    },
    initCombobox: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.width = (_param.width == undefined || _param.width == "" ? 0 : _param.width);
        _param.height = (_param.height == undefined || _param.height == "" ? 0 : _param.height);
        _param.fontSizeCombobox = (_param.fontSizeCombobox == undefined ? "" : _param.fontSizeCombobox);
        _param.searchDropDown = (_param.searchDropDown == undefined ? true : _param.searchDropDown);
        
        var _this = this;

        $(_param.id + " select").select2({
        }).on("select2:open", function () {
            $(_param.id + " .select2-container .select2-selection--single").css({
                borderWidth: "2px",
                borderColor: "#5CB85C"
            });

            $(".select2-dropdown").addClass("lang lang-th font-family-th black regular f10default");
            $(".select2-search--dropdown").hide();

            if (_param.searchDropDown == true) {
                $(".select2-search--dropdown").show();
                $(".select2-search--dropdown .select2-search__field").addClass("font-family-th black regular f10default");
            }
        }).on("select2:close", function () {
            $(_param.id + " .select2-container .select2-selection--single").css({
                borderWidth: "2px",
                borderColor: "#BDC3C7"
            });
        }).on("select2:select", function () {
            _this.tut.setSelectCombobox({
                id: _param.id,
                value: $(this).val()
            });
        });

        this.comboboxSetSize({
            id: _param.id,
            width: _param.width,
            height: _param.height,
            fontSizeCombobox: _param.fontSizeCombobox
        });
    },
    initCheck: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);

        $("input[name=" + _param.id + "]").iCheck({
            checkboxClass: "icheckbox_minimal",
            radioClass: "iradio_minimal"
        });
    },
    initCalendar: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.buddhist = (_param.buddhist == undefined || _param.buddhist == "" ? false : _param.buddhist);
        _param.yearRange = (_param.yearRange == undefined || _param.yearRange == "" ? "-1:+1" : _param.yearRange);
        _param.minDate = (_param.minDate == undefined ? "" : _param.minDate);
        _param.maxDate = (_param.maxDate == undefined ? "" : _param.maxDate);

        var _this = this;

        $(document).ready(function () {
            $(_param.id).datepicker({
                buttonImage: ("../../../Content/Image/" + (_this1.tut.pathProject.length > 0 ? (_this1.tut.pathProject + "/") : "") + "DatePicker.png"),
                buttonImageOnly: true,
                showOn: "button",
                showAnim: "",
                prevText: "",
                nextText: "",
                changeMonth: true,
                changeYear: true,
                yearRange: _param.yearRange,
                dateFormat: "dd/mm/yy",
                isBuddhist: _param.buddhist,
                monthNamesShort: (_param.buddhist == true ? ["ม.ค.", "ก.พ.", "มี.ค.", "เม.ย.", "พ.ค.", "มิ.ย.", "ก.ค.", "ส.ค.", "ก.ย.", "ต.ค.", "พ.ย.", "ธ.ค."] : ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]),
                beforeShow: function () {
                    if (_param.minDate.length > 0)
                        $(_param.id).datepicker("option", "minDate", _param.minDate);

                    if (_param.maxDate.length > 0)
                        $(_param.id).datepicker("option", "maxDate", _param.maxDate);

                    $("img.ui-datepicker-trigger").css({
                        "vertical-align": "bottom",
                        "margin-left": "2px"
                    });
                }
            });

            $("img.ui-datepicker-trigger").css({
                "vertical-align": "bottom",
                "margin-left": "2px"
            });
        });
    },
    initCalendarFromTo: function (_param) {
        _param.idFrom = (_param.idFrom == undefined ? "" : _param.idFrom);
        _param.fixFrom = (_param.fixFrom == undefined || _param.fixFrom == "" ? false : _param.fixFrom);
        _param.idTo = (_param.idTo == undefined ? "" : _param.idTo);
        _param.fixTo = (_param.fixTo == undefined || _param.fixTo == "" ? false : _param.fixTo);
        _param.buddhist = (_param.buddhist == undefined || _param.buddhist == "" ? false : _param.buddhist);
        _param.yearRange = (_param.yearRange == undefined || _param.yearRange == "" ? "-1:+1" : _param.yearRange);
        _param.minDate = (_param.minDate   == undefined ? "" : _param.minDate  );
        _param.maxDate = (_param.maxDate == undefined ? "" : _param.maxDate);

        var _this = this;

        $(document).ready(function () {
            if (_param.fixFrom == false) {
                $(_param.idFrom).datepicker({
                    buttonImage: ("../../../Content/Image/" + (_this1.tut.pathProject.length > 0 ? (_this1.tut.pathProject + "/") : "") + "DatePicker.png"),
                    buttonImageOnly: true,
                    showOn: "button",
                    showAnim: "",
                    prevText: "",
                    nextText: "",
                    changeMonth: true,
                    changeYear: true,
                    yearRange: _param.yearRange,
                    dateFormat: "dd/mm/yy",
                    isBuddhist: _param.buddhist,
                    monthNamesShort: (_param.buddhist == true ? ["ม.ค.", "ก.พ.", "มี.ค.", "เม.ย.", "พ.ค.", "มิ.ย.", "ก.ค.", "ส.ค.", "ก.ย.", "ต.ค.", "พ.ย.", "ธ.ค."] : ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]),
                    beforeShow: function () {
                        if (_param.minDate.length > 0)
                            $(_param.idFrom).datepicker("option", "minDate", _param.minDate);

                        if (_param.maxDate.length > 0)
                            $(_param.idFrom).datepicker("option", "maxDate", _param.maxDate);

                        if ($(_param.idTo).val().length > 0)
                            $(_param.idFrom).datepicker("option", "maxDate", $(_param.idTo).val());

                        $("img.ui-datepicker-trigger").css({
                            "vertical-align": "bottom",
                            "margin-left": "2px"
                        });
                    }
                });

                $("img.ui-datepicker-trigger").css({
                    "vertical-align": "bottom",
                    "margin-left": "2px"
                });
            }

            if (_param.fixTo == false) {
                $(_param.idTo).datepicker({
                    buttonImage: ("../../../Content/Image/" + (_this1.tut.pathProject.length > 0 ? (_this1.tut.pathProject + "/") : "") + "DatePicker.png"),
                    buttonImageOnly: true,
                    showOn: "button",
                    showAnim: "",
                    prevText: "",
                    nextText: "",
                    changeMonth: true,
                    changeYear: true,
                    yearRange: _param.yearRange,
                    dateFormat: "dd/mm/yy",
                    isBuddhist: _param.buddhist,
                    monthNamesShort: (_param.buddhist == true ? ["ม.ค.", "ก.พ.", "มี.ค.", "เม.ย.", "พ.ค.", "มิ.ย.", "ก.ค.", "ส.ค.", "ก.ย.", "ต.ค.", "พ.ย.", "ธ.ค."] : ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]),
                    beforeShow: function () {
                        if (_param.minDate.length > 0)
                            $(_param.idTo).datepicker("option", "minDate", _param.minDate);

                        if (_param.maxDate.length > 0)
                            $(_param.idTo).datepicker("option", "maxDate", _param.maxDate);

                        if ($(_param.idFrom).val().length > 0)
                            $(_param.idTo).datepicker("option", "minDate", $(_param.idFrom).val());

                        $("img.ui-datepicker-trigger").css({
                            "vertical-align": "bottom",
                            "margin-left": "2px"
                        });
                    }
                });

                $("img.ui-datepicker-trigger").css({
                    "vertical-align": "bottom",
                    "margin-left": "2px"
                });
            }
        });
    },
    initUploadFile: function () {
        $(function () {
            $(".uploadfile-form").trigger("reset");
            $(".uploadfile-form input[type='text']").prop("disabled", true);
            $(".uploadfile-form .uploadfile-button input[type='file']").css({
                cursor: "pointer",
                position: "absolute",
                top: 0,
                left: 0,
                opacity: 0
            });
            $(".uploadfile-form .link-file").hide();
            
            $(".uploadfile-form .uploadfile-button").mousemove(function (_e) {
                var _offL;
                var _offR;
                var _idButtonUpload = ($(this).attr("id"));
                var _idBrowseFile = $("#" + _idButtonUpload + " input[type='file']").attr("id");

                _offL = $(this).offset().left;
                _offT = $(this).offset().top;

                $("#" + _idBrowseFile).css({
                    left: ((_e.pageX - _offL - $("#" + _idBrowseFile).width()) + 40),
                    top: (_e.pageY - _offT - 10)
                })
            });
            
            $(".uploadfile-form .uploadfile-button input[type='file']").change(function () {
                var _idLabelBrowseFile = $(this).attr("alt") + "-label";
                var _filename = $(this).val().split("\\").pop();

                $("#" + _idLabelBrowseFile).html(_filename.toLowerCase()).show();
            });
        });
    },

    initDragAndCropImage: function (_param, _callBackFunc) {
        _param.id       = (_param.id == undefined ? "" : _param.id);
        _param.width    = (_param.width == undefined || _param.width == "" || _param.width == 0 ? 100 : _param.width);
        _param.height   = (_param.height == undefined || _param.height == "" || _param.height == 0 ? 100 : _param.height);

        $(function () {
            $(_param.id).jWindowCrop({
                targetWidth: _param.width,
                targetHeight: _param.height,
                onChange: function (_result) {
                    _callBackFunc(_result);
                }
            });
        });
    },
    initTab: function (_param, _callBackFunc) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.idContent = (_param.idContent == undefined ? "" : _param.idContent);
        _param.showContentByTab = (_param.showContentByTab == undefined || _param.showContentByTab == "" ? true : _param.showContentByTab);
        _param.classActive = (_param.classActive == undefined || _param.classActive == "" ? "active" : _param.classActive);
        _param.classNoActive = (_param.classNoActive == undefined || _param.classNoActive == "" ? "noactive" : _param.classNoActive);

        var _this = this;

        $(document).ready(function () {
            $(_param.idContent + " ." + _param.classNoActive).hide();
            $(_param.id + " ul li a").click(function () {
                var _idLink = $(this).attr("id");

                _this.gotoTab({
                    id: _param.id,
                    idContent: _param.idContent,
                    showContentByTab: _param.showContentByTab,
                    idLink: _idLink,
                    classActive: _param.classActive,
                    classNoActive: _param.classNoActive
                }, function (_result) {
                    _this.dialogMessageClose();
                    
                    if (_param.showContentByTab == true) {
                        if ($("#" + Util.dialogForm + "1").is(":visible") == false)
                            _this.gotoTopElement();
                    }
                    else
                        _this.gotoElement({
                            anchorName: ("#" + _result)
                        });

                    _callBackFunc(_result);
                });
            });
        });
    },    
    initTabChartTable: function(_param, _callBackFunc) {        
        _param.this = (_param.this == undefined || _param.this == "" ? null : _param.this);
        _param.section = (_param.section == undefined || _param.section == "" ? null : _param.section);

        var _this1 = this;
        var _this2 = _param.this.viewchart;
        var _this3 = _param.this.viewtable;
        var _getTab = false;
        
        if ($("#infobar-" + _param.section.toLowerCase() + " .operator-profile").length > 0)
            $("#infobar-" + _param.section.toLowerCase() + " .operator-profile").hide();

        $("#" + _param.this.idSectionMain + "-content").css("padding-top", $("#" + _param.this.idSectionMain + "-viewsdisplay.tabbar").outerHeight());
            
        this.initTab({
            id: ("#" + _param.this.idSectionMain + "-viewsdisplay-content"),
            idContent: ("#" + _param.this.idSectionMain + "-content"),
            showContentByTab: true,
            classActive: "tab-active",
            classNoActive: "tab-noactive"
        }, function (_result) {
            var _idLink = _result;
            
            if (_idLink == _this2.idSectionMain) {
                if ($("#infobar-" + _param.section.toLowerCase() + " .operator-profile").length > 0)
                    $("#infobar-" + _param.section.toLowerCase() + " .operator-profile").hide();

                if ($("#" + _this3.idSectionMain).length > 0 && $("#" + _this3.idSectionMain).html().length > 0) {
                    if (($("#" + _this3.idSectionMain + " .table-recordcount .recordcount-search").html().length > 0 && ($("#" + _this2.idSectionMain + " .chart-recordcount .recordcount-search").length == 0 || $("#" + _this2.idSectionMain + " .chart-recordcount .recordcount-search").html().length == 0)) ||
                        ($("#" + _this3.idSectionMain + " .table-recordcount .recordcount-search").html().length == 0 && $("#" + _this2.idSectionMain).html().length == 0))
                        _getTab = true;
                    else
                        _getTab = false;
                }
                else
                    _getTab = false;
            }

            if (_idLink == _this3.idSectionMain) {
                if ($("#infobar-" + _param.section.toLowerCase() + " .operator-profile").length > 0)
                    $("#infobar-" + _param.section.toLowerCase() + " .operator-profile").show();

                if ($("#" + _this2.idSectionMain).length > 0 && $("#" + _this2.idSectionMain).html().length > 0) {
                    if (($("#" + _this2.idSectionMain + " .chart-recordcount .recordcount-search").html().length > 0 && ($("#" + _this3.idSectionMain + " .table-recordcount .recordcount-search").length == 0 || $("#" + _this3.idSectionMain + " .table-recordcount .recordcount-search").html().length == 0)) ||
                        ($("#" + _this2.idSectionMain + " .chart-recordcount .recordcount-search").html().length == 0 && $("#" + _this3.idSectionMain).html().length == 0))
                        _getTab = true;
                    else 
                        _getTab = false;
                }
                else
                    _getTab = false;
            }
           
            _this1.setMenuBarLayout();
            _this1.setInfoBarLayout();
            _this1.setChartLayout();
            _this1.setTableLayout();
            _this1.setFooterLayout();

            if (_getTab == true) {
                _this1.getTabOnClick({
                    idLink: _idLink
                }, function (_result) {
                    _this1.setChartLayout();
                    _this1.setTableLayout();
                    
                    if (_result == true) {
                        if (_idLink == _this2.idSectionMain)
                            _this2.sectionMain.initMain();
                        
                        if (_idLink == _this3.idSectionMain) {
                            _this3.sectionMain.initMain({});
                            _this3.sectionMain.initTable({});
                            _this1.initTable();
                        }
                    }

                    _callBackFunc(_result);
                });
            }
            else
                _callBackFunc(false);
        });
    },    
    initTable: function () {
        var _this = this;

        if ($(".select-child").length > 0)
            _this.initCheck({
                id: "select-child"
            });

        $(".select-root").on("ifChecked ifUnchecked", function (_e) {
            var _idCheckboxRoot = $(this).attr("name");

            _this.dialogMessageClose();

            if (_idCheckboxRoot == "select-root") {
                var _idCheckboxChild = $(this).attr("alt");

                _this.uncheckboxAll({
                    idRoot: _idCheckboxRoot,
                    idChild: _idCheckboxChild
                });
            }
        });

        $(".select-child").on("ifUnchecked", function () {
            var _idCheckboxChild = $(this).attr("name");

            _this.dialogMessageClose();

            if (_idCheckboxChild == "select-child") {
                var _idCheckboxRoot = $(this).attr("alt");

                _this.uncheckboxRoot(_idCheckboxRoot);
            }
        });
    },
    initTableLayoutWidthDynamic: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        
        $("#" + _param.id + ".table-width-dynamic .table-list").scroll(function () {
            var _hr = $("#" + _param.id + ".table-width-dynamic .table-content .table-head");
            var _ls = $("#" + _param.id + ".table-width-dynamic .table-list");

            _hr.css("left", (-_ls.scrollLeft() + "px"));
        });
    },
    initSearch: function () {
        var _this = this;
        
        $(".form.search .form-content .inputbox, .form.search .form-content .combobox, .search .inputbox").keypress(function () {
            _this.clearTable();
            _this.tut.tse.clearTable();
            _this.dialogMessageClose();
        });

        $(".form.search .form-content .inputbox, .form.search .form-content .combobox, .search .inputbox, .search .combobox").change(function () {
            _this.clearTable();
            _this.tut.tse.clearTable();
            _this.dialogMessageClose();
        });
        
        $(".form.search .button-toggle a").click(function () {
            if ($(".form.search .search-layout").is(":visible")) {
                $(".form.search .search-layout").hide();
                $(this).html("S<br />H<br />O<br />W<br /><br />M<br />O<br />R<br />E");
            }
            else {
                $(".form.search .search-layout").show();
                $(this).html("S<br />H<br />O<br />W<br /><br />L<br />E<br />S<br />S");
            }

            _this.tut.tse.setSearchLayout();
            _this.setMainLayout();
            _this.setChartLayout();
            _this.setTableLayout();
            _this.setFooterLayout();
        });

        $(".form.search .form-content .button .click-button, .search .btn-command a").click(function () {
            var _page = $(this).attr("alt");

            if ($(this).hasClass("button-toggle")) {
                if ($(".search .panel-body").is(":visible") == false) {
                    $(".search .button-toggle span").removeClass("glyphicon-menu-down").addClass("glyphicon-menu-up");
                    $(".search .panel-heading").css("border-bottom-width", "1px");
                    $(".search .panel-body").show();
                }
                else {
                    $(".search .button-toggle span").removeClass("glyphicon-menu-up").addClass("glyphicon-menu-down");
                    $(".search .panel-heading").css("border-bottom-width", "0px");
                    $(".search .panel-body").hide();
                }
            }

            if ($(this).hasClass("button-search")) {
                if (_this.tut.tse.validateSearch({
                    page: _page
                }))
                    _this.tut.tse.getSearch({
                        page: _page,
                        setSearchShow: true
                    });
            }
            
            if ($(this).hasClass("button-undo") || $(this).hasClass("button-reset")) {
                _this.tut.tse.resetSearch({
                    page: _page
                });
                _this.clearTable();
                _this.tut.tse.clearTable();
                _this.gotoTopElement();
            }
        });
    },
    initAddUpdateMessage: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.idMessage = (_param.idMessage == undefined ? "" : _param.idMessage);
    
        var _this = this;

        $("#" + _param.id + "-form .button a").click(function () {
            if ($(this).hasClass("button-save")) {
                if (_this.validateAddUpdateMessage({
                    id: _param.id,
                    idMessage: _param.idMessage
                })) {
                    $("#" + _param.idMessage).val($("#" + _param.id + "-form .textareabox").val());
                    $("#" + _this.dialogForm + "1").dialog("close");
                }
            }

            if ($(this).hasClass("button-undo"))
                _this.resetAddUpdateMessage({
                    id: _param.id,
                    idMessage: _param.idMessage
                });
        });
    },
    initTooltip: function () {
        $("[data-toggle='tooltip']").tooltip({
            container: "body",
            html: true
        });
    },
    initMenuBar: function () {
        var _objMenuToggle = $(".navbar-menu-toggle");

        $("main .navbar .navbar-menu .navbar-toggle").click(function (event) {
            $("main .navbar .navbar-menu .navbar-collapse").hide();

            if (_objMenuToggle.is(":visible"))
                _objMenuToggle.removeClass("active");
            else
                _objMenuToggle.addClass("active").show();
        });
    },
    resetAddUpdateMessage: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.idMessage = (_param.idMessage == undefined ? "" : _param.idMessage);

        var _valueMessage = $("#" + _param.idMessage).val();

        $("#" + _param.id + "-form .button-save").focus();
        $("#" + _param.id + "-form .textareabox").val(_valueMessage);
    },
    validateAddUpdateMessage: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.idMessage = (_param.idMessage == undefined ? "" : _param.idMessage);

        var _this = this;
        var _error = false;
        var _msgTH;
        var _msgEN;

        if (_error == false && $("#" + _param.id + "-form .textareabox").val().length == 0) {
            _error = true;
            _msgTH = "กรุณาใส่ข้อความ";
            _msgEN = "Please enter a message.";
        }

        if (_error == true) {
            _this.dialogMessageError({
                content: ("<div class='th-label'>" + _msgTH + "</div><div class='en-label'>" + _msgEN + "</div>"),
                modal: false
            });

            return false;
        }

        return true;
    },
    comboboxSetSize: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.width = (_param.width == undefined || _param.width == "" ? 0 : _param.width);
        _param.height = (_param.height== undefined || _param.height == "" ? 0 : _param.height);
        _param.fontSizeCombobox = (_param.fontSizeCombobox == undefined ? "" : _param.fontSizeCombobox);

        var _width = (_param.width > 0 ? _param.width : "99.9%");
        var _height = _param.height;

        $(_param.id + " select").select2({
            width: _width
        });

        if (_param.width > 0) {
            $(_param.id + " .select2-container .select2-selection--single").css({
                width: _param.width
            });
        }

        if (_param.height > 0) {
            $(_param.id + " .select2-container .select2-selection--single").css({
                height: _param.height
            });
        }
        
        var _objSelectionRendered = $(_param.id + " .select2-container--default .select2-selection--single .select2-selection__rendered");
        var _objSelectionArrow = $(_param.id + " .select2-container--default .select2-selection--single .select2-selection__arrow");

        _objSelectionArrow.css({
            "height": ((($(_param.id).height() / 2) + 10) + "px")
        });

        Util.setLanguageOnCombobox({
            id: _param.id,
            fontSizeCombobox: _param.fontSizeCombobox
        });
    },
    comboboxDisable: function (_param, _callBackFunc) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.width = (_param.width == undefined || _param.width == "" ? 0 : _param.width);
        _param.height = (_param.height == undefined || _param.height == "" ? 0 : _param.height);
        _param.fontSizeCombobox = (_param.fontSizeCombobox == undefined ? "" : _param.fontSizeCombobox);

        var _i = 0;

        _id = _param.id.split(",")

        for (_i = 0; _i < _id.length; _i++) {
            $(_id[_i] + " select").select2("destroy");
            $(_id[_i] + " select").prop("disabled", true);

            this.initCombobox({
                id: _id[_i],
                width: _param.width,
                height: _param.height,
                fontSizeCombobox: _param.fontSizeCombobox
            });

            $(_id[_i] + " .select2-container .select2-selection--single").css({
                background: "#B3B3B9",
                color: "#000000"
            });
        }

        _callBackFunc();
    },
    comboboxEnable: function (_param, _callBackFunc) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.width = (_param.width == undefined || _param.width == "" ? 0 : _param.width);
        _param.height = (_param.height == undefined || _param.height == "" ? 0 : _param.height);
        _param.fontSizeCombobox = (_param.fontSizeCombobox == undefined ? "" : _param.fontSizeCombobox);

        var _i = 0;

        _id = _param.id.split(",")

        for (_i = 0; _i < _id.length; _i++) {
            $(_id[_i] + " select").select2("destroy");
            $(_id[_i] + " select").prop("disabled", false);

            this.initCombobox({
                id: _id[_i],
                width: _param.width,
                height: _param.height,
                fontSizeCombobox: _param.fontSizeCombobox
            });

            $(_id[_i] + " .select2-container .select2-selection--single").css({
                background: "#FFFFFF",
                color: "#000000"
            });
        }

        _callBackFunc();
    },
    comboboxSetValue: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.value = (_param.value == undefined ? "" : _param.value);
        
        var _i = 0
        var _id = _param.id.split(",")

        for (_i = 0; _i < _id.length; _i++) {
            $(_id[_i] + " select").val(_param.value).trigger("change");

            if (this.comboboxGetValue(_id[_i]) == null)
                $(_id[_i] + " select").val("0").trigger("change");
        }
    },
    comboboxGetValue: function (_id) {
        return $(_id + " select").val();
    },
    checkSetValue: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.value = (_param.value == undefined ? "" : _param.value);

        $("input[name=" + _param.id + "]").filter("[value='" + _param.value + "']").iCheck("check");
        $("input[name=" + _param.id + "]").iCheck("update");
    },
    checkGetValue: function (_id) {
        return ($("input[name=" + _id + "]").is(":checked") == true ? $("input[name=" + _id + "]:checked").val() : "");
    },
    uncheckboxRoot: function (_id) {
        if ($("#" + _id).is(":checked") == true) {
            _obj = ("input[name=" + _id + "]");
            $(_obj).iCheck("uncheck");
        }
    },
    uncheckboxAll: function (_param) {
        _param.idRoot = (_param.idRoot == undefined ? "" : _param.idRoot);
        _param.idChild = (_param.idChild == undefined ? "" : _param.idChild);

        _obj = ("input[name=" + _param.idChild + "]");

        if ($("#" + _param.idRoot).is(":checked") == false) {
            if (parseInt($(_obj + ":checked").length) == parseInt($(_obj).length))
                $(_obj).iCheck("uncheck");
        }
        else
            $(_obj).iCheck("check");
    },
    textboxDisable: function (_id) {
        $(_id).prop("disabled", true);
        $(_id).css({
            background: "#B3B3B9",
            color: "#000000"
        });

        $("input:text, input:password, textarea").trigger("blur");
    },
    textboxEnable: function (_id) {
        $(_id).prop("disabled", false);
        $(_id).css({
            background: "#FFFFFF",
            color: "#000000"
        });
    },
    calendarDisable: function (_id) {
        $(_id).prop("disabled", true);
        $(_id).addClass("textbox-disable");
        $(_id).datepicker("disable");
        $(_id).css({
            background: "#B3B3B9",
            color: "#000000"
        });

        $("input:text, input:password, textarea").trigger("blur");
    },
    calendarEnable: function (_id) {
        $(_id).prop("disabled", false);
        $(_id).removeClass("textbox-disable");
        $(_id).datepicker("enable");
    },
    getValueSelectCheck: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.idParent = (_param.idParent == undefined ? "" : _param.idParent);

        var _idSelectCheck = $((_param.idParent.length > 0 ? (_param.idParent + " ") : "") + "input[name=" + _param.id + "]:checked");
        var _countSelectCheck = _idSelectCheck.length;
        var _valueSelectCheck = new Array();

        if (_countSelectCheck > 0) {
            _idSelectCheck.each(function (_i) {
                _valueSelectCheck[_i] = this.value;
            });
        }

        return _valueSelectCheck;
    },
    getSelectionIsSelect: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.type = (_param.type == undefined ? "" : _param.type);
        _param.valueTrue = (_param.valueTrue == undefined ? "" : _param.valueTrue);
        _param.valueFalse = (_param.valueFalse == undefined ? "" : _param.valueFalse);
       
        if (_param.id.length > 0 && _param.type.length > 0) {
            if (_param.type == "select")
                return (this.comboboxGetValue(_param.id) != "0" ? _param.valueTrue : _param.valueFalse);

            if (_param.type == "radio")
                return ($("input[name=" + _param.id + "]:radio").is(":checked") == true && $("input[name=" + _param.id + "]:checked").val() != "0" ? _param.valueTrue : _param.valueFalse);

            if (_param.type == "checkbox")
                return ($("input[name=" + _param.id + "]:checkbox").is(":checked") == true && $("input[name=" + _param.id + "]:checked").val() != "0" ? _param.valueTrue : _param.valueFalse);
        }

        return "";
    },
    getTabOnClick: function (_param, _callBackFunc) {
        _param.idLink = (_param.idLink == undefined ? "" : _param.idLink);
        _param.data = (_param.data == undefined ? "" : _param.data);
        _param.loadFormRepeat = (_param.loadFormRepeat == undefined || _param.loadFormRepeat == "" ? false : _param.loadFormRepeat);

        var _loadForm = false;
        var _page = $("#" + _param.idLink).attr("alt");
        
        if (($("#" + _param.idLink).length > 0 && ($("#" + _param.idLink).html().length == 0 || _param.loadFormRepeat == true)) ||
            ($("#" + _param.idLink + " .chart-recordcount .recordcount-search").length > 0 && $("#" + _param.idLink + " .chart-recordcount .recordcount-search").html().length == 0) ||
            ($("#" + _param.idLink + " .table-recordcount .recordcount-search").length > 0 && $("#" + _param.idLink + " .table-recordcount .recordcount-search").html().length == 0))
            _loadForm = true;

        if (_loadForm == true) {
            $("#" + _param.idLink).html("");

            this.loadForm({
                index: 0,
                name: _page,
                data: _param.data,
                id: _param.idLink
            }, function (_result) {
                if (_result != undefined)
                    _callBackFunc(true);
                else
                    _callBackFunc(false);
            });
        }
        else
            _callBackFunc(false);
    },
    getTabActive: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);

        var _idSectionActive;
        var _idTabActive;

        _idSectionActive = $("#" + _param.id + " .menu-active").attr("id");
        _idTabActive = ($("#" + _idSectionActive + " .tabbar").length == 0 ? _idSectionActive : $("#" + _idSectionActive + " .tabbar").attr("id"));

        if ($("#" + _idSectionActive + " .subtabbar").length > 0) {
            _idSectionActive = ($("#" + _idTabActive + ".tabbar").length == 0 ? _idTabActive : $("#" + _idTabActive + " ul li .tab-active").attr("alt"));
            _idTabActive = ($("#" + _idSectionActive + " .subtabbar").length == 0 ? _idTabActive : $("#" + _idSectionActive + " .subtabbar").attr("id"));
        }

        return _idTabActive;
    },
    getTabActiveOnTabbar: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        
        return ($("#" + _param.id + ".tabbar").length == 0 ? "" : $("#" + _param.id + " ul li .tab-active").attr("alt"));;
    },
    getSectionActive: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);

        var _idSectionActive;

        _idSectionActive = $("#" + _param.id + " .menu-active").attr("id");
        _idSectionActive = ($("#" + _idSectionActive + " .tabbar").length == 0 ? _idSectionActive : $("#" + _idSectionActive + " .tabbar ul li .tab-active").attr("alt"));
        _idSectionActive = ($("#" + _idSectionActive + " .subtabbar").length == 0 ? _idSectionActive : $("#" + _idSectionActive + " .subtabbar ul li .subtab-active").attr("alt"));

        return _idSectionActive;
    },
    getPageSectionActive: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);

        var _page;
        var _idActive;
        var _active = {};

        _page = $("#" + _param.id + " .menu-active").attr("alt");
        _idActive = $("#" + _param.id + " .menu-active").attr("id");

        _page = ($("#" + _idActive + " .tabbar").length == 0 ? _page : $("#" + _idActive + "-content .tab-active").attr("alt"));
        _idActive = ($("#" + _idActive + " .tabbar").length == 0 ? _idActive : $("#" + _idActive + "-content .tab-active").attr("id"));

        _page = ($("#" + _idActive + " .subtabbar").length == 0 ? _page : $("#" + _idActive + "-content .subtab-active").attr("alt"));
        _idActive = ($("#" + _idActive + " .subtabbar").length == 0 ? _idActive : $("#" + _idActive + "-content .subtab-active").attr("id"));

        _active.page = _page;
        _active.id = _idActive;
        
        return _active;
    },
    getPageActive: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);

        var _active = this.getPageSectionActive({
            id: _param.id
        });

        return _active.page;
    },
    getFrmViewMessage: function (_param) {
        _param.page = (_param.page == undefined ? "" : _param.page);
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.idMessage = (_param.idMessage == undefined ? "" : _param.idMessage);

        this.loadForm({
            index: 1,
            name: _param.page,
            dialog: true,
            modal: true,
        }, function (_result, _e) {
            if (_result.Content.length > 0 && _e != "close") {
                var _valueMessage = $("#" + _param.idMessage).val();
                
                $("#" + _param.id + "-form .textareabox").css({
                    "width": ($("#" + _param.id + "-form .form-layout").width() - 7),
                    "height": ($("#" + _param.id + "-form .form-layout").height() - 4)
                });
                $("#" + _param.id + "-form .textareabox").prop("disabled", true).val(_valueMessage);
            }
        });
    },
    getFrmAddUpdateMessage: function (_param) {
        _param.page = (_param.page == undefined ? "" : _param.page);
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.idMessage = (_param.idMessage == undefined ? "" : _param.idMessage);

        var _this = this;

        this.loadForm({
            index: 1,
            name: _param.page,
            dialog: true,
            modal: true,
        }, function (_result, _e) {
            if (_result.Content.length > 0 && _e != "close") {
                $("#" + _param.id + "-form .textareabox").css({
                    "width": ($("#" + _param.id + "-form .form-layout").width() - 28),
                    "height": ($("#" + _param.id + "-form .form-layout").height())
                });
                $("#" + _param.id + "-form .form-layout").height($("#" + _param.id + "-form .form-layout").height() + 65);

                _this.initAddUpdateMessage({
                    id: _param.id,
                    idMessage: _param.idMessage
                });
                _this.resetAddUpdateMessage({
                    id: _param.id,
                    idMessage: _param.idMessage
                });
            }
        });
    },
    getStudentCV: function (_param) {
        _param.data = (_param.data == undefined ? "" : _param.data);

        if (_param.data.length > 0)
            this.gotoPage({
                page: ("index.aspx?p=" + this.tut.pageStudentRecordsStudentCVMain + "&id=" + _param.data),
                target: "_newtab"
            });
        else
            this.dialogMessageError({
                content: "<div class='th-label'>กรุณาเลือกนักศึกษา</div><div class='en-label'>Please select student.</div>",
                modal: false
            });
    },
    getList: function (_param, _callBackFunc) {
        _param.cmd = (_param.cmd == undefined ? "" : _param.cmd);
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.data = (_param.data == undefined ? "" : _param.data);        

        var _data = {};
        _data.action = "list";
        _data.cmd = _param.cmd;
        _data.data = _param.data;
        
        this.msgPreloading = "";

        Util.loadAjax({
            url: this.tut.urlHandler,
            method: "POST",
            data: _data,
            showPreloadingInline: true,
            idPreloadingInline: _param.id
        }, function (_result) {
            $("#" + _param.id).html("");
            $("#" + _param.id).html(_result.Content);

            _callBackFunc(_result);
        });
    },
    getProgramCode: function (_param, _callBackFunc) {
        _param.program = (_param.program == undefined ? "" : _param.program);

        var _data = {};
        _data.action = "list";
        _data.cmd = "getprogramcode";
        _data.program = _param.program;

        this.msgPreloading = "";

        Util.loadAjax({
            url: this.tut.urlHandler,
            method: "POST",
            data: _data
        }, function (_result) {
            _callBackFunc(_result.Content);
        });
    },
    setInputOtherOnCheck: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.value = (_param.value == undefined ? "" : _param.value);
        _param.idCombobox = (_param.idCombobox == undefined ? "" : _param.idCombobox);
        _param.idTextboxOther = (_param.idTextboxOther == undefined ? "" : _param.idTextboxOther);
        _param.idCheckboxOther = (_param.idCheckboxOther == undefined ? "" : _param.idCheckboxOther);
        _param.idRadioboxOther = (_param.idRadioboxOther == undefined ? "" : _param.idRadioboxOther);
        _param.idComboboxOther = (_param.idComboboxOther == undefined ? "" : _param.idComboboxOther);
        _param.width = (_param.width == undefined || _param.width == "" ? 0 : _param.width);
        _param.height = (_param.height == undefined || _param.height == "" ? 0 : _param.height);
        _param.fontSizeCombobox = (_param.fontSizeCombobox == undefined ? "" : _param.fontSizeCombobox);
        _param.idContainerOther = (_param.idContainerOther == undefined ? "" : _param.idContainerOther);

        if ($("input[name=" + _param.id + "]:checked").val() == _param.value) {
            if (_param.idCombobox.length > 0)
                this.comboboxSetValue({
                    id: _param.idCombobox,
                    value: "0"
                });

            if (_param.idTextboxOther.length > 0) {
                this.textboxEnable(_param.idTextboxOther);
                this.calendarEnable(_param.idTextboxOther);
            }

            if (_param.idCheckboxOther.length > 0)
                $(_param.idCheckboxOther).iCheck("enable");

            if (_param.idRadioboxOther.length > 0)
                $("input[name=" + _param.idRadioboxOther + "]").iCheck("enable");

            if (_param.idComboboxOther.length > 0)
                this.comboboxEnable({
                    id: _param.idComboboxOther, 
                    width: _param.width,
                    height: _param.height,
                    fontSizeCombobox: _param.fontSizeCombobox
                }, function () {
                });

            if (_param.idContainerOther.length > 0)
                $(_param.idContainerOther).show();
        }
        else
        {
            if (_param.idCombobox.length > 0)
                this.comboboxEnable({
                    id: _param.idCombobox,
                    width: _param.width,
                    height: _param.height,
                    fontSizeCombobox: _param.fontSizeCombobox
                }, function () {
                });

            if (_param.idTextboxOther.length > 0) {
                $(_param.idTextboxOther).val("");
                this.textboxDisable(_param.idTextboxOther);
                this.calendarDisable(_param.idTextboxOther);
            }

            if (_param.idCheckboxOther.length > 0) {
                $(_param.idCheckboxOther).iCheck("uncheck");
                $(_param.idCheckboxOther).iCheck("disable");
            }

            if (_param.idRadioboxOther.length > 0) {
                $("input[name=" + _param.idRadioboxOther + "]").iCheck("uncheck");
                $("input[name=" + _param.idRadioboxOther + "]").iCheck("disable");
            }

            if (_param.idComboboxOther.length > 0) {
                this.comboboxSetValue({
                    id: _param.idComboboxOther,
                    value: "0"
                });
                this.comboboxDisable({
                    id: _param.idComboboxOther, 
                    width: _param.width,
                    height: _param.height,
                    fontSizeCombobox: _param.fontSizeCombobox
                }, function () {
                });
            }

            if (_param.idContainerOther.length > 0) {
                $(_param.idContainerOther).hide();
                $(_param.idContainerOther + " .form-inputlist-list").html("");
            }
        }
    },
    loadAjax: function (_param, _callBackFunc) {
        _param.url = (_param.url == undefined ? "" : _param.url);
        _param.method = (_param.method == undefined ? "" : _param.method);
        _param.data = (_param.data == undefined || _param.data == "" ? {} : _param.data);
        _param.showPreloadingInline = (_param.showPreloadingInline == undefined || _param.showPreloadingInline == "" ? false : _param.showPreloadingInline);
        _param.idPreloadingInline = (_param.idPreloadingInline == undefined ? "" : _param.idPreloadingInline);

        var _this1 = this;
        
        $.ajax({
            beforeSend: function () {
                if (_this1.msgPreloading.length > 0 && _param.showPreloadingInline == false)
                    _this1.dialogMessagePreloading();

                if (_param.showPreloadingInline == true)
                    $("#" + _param.idPreloadingInline).html("<img class='preloading-inline' src='../../../Content/Image/" + (_this1.tut.pathProject.length > 0 ? (_this1.tut.pathProject + "/") : "") + "PerloadingInline.gif' />");
            },
            async: true,
            type: _param.method,
            url: _param.url,
            data: _param.data,
            dataType: "json",
            charset: "utf-8",
            success: function (_result) {
                if (_this1.msgPreloading.length > 0 && _param.showPreloadingInline == false)
                    $("#" + _this1.dialogPreloading).modal("hide");

                if (_param.showPreloadingInline == true)
                    $("#" + _param.idPreloadingInline).html("");

                if (BrowserDetect.browser == "Explorer" && BrowserDetect.version < 9) {
                    $("body").css("background-image", "none");
                    $("#bodymain, main").hide();
                    $("#bodyfooter, footer").hide();

                    _this1.dialogMessageError({
                        content: ("<div class='lang lang-th font-family-th black regular " + _this1.dialogFormFontTHSize + "'>ไม่สนับสนุน IE ต่ำกว่าเวอร์ชั้น 9 <a href='http://windows.microsoft.com/en-us/internet-explorer/download-ie' target='_blank'>( คลิกเพื่อดาวน์โหลด IE เวอร์ชั่นใหม่ )</a></div>" +
                                  "<div class='lang lang-en font-family-en black regular " + _this1.dialogFormFontENSize + "'>Not support IE ​​less than version 9. <a href='http://windows.microsoft.com/en-us/internet-explorer/download-ie' target='_blank'>( Click to download the latest version of Internet Explorer. )</a></div>")
                    });

                    return;
                }

                if (_result.ErrorUpdate == true) {
                    _this1.dialogMessageError({
                        content: ("<div class='lang lang-th font-family-th black regular " + _this1.dialogFormFontTHSize + "'>ข้อมูลมีการเปลี่บนแปลง กรุณารีเฟรชหน้าจอ</div>",
                                  "<div class='lang lang-en font-family-en black regular " + _this1.dialogFormFontENSize + "'>Data is updated, please refresh the page</div>")
                    });

                    return;
                }

                $("#bodymain, main").show();
                $("#bodyfooter, footer").show();

                _callBackFunc(_result);
            },
            error: function (_xhr, _ajaxOptions, _thrownError) {
                $("#" + _this1.dialogPreloading).modal("hide");
                $("#headbody, main").show();
                $("#footerbody, footer").show();

                _this1.dialogMessageError({
                    content: ("<div class='lang lang-th font-family-th th-label black regular " + _this1.dialogFormFontTHSize + "'>ประมวลผลไม่สำเร็จ กรุณารีเฟรชหน้าจอ หรือเปลี่ยนเว็บเบราว์เซอร์</div>" +
                              "<div class='lang lang-en font-family-en en-label black regular " + _this1.dialogFormFontENSize + "'>Processing was not successful, Please refresh this page or change web browser.</div>")
                });
            }
        });
    },
    loadForm: function (_param, _callBackFunc) {
        _param.name = (_param.name == undefined ? "" : _param.name);
        _param.dialog = (_param.dialog == undefined || _param.dialog == "" ? false : _param.dialog);
        _param.data = (_param.data == undefined ? "" : _param.data);
        _param.showPreloadingInline = (_param.showPreloadingInline == undefined || _param.showPreloadingInline == "" ? false : _param.showPreloadingInline);
        _param.idPreloadingInline = (_param.idPreloadingInline == undefined ? "" : _param.idPreloadingInline);
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.idActive = (_param.idActive == undefined ? "" : _param.idActive);

        if (_param.idActive.length > 0)
            $("#" + _param.idActive).addClass("active");

        var _this1 = this;
        var _error;
        var _data = {};
        _data.action = "form";
        _data.form = _param.name;
        _data.id = _param.data;

        this.msgPreloading = "Loading...";

        this.loadAjax({
            url: this.tut.urlHandler,
            method: "POST",
            data: _data,
            showPreloadingInline: _param.showPreloadingInline,
            idPreloadingInline: _param.idPreloadingInline
        }, function (_result) {            
            _error = _this1.tut.getErrorMsg({
                signinYN: _result.SignInYN,
                pageError: _result.FormError,
                cookieError: _result.CookieError,
                userError: _result.UserError
            });

            if (_error == false) {
                if (_result.MainContent.length == 0) {
                    _this1.dialogMessageError({
                        content: ("<div class='lang lang-th font-family-th black regular " + _this1.dialogFormFontTHSize + "'>ไม่พบเนื้อหา</div>" +
                                  "<div class='lang lang-en font-family-en black regular " + _this1.dialogFormFontENSize + "'>Content not found.</div>")
                    });

                    _callBackFunc(_result);
                }
                else
                {
                    if (_param.dialog == true) {
                        _this1.dialogMessageForm({
                            title: _result.TitleContent,
                            content: _result.MainContent,
                            width: _result.Width,
                            height: parseInt(_result.Height),
                            idActive: _param.idActive
                        }, function (_e) {
                            _this1.initTextSelect();
                            _this1.initTooltip();

                            _callBackFunc(_result, _e);
                        });
                    }
                    else
                    {   
                        $("#" + _param.id).html(_result.MainContent);

                        _this1.initTextSelect();
                        _this1.initTooltip();

                        _callBackFunc(_result);
                    }
                }
            }
            else
                _callBackFunc();
        });
    },
    loadCombobox: function (_param, _callBackFunc) {
        _param.cmd = (_param.cmd == undefined ? "" : _param.cmd);
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.idContainer = (_param.idContainer == undefined ? "" : _param.idContainer);
        _param.data = (_param.data  == undefined || _param.data  == "" ? {} : _param.data );
        _param.valueDefault = (_param.valueDefault == undefined || _param.valueDefault == "" ? "0" : _param.valueDefault);
        _param.width = (_param.width == undefined || _param.width == "" ? 0 : _param.width);
        _param.height = (_param.height == undefined || _param.height == "" ? 0 : _param.height);
        _param.fontSizeCombobox = (_param.fontSizeCombobox == undefined ? "" : _param.fontSizeCombobox);

        var _this = this;
        var _data = _param.data;
        _data.action = "combobox";
        _data.cmd = _param.cmd;

        this.msgPreloading = "";

        this.loadAjax({
            url: this.tut.urlHandler,
            method: "POST",
            data: _data,
            showPreloadingInline: true,
            idPreloadingInline: _param.idContainer
        }, function (_result) {
            $("#" + _param.idContainer).html(_result.Content);

            _this.initCombobox({
                id: ("#" + _param.id),
                width: _param.width,
                height: _param.height,
                fontSizeCombobox: _param.fontSizeCombobox
            });
            _this.comboboxSetValue({
                id: ("#" + _param.id),
                value: _param.valueDefault
            });

            $(".form.search .form-content .inputbox, .form.search .form-content .combobox").keypress(function () {
                _this.clearTable();
                _this.tut.tse.clearTable();
                _this.dialogMessageClose();
            });

            $(".form.search .form-content .inputbox, .form.search .form-content .combobox").change(function () {
                _this.clearTable();
                _this.tut.tse.clearTable();
                _this.dialogMessageClose();
            });

            _callBackFunc();
        });
    },
    actionTask: function (_param, _callBackFunc) {
        _param.action = (_param.action == undefined ? "" : _param.action);
        _param.page = (_param.page == undefined ? "" : _param.page);
        _param.data = (_param.data == undefined || _param.data == "" ? {} : _param.data);
        _param.closeDialog = (_param.closeDialog == undefined || _param.closeDialog == "" ? false : _param.closeDialog);

        var _data = _param.data;
        _data.action = _param.action;
        _data.page = _param.page;

        Util.loadAjax({
            url: this.tut.urlHandler,
            method: "POST",
            data: _data
        }, function (_result) {
            if (_result.SaveError == "0" && _result.KeyUpdateError == "0") {
                if (_param.closeDialog == true)
                    $("#" + Util.dialogForm + "1").dialog("close");
            }

            _callBackFunc(_result);
        });
    },
    actionSearch: function (_param, _callBackFunc) {
        _param.pageMain = (_param.pageMain == undefined ? "" : _param.pageMain);
        _param.pageSearch = (_param.pageSearch == undefined ? "" : _param.pageSearch);
        _param.data = (_param.data == undefined || _param.data == "" ? {} : _param.data);
        _param.idChart = (_param.idChart == undefined ? "" : _param.idChart);
        _param.idTable = (_param.idTable == undefined ? "" : _param.idTable);
        _param.pressNavPage = (_param.pressNavPage == undefined || _param.pressNavPage == "" ? false : _param.pressNavPage);

        var _this = this
        var _objChartTitle = ("#" + _param.idChart + " .chart-title");
        var _objChartRecordCountSearch = ("#" + _param.idChart + " .chart-recordcount .recordcount-search");
        var _objChartRecordCountPrimarySearch = ("#" + _param.idChart + " .chart-recordcount .recordcountprimary-search");
        var _objChartRecordCountSecondarySearch = ("#" + _param.idChart + " .chart-recordcount .recordcountsecondary-search");
        var _objChartRecordCountPrimaryAll = ("#" + _param.idChart + " .chart-recordcount .recordcountprimary-all");
        var _objChartRecordCountSecondaryAll = ("#" + _param.idChart + " .chart-recordcount .recordcountsecondary-all");
        var _objChartList = ("#" + _param.idChart + " .chart-list");
        var _objTableTitle = ("#" + _param.idTable + " .table-title");
        var _objTableLinkGoBack = ("#" + _param.idTable + " .table-recordcount .link-goback");
        var _objTableRecordCountSearch = ("#" + _param.idTable + " .table-recordcount .recordcount-search");
        var _objTableRecordCountPrimarySearch = ("#" + _param.idTable + " .table-recordcount .recordcountprimary-search");
        var _objTableRecordCountSecondarySearch = ("#" + _param.idTable + " .table-recordcount .recordcountsecondary-search");
        var _objTableRecordCountPrimaryAll = ("#" + _param.idTable + " .table-recordcount .recordcountprimary-all");
        var _objTableRecordCountSecondaryAll = ("#" + _param.idTable + " .table-recordcount .recordcountsecondary-all");
        var _objTableList = ("#" + _param.idTable + " .table-list");
        var _objTableNavPage = ("#" + _param.idTable + " .table-navpage")
       
        if (_param.idChart.length > 0) {
            if ($(_objChartTitle).length > 0)
                $(_objChartTitle + " .contentbody-left").hide();

            if ($(_objChartRecordCountSearch).length > 0)
                $(_objChartRecordCountSearch).html("");

            if ($(_objChartRecordCountPrimarySearch).length > 0)
                $(_objChartRecordCountPrimarySearch).html("");

            if ($(_objChartRecordCountSecondarySearch).length > 0)
                $(_objChartRecordCountSecondarySearch).html("");

            if ($(_objChartRecordCountPrimaryAll).length > 0)
                $(_objChartRecordCountPrimaryAll).html("");

            if ($(_objChartRecordCountSecondaryAll).length > 0)
                $(_objChartRecordCountSecondaryAll).html("");

            if ($(_objChartList).length > 0)
                $(_objChartList).html("");
        }

        if (_param.idTable.length > 0) {
            if ($(_objTableTitle).length > 0)
                $(_objTableTitle + " .contentbody-left").hide();

            if ($(_objTableLinkGoBack).length > 0)
                $(_objTableLinkGoBack).hide();

            if ($(_objTableRecordCountSearch).length > 0)
                $(_objTableRecordCountSearch).html("");

            if ($(_objTableRecordCountPrimarySearch).length > 0)
                $(_objTableRecordCountPrimarySearch).html("");

            if ($(_objTableRecordCountSecondarySearch).length > 0)
                $(_objTableRecordCountSecondarySearch).html("");

            if ($(_objTableRecordCountPrimaryAll).length > 0)
                $(_objTableRecordCountPrimaryAll).html("");

            if ($(_objTableRecordCountSecondaryAll).length > 0)
                $(_objTableRecordCountSecondaryAll).html("");

            if (_param.pressNavPage == false && $(_objTableList).length > 0)
                $(_objTableList).html("");

            if ($(_objTableNavPage).length > 0)
                $(_objTableNavPage).html("");            
        }

        _this.tut.tse.clearTable();

        var _i;
        var _j = 2;
        var _data = _param.data;
        _data.action = "search";
        _data.pageMain = _param.pageMain;
        _data.pageSearch = _param.pageSearch;
        
        Util.loadAjax({
            url: this.tut.urlHandler,
            method: "POST",
            data: _data
        }, function (_result) {
            if (_param.idChart.length > 0) {
                if ($(_objChartTitle).length > 0)
                    $(_objChartTitle + " .contentbody-left").show();

                if ($(_objChartRecordCountSearch).length > 0)
                    $(_objChartRecordCountSearch).html(_result.RecordCountContent);

                if ($(_objChartRecordCountPrimarySearch).length > 0)
                    $(_objChartRecordCountPrimarySearch).html(_result.RecordCountPrimaryContent);

                if ($(_objChartRecordCountSecondarySearch).length > 0)
                    $(_objChartRecordCountSecondarySearch).html(_result.RecordCountSecondaryContent.length > 0 ? (" ( " + _result.RecordCountSecondaryContent + " )") : "");

                if ($(_objChartRecordCountPrimaryAll).length > 0)
                    $(_objChartRecordCountPrimaryAll).html(" / " + _result.RecordCountAllPrimaryContent);

                if ($(_objChartRecordCountSecondaryAll).length > 0)
                    $(_objChartRecordCountSecondaryAll).html(_result.RecordCountAllSecondaryContent.length > 0 ? (" ( " + _result.RecordCountAllSecondaryContent + " )") : "");

                if ($(_objChartList).length > 0)
                    $(_objChartList).html(_result.ListContent);
            }

            if (_param.idTable.length > 0) {
                if ($(_objTableTitle).length > 0)
                    $(_objTableTitle + " .contentbody-left").show();

                if ($(_objTableLinkGoBack).length > 0)
                    $(_objTableLinkGoBack).show();

                if ($(_objTableRecordCountSearch).length > 0)
                    $(_objTableRecordCountSearch).html(_result.RecordCountContent);

                if ($(_objTableRecordCountPrimarySearch).length > 0)
                    $(_objTableRecordCountPrimarySearch).html(_result.RecordCountPrimaryContent);

                if ($(_objTableRecordCountSecondarySearch).length > 0)
                    $(_objTableRecordCountSecondarySearch).html(_result.RecordCountSecondaryContent.length > 0 ? (" ( " + _result.RecordCountSecondaryContent + " )") : "");

                if ($(_objTableRecordCountPrimaryAll).length > 0)
                    $(_objTableRecordCountPrimaryAll).html(" / " + _result.RecordCountAllPrimaryContent);

                if ($(_objTableRecordCountSecondaryAll).length > 0)
                    $(_objTableRecordCountSecondaryAll).html(_result.RecordCountAllSecondaryContent.length > 0 ? (" ( " + _result.RecordCountAllSecondaryContent + " )") : "");

                if (_param.pressNavPage == false && $(_objTableList).length > 0)
                    $(_objTableList).html($(_objTableList).html() + _result.ListContent);

                if ($(_objTableNavPage).length > 0)
                    $(_objTableNavPage).html(_result.NavPageContent);
            }

            if ($("input[name=select-root]:checkbox").length > 0)
                Util.uncheckboxRoot("select-root");

            _callBackFunc(_result);
        });
    },
    getParentWidth: function () {
        return ($("#headbody").width() > this.tut.parentWidth ? $(window).width() : this.tut.parentWidth);
    },
    getPage: function () {
        this.tut.loadPage(function () { });
    },
    setStickyTop: function (_height) {
        _height = (_height == "" ? 0 : _height);

        $("#contentbody").css({
            "padding-top": (($("#headbody").outerHeight() + _height) + "px")
        });
        $(".after-sticky").css({
            "padding-top": (($(".infobar .infobar-layout").outerHeight() + $(".infobar .important-layout").outerHeight()) + "px")
        });
    
        this.offsetTop = ($("#headbody").outerHeight() + $(".infobar").outerHeight());
    },
    setMenuBarLayout: function () {
        var _width = this.getParentWidth();

        if ($(".menubar").is(":visible")) {
            $(".menubar").width(_width);
            $(".menubar .menubar-content .contentbody-left").css({
                "width": ((_width - $(".menubar .menubar-content .contentbody-right").width() - 1) + "px")
            });
        }
    },
    setInfoBarLayout: function () {
        var _width = this.getParentWidth();

        if ($(".infobar").is(":visible")) {
            $(".infobar").width(_width);
            $(".infobar .infobar-content .contentbody-left").css({
                "width": ((_width - $(".infobar .infobar-content .contentbody-right").width()) + "px"),
                "min-width": ((_width - $(".infobar .infobar-content .contentbody-right").width()) + "px")
            });

            if ($(".infobar .linkto").is(":visible"))
                $(".infobar .linkto").css({
                    "left": (_width - $(".infobar .linkto").width())
                });
        }
    },    
    setHeaderLayout: function () {
        if ($("main header").is(":visible")) {
            $("main header").css({
                "padding-top": ($("main .sticky").outerHeight() + "px"),
                "padding-bottom": (($("footer").outerHeight() + 10) + "px")
            });
        }
    },
    setSectionLayout: function () {
        if ($("main section").is(":visible"))
            $("main section").css({
                "padding-top": (($("main header").is(":visible") ? 0 : ($("main .sticky").outerHeight() + 10)) + "px"),
                "padding-bottom": (($("footer").outerHeight() + 10) + "px")
            });
    },
    setFooterLayout: function () {
        $("footer").removeClass("hidden");
    },
    setTableLayout: function () {        
        var _width = (this.getParentWidth() - ($(".sticky-left").width() + $(".sticky-left .button-toggle a").width()));
        var _height;
        
        if ($(".table").is(":visible")) {
            $(".table:not(.table-previewprogress) .table-content .table-title, " +
              ".table:not(.table-previewprogress) .table-content .table-head, " +
              ".table:not(.table-previewprogress) .table-content .table-grid, " +
              ".table:not(.table-previewprogress) .table-content .table-navpage").width(_width);
            _height = $(".table .table-content .table-freeze").height();
            
            if (_height == 0)
                _height = $(".table:eq(1) .table-content .table-freeze").height();

            if (_height == 0)
                _height = $(".table:eq(2) .table-content .table-freeze").height();
            
            $(".table:not(.table-previewprogress) .table-list").css({
                "padding-top": (_height + "px")
            });
        }
        
        if ($(".main .table").is(":visible") && $(".main .mainform").is(":visible")) {
            var _objTable = ".main .table .table-content .table-title, .main .table .table-content .table-head, .main .table .table-content .table-grid, .main .table .table-content .table-navpage";
            var _objForm = ".main .mainform";

            $(_objTable).width($(_objTable).width() - $(_objForm + " .mainform-layout").width());
            $(_objForm).css({
                "left": ($(_objTable).width() + "px"),
                "top": (this.offsetTop + $(".tabbar").outerHeight() + "px")
            });
            $(_objForm + " .mainform-layout").height($(window).height());
        }
    },
    setTableLayoutOnDialogForm: function (_param) {
        _param.idForm = (_param.idForm == undefined ? "" : _param.idForm);

        var _width = $("#" + _param.idForm).width();

        if ($("#" + _param.idForm + " .table").is(":visible")) {
            $("#" + _param.idForm + " .table .table-content .table-title, " +
              "#" + _param.idForm + " .table .table-content .table-head, " +
              "#" + _param.idForm + " .table .table-content .table-grid").width(_width);

            $("#" + _param.idForm + " .table .table-list").css({
                "height": (($(window).height() -
                           (($("#" + _param.idForm + " .table .table-freeze").height() + $("#" + _param.idForm + " .table .button").height() + 78))) + "px")
            });
        }
    },
    setTableLayoutWidthDynamic: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);

        if ($("#" + _param.id + ".table-width-dynamic .table-list .table-grid .table-row").length > 0) {
            var _hr = $("#" + _param.id + ".table-width-dynamic .table-freeze .table-head .table-row")[0].children;
            var _dr = $("#" + _param.id + ".table-width-dynamic .table-list .table-grid .table-row")[0].children;
            var _i;

            for (_i = 0; _i < _dr.length; _i++) {
                if (_dr[_i].offsetWidth > _hr[_i].offsetWidth) {
                    _dr[_i].children[0].style.width = (_dr[_i].children[0].offsetWidth - 12 + "px");
                    _hr[_i].children[0].style.width = (_dr[_i].children[0].offsetWidth - 14 + "px");
                }
                else
                {
                    _hr[_i].children[0].style.width = (_hr[_i].children[0].offsetWidth - 12 + "px");
                    _dr[_i].children[0].style.width = (_hr[_i].children[0].offsetWidth - 14 + "px");
                }
            }
        }
    },
    setChartLayout: function () {        
        var _width = (this.getParentWidth() - ($(".sticky-left").width() + $(".sticky-left .button-toggle a").width()));
        var _paddingWidth = 0;
        var _i;
        var _chart;

        if ($(".chart").is(":visible")) {
            if ($(".chart .chart-content .chart-grid .chart-col").length > 0)
                _paddingWidth = (parseInt($(".chart .chart-content .chart-grid .chart-col").css("paddingLeft").replace("px", "")) + parseInt($(".chart .chart-content .chart-grid .chart-col").css("paddingRight").replace("px", "")));

            $(".chart .chart-content .chart-title").width(_width);
            $(".chart .chart-content .chart-container").css({
                "width": ((_width - _paddingWidth) + "px")
            });

            for (_i = 0; _i < $(".chart-container").length; _i++) {
                _chart = $("#" + $(".chart-container:eq(" + _i + ")").attr("id")).highcharts();

                _chart.setSize(
                    $(".chart .chart-content .chart-container").width(),
                    ($(window).height() - (this.offsetTop + $(".chart .chart-content .chart-freeze").height()) - 64),
                    false
                );
            }

            $(".chart-list").css("padding-top", $(".chart .chart-content .chart-freeze").height() + "px");
        }
    },
    setTopMenuBarLayout: function () {
        if ($("main .navbar-top").is(":visible"))
        {
            var _objL = $("main .navbar-top .float-left");
            var _objR = $("main .navbar-top .float-right");

            _objL.width($(window).width() - _objR.outerWidth() - 50);
        }
    },
    setBottomMenuBarLayout: function () {
        if ($("main .navbar .navbar-menu.bottom-menu").is(":visible")) {
            var _objL = $("main .navbar .navbar-menu.bottom-menu .menu-left");
            var _objR1 = $("main .navbar .navbar-menu.bottom-menu .menu-right div:eq(0)");
            var _objR2 = $("main .navbar .navbar-menu.bottom-menu .menu-right .navbar-nav");
            var _objNavBar = $("main .navbar .navbar-menu.bottom-menu .menu-right .navbar-collapse");
            var _menuPaddingL = 17;
            var _menuPaddingR = 17;

            if (_objR2.outerWidth() == 0) {
                _menuPaddingL = 27;
                _menuPaddingR = 18;
            }

            $("main nav.navbar .navbar-menu").css({
                "padding-left": (_menuPaddingL + "px"),
                "padding-right": (_menuPaddingR + "px")
            });

            _objR1.width($(window).width() - (_objL.outerWidth() + _objR2.outerWidth()) - _menuPaddingL - _menuPaddingR - 27);
        }
    },
    setDialogFormLayout: function (_param) {
        _param.width = (_param.width == undefined || _param.width == "" ? 0 : _param.width);
            
        if (_param.width > 0 && _param.width < $(window).width())
            $("#" + Util.dialogForm + " .modal-dialog").width(_param.width);
        else
            $("#" + Util.dialogForm + " .modal-dialog").width($(window).width() - 58);
    },
    setSearchShow: function () {
        if ($("#bodysearch").is(":visible"))
            $("#bodysearch").hide();
        else {
            this.tut.tse.setSearchLayout();
            $("#bodysearch").show();
        }
    },
    setList: function (_param) {
        _param.add = (_param.add == undefined || _param.add == "" ? false : _param.add);
        _param.data = (_param.data == undefined || _param.data == "" ? new Array() : _param.data);
        _param.separatorCol = (_param.separatorCol == undefined ? "" : _param.separatorCol);
        _param.idInputList = (_param.idInputList == undefined ? "" : _param.idInputList);
        _param.idList = (_param.idList == undefined ? "" : _param.idList);
        _param.idListRow = (_param.idListRow == undefined ? "" : _param.idListRow);

        var _value;
        var _i;
        var _j;
        var _countCol;

        if (_param.add == true) {
            _value = ($("#" + _param.idInputList).val().length > 0 ? ($("#" + _param.idInputList).val() + ";") : "");
            _value = (_value + _param.data.join(_param.separatorCol));

            $("#" + _param.idInputList).val(_value);
        }
        else {
            $("#" + _param.idInputList).val("");
            _param.idList = (_param.idList + " .list-row");

            for (_i = 0; _i < $("#" + _param.idList).length; _i++) {
                if ($("#" + _param.idListRow + (_i + 1)).is(":visible") == true) {
                    _countCol = $("#" + _param.idListRow + (_i + 1) + " .contentbody-left input:hidden").length;
                    _param.data = new Array();

                    for (_j = 1; _j <= _countCol; _j++) {
                        _param.data[_j - 1] = $("#" + _param.idListRow + (_i + 1) + " .contentbody-left:nth-child(" + _j + ") input:hidden").val();
                    }

                    _value = ($("#" + _param.idInputList).val().length > 0 ? ($("#" + _param.idInputList).val() + ";") : "");
                    _value = (_value + _param.data.join(_param.separatorCol));

                    $("#" + _param.idInputList).val(_value);
                }
            }
        }
    },
    setLinkToShow: function () {
        if ($(".infobar .linkto").is(":visible"))
            $(".infobar .linkto").hide();
        else {
            this.setInfoBarLayout();
            $(".infobar .linkto").show();
        }
    },
    setLanguage: function (_param) {
        _param.lang = (_param.lang == undefined || _param.lang == "" ? this.lang : _param.lang);

        this.lang = _param.lang;

        $(".lang").hide();
        $(".lang-" + this.lang.toLowerCase()).show();

        this.setTopMenuBarLayout();
        this.setBottomMenuBarLayout();
    },
    setLanguageOnForm: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);

        if (_param.id.length > 0) {
            $(_param.id + " .lang").hide();
            $(_param.id + " .lang-" + this.lang.toLowerCase()).show();
        }
    },
    setLanguageOnCombobox: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.fontSizeCombobox = (_param.fontSizeCombobox == undefined ? "" : _param.fontSizeCombobox);

        if (_param.id.length > 0) {
            $(_param.id + " .lang").hide();
            $(_param.id + " .lang-" + this.lang.toLowerCase()).show();
            $(_param.id + " .select2-container--default .select2-selection--single .select2-selection__rendered").addClass("lang lang-" + this.lang.toLowerCase() + " font-family-" + this.lang.toLowerCase() + " " + _param.fontSizeCombobox + " black regular");
        }
    },
    setLanguageOnAllCombobox: function (_param) {
        _param.fontSizeCombobox = (_param.fontSizeCombobox == undefined ? "" : _param.fontSizeCombobox);

        $(".select2-container--default .select2-selection--single .select2-selection__rendered").removeClass("lang-th");
        $(".select2-container--default .select2-selection--single .select2-selection__rendered").removeClass("lang-en");
        $(".select2-container--default .select2-selection--single .select2-selection__rendered").removeClass("font-family-th");
        $(".select2-container--default .select2-selection--single .select2-selection__rendered").removeClass("font-family-en");
        $(".select2-container--default .select2-selection--single .select2-selection__rendered").removeClass("f7");
        $(".select2-container--default .select2-selection--single .select2-selection__rendered").removeClass("f7default");
        $(".select2-container--default .select2-selection--single .select2-selection__rendered").removeClass("f9");
        $(".select2-container--default .select2-selection--single .select2-selection__rendered").removeClass("f9default");
        $(".select2-container--default .select2-selection--single .select2-selection__rendered").removeClass("f10");
        $(".select2-container--default .select2-selection--single .select2-selection__rendered").removeClass("f10default");
        $(".select2-container--default .select2-selection--single .select2-selection__rendered").removeClass("black");
        $(".select2-container--default .select2-selection--single .select2-selection__rendered").removeClass("regular");
        $(".select2-container--default .select2-selection--single .select2-selection__rendered").addClass("lang lang-" + this.lang.toLowerCase() + " font-family-" + this.lang.toLowerCase() + " " + _param.fontSizeCombobox + " black regular");
    },
    setNiceScroll: function (_param) {
        _param.id = (_param.id == undefined ? "" : _param.id);
        _param.method = (_param.method == undefined ? "" : _param.method);

        if (_param.id.length > 0 && _param.method.length > 0) {
            if (_param.method == "show")
                $(_param.id).niceScroll({
                    zindex: 999,
                    cursorcolor: "#000000",
                    cursoropacitymax: 0.6,
                    autohidemode: false,
                    cursorwidth: 15,
                    cursorborder: 0,
                    cursorborderradius: 0,
                    horizrailenabled: true,
                    railpadding: { top: 0, right: -15, left: 0, bottom: 0 }
                });

            if (_param.method == "hide")
                $(_param.id).getNiceScroll().remove();
        }
    },
    clearPage: function () {
        $(".lang").hide();
        $("main .navbar-top").hide();
        $("main .navbar-header").hide();
        $("main .navbar .navbar-menu").hide();
        $("main .navbar .navbar-menu .container").html("");
        $("main header").hide();
        $("main section").hide();
        $("main section .container").html("");
        $("footer").hide();
        Util.setLanguage({});
    },    
    clearTable: function () {
        $(".chart-recordcount .recordcount-search, .chart-recordcount .recordcountprimary-search, .chart-recordcount .recordcountsecondary-search, .chart-recordcount .recordcountprimary-all, " +
          ".chart-recordcount .recordcountsecondary-all, .chart-list, .table-subject, .table-recordcount .recordcount-search, .table-recordcount .recordcountprimary-search, " +
          ".table-recordcount .recordcountsecondary-search, .table-recordcount .recordcountprimary-all, .table-recordcount .recordcountsecondary-all, .table-list, .table-navpage").html("");
        $(".table").show();
        $(".table .table-recordcount .link-goback, .table-level").hide();
    },
    confirmSignOut: function () {
        var _this = this;

        this.dialogMessageConfirm({
            content: ("<div class='lang lang-th font-family-th black regular " + Util.dialogFormFontTHSize + "'>ยืนยันต้องการออกจากระบบ</div>" +
                      "<div class='lang lang-en font-family-en black regular " + Util.dialogFormFontENSize + "'>Confirm your would like to sign out.</div>")
        }, function (_result) {
            if (_result == true) {
                Util.msgPreloading = "Sign Out...";

                Util.actionTask({
                    action: "signout"
                }, function () {
                    Util.gotoPage({ page: "index.aspx" });
                });
            };
        });
    },
    confirmSave: function (_callBackFunc) {
        var _this = this;

        this.dialogMessageConfirm({
            content: ("<div class='lang lang-th font-family-th black regular " + Util.dialogFormFontTHSize + "'>ต้องการบันทึกข้อมูลนี้หรือไม่</div>" +
                      "<div class='lang lang-en font-family-en black regular " + Util.dialogFormFontENSize + "'>Do you want to save changes ?</div>")
        }, function (_result) {
            _callBackFunc(_result);
        });
    },
    startUploadFile: function () {
        this.msgPreloading = "Uploading...";
        this.dialogMessagePreloading();
    },
    calAge: function (_param, _callBackFunc) {
        _param.birthdate = (_param.birthdate == undefined ? "" : _param.birthdate);

        var _data = {};
        _data.action    = "calage";
        _data.birthdate = _param.birthdate;

        this.msgPreloading = "";

        Util.loadAjax({
            url: this.tut.urlHandler,
            method: "POST",
            data: _data
        }, function (_result) {
            _callBackFunc(_result.Age);
        });
    },
    calBMI: function (_param, _callBackFunc) {
        _param.idContainer = (_param.idContainer == undefined ? "" : _param.idContainer);
        _param.weight = (_param.weight == undefined ? "" : _param.weight);
        _param.height = (_param.height == undefined ? "" : _param.height);

        var _data = {};
        _data.action    = "calbmi";
        _data.weight    = _param.weight;
        _data.height    = _param.height;

        this.msgPreloading = "";

        Util.loadAjax({
            url: this.tut.urlHandler,
            method: "POST",
            data: _data,
            showPreloadingInline: (_param.idContainer.length > 0 ? true : false),
            idPreloadingInline: _param.idContainer
        }, function (_result) {
            _callBackFunc(_result);
        });
    },
    chkStudentRecordsFillComplete: function (_param) {
        _param.idContainer = (_param.idContainer == undefined ? "" : _param.idContainer);
        _param.personal = (_param.personal == undefined ? false : _param.personal);
        _param.addressPermanent = (_param.addressPermanent == undefined ? false : _param.addressPermanent);
        _param.addressCurrent = (_param.addressCurrent == undefined ? false : _param.addressCurrent);
        _param.educationPrimarySchool = (_param.educationPrimarySchool == undefined ? false : _param.educationPrimarySchool);
        _param.educationJuniorHighSchool = (_param.educationJuniorHighSchool == undefined ? false : _param.educationJuniorHighSchool);
        _param.educationHighSchool = (_param.educationHighSchool == undefined ? false : _param.educationHighSchool);
        _param.educationUniversity = (_param.educationUniversity == undefined ? false : _param.educationUniversity);
        _param.educationAdmissionScores = (_param.educationAdmissionScores == undefined ? false : _param.educationAdmissionScores);
        _param.talent = (_param.talent == undefined ? false : _param.talent);
        _param.healthy = (_param.healthy == undefined ? false : _param.healthy);
        _param.work = (_param.work == undefined ? false : _param.work);
        _param.financial = (_param.financial == undefined ? false : _param.financial);
        _param.familyFatherPersonal = (_param.familyFatherPersonal == undefined ? false : _param.familyFatherPersonal);
        _param.familyMotherPersonal = (_param.familyMotherPersonal == undefined ? false : _param.familyMotherPersonal);
        _param.familyParentPersonal = (_param.familyParentPersonal == undefined ? false : _param.familyParentPersonal);
        _param.familyFatherAddressPermanent = (_param.familyFatherAddressPermanent == undefined ? false : _param.familyFatherAddressPermanent);
        _param.familyMotherAddressPermanent = (_param.familyMotherAddressPermanent == undefined ? false : _param.familyMotherAddressPermanent);
        _param.familyParentAddressPermanent = (_param.familyParentAddressPermanent == undefined ? false : _param.familyParentAddressPermanent);
        _param.familyFatherAddressCurrent = (_param.familyFatherAddressCurrent == undefined ? false : _param.familyFatherAddressCurrent);
        _param.familyMotherAddressCurrent = (_param.familyMotherAddressCurrent == undefined ? false : _param.familyMotherAddressCurrent);
        _param.familyParentAddressCurrent = (_param.familyParentAddressCurrent == undefined ? false : _param.familyParentAddressCurrent);
        _param.familyFatherWork = (_param.familyFatherWork == undefined ? false : _param.familyFatherWork);
        _param.familyMotherWork = (_param.familyMotherWork == undefined ? false : _param.familyMotherWork);
        _param.familyparentwork = (_param.familyparentwork == undefined ? false : _param.familyparentwork);

        var _personal = $("#" + _param.idContainer + "-studentrecordspersonalstatus-hidden").val();
        var _addressPermanent = $("#" + _param.idContainer + "-studentrecordsaddresspermanentstatus-hidden").val();
        var _addressCurrent = $("#" + _param.idContainer + "-studentrecordsaddresscurrentstatus-hidden").val();
        var _educationPrimarySchool = $("#" + _param.idContainer + "-studentrecordseducationprimaryschoolstatus-hidden").val();
        var _educationJuniorHighSchool = $("#" + _param.idContainer + "-studentrecordseducationjuniorhighschoolstatus-hidden").val();
        var _educationHighSchool = $("#" + _param.idContainer + "-studentrecordseducationhighschoolstatus-hidden").val();
        var _educationUniversity = $("#" + _param.idContainer + "-studentrecordseducationuniversitystatus-hidden").val();
        var _educationAdmissionScores = $("#" + _param.idContainer + "-studentrecordseducationadmissionscoresstatus-hidden").val();
        var _talent = $("#" + _param.idContainer + "-studentrecordstalentstatus-hidden").val();
        var _healthy = $("#" + _param.idContainer + "-studentrecordshealthystatus-hidden").val();
        var _work = $("#" + _param.idContainer + "-studentrecordsworkstatus-hidden").val();
        var _financial = $("#" + _param.idContainer + "-studentrecordsfinancialstatus-hidden").val();
        var _familyFatherPersonal = $("#" + _param.idContainer + "-studentrecordsfamilyfatherpersonalstatus-hidden").val();
        var _familyMotherPersonal = $("#" + _param.idContainer + "-studentrecordsfamilymotherpersonalstatus-hidden").val();
        var _familyParentPersonal = $("#" + _param.idContainer + "-studentrecordsfamilyparentpersonalstatus-hidden").val();
        var _familyFatherAddressPermanent = $("#" + _param.idContainer + "-studentrecordsfamilyfatheraddresspermanentstatus-hidden").val();
        var _familyMotherAddressPermanent = $("#" + _param.idContainer + "-studentrecordsfamilymotheraddresspermanentstatus-hidden").val();
        var _familyParentAddressPermanent = $("#" + _param.idContainer + "-studentrecordsfamilyparentaddresspermanentstatus-hidden").val();
        var _familyFatherAddressCurrent = $("#" + _param.idContainer + "-studentrecordsfamilyfatheraddresscurrentstatus-hidden").val();
        var _familyMotherAddressCurrent = $("#" + _param.idContainer + "-studentrecordsfamilymotheraddresscurrentstatus-hidden").val();
        var _familyParentAddressCurrent = $("#" + _param.idContainer + "-studentrecordsfamilyparentaddresscurrentstatus-hidden").val();
        var _familyFatherWork = $("#" + _param.idContainer + "-studentrecordsfamilyfatherworkstatus-hidden").val();
        var _familyMotherWork = $("#" + _param.idContainer + "-studentrecordsfamilymotherworkstatus-hidden").val();
        var _familyparentwork = $("#" + _param.idContainer + "-studentrecordsfamilyparentworkstatus-hidden").val();
        var _error = new Array();
        var _i = 0;
        var _data = {};

        if (_param.personal == true)
            _data.personal = _personal;

        if (_param.addressPermanent == true)
            _data.addressPermanent = _addressPermanent;

        if (_param.addressCurrent == true)
            _data.addressCurrent = _addressCurrent;

        if (_param.educationPrimarySchool == true)
            _data.educationPrimarySchool = _educationPrimarySchool;

        if (_param.educationJuniorHighSchool == true)
            _data.educationJuniorHighSchool = _educationJuniorHighSchool;

        if (_param.educationHighSchool == true)
            _data.educationHighSchool = _educationHighSchool;

        if (_param.educationUniversity == true)
            _data.educationUniversity = _educationUniversity;

        if (_param.educationAdmissionScores == true)
            _data.educationAdmissionScores = _educationAdmissionScores;

        if (_param.talent == true)
            _data.talent = _talent;

        if (_param.healthy == true)
            _data.healthy = _healthy;

        if (_param.work == true)
            _data.work = _work;

        if (_param.financial == true)
            _data.financial = _financial;

        if (_param.familyFatherPersonal == true)
            _data.familyFatherPersonal = _familyFatherPersonal;

        if (_param.familyMotherPersonal == true)
            _data.familyMotherPersonal = _familyMotherPersonal;

        if (_param.familyParentPersonal == true)
            _data.familyParentPersonal = _familyParentPersonal;

        if (_param.familyFatherAddressPermanent == true)
            _data.familyFatherAddressPermanent = _familyFatherAddressPermanent; 

        if (_param.familyMotherAddressPermanent == true)
            _data.familyMotherAddressPermanent = _familyMotherAddressPermanent;

        if (_param.familyParentAddressPermanent == true)
            _data.familyParentAddressPermanent = _familyParentAddressPermanent;

        if (_param.familyFatherAddressCurrent == true)
            _data.familyFatherAddressCurrent = _familyFatherAddressCurrent;

        if (_param.familyMotherAddressCurrent == true)
            _data.familyMotherAddressCurrent = _familyMotherAddressCurrent;

        if (_param.familyParentAddressCurrent == true)
            _data.familyParentAddressCurrent = _familyParentAddressCurrent;

        if (_param.familyFatherWork == true)
            _data.familyFatherWork = _familyFatherWork;

        if (_param.familyMotherWork == true)
            _data.familyMotherWork = _familyMotherWork;

        if (_param.familyparentwork == true)
            _data.familyparentwork = _familyparentwork;

        if (_data.personal == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลส่วนตัวให้ครบถ้วนและสมบูรณ์;Please enter student's personal data information complete.;";
            _i++;
        }

        if (_data.addressPermanent == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลที่อยู่ตามทะเบียนให้ครบถ้วนและสมบูรณ์;Please enter permanent address of student's address complete.;";
            _i++;
        }

        if (_data.addressCurrent == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้ให้ครบถ้วนและสมบูรณ์;Please enter current address of student's address complete.;";
            _i++;
        }

        if (_data.educationPrimarySchool == "N") {
            _error[_i] = ";;";
            _i++;
        }

        if (_data.educationJuniorHighSchool == "N") {
            _error[_i] = ";;";
            _i++;
        }

        if (_data.educationHighSchool == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลการศึกษาระดับมัธยมปลายให้ครบถ้วนและสมบูรณ์;Please enter high school education of academic record complete.;";
            _i++;
        }

        if (_data.educationUniversity == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลการศึกษาก่อนที่เข้า ม.มหิดลให้ครบถ้วนและสมบูรณ์;Please enter prior to entering MAHIDOL UNIVERSITY of academic record complete.;";
            _i++;
        }

        if (_data.educationAdmissionScores == "N") {
            _error[_i] = ";;";
            _i++;
        }

        if (_data.talent == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลความสามารถพิเศษให้ครบถ้วนและสมบูรณ์;Please enter talent information complete.;";
            _i++;
        }

        if (_data.healthy == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลสุขภาพให้ครบถ้วนและสมบูรณ์;Please enter health information complete.;";
            _i++;
        }

        if (_data.work == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลการทำงานให้ครบถ้วนและสมบูรณ์;Please enter worker information complete.;";
            _i++;
        }

        if (_data.financial == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลการเงินให้ครบถ้วนและสมบูรณ์;Please enter finance information complete.;";
            _i++;
        }

        if (_data.familyFatherPersonal == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลส่วนตัวของบิดาให้ครบถ้วนและสมบูรณ์;Please enter personal data of father's information complete.;";
            _i++;
        }

        if (_data.familyMotherPersonal == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลส่วนตัวของมารดาให้ครบถ้วนและสมบูรณ์;Please enter personal data of mother's information complete.;";
            _i++;
        }

        if (_data.familyParentPersonal == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลส่วนตัวของผู้ปกครองให้ครบถ้วนและสมบูรณ์;Please enter personal data of parent's information complete.;";
            _i++;
        }

        if (_data.familyFatherAddressPermanent == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลที่อยู่ตามทะเบียนบ้านของบิดาให้ครบถ้วนและสมบูรณ์;Please enter permanent address of father's address complete.;";
            _i++;
        }

        if (_data.familyMotherAddressPermanent == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลที่อยู่ตามทะเบียนบ้านของมารดาให้ครบถ้วนและสมบูรณ์;Please enter permanent address of mother's address complete.;";
            _i++;
        }

        if (_data.familyParentAddressPermanent == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลที่อยู่ตามทะเบียนบ้านของผู้ปกครองให้ครบถ้วนและสมบูรณ์;Please enter permanent address of parent's address complete.;";
            _i++;
        }

        if (_data.familyFatherAddressCurrent == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้ของบิดาให้ครบถ้วนและสมบูรณ์;Please enter current address of father's address complete.;";
            _i++;
        }

        if (_data.familyMotherAddressCurrent == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้ของมารดาให้ครบถ้วนและสมบูรณ์;Please enter current address of mother's address complete.;";
            _i++;
        }

        if (_data.familyParentAddressCurrent == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลที่อยู่ปัจจุบันที่ติดต่อได้ของผู้ปกครองให้ครบถ้วนและสมบูรณ์;Please enter current address of parent's address complete.;"; 
            _i++;
        }
        if (_data.familyFatherWork == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลการทำงานของบิดาให้ครบถ้วนและสมบูรณ์;Please enter worker information of father's information complete.;";
            _i++;
        }
        if (_data.familyMotherWork == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลการทำงานของมารดาให้ครบถ้วนและสมบูรณ์;Please enter worker information of mother's information complete.;";
            _i++;
        }
        if (_data.familyparentwork == "N") {
            _error[_i] = "กรุณาใส่ข้อมูลการทำงานของผู้ปกครองให้ครบถ้วนและสมบูรณ์;Please enter worker information of parent's information complete.;";
            _i++;
        }

        Util.dialogListMessageError({
            content: _error
        });

        return (_i > 0 ? false : true);
    }
}