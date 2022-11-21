import expressApi from "./routes/express-api.js"
import sequelizeClient from "./db/sequelize-client.js";

import { port, host, environment} from "./config/configuration.js";

(async function () {
    process
        .on("unhandledRejection", ex => { throw ex })
        .on('SIGTERM', () => process.exit(0))
        .on('SIGINT', () => process.exit(0))
        
        expressApi.listen(port, host, () => console.log(`Server started as ${environment} on http://${host}:${port}}`));
        await sequelizeClient.initialize()
})();
