import React from 'react';
import {
    StyleSheet,
    TouchableOpacity,
    Text,
    View,
} from 'react-native';

class Page2 extends React.PureComponent {

    render() {
        return (
            <View style={styles.main}>
                <Text>page2</Text>
                <TouchableOpacity onPress={ () => appNavigator.pop() }>
                    <Text>go back</Text>
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

export default Page2;
