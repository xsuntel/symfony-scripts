module.exports = {
    "env": {
        "browser": true,
        "commonjs": true,
        "es6": true,
        "node": true,
        "shared-node-browser": true,
        "jquery": true
    },
    "extends": [
        "eslint:recommended",
        "plugin:react/recommended"
        //"plugin:jquery/recommended"
        //"plugin:jquery/deprecated"
    ],
    "parserOptions": {
        "ecmaVersion": 6,
        "ecmaFeatures": {
            "experimentalObjectRestSpread": true,
            "jsx": true
        },
        "sourceType": "module"
    },
    "plugins": [
        "react",
        "jquery"
    ],
    "globals": {},
    "rules": {
        "indent": [
            "error",
            4
        ],
        "linebreak-style": [
            "error",
            "unix"
        ],
        "semi": ["error", "always"],
        "quotes": ["error", "single"],
        "func-names": [
            "error", "never"
        ],
        // react
        "react/jsx-uses-react": "error",
        "react/jsx-uses-vars": "error",

        // override configuration set by extending "eslint:recommended"
        "no-empty": "warn",
        "no-cond-assign": ["error", "always"],

        // disable rules from base configurations
        "for-direction": "off",
    }
};