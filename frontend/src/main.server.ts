import { BootstrapContext, bootstrapApplication } from '@angular/platform-browser';
import { App } from './app/app';
import { config } from './app/app.config.server';

type BootstrapApplication = typeof bootstrapApplication;

export const createBootstrap =
  (bootstrapApplicationFn: BootstrapApplication = bootstrapApplication) =>
  (context: BootstrapContext) =>
    bootstrapApplicationFn(App, config, context);

export default createBootstrap();
