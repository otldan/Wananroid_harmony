import WindowUtils from '../common/WindowUtils'
import { router } from '@kit.ArkUI';

@Component
export struct TitleView {
  @Prop
  title: string;
  showBack: boolean = true;
  onBack: () => void = () => {
    router.back();
  }

  build() {
    Column() {
      Row()
        .width('100%')
        .height(WindowUtils.statusBarHeight + 'px')
      Row() {
        if (this.showBack) {
          Image($r("app.media.ic_back"))
            .width($r('app.float.size_48'))
            .height($r('app.float.size_48'))
            .padding($r('app.float.size_14'))
            .fillColor($r("app.color.text_h1"))
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              if (this.onBack !== undefined) {
                this.onBack();
              }
            })
        }
        Text(this.title)
          .layoutWeight(1)
          .fontSize($r('app.float.float_20'))
          .fontColor($r("app.color.text_h1"))
          .maxLines(1)
          .textAlign(TextAlign.Center)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .padding({  right: $r('app.float.size_16') })
      }
      .width('100%')
      .height($r('app.float.size_48'))
      .alignItems(VerticalAlign.Center)
      Divider().vertical(false).strokeWidth(1).color($r('app.color.divider'))
    }
    .width('100%')
    .backgroundColor($r("app.color.white"))

  }
}