import { AccountPage } from './account/AccountPage'
import { Home } from './Home'
import { SquarePage } from './square/SquarePage'

@Entry
@Component
struct Index {
  private tabsController = new TabsController()
  @State currentIndex: number = 0

  build() {

    Column() {
      Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
        TabContent() {
          Home()
        }.tabBar(this.tabBuilder($r('app.string.home'), 0, $r("app.media.ic_tab_home_select"), $r("app.media.ic_tab_home")))


        TabContent() {
          SquarePage()
        }.tabBar(this.tabBuilder($r('app.string.square'), 1, $r("app.media.ic_tab_square_select"), $r("app.media.ic_tab_square")))

        TabContent() {
          AccountPage()
        }.tabBar(this.tabBuilder($r('app.string.special_column'), 2, $r("app.media.ic_tab_wechat_select"), $r("app.media.ic_tab_wechat")))

        TabContent() {
          // Mine()
        }.tabBar(this.tabBuilder($r('app.string.mine'), 3, $r("app.media.ic_tab_my_select"), $r("app.media.ic_tab_my")))
      }
      .scrollable(false)
      .layoutWeight(1)
      .animationDuration(0)


    }
  }

  @Builder
  tabBuilder(title:ResourceStr,targetIndex:number,selectedImg:Resource,normalImg:Resource){
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 24, height: 24 })
        .fillColor(this.currentIndex === targetIndex ? $r("app.color.main") : $r("app.color.navi_tab_unselect"))
      Text(title)
        .margin({
          top:$r("app.float.size_5")
        })
        .fontColor(this.currentIndex === targetIndex ? $r("app.color.main") : $r("app.color.navi_tab_unselect"))
        .fontSize(11)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex
      this.tabsController.changeIndex(targetIndex)
    })
  }
}

