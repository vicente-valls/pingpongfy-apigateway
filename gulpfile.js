"use strict";

let gulp = require('gulp');
let swagger = require('gulp-swagger');

gulp.task('swagger-validation', () => {
    return gulp
        .src(['swagger.yml'])
        .pipe(swagger('schema.yaml'))
        .once('error', (error) => {
            console.log(error);
            process.exit(1);
        })
        .once('end', () => {
            process.exit();
        });
});
