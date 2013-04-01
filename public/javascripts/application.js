(function() {
  jQuery(function() {
    var addNumberToSelect, checkbox;

    if ($('#add_ext_modal').length > 0) {
      if ($('#phonenumber_call_forward_to option:selected').length === 0) {
        checkbox = $('#phonenumber_is_call_forwarding_enabled');
        checkbox.attr('checked', false);
        checkbox.attr('disabled', true);
      }
      if ($('#phonenumber_sms_forward_to option:selected').length === 0) {
        checkbox = $('#phonenumber_is_sms_forwarding_enabled');
        checkbox.attr('checked', false);
        checkbox.attr('disabled', true);
      }
      addNumberToSelect = function(data) {
        var container, dialog, select;

        dialog = $('#add_ext_modal');
        select = dialog.data('select');
        select.append($("<option selected></option>").attr("value", data.id).text(data.number));
        container = select.parents('.container');
        $('[type=checkbox]', container).attr('disabled', false);
        return dialog.modal('hide');
      };
      $('.add_ext').click(function(e) {
        var dialog, select;

        e.preventDefault();
        select = $('select', $(this).parent());
        dialog = $('#add_ext_modal');
        dialog.data('select', select);
        return dialog.modal('show');
      });
      $('#text_me').click(function(e) {
        var form, request;

        e.preventDefault();
        form = $(this).parents('form');
        request = $.ajax({
          url: form.attr('action'),
          type: 'POST',
          dataType: 'json',
          data: {
            authenticity_token: $('[name=authenticity_token]', form).val(),
            text_me: true,
            number: $('[name=number]', form).val()
          }
        });
        request.done(function(data) {
          return alert(data);
        });
        return request.fail(function(jqXHR, textStatus) {
          return alert(jqXHR.responseText);
        });
      });
      return $('#save_ext').click(function(e) {
        var form, request;

        e.preventDefault();
        form = $('#create_extnumber_form');
        request = $.ajax({
          url: form.attr('action'),
          type: 'POST',
          dataType: 'json',
          data: form.serializeArray()
        });
        request.done(function(data) {
          return addNumberToSelect(data);
        });
        return request.fail(function(jqXHR, textStatus) {
          return alert(jqXHR.responseText);
        });
      });
    }
  });

}).call(this);
