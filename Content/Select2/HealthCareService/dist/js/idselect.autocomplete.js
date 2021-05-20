if ($.ui && $.ui.dialog && $.ui.dialog.prototype._allowInteraction)
{
    var ui_dialog_interaction = $.ui.dialog.prototype._allowInteraction;

    $.ui.dialog.prototype._allowInteraction = function (e) {
        if ($(e.target).closest('.select2-dropdown').length) return true;
        return ui_dialog_interaction.apply(this, arguments);
    };
}