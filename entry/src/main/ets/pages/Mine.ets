import UserLoginInfo from '../user/UserLoginInfo';
import { LoadState, PageLoading } from '../widgets/PageLoading'
import { TitleView } from '../widgets/TitleView';
import { promptAction, router } from '@kit.ArkUI';
import { User } from '../model/User';
import Api from '../net/Api';
import  {LOGIN }  from '../common/Constant'


@Component
export struct Mine {
  @State loadState: LoadState = LoadState.SUCCESS;
  @State showLoading: boolean = false;
  title: string = '';
  private user?: User
  @State isLogin: boolean = false;
  private listener = (user?: User) => {
    if (user) {
      this.isLogin = true
      this.user = user
    } else {
      this.isLogin = false
    }
  }

  aboutToAppear(): void {
    UserLoginInfo.get().addListener(this.listener)
    const user = UserLoginInfo.get().getUser();
    this.listener(user);
  }

  aboutToDisappear(): void {
    UserLoginInfo.get().removeUserListener(this.listener)
  }

  build() {
    PageLoading({ loadState: this.loadState, showLoading: this.showLoading }) {
      Column() {
        TitleView({
          title: this.title,
          showBack: false,
          showDriver:false
        })

        Column() {
          Navigator({target:this.isLogin != true ? LOGIN : "",type: NavigationType.Push }){
            Image(this.isLogin == true ? $r('app.media.login_suc') : $r('app.media.login_err'))
              .width($r('app.float.size_90'))
              .height($r('app.float.size_90'))

          }

        }.width('100%')
        .height('15%')
        .justifyContent(FlexAlign.Center)


        Row() {
          Text($r('app.string.integral'))
            .layoutWeight(1)
            .fontSize($r('app.float.float_16'))
            .fontColor($r("app.color.text_h1"))
          Text(this.user?.coinCount.toString())
            .fontSize($r('app.float.float_16'))
            .fontColor($r("app.color.text_h1"))
        }
        .width('100%')
        .height(50)
        .margin({ top: 50 })
        .alignItems(VerticalAlign.Center)
        .padding({ left: 16, right: 16 })
        .backgroundColor($r("app.color.white"))
        .onClick((e) => {
          UserLoginInfo.get().checkLogin()
        })
        Divider()
          .width('100%')
          .strokeWidth(0.5)
          .vertical(false)
          .height($r('app.float.size_16'))
          .lineCap(LineCapStyle.Round)
          .color($r('app.color.divider'))
        Row() {
          Text($r('app.string.collect'))
            .layoutWeight(1)
            .fontSize($r('app.float.float_16'))
            .fontColor($r("app.color.text_h1"))
          Image($r("app.media.ic_arrow_right"))
            .fillColor($r("app.color.text_h1"))
            .width(20)
            .height(20)
        }
        .width('100%')
        .height(50)
        .alignItems(VerticalAlign.Center)
        .padding({ left: 16, right: 16 })
        .backgroundColor($r("app.color.white"))
        .onClick((event) => {
          UserLoginInfo.get().checkLogin(() => {
            // router.pushUrl({ url: "pages/CollectList" })
          })
        })
        Divider()
          .width('100%')
          .strokeWidth(0.5)
          .vertical(false)
          .height($r('app.float.size_16'))
          .lineCap(LineCapStyle.Round)
          .color($r('app.color.divider'))
        if (this.isLogin) {
          Column() {
            Button($r('app.string.loginQuit'), {
              type: ButtonType.Capsule
            })
              .width('100%')
              .fontSize(15)
              .fontColor($r("app.color.white"))
              .backgroundColor($r("app.color.red"))
              .onClick((e) => {
                this.loginQuit()
              })
          }
          .width('100%')
          .margin({ top: 50 })
          .padding({ left: 16, right: 16 })
        }


      }.width('100%')
      .height('100%')
    }
  }

  /**
   * 退出弹框
   */
  async loginQuit() {
    const promiseResult = await promptAction.showDialog({
      message: $r('app.string.quitHint'),
      buttons: [
        {
          text: $r('app.string.confirm'),
          color: $r("app.color.main")
        },
        {
          text: $r('app.string.cancel'),
          color: $r("app.color.text_h1")
        }
      ],
      backgroundColor:$r('app.color.white'),
      alignment:DialogAlignment.Center
    })
    if (promiseResult.index === 0) {
      await Api.get().logout();
      UserLoginInfo.get().clearUser();
    }

  }
}