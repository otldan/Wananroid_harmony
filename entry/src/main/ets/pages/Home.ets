import { HomeBannerData } from '../model/Article';
import { Logger } from '../utils/LogUtils'
import { LoadState } from '../widgets/PageLoading';
import Api from '../net/Api'
import { router } from '@kit.ArkUI';
import { PopularColumn } from '../model/PopularColumn';
import { PopularWenDa } from '../model/PopularWenDa';
import  {PAGE_WEB,POPULAR_LIST }  from '../common/Constant'
import { ArticleItem } from './ArticleItem';
import { ArticleItemBean } from '../model/ArtcleItemBean';
import {RouterUtils} from '../utils/RouterUtils'

declare type HomeItemData = HomeBannerData[] | PopularColumn[] | PopularWenDa[]

@Component
export struct Home {
  @State loadState: LoadState = LoadState.LOADING;
  @State data: HomeItemData[] = [];
  @State bannerData: HomeBannerData[] = []
  articleBean:ArticleItemBean = {
    adminAdd: false,
    apkLink: '',
    audit: 0,
    author: '',
    canEdit: false,
    chapterId: 0,
    chapterName: '入门及知识点',
    collect: false,
    courseId: 0,
    desc: '',
    descMd: '',
    envelopePic: '',
    fresh: false,
    host: '',
    id: 0,
    isAdminAdd: false,
    link: '',
    niceDate: '2022-02-09 20:31',
    niceShareDate: '2022-02-09 20:31',
    origin: '',
    prefix: '',
    projectLink: '',
    publishTime: 0,
    realSuperChapterId: 0,
    selfVisible: 0,
    shareDate: 0,
    shareUser: '鸿洋',
    superChapterId: 0,
    superChapterName: 'Kotlin',
    tags: [],
    title: 'Kotlin反射全解析3 -- 大展身手的KProperty',
    type: 0,
    userId: 0,
    visible: 0,
    zan: 0
  }
  aboutToAppear(): void {
    Logger.info("首页 aboutToAppear")
    this.loadData()
  }

  jumpWebPage(url:string,title:string){
    router.pushUrl({
      url: PAGE_WEB,
      params: {
        url: url,
        title:title
      }
    });
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

        }

      }

      //专栏
      ListItem() { //https://www.wanandroid.com/article/list/0/json?cid=231  === subChapterId
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
          Image($r('app.media.hot'))
            .objectFit(ImageFit.Contain)
            .height($r('app.float.size_24'))
            .width($r('app.float.size_24'))
            .margin({
              left:$r('app.float.size_6')
            })
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
            bottom:$r('app.float.size_10'),
          })
        }.margin({
          left: $r('app.float.size_10')
        }).onClick(()=>{
          router.pushUrl({
            url: POPULAR_LIST,
            params: {
              cid: item.subChapterId,
              title:item.name
            }
          });
        })
      }, (item: PopularWenDa) => item.name)

      //问答
      ListItem() {//https://www.wanandroid.com/wenda/list/1/json 跳转
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

          Image($r('app.media.hot'))
            .objectFit(ImageFit.Contain)
            .height($r('app.float.size_24'))
            .width($r('app.float.size_24'))
            .margin({
              left:$r('app.float.size_6')
            })
        }.width('100%').margin({
          left: $r('app.float.size_10')
        })
      }.height($r('app.float.size_40')).width('100%').margin({ top: $r('app.float.size_14') })

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
        }.onClick(()=>{
          RouterUtils.jumpWebPage(item.link,item.title)
        })
      }, (item: PopularColumn) => item.title)

      ListItem().height($r('app.float.size_24'))
    }
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.SELF_FIRST
    })
    .scrollBar(BarState.Off)
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
      RouterUtils.jumpWebPage(data.url,data.title)
    })
  }


}

