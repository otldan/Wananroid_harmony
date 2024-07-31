import { HomeBannerData } from '../model/Article';
import { Logger } from '../utils/LogUtils'
import { LoadState } from '../widgets/PageLoading';
import Api from '../net/Api'
import { Popular } from '../model/Popular';
import { data } from '@kit.TelephonyKit';

declare type HomeItemData = HomeBannerData[] | Popular

@Component
export struct Home {
  @State loadState: LoadState = LoadState.LOADING;
  @State data: HomeItemData[] = [];

  aboutToAppear(): void {
    Logger.info("首页 aboutToAppear")

  }

  async loadData() {
    this.loadState = LoadState.LOADING
    this.loadDataByPage().then((data) => {
      this.data = data;
      if (this.data.length === 0) {
        this.loadState = LoadState.EMPTY;
      } else {
        this.loadState = LoadState.SUCCESS;
      }
    }, () => {
      this.loadState = LoadState.FAIL
    })
  }

  async loadDataByPage(): Promise<HomeItemData[]> {
    const bannerRes = await Api.get().getHomeBanner();
    const recommend = 
    if (bannerRes.isSuccessWithData()){
      let homeItemData :HomeItemData[]=[]

      return Promise.resolve(homeItemData)
    }
    else {
      return Promise.reject()
    }


  }

  build() {
    Column() {

    }
    .width("100%")
    .height("100%")
  }
}