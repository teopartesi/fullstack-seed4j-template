import { TestBed } from '@angular/core/testing';
import { provideRouter } from '@angular/router';
import { App } from './app';

describe('App', () => {
  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [App],
      providers: [provideRouter([])],
    }).compileComponents();
  });

  it('should create the app', () => {
    const fixture = TestBed.createComponent(App);
    const app = fixture.componentInstance;
    expect(app).toBeTruthy();
  });

  it('should expose an accessible application shell', () => {
    const fixture = TestBed.createComponent(App);
    fixture.detectChanges();
    const compiled = fixture.nativeElement as HTMLElement;

    expect(compiled.querySelector('nav')?.getAttribute('aria-label')).toBe('Navigation principale');
    expect(compiled.querySelector('a[href="#main-content"]')?.textContent).toContain(
      'Aller au contenu',
    );
    expect(compiled.querySelector('main')?.id).toBe('main-content');
    expect(compiled.querySelector('router-outlet')).not.toBeNull();
  });
});
