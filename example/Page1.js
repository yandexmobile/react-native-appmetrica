import React from 'react';
import {
    StyleSheet,
    TouchableOpacity,
    Text,
    View,
} from 'react-native';

class Page1 extends React.PureComponent {

    render() {
        return (
            <View style={styles.main}>
                <Text>page1</Text>
                <TouchableOpacity onPress={ () => appNavigator.push({ id: 'page2' }) }>
                    <Text>go to page2</Text>
                </TouchableOpacity>
            </View>
        )
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
