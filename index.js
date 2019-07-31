import React, {Component} from 'react'
import {Image, NativeModules, StyleSheet, Text, View,Platform} from 'react-native'
import PropTypes from 'prop-types';
import PreDimens from './res/PreDimens';
import PreColors from './res/PreColors';
import PreStyles from './res/PreStyles';
import PreActionSheet from './res/PreActionSheet';
import PreTouchLayout from './res/PreTouchLayout';
import icon_wechat from './res/images/icon_wechat.png';
import icon_circle from './res/images/icon_circle.png';
import qq from './res/images/qq.png';

const Share = NativeModules.AJRCTShare;


const iconAllList = {
    "微信": {"img": icon_wechat, id: 1},
    "朋友圈": {"img": icon_circle, id: 2},
    "QQ": {"img": qq, id: 3},
    "微博": {"img": icon_circle, id: 4},

};


export default class SharePanelComponent extends Component {


    static propTypes = {
        iconList: PropTypes.arrayOf(PropTypes.string),
        shareUrl: PropTypes.string.isRequired,
        title: PropTypes.string.isRequired,
        desc: PropTypes.string.isRequired,
        imgUrl: PropTypes.string.isRequired,
    };


    static defaultProps = {
        iconList: ["微信", "朋友圈"],
    }

    constructor(props) {
        super(props)
        let {desc} = props;
        //检查类型
        this._typeCheck();
        // 初始状态
        this.state = {}


        console.log("ccc==========>", Share)
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


    share = (type) => {
        //组装数据过程
        let {shareUrl, desc, imgUrl, title} = this.props;
        let shareStr = {
            mUrl: shareUrl,
            shareContent : {
                title,
                desc,
                url: imgUrl
            },
        }
        if(Platform.OS === 'ios'){
            shareStr = JSON.stringify(shareStr);
        }
        //分享到好友或朋友圈
        Share.share(type, shareStr, result => {
            if (result) {
                this.refs.shareModal && this.refs.shareModal.close();
            }
        });
    };

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
        const {iconList} = this.props;

        let viewArr = []
        iconList.map((item, index) => {
            viewArr.push(
                this.renderItemContent(item, index)
            )
        })
        return (
            <View style={[styles.viewList, {justifyContent: iconList.length === 1 ? 'center' : 'space-between'}]}>
                {viewArr}
            </View>
        )

    }

    /**
     * 列子内容布局
     * @param model
     * @returns {XML}
     */
    renderItemContent = (name, i) => {
        if (!name) {
            return false
        }
        return (
            <PreTouchLayout
                key={i}
                underlayColor={PreColors.white}
                onPress={() => {
                    this.share(iconAllList[name].id)
                }}

            >
                <View style={{alignItems: 'center'}}>
                    <Image source={iconAllList[name].img} style={styles.ivShare} resizeMode={'contain'}/>
                    <View style={[PreStyles.center]}>
                        <Text style={styles.tvList}>{
                            name
                        }</Text>
                    </View>
                </View>
            </PreTouchLayout>
        )
    }

    /**
     * 父组件上的类型检查
     * @private
     */
    _typeCheck = () => {
        let {desc, imgUrl, title, shareUrl, iconList} = this.props;
        iconList.map(item => {
            let isHasProperty = iconAllList[item];
            if (!isHasProperty) {
                throw  new Error(`分享方式不支持"${item}",仅支持[微信、朋友圈、QQ、微博]"`)
            }
        })
        //
        if (desc === undefined) {
            throw  new Error("分享组件desc必填属性缺失")
        }
        if (imgUrl === undefined) {
            throw  new Error("分享组件imgUrl必填属性缺失")
        }
        if (title === undefined) {
            throw  new Error("分享组件title必填属性缺失")
        }
        if (shareUrl === undefined) {
            throw  new Error("分享组件shareUrl必填属性缺失")
        }
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
        this.refs.shareModal.open()
    }

    close() {
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
