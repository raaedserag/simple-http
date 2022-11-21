import { Sequelize } from "sequelize";
import { setTimeout } from "timers/promises"
import { mysqlConfiguration } from "../config/configuration.js";

class MysqlClientConnection {
    constructor(connection = { host, port, user, password, database }) {
        this.connection = new Sequelize(
            connection.database,
            connection.user,
            connection.password,
            {
                host: connection.host,
                port: connection.port,
                dialect: "mysql",
            }
        );
    }
    async ping() {
        await this.connection.authenticate();
        console.log("Connection has been established successfully.");

    }
    async initialize() {
        try {
            await this.ping();

        } catch (error) {
            console.error("Connection", error);
            await setTimeout(5000)
            await this.initialize()
        }
    }
}
export default new MysqlClientConnection(mysqlConfiguration)