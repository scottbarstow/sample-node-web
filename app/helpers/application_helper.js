var utils = require('../utils');

/**
 * Returns html code of one tag with contents
 *
 * @param {String} name name of tag
 * @param {String} inner inner html
 * @param {Object} params set of tag attributes
 * @param {Object} override set params to override params in previous arg
 * @returns {String} Finalized generic tag
 */
function genericTag(name, inner, params, override) {
    return '<' + name + utils.htmlTagParams(params, override) + '>' + inner + '</' + name + '>';
}

/**
 * Returns html code of a selfclosing tag
 *
 * @param {String} name name of tag
 * @param {Object} params set of tag attributes
 * @param {Object} override set params to override params in previous arg
 * @returns {String} Finalized generic selfclosing tag
 */
function genericTagSelfclosing(name, params, override) {
    return '<' + name + utils.htmlTagParams(params, override) + ' />';
}

module.exports = {
    errorMessagesFor: function errorMessagesFor(resource) {
        var out = '';
        var h = this;

        if (resource.errors) {
            out += genericTag('div', printErrors(), {class: 'alert alert-error'});
        }

        return out;

        function printErrors() {
            var out = '<p>';
            out += genericTag('strong', 'Validation failed. Fix following errors before you continue:');
            out += '</p>';
            for (var prop in resource.errors) {
                if (resource.errors.hasOwnProperty(prop)) {
                    out += '<ul>';
                    resource.errors[prop].forEach(function (msg) {
                        out += genericTag('li', utils.camelize(prop, true) + ' ' + msg, {class: 'error-message'});
                    });
                    out += '</ul>';
                }
            }
            return out;
        }
    }
};