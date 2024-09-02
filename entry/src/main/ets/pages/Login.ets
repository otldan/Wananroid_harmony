import router from '@ohos.router'
import Api from '../net/Api'
import UserLoginInfo from '../user/UserLoginInfo';
import { toast } from '../utils/Toast';
import { LoadState, PageLoading } from '../widgets/PageLoading'
import { TitleView } from '../widgets/TitleView';

@Entry
@Component
struct Login {
  @State loadState: LoadState = LoadState.SUCCESS;
  @State showLoading: boolean = false;
  @State title: string = "登录";
  private account: string = "";
  private password: string = "";

  async login() {
    if (!this.account) {
      toast($r('app.string.input_pwd'));
      return;
    }
    if (!this.password) {
      toast($r('app.string.input_name'));
      return;
    }
    this.showLoading = true;
    const res = await Api.get().login(this.account, this.password);
    this.showLoading = false;
    if (res.isSuccessWithData()) {
      toast($r('app.string.login_suc'));
      UserLoginInfo.get().setUser(res.data);
      const user = await UserLoginInfo.get().updateUser();
      if (user) {
        router.back();
      }
    } else {
      toast(res.errorMsg);
    }
  }

  build() {
    Stack() {
      PageLoading({
        loadState: this.loadState,
        showLoading: this.showLoading,
      }) {
        Column() {
          TitleView({
            title: this.title,
            showBack:true
          })
          Column() {
            TextInput({
              placeholder: $r('app.string.input_name')
            })
              .fontSize($r('app.float.float_16'))
              .fontColor($r("app.color.text_h1"))
              .type(InputType.Email)
              .onChange((value) => {
                this.account = value
              })
            TextInput({
              placeholder: $r('app.string.input_pwd')
            })
              .margin({ top: $r('app.float.size_16') })
              .fontSize($r('app.float.float_16'))
              .fontColor($r("app.color.text_h1"))
              .type(InputType.Password)
              .onChange((value) => {
                this.password = value
              })
            Button($r('app.string.login'), {
              type: ButtonType.Capsule
            })
              .width('100%')
              .margin({ top: $r('app.float.size_48') })
              .fontSize($r('app.float.float_16'))
              .fontColor($r("app.color.white"))
              .backgroundColor($r("app.color.main"))
              .onClick((e) => {
                this.login().catch();
              })
          }
          .width('100%')
          .margin({ top: 120 })
          .padding({ left: $r('app.float.size_16'), right: $r('app.float.size_16') ,
          top:$r('app.float.size_6'),bottom:$r('app.float.size_6')})
        }
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height('100%')
  }
}

