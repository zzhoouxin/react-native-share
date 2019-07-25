
import React, { Component } from 'react'
import { StyleSheet } from 'react-native'

import PreColors from '../res/PreColors'
import PreDimens from '../res/PreDimens'
import Modal from './index'

export default class PreActionSheet extends Component {

	static defaultProps = {
		modalRef: '',
		onClose: () => {
		},
		title: '', //对话框  标题信息  用于区分是否有标题
		style: null, //样式
		type: null, //弹出框类型
		tip: '', //对话框  提示信息
		buttonText: '', //对话框  按钮右侧文字
		buttonSecondaryText: '', //对话框  按钮左侧文字
		isOnlyTip: false, //对话框只做提示样式
		renderContent: null, //自定义弹出框内容布局
		modalHeight: null, //弹出框内容的高度
		dataSource: null, //数组
		bottomList: null, //分享弹窗  底部列表
		swipeToClose: true, //滑动关闭
		onClosed: () => {
		}, //弹窗关闭
		// onItemClick: (id, name) => {
		// }, //列表类点击回调
	}

	static propTypes = {}

	// 构造
	constructor(props) {
		super(props)

		// 初始状态
		this.state = {
			isOpen: false,
			isDisabled: false,
			swipeToClose: true,
			sliderValue: 0.3
		}
	}

	render() {
		let {modalRef} = this.props
		let modalHeight = this.props.title ? PreDimens.p362 : PreDimens.p330
		if (this.props.modalHeight) {
			modalHeight = this.props.modalHeight
		}
		console.log("")
		return (
			<Modal
				{...this.props}
				style={[styles.modal, {height: modalHeight}, this.props.style]} transparent={true} position={'bottom'}
				ref={modalRef}
				swipeToClose={this.props.swipeToClose}
				onClosed={() => {
					this.props.onClosed && this.props.onClosed()
				}}
			>
				{/*内容*/}
				{this.props.renderContent()}
			</Modal>
		)
	}

	onEndReached = () => {
	}

	open() {
		const ref = this.props.modalRef
		this.refs[ref].open()
	}

	close() {
		const ref = this.props.modalRef
		this.refs[ref].close()
		this.props.onClose()
	}
}

const
	styles = StyleSheet.create({

		modal: {},
		modal4: {
			height: PreDimens.p344
		},
		itemShare: {
			alignItems: 'center',
			justifyContent: 'center',
			width: PreDimens.p100,
			height: PreDimens.p100
		},
		ivDelStyle: {
			width: PreDimens.p30,
			height: PreDimens.p40
		},
		bottomButton: {
			flexDirection: 'row',
			justifyContent: 'center',
			width: PreDimens.fill_width
		},
		viewItem: {
			height: PreDimens.p98,
			borderBottomWidth: PreDimens.p1,
			borderBottomColor: PreColors.line,
			width: PreDimens.fill_width
		},
		viewList: {flexDirection: 'row', justifyContent: 'space-between', padding: PreDimens.p30},
		ivShare: {
			width: PreDimens.p100,
			height: PreDimens.p100,
		},
		tvList: {
			textAlign: 'center',
			marginTop: PreDimens.p10
		},
	})
