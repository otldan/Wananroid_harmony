import { router } from '@kit.ArkUI';
import { PAGE_WEB } from '../common/Constant';

export class  RouterUtils{

  static jumpWebPage(url:string,title:string){
  router.pushUrl({
    url: PAGE_WEB,
    params: {
      url: url,
      title:title
    }
  });
}
}