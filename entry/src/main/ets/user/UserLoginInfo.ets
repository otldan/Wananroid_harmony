import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import EntryContext from '../common/EntryContext';
import { User } from '../model/User';
import Api from '../net/Api';
import PreferencesUtils from '../utils/PreferencesUtils';

export default class UserLoginInfo {
  private static instance: UserLoginInfo
  private static TAG = "UserLoginInfo"
  private user?: User
  private userListenerList: ((user?: User) => void)[] = []

  static get(): UserLoginInfo {
    if (UserLoginInfo.instance === undefined) {
      UserLoginInfo.instance = new UserLoginInfo()
    }
    return UserLoginInfo.instance
  }

  private constructor() {
    const context = EntryContext.getContext() as Context;
    const user:User |undefined = PreferencesUtils.get(context).getUser()
    if (user != undefined) {
      this.user = user;
      this.notifyObserver();
      this.updateUser().catch();
    }
  }

  isLogin(): boolean {
    if (this.user) {
      return true;
    }
    return false;
  }

  checkLogin(onLogin?: () => void) {
    if (this.isLogin()) {
      if (onLogin != undefined) {
        onLogin()
      }
    } else {
      promptAction.showDialog({
        title: "提示",
        message: "当前操作需要登录",
        buttons: [
          {
            text: "立即登录",
            color: $r("app.color.main")
          },
          {
            text: "取消",
            color: $r("app.color.text_h2")
          }
        ]
      }).then((resp) => {
        if (resp.index === 0) {
          router.pushUrl({
            url: 'pages/Login'
          })
        }
      })
    }
  }

  getUser(): User | undefined {
    return this.user;
  }

  setUser(user?: User) {
    this.user = user;
    this.notifyObserver();
    const context = EntryContext.getContext() as Context;
    PreferencesUtils.get(context).putUser(user);
  }

  async updateUser(): Promise<User> {
    if (this.isLogin()) {
      const res = await Api.get().getUserInfo()
      if (res.isSuccessWithData()) {
        const user = this.user!!;
        user.coinCount = res.getDataOrThrow().coinCount;
        user.level = res.getDataOrThrow().level;
        user.rank = res.getDataOrThrow().rank;
        this.setUser(user);
        return Promise.resolve(user);
      } else {
        return Promise.reject(res.errorMsg);
      }
    } else {
      return Promise.reject()
    }
  }

  addListener(listener: (user?: User) => void) {
    if (!this.userListenerList.includes(listener)) {
      this.userListenerList.push(listener);
    }
  }

  removeUserListener(listener: (user?: User) => void) {
    const index = this.userListenerList.indexOf(listener);
    if (index >= 0) {
      this.userListenerList.splice(index, 1);
    }
  }

  private notifyObserver() {
    this.userListenerList.forEach((listener) => {
      if (listener) {
        listener(this.user);
      }
    });
  }

  clearUser() {
    this.setUser(undefined);
    Api.get().clearCookie();
  }
}

