// @flow

import {NativeModules} from 'react-native';

const {AppMetrica} = NativeModules;

type ActivationConfig = {
    apiKey: string,
    sessionTimeout?: number,
    firstActivationAsUpdate?: boolean,
};

//export default AppMetrica = {

/**
 * Starts the statistics collection process.
 * @param {string} apiKey
 */
export function activateWithApiKey(apiKey: string) {
    AppMetrica.activateWithApiKey(apiKey);
}

/**
 * Starts the statistics collection process using config.
 * @param {object} params
 */
export function activateWithConfig(params: ActivationConfig) {
    AppMetrica.activateWithConfig(params);
}

/**
 * Sends a custom event message and additional parameters (optional).
 * @param {string} message
 * @param {object} [params=null]
 */
export function reportEvent(message: string, params: ?Object = null) {
    AppMetrica.reportEvent(message, params);
}

/**
 * Sends error with reason.
 * @param {string} error
 * @param {object} reason
 */
export function reportError(error: string, reason: Object) {
    AppMetrica.reportError(error, reason);
}

/**
 * Sets the ID of the user profile.
 * @param {string} userProfileId
 */
export function setUserProfileID(userProfileId: string) {
    AppMetrica.setUserProfileID(userProfileId);
}

//};
