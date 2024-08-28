import { PullToRefresh, PullToRefreshConfigurator } from '@ohos/pulltorefresh'
import { ArticleItemBean } from '../../model/ArtcleItemBean'
import { Pair } from '../../model/Pair'
import { Tree } from '../../model/Tree'
import Api from '../../net/Api'
import { StringUtils } from '../../utils/StringUtils'
import { LoadState, PageLoading } from '../../widgets/PageLoading'
import { ArticleItem } from '../ArticleItem'

@Component
export struct AccountPage {
  @State
  isShowBar: boolean = false
  @State showLoading: boolean = false;
  @State treeList: Tree[] = [];
  @State loadStateTree: LoadState = LoadState.LOADING;
  @State loadStateArticle: LoadState = LoadState.LOADING;
  @State selectTreeTemp?: Tree = undefined;
  @State selectTrees: Pair<Tree | undefined, Tree | undefined> = { first: undefined, second: undefined };
  private page: number = 1;
  private more: boolean = true;
  @State dataList: ArticleItemBean[] = [];
  private scroller: Scroller = new Scroller();
  private refreshConfig = new PullToRefreshConfigurator();

  // aboutToAppear(): void {
  //   this.getTreeData()
  // }
  async getTreeData() {
    this.loadStateTree = LoadState.LOADING

    const res = await Api.get().getTree();
    if (res.isSuccessWithData()) {
      if (res.getDataOrThrow().length > 0) {
        this.treeList = res.getDataOrThrow()
        this.selectTreeTemp = this.treeList[0];
        this.selectTrees = { first: this.treeList[0], second: this.treeList[0].children[0] };
        this.loadStateTree = LoadState.SUCCESS;
        this.getArticleListData()
      } else {
        this.loadStateTree = LoadState.EMPTY
      }
    } else {
      this.loadStateTree = LoadState.FAIL
    }

  }

  private getArticleListData() {
    this.loadStateArticle = LoadState.LOADING;
    this.page = 1;
    this.getArticleDataByPage(0).then(
      (data) => {
        this.dataList = data;
        if (this.dataList.length === 0) {
          this.loadStateArticle = LoadState.EMPTY;
        } else {
          this.loadStateArticle = LoadState.SUCCESS;
        }
      },
      () => {
        this.loadStateArticle = LoadState.FAIL;
      })
  }

  private async getArticleDataByPage(page: number): Promise<ArticleItemBean[]> {
    const res = await Api.get().getTreeArticleList(this.selectTrees.second!.id, page);
    if (res.isSuccessWithData()) {
      const list = res.getDataOrThrow().dataAll;
      return Promise.resolve(list);
    } else {
      return Promise.reject();
    }
  }

  build() {
    SideBarContainer(SideBarContainerType.Overlay) {

      Scroll() {
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.treeList, (tree: Tree) => {
            Text("父类标题"+tree.name)
            ForEach(tree.children, (childTree: Tree) => {
              Text(childTree.name)
            })
          })
        }
      }.backgroundColor($r('app.color.divider'))
      .borderRadius({
        topLeft: $r('app.float.float_16'),
        bottomLeft: $r('app.float.float_16'),
      }).padding({
        top: $r('app.float.float_20'),
        left: $r('app.float.float_14'),
        right: $r('app.float.float_14'),
        bottom: $r('app.float.float_20')
      })

      Column() { //内容
        Row() {
          Blank()
          Image($r('app.media.gengduo')).onClick(() => {

            animateTo({}, () => {
              this.isShowBar = true
            })
          }).width($r('app.float.size_36'))
            .height($r('app.float.size_36'))
        }.width('100%')

        PageLoading({
          loadState: this.loadStateTree,
          showLoading: this.showLoading,
          onReload: () => {
            this.getTreeData()
          },
        }) {
          Column() {
            PullToRefresh({
              data: $data,
              scroller: this.scroller,
              refreshConfigurator: this.refreshConfig,
              customList: () => {
                this.ArticleList();
              },
              onLoadMore: () => {
                return new Promise<string>((resolve, reject) => {
                  if (this.more) {
                    this.getArticleDataByPage(this.page).then(
                      (data) => {
                        if (data.length > 0) {
                          this.page++
                          this.dataList = this.dataList.concat(data);
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
              },
              customLoad: null,
              customRefresh: null,
            })
          }
          .width('100%')
          .height('100%')
        }
      }.padding({
        top: $r('app.float.float_20'),
        left: $r('app.float.float_14'),
        right: $r('app.float.float_14'),
        bottom: $r('app.float.float_20')
      })
    }
    .showSideBar(this.isShowBar)
    .sideBarPosition(SideBarPosition.End)
    .showControlButton(false)
    .width('100%')
    .height('100%')
    .onChange((status) => {
      this.isShowBar = status
    })

  }

  @Builder
  private ArticleList() {
    List({ scroller: this.scroller }) {
      ForEach(this.dataList, (item: ArticleItemBean) => {
        ListItem() {
          ArticleItem({
            articleBean: item
          })
        }
      })
    }
    .width('100%')
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