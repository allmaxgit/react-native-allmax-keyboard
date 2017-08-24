import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { NativeModules, TextInput, findNodeHandle } from 'react-native';

const { installKeyboard, uninstall } = NativeModules.RNAllmaxKeyboard;

export default class TextField extends Component {

  static propTypes = {
    ...TextInput.propTypes,
    customKeyboardType: PropTypes.string.isRequired
  };

  textInputRef = () => this.inputRef;

  componentDidMount() {
    setTimeout(() => installKeyboard(
      this.props.customKeyboardType, findNodeHandle(this.inputRef), this.props.keyboardHeight
    ), 80);
  }

  componentWillUnmount() {
    uninstall(findNodeHandle(this.inputRef));
  }

  render() {
    const { ...otherProps } = this.props;
    return (
      <TextInput
        ref={ref => this.inputRef = ref}
        autoCorrect={false}
        {...otherProps }
      />
    );
  }
}

