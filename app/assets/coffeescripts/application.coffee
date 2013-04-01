jQuery ->

  # edit number page
  if $('#add_ext_modal').length > 0
    
    # set checkbox statuses
    if $('#phonenumber_call_forward_to option:selected').length is 0
      checkbox = $('#phonenumber_is_call_forwarding_enabled')
      checkbox.attr 'checked' , false
      checkbox.attr 'disabled', true
    if $('#phonenumber_sms_forward_to option:selected').length is 0
      checkbox = $('#phonenumber_is_sms_forwarding_enabled')
      checkbox.attr 'checked' , false
      checkbox.attr 'disabled', true


    addNumberToSelect = (data) ->
      dialog = $('#add_ext_modal')
      select = dialog.data('select')
      select.append $("<option selected></option>").attr("value",data.id).text(data.number)

      container = select.parents '.container'
      $('[type=checkbox]', container).attr 'disabled', false

      dialog.modal('hide')

    $('.add_ext').click (e) ->
      e.preventDefault()
      select = $( 'select', $(this).parent())
      # open window
      dialog = $('#add_ext_modal')
      dialog.data('select', select)
      dialog.modal('show')

    $('#text_me').click (e) ->
      e.preventDefault()
      form = $(this).parents('form')

      request = $.ajax
        url: form.attr('action')
        type: 'POST'
        dataType: 'json'
        data:
          authenticity_token: $('[name=authenticity_token]', form).val()
          text_me: true
          number:  $('[name=number]', form).val()

      request.done (data) ->
        alert(data)

      request.fail (jqXHR, textStatus) ->
        alert jqXHR.responseText


    $('#save_ext').click (e) ->
      e.preventDefault()
      form = $('#create_extnumber_form')

      request = $.ajax
        url: form.attr('action')
        type: 'POST'
        dataType: 'json'
        data: form.serializeArray()

      request.done (data) ->
        addNumberToSelect(data)

      request.fail (jqXHR, textStatus) ->
        alert jqXHR.responseText