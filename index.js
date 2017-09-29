import { NativeModules } from 'react-native';
const { AppMetrica } = NativeModules;

export default {

    /**
     * Starts the statistics collection process.
     * @param {string} apiKey
     */
    activateWithApiKey(apiKey) {
        AppMetrica.activateWithApiKey(apiKey);
    },

    /**
     * Sends a custom event message and additional parameters (optional).
     * @param {string} message
     * @param {object} [params=null]
     */
    reportEvent(message, params = null) {
        AppMetrica.reportEvent(message, params);
    },

    /**
     * Sends error with reason.
     * @param {string} error
     * @param {object} reason
     */
    reportError(error, reason) {
        AppMetrica.reportError(error, reason);
    },
};
