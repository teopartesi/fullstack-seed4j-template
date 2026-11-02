import assert from 'node:assert/strict';
import test from 'node:test';

import releaseConfig from '../release.config.mjs';

function getPluginOptions(pluginName) {
  const pluginConfig = releaseConfig.plugins.find(entry => Array.isArray(entry) && entry[0] === pluginName);

  return pluginConfig?.[1] ?? {};
}

test('releases only from main', () => {
  assert.deepEqual(releaseConfig.branches, ['main']);
});

test('supports Gitmoji semantic version levels', () => {
  const analyzerOptions = getPluginOptions('@semantic-release/commit-analyzer');

  assert.ok(analyzerOptions.releaseRules.some(rule => rule.type === '💥' && rule.release === 'major'));
  assert.ok(analyzerOptions.releaseRules.some(rule => rule.type === '✨' && rule.release === 'minor'));
  assert.ok(analyzerOptions.releaseRules.some(rule => rule.type === '🐛' && rule.release === 'patch'));
});

test('creates release notes, a changelog commit and a GitHub release', () => {
  const pluginNames = releaseConfig.plugins.map(entry => (Array.isArray(entry) ? entry[0] : entry));
  const gitOptions = getPluginOptions('@semantic-release/git');

  assert.ok(pluginNames.indexOf('@semantic-release/release-notes-generator') < pluginNames.indexOf('@semantic-release/changelog'));
  assert.ok(pluginNames.indexOf('@semantic-release/changelog') < pluginNames.indexOf('@semantic-release/git'));
  assert.ok(pluginNames.includes('@semantic-release/github'));
  assert.deepEqual(gitOptions.assets, ['CHANGELOG.md']);
  assert.match(gitOptions.message, /\[skip ci\]/u);
});
