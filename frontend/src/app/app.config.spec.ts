import { appConfig } from './app.config';
import { config } from './app.config.server';

describe('application configuration', () => {
  it('should register the browser providers', () => {
    expect(appConfig.providers).toHaveLength(4);
  });

  it('should merge browser and server providers for SSR', () => {
    expect(config.providers?.length).toBeGreaterThan(appConfig.providers.length);
  });
});
