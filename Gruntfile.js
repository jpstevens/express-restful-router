module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    coffeelint: {
      files: ['src/**/*.coffee'],
    },
    watch: {
      server: {
        files: ['src/**/*.coffee', 'tests/**/*.coffee'],
        tasks: ['test']
      }
    },
    mochaTest: {
      options: {
        reporter: 'spec',
        require: [
          'coffee-script/register',
          function(){ expect=require('chai').expect; },
          function(){ express=require('express'); },
          function(){ request=require('supertest'); }
        ]
      },
      src: ['tests/**/*-spec.coffee']
    },
    coffee: {
      dist: {
        expand: true,
        flatten: false,
        cwd: 'src/',
        src: ['**/*.coffee'],
        dest: 'dist/',
        ext: '.js'
      }
    }
  });

  require('load-grunt-tasks')(grunt);

  grunt.registerTask('test', ['mochaTest']);
  grunt.registerTask('build', ['coffeelint', 'coffee']);
  grunt.registerTask('default', ['test', 'build']);
};
