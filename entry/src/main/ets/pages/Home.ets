import { Logger } from '../utils/LogUtils'

@Component
export struct Home {
  aboutToAppear(): void {
    Logger.info("首页 aboutToAppear")
  }

  build() {
    Column() {

    }
    .width("100%")
    .height("100%")
  }
}