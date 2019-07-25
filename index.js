
import React, {Component} from 'react'
import {
    StyleSheet,
    View,
    Text,
    Image,
} from 'react-native'

// import {PreDimens, PreColors, PreStyles, PreActionSheet, PreTouchLayout} from 'pre_box'
import PreDimens from './res/PreDimens';
import PreColors from './res/PreColors';
import PreStyles from './res/PreStyles';
import PreActionSheet from './res/PreActionSheet';
import PreTouchLayout from './res/PreTouchLayout';
import icon_wechat from './res/images/icon_wechat.png'
import icon_circle from './res/images/icon_circle.png'


const TOP_LIST = [
    {id: 1, name: '好友', icon: icon_wechat},
    {id: 2, name: '朋友圈', icon: icon_circle},
]

const TOP_LIST_SINGLE = [
    {id: 1, name: '好友', icon: icon_wechat}
]

export default class SharePanelComponent extends Component {

    static defaultProps = {}

    constructor(props) {
        super(props)
        // 初始状态
        this.state = {}
    }

    componentWillMount() {
    }

    render() {
        return (
            <PreActionSheet
                ref={"shareModal"}
                style={{height: PreDimens.p300}}
                renderContent={this.renderContent}
            />
        )
    }

    renderContent = () => {
        return (
            <View>
                <Text style={{alignSelf: 'center', marginTop: PreDimens.p30, color: '#423f3d'}}>分享到</Text>
                {this.renderTopList()}
            </View>
        )
    }

    /**
     * 头部
     */
    renderTopList = () => {
        const {single} = this.props
        let topList = single ? TOP_LIST_SINGLE : TOP_LIST
        let viewArr = []
        for (let i = 0; i < topList.length; i++) {
            let model = topList[i]
            viewArr.push(
                this.renderItemContent(model)
            )
        }
        return (
            <View style={[styles.viewList, {justifyContent: single ? 'center' : 'space-between'}]}>
                {viewArr}
            </View>
        )
    }

    /**
     * 列子内容布局
     * @param model
     * @returns {XML}
     */
    renderItemContent = (model) => {
        if (!model) {
            return false
        }
        return (
            <PreTouchLayout
                underlayColor={PreColors.white}
                onPress={() => {
                    if (this.props.actionButton) {
                        this.props.actionButton(model)
                    }
                }}
            >
                <View style={{alignItems: 'center'}}>
                    <Image source={model.icon} style={styles.ivShare} resizeMode={'contain'}/>
                    <View style={[PreStyles.center]}>
                        <Text style={styles.tvList}>{
                            model.name
                        }</Text>
                    </View>
                </View>
            </PreTouchLayout>
        )
    }

    /**
     * 点击操作
     */
    actionButton = (model) => {
        let id = model.id
        if (!id) {
            return false
        }
    }

    open() {
        // const ref = this.props.modalRef
        this.refs.shareModal.open()
    }

    close() {
        // const ref = this.props.modalRef
        this.refs.shareModal.close()
        this.props.onClose && this.props.onClose('1')
    }
}

const styles = StyleSheet.create({
    viewList: {
        flexDirection: 'row',
        paddingLeft: PreDimens.p130,
        paddingRight: PreDimens.p130,
        paddingTop: PreDimens.p40,
        paddingBottom: PreDimens.p40
    },
    ivShare: {
        width: PreDimens.p100,
        height: PreDimens.p100,
    },
    tvList: {
        textAlign: 'center',
        marginTop: PreDimens.p10,
        color: '#423f3d'
    },
})
