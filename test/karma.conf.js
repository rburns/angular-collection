module.exports = function(config) {
	config.set({

		basePath: '../',

		frameworks: ['mocha', 'sinon-chai'],

		files: [
			'test/helper/angular.js',
			'src/**/*.js',
			'test/mock/**/*.js',
			'test/mock/**/*.coffee',
			'test/helper/**/*.coffee',
			'test/spec/**/*.coffee'
		],

		exclude: [
		],

		preprocessors: {
			'src/**/*.js': 'coverage',
			'test/mock/**/*.coffee': 'coffee',
			'test/helper/**/*.coffee': 'coffee',
			'test/spec/**/*.coffee': 'coffee'
		},


		// possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
		reporters: ['progress'],
		// reporters: ['progress', 'coverage'],

		coffeePreprocessor: {
			options: {
				bare: true,
				sourceMap: true
			},
			transformPath: function(path) {
				return path.replace(/\.js$/, '.coffee');
			}
		},

		coverageReporter: {
			type : 'html',
			dir : 'test/coverage/'
		},

		port: 9876,

		colors: true,

		// possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
		logLevel: config.LOG_INFO,

		autoWatch: true,

		// Start these browsers, currently available:
		// - Chrome
		// - ChromeCanary
		// - Firefox
		// - Opera
		// - Safari (only Mac)
		// - PhantomJS
		// - IE (only Windows)
		browsers: ['PhantomJS'],

		captureTimeout: 60000,

		// Continuous Integration mode
		// if true, it capture browsers, run tests and exit
		singleRun: false
	});
};
