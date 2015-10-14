var babel = require("babel-core");

module.exports = {
  process: function (src, filename) {
    if (filename.indexOf("node_modules") === -1 && babel.canCompile(filename)) {
      return babel.transform(src, {
        filename: filename,
        stage: 2,
        retainLines: true,
        auxiliaryCommentBefore: "istanbul ignore next"
      }).code;
    }
    return src;
  }
};
