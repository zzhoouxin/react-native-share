/**
 * Created by zhongzihuan on 2017/3/12.
 * 渲染点击效果
 */
import React, { Component } from 'react'
import {
	TouchableHighlight,
	View
} from 'react-native'

import PreColors from '../res/PreColors'

export default class PreTouchLayout extends Component {

	static defaultProps = {
		underlayColor: PreColors.bgBgPress,
		delay: 1500
	}

	static propTypes = {}

	// 构造
	constructor(props) {
		super(props)
		// 初始状态
		this.state = {
			enable: true
		}
		this.timer = null;
	}

	render() {
		let {
			underlayColor,
			style,
			delay
		} = this.props

		if (this.props.disable) {
			return (
				<View
					style={style}
				>
					<View>
						{this.props.children}
					</View>
				</View>
			)
		} else {
			return (
				<TouchableHighlight
					underlayColor={underlayColor}
					onPress={() => {
						if (this.state.enable) {
							this.timer !== null && clearTimeout(this.timer)
							if (this.props.onPress) {
								this.props.onPress()
								this.state.enable = false
								this.timer = setTimeout(() => {
									this.state.enable = true
								}, delay)
							}
						}
					}}
					style={style}
				>
					<View>
						{this.props.children}
					</View>
				</TouchableHighlight>
			)
		}
	}
}
