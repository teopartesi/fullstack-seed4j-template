import { AngularNodeAppEngine } from '@angular/ssr/node';
import { Express, NextFunction, Request, Response as ExpressResponse } from 'express';
import { vi } from 'vitest';
import { handleAngularRequest, reqHandler, startServer } from './server';

describe('SSR server', () => {
  const angularHandle = vi.fn();
  const engine = { handle: angularHandle } as unknown as Pick<AngularNodeAppEngine, 'handle'>;
  const request = {} as Request;
  const nodeResponse = {} as ExpressResponse;
  const next = vi.fn();
  const writeResponse = vi.fn();

  beforeEach(() => {
    angularHandle.mockReset();
    next.mockReset();
    writeResponse.mockReset();
  });

  it('should expose the Angular request handler', () => {
    expect(reqHandler).toBeTypeOf('function');
  });

  it('should write a rendered Angular response', async () => {
    const response = new Response('rendered');
    angularHandle.mockResolvedValue(response);

    await handleAngularRequest(engine, request, nodeResponse, next as NextFunction, writeResponse);

    expect(writeResponse).toHaveBeenCalledWith(response, nodeResponse);
    expect(next).not.toHaveBeenCalled();
  });

  it('should continue when Angular does not render a response', async () => {
    angularHandle.mockResolvedValue(null);

    await handleAngularRequest(engine, request, nodeResponse, next as NextFunction, writeResponse);

    expect(next).toHaveBeenCalledWith();
    expect(writeResponse).not.toHaveBeenCalled();
  });

  it('should forward rendering failures to Express', async () => {
    const error = new Error('render failure');
    angularHandle.mockRejectedValue(error);

    await handleAngularRequest(engine, request, nodeResponse, next as NextFunction, writeResponse);

    expect(next).toHaveBeenCalledWith(error);
  });

  it('should start Express on the configured port', () => {
    const listen = vi.fn((_port, callback) => callback());
    const server = { listen } as unknown as Express;
    const consoleLog = vi.spyOn(console, 'log').mockImplementation(() => undefined);

    startServer(server, 4100);

    expect(listen).toHaveBeenCalledWith(4100, expect.any(Function));
    expect(consoleLog).toHaveBeenCalledWith(
      'Node Express server listening on http://localhost:4100',
    );
    consoleLog.mockRestore();
  });

  it('should fail when Express cannot start', () => {
    const error = new Error('listen failure');
    const server = {
      listen: vi.fn((_port, callback) => callback(error)),
    } as unknown as Express;

    expect(() => startServer(server, 4100)).toThrow(error);
  });
});
