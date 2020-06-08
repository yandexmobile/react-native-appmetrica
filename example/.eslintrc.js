module.exports = {
  root: true,
  extends: '@react-native-community',
  "overrides": [
    {
      "files": ["index.js"],
      "rules": {
        "no-undef": "off"
      },
    }
  ],
};
