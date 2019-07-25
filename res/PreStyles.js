/**
 * Created by zhongzihuan on 2017/2/27.
 * 样式资源
 */
import {
	Dimensions,
	PixelRatio
} from 'react-native'
import PreColors from './PreColors'
import PreDimens from './PreDimens'

const PIXEL = 1 / PixelRatio.get()

const PreStyles = {

	container: {
		flex: 1,
		backgroundColor: PreColors.white,
	},
	padding: {
		padding: PreDimens.p30,
		backgroundColor: PreColors.white
	},
	space_between: {
		flexDirection: 'row',
		alignItems: 'center',
		justifyContent: 'space-between',
	},
	row: {
		flexDirection: 'row',
	},
	rowCenter: {
		flexDirection: 'row',
		alignItems: 'center'
	},
	space_between: {
		flexDirection: 'row',
		justifyContent: 'space-between'
	},
	grid: {
		flexDirection: 'row',
	},
	tv_normal: {
		fontSize: 13,
		color: PreColors.light_orange
	},
	tv_center_gray: {
		fontSize: 13,
		color: '#999999'
	},
	center_horizontal: {
		alignItems: 'center',
	},
	center_vertical: {
		justifyContent: 'center',
	},
	tv_small_orange: {
		fontSize: 13,
		color: '#ff7800'
	},
	tv_middle_black: {
		fontSize: 14,
		color: '#333333'
	},
	tv_middle_gray: {
		fontSize: 14,
		color: '#666666'
	},
	tv_big_white: {
		fontSize: PreDimens.p30,
		color: 'white'
	},
	center: {
		justifyContent: 'center',
		alignItems: 'center'
	},
	centerRow: {
		justifyContent: 'center',
		alignItems: 'center',
		flexDirection: 'row',
	},
	fill_width: Dimensions.get('window').width,
	fill_height: Dimensions.get('window').height,

	tvGrayLight13: {
		fontSize: 13,
		color: '#999999'
	},
	tvGrayDark13: {
		fontSize: 13,
		color: '#666666'
	},
	tvOrangeLight15: {
		fontSize: 15,
		color: PreColors.tv_light_orange
	},
	line: {
		height: PIXEL,
		backgroundColor: '#e5e5e5',
	},
	lineVertical: {
		width: PreDimens.p2,
		backgroundColor: '#e5e5e5',
	},

	dashItem: {
		height: 1,
		width: 4,
		marginRight: 2,
		flex: 1,
		backgroundColor: '#ddd',
	},
	//字体大小
	tvBig: {
		fontSize: 17,
	},
	tvH1: {
		fontSize: 16,
	},
	tvH2: {
		fontSize: PreDimens.p30,
	},
	tvH3: {
		fontSize: PreDimens.p28,
	},
	tvH4: {
		fontSize: PreDimens.p24,
	},
	tvH4Gray: {
		fontSize: PreDimens.p24,
		color: PreColors.gray_two
	},
	tvH5: {
		fontSize: 11,
	},

	bottomPadding: {
		height: PreDimens.p100
	},
	paddingTop: {
		height: PreDimens.p30
	},
	ring: {
		width: PreDimens.p16,
		height: PreDimens.p16,
		borderRadius: 8,
		backgroundColor: PreColors.bgLighOrange6
	},

	/**
	 * 文字样式
	 */
	tvLight13: {
		fontSize: 13,
		color: PreColors.tv_light_orange
	},
	tvHouseTitle: {
		fontSize: 17,
		fontWeight: 'bold',
		color: PreColors.tvOrange4
	},
	tvNormalBlack: {
		fontSize: 14,
		color: PreColors.tv_black
	},
	tvNormalWhite: {
		fontSize: 14,
		color: PreColors.white
	},
	tvNormalGray: {
		fontSize: 14,
		color: PreColors.tvGray
	},
	tvNormalOrange: {
		fontSize: 14,
		color: PreColors.tvOrange4
	},
	tvNormalGrayLight: {
		fontSize: 14,
		color: PreColors.tvGary2
	},

	tvSmallNormalGray: {
		fontSize: PreDimens.p24,
		color: PreColors.tvGray,
		lineHeight: 17
	},
	tvSmallGrayBlack: {
		fontSize: PreDimens.p24,
		color: PreColors.tvBlack
	},
	tvSmallGrayLight: {
		fontSize: PreDimens.p24,
		color: PreColors.tvGary2
	},
	lineHeightSmall: {
		lineHeight: 18
	},
	lineHeight: {
		lineHeight: 20
	},
	bottomButton: {
		width: Dimensions.get('window').width,
		height: PreDimens.p100,
		position: 'absolute',
		bottom: 0,
		backgroundColor: PreColors.red,
		justifyContent: 'center',
		borderTopWidth: PreDimens.p1,
		borderTopColor: PreColors.line
	},
	bottom: {
		position: 'absolute',
		bottom: 0
	},
	buttonView: {
		width: Dimensions.get('window').width,
		paddingLeft: PreDimens.p30,
		paddingRight: PreDimens.p30,
		backgroundColor: PreColors.white,
		flexDirection: 'row',
		alignItems: 'center'
	},
	listTouch: {
		height: PreDimens.p106,
		backgroundColor: PreColors.white,
		paddingLeft: PreDimens.p30,
		paddingRight: PreDimens.p30,
		justifyContent: 'center'
	},
	itemSeprator: {
		height: PreDimens.p20,
		backgroundColor: PreColors.bg
	},
	//字体样式形成标准
	tvSmallLightOrange: {
		fontSize: PreDimens.p24,
		color: PreColors.tv_light_orange
	},
	tvMiddle: {
		fontSize: PreDimens.a26,
	},
	tvLarge: {
		fontSize: PreDimens.p28
	},

	//字体样式形成标准:字体样式迭代都按照下面进行增减统一管理
	//36
	tvOrange36: {
		fontSize: PreDimens.p32,
		color: PreColors.tvOrange6
	},
	tvGray36: {
		fontSize: PreDimens.p32,
		color: PreColors.tvGray
	},
	//32
	tvBlack32: {
		fontSize: PreDimens.p32,
		color: PreColors.tvBlack
	},

	tvBlack32Bold: {
		fontSize: PreDimens.p32,
		color: PreColors.tvBlack,
		fontWeight: 'bold'
	},
	tvOrange30: {
		fontSize: PreDimens.a30,
		color: PreColors.tvOrange6
	},
	//28
	tvBlack28: {
		fontSize: PreDimens.p28,
		color: PreColors.tvBlack
	},
	tvOrange28: {
		fontSize: PreDimens.p28,
		color: PreColors.tvOrange6
	},
	tvGray28: {
		fontSize: PreDimens.p28,
		color: PreColors.tvGray
	},
	//24
	tvGray24: {
		fontSize: PreDimens.p24,
		color: PreColors.tvGray
	},
	tvLightOrange24: {
		fontSize: PreDimens.p24,
		color: PreColors.tv_light_orange
	},
	//20
	tvGrayLight20: {
		fontSize: PreDimens.p20,
		color: PreColors.tvGary2
	},
	tvOrange20: {
		fontSize: PreDimens.p20,
		color: PreColors.tvOrange6
	},
	tvBlueLight20: {
		fontSize: PreDimens.p20,
		color: PreColors.tv_blue1
	},
	tvCyan20: {
		fontSize: PreDimens.p20,
		color: PreColors.cyan
	},

}

export default PreStyles
