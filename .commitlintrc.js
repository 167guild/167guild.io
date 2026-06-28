/** @type {import('@commitlint/types').UserConfig} */
module.exports = {
  extends: ['@commitlint/config-conventional'],
  ignores: [
    // Ignore Copilot agent placeholder commits that are replaced by real work
    (commit) => commit === 'Initial plan',
  ],
};
