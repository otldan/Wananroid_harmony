import { HomeBannerData } from '../model/Article';
import { Logger } from '../utils/LogUtils'
import { LoadState } from '../widgets/PageLoading';
import Api from '../net/Api'
import { router } from '@kit.ArkUI';
import { PopularColumn } from '../model/PopularColumn';
import { PopularWenDa } from '../model/PopularWenDa';

declare type HomeItemData = HomeBannerData[] | PopularColumn[] | PopularWenDa[]

@Component
export struct Home {
  @State loadState: LoadState = LoadState.LOADING;
  @State data: HomeItemData[] = [];
  @State bannerData: HomeBannerData[] = []

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
    const popularColumn = await Api.get().getHomePopularColumn()
    const popularWenDa = await Api.get().getHomePopularWenDa()
    if (bannerRes.isSuccessWithData()) {
      let homeItemData: HomeItemData[] = []
      homeItemData.push(bannerRes.data as HomeBannerData[])
      homeItemData.push(popularColumn.data as PopularWenDa[])
      homeItemData.push(popularWenDa.data as PopularColumn[])
      return Promise.resolve(homeItemData)
    } else {
      return Promise.reject()
    }


  }

  build() {
    List() {
      ListItem() {
        Column() {
          if (this.data.length > 0) {
            BannerComponent({ bannerList: this.data[0] as HomeBannerData[] })
          } else { //占位
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
                })
                .fontColor($r("app.color.white"))
                .fontSize($r('app.float.float_16'))
                .maxLines(1)
            }
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center)
            .borderRadius($r("app.float.size_12"))
            .backgroundColor($r("app.color.green"))
            .height("100%")
            .justifyContent(FlexAlign.Center)

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
                })
                .fontColor($r("app.color.white"))
                .fontSize($r('app.float.float_16'))
                .maxLines(1)
            }
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center)
            .borderRadius($r("app.float.size_12"))
            .backgroundColor($r("app.color.blue"))
            .justifyContent(FlexAlign.Center)
            .margin({
              left: $r("app.float.size_16"),
            })
            .height("100%")
          }.width('100%')
          .padding({
            left: $r("app.float.size_16"),
            right: $r("app.float.size_16"),
          }).height($r('app.float.size_90'))
          .margin({
            top: $r("app.float.size_24")
          })


          // List() {
          //   }
          // .nestedScroll({
          //   scrollForward: NestedScrollMode.PARENT_FIRST,
          //   scrollBackward: NestedScrollMode.SELF_FIRST
          // })
          // .edgeEffect(EdgeEffect.None)
          // .width('100%')
          // .padding({ top: $r('app.float.size_18'), bottom: $r('app.float.size_18') })

          //   }
          // }.scrollBar(BarState.Off)
          // .width('100%')
          // .height('100%')
        }

      }

      ListItem() {
        Row() {
          Divider()
            .width($r('app.float.size_5'))
            .strokeWidth(5)
            .vertical(true)
            .height($r('app.float.size_16'))
            .lineCap(LineCapStyle.Round)
            .color($r('app.color.main'))
          Text($r('app.string.answers'))
            .margin({
              left: $r('app.float.size_5')
            })
            .fontSize($r('app.float.float_18'))
            .fontColor($r('app.color.black'))
        }.width('100%').margin({
          left: $r('app.float.size_10')
        })
      }.height($r('app.float.size_40')).width('100%').margin({ top: $r('app.float.size_24') })

      ForEach(this.data[2], (item: PopularColumn) => {
        ListItem() {
          Column() {
            Text(item.title)
              .fontSize($r('app.float.float_16'))
              .fontColor($r('app.color.black'))
              .padding({
                top: $r('app.float.size_10'),
                bottom: $r('app.float.size_10'),
                left: $r('app.float.size_10')
              }).width('100%')
            Divider()
              .width('100%')
              .strokeWidth(5)
              .vertical(false)
              .height($r('app.float.size_16'))
              .lineCap(LineCapStyle.Round)
              .color($r('app.color.line_1'))
          }
        }
      }, (item: PopularColumn) => item.title)

      ListItem() { //问答跳转到https://www.wanandroid.com/wenda/list/1/json
        Row() {
          Divider()
            .width($r('app.float.size_5'))
            .strokeWidth(5)
            .vertical(true)
            .height($r('app.float.size_16'))
            .lineCap(LineCapStyle.Round)
            .color($r('app.color.main'))
          Text($r('app.string.special'))
            .margin({
              left: $r('app.float.size_5')
            })
            .fontSize($r('app.float.float_18'))
            .fontColor($r('app.color.black'))
        }.width('100%')
      }.height($r('app.float.size_40')).width('100%')
      .margin({
        left: $r('app.float.size_10'),
        top: $r('app.float.size_16')
      })

      ForEach(this.data[1], (item: PopularWenDa, index: number) => {
        ListItem() {
          Row() {

            Text((index + 1).toString())
              .fontSize($r('app.float.float_16'))
              .fontColor($r('app.color.white'))
              .height($r('app.float.size_18'))
              .width($r('app.float.size_18'))
              .textAlign(TextAlign.Center)
              .borderRadius(3)
              .backgroundColor(this.getTextColor(index))


            Text(item.name)
              .fontSize($r('app.float.float_16'))
              .fontColor($r('app.color.black'))
              .margin({
                left: $r('app.float.size_10')
              })

          }
          .padding({
            top: $r('app.float.size_10'),
          })
        }.margin({
          left: $r('app.float.size_10')
        })
      }, (item: PopularWenDa) => item.name)
      ListItem().height($r('app.float.size_24'))
    }
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.SELF_FIRST
    })
    .edgeEffect(EdgeEffect.None)
    .width('100%')
    .height('100%')
    .padding({ top: $r('app.float.size_18') })
  }

  getTextColor(index: number): ResourceStr {
    if (index === 0) {
      return $r('app.color.red')

    } else if (index === 1) {
      return $r('app.color.orange')

    } else if (index === 2) {
      return $r('app.color.yellow')

    } else {
      return $r('app.color.text_h2')
    }

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