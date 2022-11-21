import sequelizeClient from "../db/sequelize-client.js";


export async function checkLiveStatus(req, res) {
    try {
        await sequelizeClient.ping();
        return res.status(200).send("Well done");
    } catch (error) {
        return res.status(503).send("Maintenance")
    }
}