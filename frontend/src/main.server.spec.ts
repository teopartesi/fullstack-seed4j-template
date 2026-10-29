import { BootstrapContext, bootstrapApplication } from '@angular/platform-browser';
import { vi } from 'vitest';
import { App } from './app/app';
import { config } from './app/app.config.server';
import { createBootstrap } from './main.server';

describe('server bootstrap', () => {
  it('should bootstrap the application with its server configuration', async () => {
    const context = {} as BootstrapContext;
    const bootstrapApplicationFn = vi
      .fn()
      .mockResolvedValue({}) as unknown as typeof bootstrapApplication;
    const bootstrap = createBootstrap(bootstrapApplicationFn);

    await bootstrap(context);

    expect(bootstrapApplicationFn).toHaveBeenCalledWith(App, config, context);
  });
});
