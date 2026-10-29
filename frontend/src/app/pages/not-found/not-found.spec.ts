import { TestBed } from '@angular/core/testing';
import { provideRouter } from '@angular/router';
import { NotFound } from './not-found';

describe('NotFound', () => {
  it('should offer a link back to the home page', async () => {
    await TestBed.configureTestingModule({
      imports: [NotFound],
      providers: [provideRouter([])],
    }).compileComponents();
    const fixture = TestBed.createComponent(NotFound);

    fixture.detectChanges();

    const homeLink = fixture.nativeElement.querySelector('a') as HTMLAnchorElement;
    expect(homeLink.textContent).toContain('Revenir à l’accueil');
    expect(homeLink.getAttribute('href')).toBe('/');
  });
});
