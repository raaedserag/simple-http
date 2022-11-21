import config from "config"

export const
  port = config.get("PORT"),
  host = config.get("HOST"),
  environment = config.get("ENVIRONMENT"),
  mysqlConfiguration = {
    host: config.get("MYSQL_HOST"),
    port: config.get("MYSQL_PORT"),
    user: config.get("MYSQL_USER"),
    password: config.get("MYSQL_PASSWORD"),
    database: config.get("MYSQL_DATABASE")
  }