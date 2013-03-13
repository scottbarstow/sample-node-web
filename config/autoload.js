module.exports = function (compound) {
    return typeof window === 'undefined' ? [
        'ejs-ext',
        'jade-ext',
        'jugglingdb',
        'seedjs',
        'co-assets-compiler',
 		'railway-mailer'
    ].map(require) : [
    ];
};

