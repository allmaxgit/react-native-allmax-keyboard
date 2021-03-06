import React, { Component } from 'react';
import { AppRegistry, NativeModules, View } from 'react-native';
import TextField from './lib/TextField';

const { backSpace, insertText, switchSystemKeyboard, done } = NativeModules.RNAllmaxKeyboard;

const keyboardTypeRegistry = {};

function registerKeyboard(keyboardType, keyboardProvider) {
  keyboardTypeRegistry[keyboardType] = keyboardProvider;
}

class CustomKeyboardContainer extends Component {
  render() {
    const { tag, keyboardType } = this.props;
    const factory = keyboardTypeRegistry[keyboardType];
    if (!factory) {
      console.warn(`Custom keyboard type ${keyboardType} not registered.`);
      return null;
    }
    const Keyboard = factory();
    return <Keyboard tag={tag} />;
  }
}

AppRegistry.registerComponent("AllMaxKeyboard", () => CustomKeyboardContainer);

export {
  registerKeyboard,
  TextField,
  backSpace,
  insertText,
  done,
  switchSystemKeyboard,
}
