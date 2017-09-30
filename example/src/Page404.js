import React from 'react';
import {
    StyleSheet,
    Text,
    View,
} from 'react-native';

class Page2 extends React.PureComponent {

    render() {
        return (
            <View style={styles.main}>
                <Text>Unknown page</Text>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    main: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
    },
});

export default Page2;
