normalizePhoneNumber =  (phoneNumber) ->
    digits = phoneNumber.replace( /[^\d]/g, '' )

    if [10,11,12].indexOf(digits.length) < 0
        return null

    if digits.length == 10
      return "+1" + digits

    else if digits.length == 11
      return "+" + digits

    else
      return digits

module.exports = (compound) ->
  compound.controllerExtensions.normalizePhoneNumber = normalizePhoneNumber