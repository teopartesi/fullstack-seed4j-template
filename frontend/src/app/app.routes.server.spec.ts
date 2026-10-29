import { RenderMode } from '@angular/ssr';
import { serverRoutes } from './app.routes.server';

describe('server routes', () => {
  it('should render the home route on the server', () => {
    expect(serverRoutes[0]).toEqual({
      path: '',
      renderMode: RenderMode.Server,
    });
  });

  it('should return an HTTP 404 for unknown routes', () => {
    expect(serverRoutes[1]).toEqual({
      path: '**',
      renderMode: RenderMode.Server,
      status: 404,
    });
  });
});
