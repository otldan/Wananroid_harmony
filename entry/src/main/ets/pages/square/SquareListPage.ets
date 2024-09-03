import {  ArticleList } from '../../model/Article'
import Api from '../../net/Api';
import { LoadState, PageLoading } from '../../widgets/PageLoading';
import { Logger } from '../../utils/LogUtils';
import { PullToRefresh, PullToRefreshConfigurator } from '@ohos/pulltorefresh';
import { ArticleItem } from '../ArticleItem';
import { ArticleItemBean } from '../../model/ArtcleItemBean';
import { StringUtils } from '../../utils/StringUtils';
import CollectUtils from '../../utils/CollectUtils';

@Component
export struct SquareListPage {
  @State loadState: LoadState = LoadState.LOADING;
  @State showLoading: boolean = false;
  cid: number = 0
  @State articleList: ArticleItemBean[] = []
  @State page: number = 0
  private scroller: Scroller = new Scroller();
  private refreshConfig = new PullToRefreshConfigurator();
  private more: boolean = true;

  aboutToAppear(): void {
    this.getData()
  }

  getData() {
    this.loadState = LoadState.LOADING
    this.getPageList(0).then((data) => {
      this.articleList = data;
      Logger.info("数据", `data = :${JSON.stringify(data)}`)
      if (this.articleList.length === 0) {
        this.loadState = LoadState.EMPTY;
      } else {
        this.loadState = LoadState.SUCCESS;
      }
    }, () => {
      this.loadState = LoadState.FAIL;
    })
  }

  private async getPageList(page: number): Promise<ArticleItemBean[]> {
    let data = await Api.get().getSquareArticleList(this.cid, page);
    if (data.isSuccessWithData()) {
      const list = data.getDataOrThrow().datas
      return Promise.resolve(list)
    } else {
      return Promise.reject()
    }

  }

  build() {
    PageLoading({
      loadState:this.loadState,
      showLoading:false,
      onReload:()=>{
        this.getData()
      }
    }){
      PullToRefresh({
        data:$articleList,
        scroller:this.scroller,
        refreshConfigurator:this.refreshConfig,
        customList:()=>{
         this.ArticleList()
        },
        onRefresh:()=>{
          return new Promise<string>((resolve, reject) => {
            this.getPageList(0).then(
              (data) => {
                this.page = 1;
                this.articleList = data;
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
              this.getPageList(this.page).then(
                (data) => {
                  if (data.length > 0) {
                    this.page++
                    this.articleList = this.articleList.concat(data);
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

      }).width('100%')
        .height('100%')
    }
  }


  @Builder
  private ArticleList(){
    List({scroller:this.scroller}){
      ForEach(this.articleList, (item: ArticleItemBean) => {
        ListItem() {
          ArticleItem({
            articleBean:item,
            collectCallBack: async (itemBean: ArticleItemBean)=>{
              const result = await  CollectUtils.collect(itemBean)
              if (result) {
                this.articleList = this.articleList.map(item => {
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