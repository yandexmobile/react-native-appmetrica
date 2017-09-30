import React from 'react';
import {
    StyleSheet,
    View,
} from 'react-native';
import { Navigator } from 'react-native-deprecated-custom-components';

import Page1 from './Page1';
import Page2 from './Page2';
import Page404 from './Page2';

const INITIAL_ROUTE = { id: 'page1' };

class Navigation extends React.PureComponent {

    render() {
        return (
            <View style={styles.main}>
                <Navigator
                    ref={ (component) => global.appNavigator = component }
                    initialRoute={ INITIAL_ROUTE }
                    renderScene={ this.renderScene }
                />
            </View>
        );
    }

    renderScene(route) {
        switch (route.id) {
            case 'page1': return <Page1/>;
            case 'page2': return <Page2/>;
            default: return <Page404/>;
        }
    }
}

const styles = StyleSheet.create({
    main: {
        flex: 1,
    },
});

export default Navigation;
