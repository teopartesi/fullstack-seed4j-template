describe('browser bootstrap', () => {
  it('should bootstrap the application in its root element', async () => {
    document.body.innerHTML = '<app-root></app-root>';

    const { bootstrapPromise } = await import('./main');
    await bootstrapPromise;

    expect(document.querySelector('app-root main')).not.toBeNull();
  });
});
