utils      = require '../utils'
timezoneJS = require 'timezone-js'

###
Returns html code of one tag with contents
 
@param {String} name name of tag
@param {String} inner inner html
@param {Object} params set of tag attributes
@param {Object} override set params to override params in previous arg
@returns {String} Finalized generic tag
###
genericTag = (name, inner, params, override) ->
  '<' + name + utils.htmlTagParams(params, override) + '>' + inner + '</' + name + '>'

###
Returns html code of a selfclosing tag

@param {String} name name of tag
@param {Object} params set of tag attributes
@param {Object} override set params to override params in previous arg
@returns {String} Finalized generic selfclosing tag
###
genericTagSelfclosing = (name, params, override) ->
  '<' + name + utils.htmlTagParams(params, override) + ' />'

us_states = [
  ['Alabama', 'AL'],
  ['Alaska', 'AK'],
  ['Arizona', 'AZ'],
  ['Arkansas', 'AR'],
  ['California', 'CA'],
  ['Colorado', 'CO'],
  ['Connecticut', 'CT'],
  ['Delaware', 'DE'],
  ['District of Columbia', 'DC'],
  ['Florida', 'FL'],
  ['Georgia', 'GA'],
  ['Hawaii', 'HI'],
  ['Idaho', 'ID'],
  ['Illinois', 'IL'],
  ['Indiana', 'IN'],
  ['Iowa', 'IA'],
  ['Kansas', 'KS'],
  ['Kentucky', 'KY'],
  ['Louisiana', 'LA'],
  ['Maine', 'ME'],
  ['Maryland', 'MD'],
  ['Massachusetts', 'MA'],
  ['Michigan', 'MI'],
  ['Minnesota', 'MN'],
  ['Mississippi', 'MS'],
  ['Missouri', 'MO'],
  ['Montana', 'MT'],
  ['Nebraska', 'NE'],
  ['Nevada', 'NV'],
  ['New Hampshire', 'NH'],
  ['New Jersey', 'NJ'],
  ['New Mexico', 'NM'],
  ['New York', 'NY'],
  ['North Carolina', 'NC'],
  ['North Dakota', 'ND'],
  ['Ohio', 'OH'],
  ['Oklahoma', 'OK'],
  ['Oregon', 'OR'],
  ['Pennsylvania', 'PA'],
  ['Puerto Rico', 'PR'],
  ['Rhode Island', 'RI'],
  ['South Carolina', 'SC'],
  ['South Dakota', 'SD'],
  ['Tennessee', 'TN'],
  ['Texas', 'TX'],
  ['Utah', 'UT'],
  ['Vermont', 'VT'],
  ['Virginia', 'VA'],
  ['Washington', 'WA'],
  ['West Virginia', 'WV'],
  ['Wisconsin', 'WI'],
  ['Wyoming', 'WY']
]

underscore = (name) ->
  if name?
    name.toLowerCase().replace(/\[/g,'_').replace(/\]/g,'')
  else
    name

module.exports =
  us_states: -> us_states

  optionsForSelect: (arr, val) ->
    out = ''
    for i in arr
      [name, id] = i
      params = {value: id}
      params.selected = 'selected' if val? and id? and val.toString() == id.toString()
      out += genericTag('option', utils.escape(name), params)
    return out

  selectTag: (name, options, params) ->
    params ||= {}
    params.name = name
    
    id = underscore(name)
    params.id = id if id?

    genericTag('select', options, params)

  selectYear: (name, params) ->
    params ||={}
    start = params.start || new Date().getFullYear()
    end   = params.end || (start + 15)
    delete params.start
    delete params.end
    params.name = name
    
    options = ''
    for year in [start..end]
      options += genericTag('option', year, value: year)

    genericTag('select', options, params)

  selectMonth: (name, params) ->
    params ||={}
    params.name = name

    options = ''
    for i in [1..12]
      options += genericTag('option', "#{i} - #{@t('date.month.'+i)}", value: i)

    genericTag('select', options, params)

  switcher: (name, value, isChecked) ->
    id = underscore(name)
    params = 
      type: 'checkbox'
      class: 'ios-switch'
      value: value
      name:  name
      id:    id
      
    params.checked = 'checked' if isChecked

    html = []
    html.push @viewContext.inputTag(params)
    html.push '<div class="switch"></div>'
    html.join('')

  navItem: (title, path, namespace) ->
    params = {class: 'active'} if namespace is @controllerName
    genericTag 'li', genericTag('a', title, href: path), params

  paginate: (collection) ->
    step = 5;
    return '' if (!collection.totalPages || collection.totalPages < 2)
    page = parseInt(collection.currentPage, 10)
    pages = collection.totalPages
    html = '<div class="pagination"><ul>'


    if page is 1
      html += "<li class='disabled'><a class='disabled'>«</a></li>"
    else
      html += "<li><a href='?page=#{page-1}'>«</a></li>"

    nextClass = (if page is pages then ' disabled' else '')

    start = if page <= step then 1 else page-step
    end   = page+step;
    
    start = pages-(step*2) if page > pages-step and pages-(step*2) > 0

    end = step*2 if end < (step*2)
    end = pages  if end > pages

    for i in [start..end]
      if i == page
        html += "<li class='active'><a>#{i}</a></li>"
      else
        html += "<li><a href='?page=#{i}'>#{i}</a></li>"

    if page is pages
      html += "<li class='disabled'><a class='disabled'>»</a></li>"
    else
      html += "<li><a href='?page=#{page+1}'>»</a></li>"

    html += '</ul></div>';
    return html;


  phoneNumber: (number) ->
        # code from ActionPack - little bit modified
        return '' unless number

        number = number.number if number.number

        return number if isNaN parseFloat(number)

        number       = number.toString().trim()
        delimiter    = "-"

        number.replace /(\d{1,3})(\d{3})(\d{4}$)/g,"#{delimiter}$1#{delimiter}$2#{delimiter}$3"


  dt: (milliseconds) ->
    return '' unless milliseconds
    d = new timezoneJS.Date( milliseconds, @locals.timezone )
    d.toString('MM/dd/yyyy HH:mm:ss Z')

  errorMessagesFor: (resource) ->
    printErrors = ->
      out = '<p>'
      out += genericTag('strong', 'Validation failed. Fix following errors before you continue:')
      out += '</p>'

      for own prop, messages of resource.errors
          out += '<ul>'
          messages.forEach (msg) ->
              out += genericTag('li', utils.camelize(prop, true) + ' ' + msg, class: 'error-message')

          out += '</ul>'

      return out

    out = ''
    if resource.errors
      out += genericTag('div', printErrors(), class: 'alert alert-error')


    return out
