// @flow

import { NativeModules } from 'react-native';
const { AppMetrica } = NativeModules;

type ActivationConfig = {
    apiKey: string,
    sessionTimeout?: number,
    firstActivationAsUpdate?: boolean,
};

type UserProfileAttributes = {
    name?: ?string,
    gender?: 'female' | 'male' | string | void,
    age?: ?number,
    birthDate?: Date | [number] | [number, number] | [number, number, number] | void,
    notificationsEnabled?: boolean,
    [string]: string | number | boolean,
};

export default {

    /**
     * Starts the statistics collection process.
     * @param {string} apiKey
     */
    activateWithApiKey(apiKey: string) {
        AppMetrica.activateWithApiKey(apiKey);
    },

    /**
     * Starts the statistics collection process using config.
     * @param {object} params
     */
    activateWithConfig(params: ActivationConfig) {
        AppMetrica.activateWithConfig(params);
    },

    /**
     * Sends a custom event message and additional parameters (optional).
     * @param {string} message
     * @param {object} [params=null]
     */
    reportEvent(message: string, params: ?Object = null) {
        AppMetrica.reportEvent(message, params);
    },

    /**
     * Sends error with reason.
     * @param {string} error
     * @param {object} reason
     */
    reportError(error: string, reason: Object) {
        AppMetrica.reportError(error, reason);
    },

    /**
     * Sets the ID of the user profile.
     * @param {string} userProfileId
     */
    setUserProfileID(userProfileId: string) {
        AppMetrica.setUserProfileID(userProfileId);
    },

    /**
     * Sets attributes of the user profile.
     * @param {object} attributes
     */
    reportUserProfile(attributes: UserProfileAttributes) {
        const readyAttributes = {};
        Object.keys(attributes).forEach(key => {
            if (
                key === 'birthDate' &&
                typeof attributes.birthDate === 'object' &&
                typeof attributes.birthDate.getTime === 'function'
            ) {
                readyAttributes.birthDate = attributes.birthDate.getTime();
            } else {
                readyAttributes[key] = attributes[key];
            }
        });
        AppMetrica.reportUserProfile(readyAttributes);
    },
};
