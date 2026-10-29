import {
  AngularNodeAppEngine,
  createNodeRequestHandler,
  isMainModule,
  writeResponseToNodeResponse,
} from '@angular/ssr/node';
import express, { Express, NextFunction, Request, Response as ExpressResponse } from 'express';
import { join } from 'node:path';

const browserDistFolder = join(import.meta.dirname, '../browser');

const app = express();
let angularApp: AngularNodeAppEngine | undefined;

const getAngularApp = (): AngularNodeAppEngine => {
  angularApp ??= new AngularNodeAppEngine();
  return angularApp;
};

type AngularRequestEngine = Pick<AngularNodeAppEngine, 'handle'>;
type AngularResponseWriter = (
  response: Response,
  nodeResponse: ExpressResponse,
) => void | Promise<void>;

export const handleAngularRequest = async (
  engine: AngularRequestEngine,
  request: Request,
  response: ExpressResponse,
  next: NextFunction,
  writeResponse: AngularResponseWriter = writeResponseToNodeResponse,
): Promise<void> => {
  try {
    const angularResponse = await engine.handle(request);

    if (angularResponse) {
      await writeResponse(angularResponse, response);
    } else {
      next();
    }
  } catch (error) {
    next(error);
  }
};

export const startServer = (
  server: Express = app,
  port: string | number = process.env['PORT'] || 4000,
): void => {
  server.listen(port, (error) => {
    if (error) {
      throw error;
    }

    console.log(`Node Express server listening on http://localhost:${port}`);
  });
};

/**
 * Example Express Rest API endpoints can be defined here.
 * Uncomment and define endpoints as necessary.
 *
 * Example:
 * ```ts
 * app.get('/api/{*splat}', (req, res) => {
 *   // Handle API request
 * });
 * ```
 */

/**
 * Serve static files from /browser
 */
app.use(
  express.static(browserDistFolder, {
    maxAge: '1y',
    index: false,
    redirect: false,
  }),
);

/**
 * Handle all other requests by rendering the Angular application.
 */
app.use((req, res, next) => {
  void handleAngularRequest(getAngularApp(), req, res, next);
});

/**
 * Start the server if this module is the main entry point, or it is ran via PM2.
 * The server listens on the port defined by the `PORT` environment variable, or defaults to 4000.
 */
if (isMainModule(import.meta.url) || process.env['pm_id']) {
  startServer();
}

/**
 * Request handler used by the Angular CLI (for dev-server and during build) or Firebase Cloud Functions.
 */
export const reqHandler = createNodeRequestHandler(app);
