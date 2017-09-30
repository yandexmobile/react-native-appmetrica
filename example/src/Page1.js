import React from 'react';
import {
    Alert,
    StyleSheet,
    TouchableOpacity,
    Text,
    View,
} from 'react-native';

import AppMetrica from './appmetrica';

class Page1 extends React.PureComponent {

    render() {
        return (
            <View style={styles.main}>
                <Text>page1</Text>
                <TouchableOpacity onPress={ this.handlePress }>
                    <Text>go to page2</Text>
                </TouchableOpacity>
                <TouchableOpacity onPress={ this.reportEventToAppMetrica }>
                    <Text>report event to AppMetrica</Text>
                </TouchableOpacity>
            </View>
        );
    }

    handlePress() {
        appNavigator.push({ id: 'page2' });
    }

    reportEventToAppMetrica() {
        AppMetrica.reportEvent('event from page1');
        Alert.alert('OK!');
    }
}

const styles = StyleSheet.create({
    main: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
    },
});

export default Page1;
