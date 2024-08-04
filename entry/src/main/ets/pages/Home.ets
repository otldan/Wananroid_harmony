import { HomeBannerData } from '../model/Article';
import { Logger } from '../utils/LogUtils'
import { LoadState } from '../widgets/PageLoading';
import Api from '../net/Api'
import { Popular } from '../model/Popular';
import { recommend } from '../model/Recommend'
import { router } from '@kit.ArkUI';

declare type HomeItemData = HomeBannerData[] | Popular

@Component
export struct Home {
  @State loadState: LoadState = LoadState.LOADING;
  @State data: HomeItemData[] = [];

  aboutToAppear(): void {
    Logger.info("首页 aboutToAppear")
    this.loadData()
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
  // const recommend =
  if (bannerRes.isSuccessWithData()){
    let homeItemData :HomeItemData[]=[]
    homeItemData.push(bannerRes.data as HomeBannerData[])
    return Promise.resolve(homeItemData)
  }
  else {
    return Promise.reject()
  }


  }

  build() {
    Scroll() {
      Column() {
        if (this.data.length > 0){
          BannerComponent({bannerList:this.data[0] as HomeBannerData[]})
        }else {//占位
          Blank().width('100%').height(220)
        }
        Row() {
          Column() {
            Image($r("app.media.remen"))
              .objectFit(ImageFit.Cover)
              .width($r("app.float.size_40"))
              .height($r("app.float.size_40"))
            Text($r("app.string.popularBlog"))
              .padding({
                left: 16,
                top: 6,
                right: 16,
                bottom: 6
              })
              .fontColor($r("app.color.white"))
              .fontSize(15)
              .maxLines(1)
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .borderRadius($r("app.float.size_12"))
          .backgroundColor($r("app.color.green"))
          .padding({
            top: $r("app.float.size_12"),
            bottom: $r("app.float.size_12")
          })

          Column() {
            Image($r("app.media.wenti"))
              .objectFit(ImageFit.Cover)
              .width($r("app.float.size_40"))
              .height($r("app.float.size_40"))
            Text($r("app.string.dailyAsk"))
              .padding({
                left: 16,
                top: 6,
                right: 16,
                bottom: 6
              })
              .fontColor($r("app.color.white"))
              .fontSize(15)
              .maxLines(1)
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .borderRadius($r("app.float.size_12"))
          .backgroundColor($r("app.color.blue"))
          .padding({
            top: $r("app.float.size_12"),
            bottom: $r("app.float.size_12")
          })
          .margin({
            left: $r("app.float.size_16"),
          })
        }.width('100%')
        .padding({
          left: $r("app.float.size_16"),
          right: $r("app.float.size_16"),
          top:$r("app.float.size_16")
        })


        List() {
          ForEach(['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'], (item: string) => {
            ListItem() {
              Text(item)
                .fontSize(50)
                .height(150)
            }
          }, (item: string) => item)
        }
        .nestedScroll({
          scrollForward: NestedScrollMode.PARENT_FIRST,
          scrollBackward: NestedScrollMode.SELF_FIRST
        })
        .divider({
          strokeWidth: 1,
          color: Color.Gray
        })
        .edgeEffect(EdgeEffect.None)
        .height('100%')
        .width('100%')
      }
    }
    .width('100%')
    .height('100%')
  }
}

@Component
struct BannerComponent {
  private swiperController: SwiperController = new SwiperController()
  @State private bannerPosition: number = 0
  bannerList: HomeBannerData[] = []

  build() {
    Stack() {
      Swiper(this.swiperController) {
        ForEach(this.bannerList, (item: HomeBannerData) => {
          this.bannerItemBuilder(item)
        })
      }
      .autoPlay(true)
      .index(this.bannerPosition)
      .loop(true)
      .indicatorStyle({
        right: 16,
        bottom: 0
      })
      .onChange((index) => {
        this.bannerPosition = index;
      })
    }
    .width('100%')
    .height(220)
  }

  @Builder
  private bannerItemBuilder(data: HomeBannerData) {
    Stack({ alignContent: Alignment.Bottom }) {
      Image(data.imagePath)
        .objectFit(ImageFit.Cover)
        .width('100%')
        .height('100%')
      Text(data.title)
        .width('100%')
        .padding({
          left: 16,
          top: 6,
          right: 16,
          bottom: 6
        })
        .fontColor($r("app.color.white"))
        .fontSize(15)
        .maxLines(1)
        .backgroundColor($r("app.color.translucent_black_40"))
    }
    .width('100%')
    .height('100%')
    .onClick((event) => {
      router.pushUrl({
        url: 'pages/WebPage',
        params: {
          url: data.url
        }
      });
    })
  }
}