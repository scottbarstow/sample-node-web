var undef;

exports.htmlTagParams = function(params, override) {
    var maybe_params = '';
    safeMerge(params, override);
    for (var key in params) {
        if (params[key] != undef) {
            maybe_params += ' ' + key + '="' + params[key].toString().replace(/&/g, '&amp;').replace(/"/g, '&quot;') + '"';
        }
    }
    return maybe_params;
};

var safeMerge = exports.safeMerge = function(merge_what) {
    merge_what = merge_what || {};
    Array.prototype.slice.call(arguments).forEach(function(merge_with, i) {
        if (i == 0) return;
        for (var key in merge_with) {
            if (!merge_with.hasOwnProperty(key) || key in merge_what) continue;
            merge_what[key] = merge_with[key];
        }
    });
    return merge_what;
};

exports.camelize = function(underscored, upcaseFirstLetter) {
    var res = '';
    underscored.split('_').forEach(function(part) {
        res += part[0].toUpperCase() + part.substr(1);
    });
    return upcaseFirstLetter ? res : res[0].toLowerCase() + res.substr(1);
};

exports.blank = function(v) {
    if (typeof v === 'undefined') return true;
    if (v instanceof Array && v.length === 0) return true;
    if (v === null) return true;
    if (typeof v == 'string' && v.trim().length === 0) return true;
    return false;
}

exports.escape = function(s){
    return (''+s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#x27;').replace(/\//g,'&#x2F;')
}
