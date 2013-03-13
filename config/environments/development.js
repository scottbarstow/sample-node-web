var express = require('express');

module.exports = function (compound) {
    var app = compound.app;

    app.configure('development', function () {
        //app.disable('view cache'); 
        //app.disable('model cache'); 
        //app.disable('eval cache'); 
        app.enable('log actions');
        app.enable('env info');
        app.enable('watch');
        //app.enable('merge stylesheets')
        //app.set('view options', { pretty: true });
        app.use(require('express').errorHandler({ dumpExceptions: true, showStack: true }));
        app.set('translationMissing', 'display');
    });
};
