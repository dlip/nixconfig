let { join } = require("path");

module.exports = {
  mode: process.env["NODE_ENV"] || "development",
  port: process.env["PORT"] || 5006,
  hostname: process.env["HOSTNAME"] || "0.0.0.0",
  serverFiles: process.env["SERVER_FILES"] || join(__dirname, "server-files"),
  userFiles: process.env["USER_FILES"] || join(__dirname, "user-files"),
};
