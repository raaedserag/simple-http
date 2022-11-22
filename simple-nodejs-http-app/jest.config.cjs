module.exports = {
    reporters: [
        'default',
        ['jest-junit', {
            outputDirectory: "./test-results/jest",
            outputName: "simple-http-api-results.xml"
        }]
    ]
}