import web_webview from '@ohos.web.webview';
import { router } from '@kit.ArkUI';
import { WebParams } from '../model/WebParams';
import { TitleView } from '../widgets/TitleView';

@Entry
@Component
export struct WebPage {
  private webController: web_webview.WebviewController = new web_webview.WebviewController()
  private params: WebParams = (router.getParams() as WebParams)
  @State progress: number = 0

  build() {
    Column() {
      TitleView({
        title: this.params.title,
        showBack: true,
        onBack: () => {
          if (this.webController.accessBackward()) {
            this.webController.backward()
          } else {
            router.back()
          }
        }
      })

      Stack() {
        Web({
          src: this.params.url,
          controller: this.webController
        })
          .width('100%')
          .height('100%')
          .onlineImageAccess(true)
          .javaScriptAccess(true)
          .domStorageAccess(true)
          .databaseAccess(true)
          .mixedMode(MixedMode.All)
          .onTitleReceive((event) => {
          })
          .onProgressChange((event) => {
            this.progress = event?.newProgress ?? 0
          })

        if (this.progress != 100) {

          LoadingProgress()
            .color($r('app.color.main'))
            .width($r('app.float.size_120'))
            .height($r('app.float.size_120'))
        }
      }
    }
    .height('100%')
    .width('100%')
  }

  onBackPress(): boolean | void {
    if (this.webController.accessBackward()) {
      this.webController.backward()
      return true;
    }
    return false;
  }
}