import { ArticleItemBean } from '../model/ArtcleItemBean';
import Api from '../net/Api';
import UserLoginInfo from '../user/UserLoginInfo';
import { toast } from './Toast';

export default class CollectUtils {
  static async collect(article: ArticleItemBean, id?: number): Promise<boolean> {
    if (!UserLoginInfo.get().isLogin()) {
      UserLoginInfo.get().checkLogin();
      return Promise.resolve(false);
    }

    if (!id) {
      id = article.id;
    }
    if (article.collect) {
      const res = await Api.get().unCollect(id);
      if (res.isSuccess()) {
        article.collect = false;
      } else {
        toast(res.errorMsg);
      }
      return Promise.resolve(res.isSuccess());
    } else {
      const res = await Api.get().collect(id);
      if (res.isSuccess()) {
        article.collect = true;
      } else {
        toast(res.errorMsg);
      }
      return Promise.resolve(res.isSuccess());
    }
  }
}