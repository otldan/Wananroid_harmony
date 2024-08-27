import { PullToRefresh } from '@ohos/pulltorefresh'
import { DBUtils, User } from '../../db/utils/DBUtils'
import { LoadState, PageLoading } from '../../widgets/PageLoading'

@Component
export struct AccountPage {
  dbUtils: DBUtils = new DBUtils()
  @State
  isShowBar: boolean = false
  @State loadState: LoadState = LoadState.LOADING;
  @State showLoading: boolean = false;
  aboutToAppear(): void {

  }

  build() {
    SideBarContainer(SideBarContainerType.Overlay) {

      Flex({wrap:FlexWrap.Wrap}) {
        Text('11111').margin({
          left:$r('app.float.float_16')
        }).B
        Text('2222').margin({
          left:$r('app.float.float_16')
        })
        Text('3333').margin({
          left:$r('app.float.float_16')
        })
        Text('444444444444').margin({
          left:$r('app.float.float_16')
        })
        Text('55').margin({
          left:$r('app.float.float_16')
        })
        Text('777777777').margin({
          left:$r('app.float.float_16')
        })
      }.backgroundColor($r('app.color.divider'))
      .borderRadius({
        topLeft:$r('app.float.float_16'),
        bottomLeft:$r('app.float.float_16'),
      }).padding({
        top: $r('app.float.float_20'),
        left: $r('app.float.float_14'),
        right: $r('app.float.float_14'),
        bottom: $r('app.float.float_20')
      })
      Column() { //内容
        Row() {
          Blank()
          Image($r('app.media.gengduo')).onClick(() => {

            animateTo({}, () => {
              this.isShowBar = true
            })
          }).width($r('app.float.size_36'))
            .height($r('app.float.size_36'))
        }.width('100%')
        PageLoading({
          loadState: this.loadState,
          showLoading: this.showLoading,
          onReload: () => {

          },
        }){
          // PullToRefresh()
        }
      }.padding({
        top: $r('app.float.float_20'),
        left: $r('app.float.float_14'),
        right: $r('app.float.float_14'),
        bottom: $r('app.float.float_20')
      })
    }
    .showSideBar(this.isShowBar)
    .sideBarPosition(SideBarPosition.End)
    .showControlButton(false)
    .width('100%')
    .height('100%')
    .onChange((status)=>{
      this.isShowBar = status
    })

  }
}