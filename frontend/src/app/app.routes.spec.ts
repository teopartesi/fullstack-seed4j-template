import { TestBed } from '@angular/core/testing';
import { provideRouter } from '@angular/router';
import { RouterTestingHarness } from '@angular/router/testing';
import { routes } from './app.routes';
import { Home } from './pages/home/home';
import { NotFound } from './pages/not-found/not-found';

describe('application routes', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({ providers: [provideRouter(routes)] });
  });

  it('should display the home page and its document title', async () => {
    const harness = await RouterTestingHarness.create();

    await harness.navigateByUrl('/', Home);

    expect(harness.routeNativeElement?.querySelector('h1')?.textContent).toContain(
      'Un socle prêt pour votre prochaine application.',
    );
    expect(document.title).toBe('Accueil — Starter');
  });

  it('should display the not-found page for an unknown route', async () => {
    const harness = await RouterTestingHarness.create();

    await harness.navigateByUrl('/adresse-inconnue', NotFound);

    expect(harness.routeNativeElement?.textContent).toContain('Erreur 404');
    expect(document.title).toBe('Page introuvable — Starter');
  });
});
