import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    pathMatch: 'full',
    title: 'Accueil — Starter',
    loadComponent: () => import('./pages/home/home').then(({ Home }) => Home),
  },
  {
    path: '**',
    title: 'Page introuvable — Starter',
    loadComponent: () => import('./pages/not-found/not-found').then(({ NotFound }) => NotFound),
  },
];
