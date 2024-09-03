import { ArticleItemBean } from '../model/ArtcleItemBean'
import Api from '../net/Api'
import { LoadState, PageLoading } from '../widgets/PageLoading'
import { TitleView } from '../widgets/TitleView'
import { BusinessError } from '@kit.BasicServicesKit'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { PullToRefresh, PullToRefreshConfigurator } from '@ohos/pulltorefresh'
import { ArticleItem } from './ArticleItem'
import { router } from '@kit.ArkUI'
import { ArtcleParams } from '../model/ArtcleParams'
import { StringUtils } from '../utils/StringUtils'
import CollectUtils from '../utils/CollectUtils'


@Entry
@Component
struct CollectListPage {
  @State loadState: LoadState = LoadState.LOADING;
  @State showLoading: boolean = false;
  @State data: ArticleItemBean[] = [];
  private scroller: Scroller = new Scroller();
  private refreshConfig = new PullToRefreshConfigurator();
  private page: number = 1;
  private more: boolean = true;
  private params: ArtcleParams = (router.getParams() as ArtcleParams)



  aboutToAppear(): void {
    this.getData()
  }

  private getData() {
    this.loadState = LoadState.LOADING

    this.getPopularItemList(0).then((data)=>{
      this.data = data;
      hilog.info(0, "数据", `data = :${JSON.stringify(data)}`)
      if (this.data.length === 0) {
        this.loadState = LoadState.EMPTY;
      } else {
        this.loadState = LoadState.SUCCESS;
      }
    },()=>{
      this.loadState = LoadState.FAIL;
    })
  }

  private async getPopularItemList(page:number):Promise<ArticleItemBean[]>{
   const  data = await Api.get().getCollectList(page)
    if (data.isSuccessWithData()) {
      const list = data.getDataOrThrow().datas;
      list.forEach((item) => {
        item.collect = true;
      })
     return Promise.resolve(list)
    } else {
      return Promise.reject()
    }
  }



  build() {
    Column() {
      TitleView({
        title: StringUtils.getString($r('app.string.myCollect'))
      })
      PageLoading({
        loadState: this.loadState,
        showLoading: this.showLoading,
        onReload: () => {
          this.getData()
        },
      }){
        Column() {
          PullToRefresh({
            data: this.data,
            scroller: this.scroller,
            refreshConfigurator: this.refreshConfig,
            customList: () => {
              this.ArticleList()
            },
            onRefresh:()=>{
              return new Promise<string>((resolve, reject) => {
                this.getPopularItemList(0).then(
                  (data) => {
                    this.page = 1;
                    this.data = data;
                    resolve(StringUtils.getString($r('app.string.refresh_suc')));
                  },
                  () => {
                    resolve(StringUtils.getString($r('app.string.refresh_fail')));
                  }
                )
              });
            },
            onLoadMore:()=>{
              return new Promise<string>((resolve, reject) => {
                if (this.more) {
                  this.getPopularItemList(this.page).then(
                    (data) => {
                      if (data.length > 0) {
                        this.page++
                        this.data = this.data.concat(data);
                        resolve(StringUtils.getString($r('app.string.load_suc')));
                      } else {
                        this.more = false;
                        resolve(StringUtils.getString($r('app.string.load_more')));
                      }
                    },
                    () => {
                      resolve(StringUtils.getString($r('app.string.load_fail')));
                    }
                  )
                } else {
                  resolve(StringUtils.getString($r('app.string.load_more')));
                }
              });
            }
          })
        }
        .width('100%')
        .height('100%')
      }

    }.width("100%")
    .height("100%")
  }

  @Builder
  private ArticleList(){
  List({scroller:this.scroller}){
    ForEach(this.data, (item: ArticleItemBean) => {
      ListItem() {
        ArticleItem({
          articleBean:item,
          collectCallBack: async (itemBean: ArticleItemBean)=>{
            const result = await  CollectUtils.collect(itemBean,itemBean.originId)
            if (result) {
              this.data = this.data.map(item => {
                if (itemBean.id == item.id) {
                  item.collect =itemBean.collect
                }
                return item
              });
            }
          }
        })
      }
    })
  }.width('100%')
  .height('100%')
  .listDirection(Axis.Vertical)
  .divider({
    strokeWidth: 0.5,
    color: $r("app.color.divider"),
    startMargin: 16,
    endMargin: 16
  })
  .edgeEffect(EdgeEffect.None)

  }

}
