const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const pkg = require('../package.json');

const server = (() => {
  const router = new express.Router();
  router.get('/', (req, res) => {
    // This is an example route. Remove it for production applications.
    res.send('${pkg.version} - Hello, World!');
  });
  router.get('/health-status', (req, res) => {
      res.send('ok');
  });
  
  const app = express();
  const env = conf.get('NODE_ENV');
  let serverProcess;

  const start = () => new Promise((resolve) => {
    app.set('port', conf.get('PORT'));
    app.use(requestLogger());
    app.use(cors());
    app.use(express.json());
    app.use(helmet());
    app.use('/', router);

    serverProcess = app.listen(app.get('port'), () => {
      logger.info('------------------------------------------------------------------');
      logger.info(`${pkg.name} - Version: ${pkg.version}`);
      logger.info('------------------------------------------------------------------');
      logger.info(`ATTENTION, ${env} ENVIRONMENT!`);
      logger.info('------------------------------------------------------------------');
      logger.info(`Express server listening on port: ${serverProcess.address().port}`);
      logger.info('------------------------------------------------------------------');

      return resolve(app);
    });
  });

  const stop = () => new Promise((resolve, reject) => {
    if (serverProcess) {
      serverProcess.close((err) => {
        if (err) {
          return reject(err);
        }
        return resolve();
      });
    }
  });

  return {
    start,
    stop
  };
})();

module.exports = server;
