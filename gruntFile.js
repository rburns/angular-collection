module.exports = function(grunt) {

	grunt.loadNpmTasks('grunt-contrib-uglify');
	grunt.loadNpmTasks('grunt-contrib-concat');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-angular-templates');
	grunt.loadNpmTasks('grunt-ngmin');
	grunt.loadNpmTasks('grunt-karma');

	grunt.initConfig({
		concat: {
			options: {separator: ';'},
			dist: {
				src: [
					'src/*.js'
				],
				dest: 'dist/collection.js'
			},
		},
		uglify: {
			options: {report: 'min'},
			dist: {
				files: {'dist/collection.min.js': 'dist/collection.js'}
			}
		},
		ngmin: {
			js: {
				src: ['dist/collection.js'],
				dest: 'dist/collection.js'
			},
		},
		karma: {
			spec: {
				configFile: 'test/karma.conf.js'
			}
		},
		watch: {
			files: ['src/**/*.js', 'lib/**/*.js'],
			tasks: 'default'
		}
	});

	grunt.registerTask('default', ['concat', 'ngmin', 'uglify']);

	grunt.registerTask('spec', ['karma:spec']);
};
