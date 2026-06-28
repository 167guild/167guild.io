/** @type {import('@commitlint/types').UserConfig} */
export default {
  extends: ['@commitlint/config-conventional'],
  ignores: [
    // Ignore Copilot agent placeholder commits that are replaced by real work
    (commit) => commit === 'Initial plan',
  ],
};
