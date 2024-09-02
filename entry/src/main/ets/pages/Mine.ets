import UserLoginInfo from '../user/UserLoginInfo';
import { LoadState, PageLoading } from '../widgets/PageLoading'
import { TitleView } from '../widgets/TitleView';
import { promptAction, router } from '@kit.ArkUI';
import { User } from '../model/User';
import Api from '../net/Api';

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
    } else {
      this.isLogin = false
    }
  }

  aboutToAppear(): void {
    UserLoginInfo.get().addListener(this.listener)
  }

  aboutToDisappear(): void {
    UserLoginInfo.get().removeUserListener(this.listener)
  }

  build() {
    PageLoading({ loadState: this.loadState, showLoading: this.showLoading }) {
      Column() {
        TitleView({
          title: this.title,
          showBack: false
        })

        Column() {
          Image(this.isLogin == true ? $r('app.media.login_suc') : $r('app.media.login_err'))
            .width($r('app.float.size_76'))
            .height($r('app.float.size_76'))
        }.width('100%')
        .height('30%')


        Row() {
          Text($r('app.string.integral'))
            .layoutWeight(1)
            .fontSize(15)
            .fontColor($r("app.color.text_h1"))
          Text('积分')
            .fontSize(15)
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

        Row()
          .width('100%')
          .height(0.5)
          .backgroundColor($r("app.color.divider"))
        Row() {
          Text($r('app.string.collect'))
            .layoutWeight(1)
            .fontSize(15)
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
      title: $r('app.string.quitTitle'),
      message: $r('app.string.quitHint'),
      buttons: [
        {
          text: $r('app.string.confirm'),
          color: $r("app.color.main")
        },
        {
          text: $r('app.string.cancel'),
          color: $r("app.color.text_h2")
        }
      ]
    })
    if (promiseResult.index === 0) {
      await Api.get().logout();
      UserLoginInfo.get().clearUser();
    }

  }
}