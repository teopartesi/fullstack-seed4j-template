import { TestBed } from '@angular/core/testing';
import { Home } from './home';

describe('Home', () => {
  it('should explain the current frontend scope', async () => {
    await TestBed.configureTestingModule({ imports: [Home] }).compileComponents();
    const fixture = TestBed.createComponent(Home);

    fixture.detectChanges();

    const content = fixture.nativeElement.textContent as string;
    expect(content).toContain('Socle frontend opérationnel');
    expect(content).toContain('aucune fonctionnalité métier');
  });
});
