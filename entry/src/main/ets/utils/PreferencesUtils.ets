import dataPreferences from '@ohos.data.preferences';
import { ArticleItemBean } from '../model/ArtcleItemBean';
import { Pair } from '../model/Pair';
import { User } from '../model/User';

const PREFERENCES_NAME = "wanandroid.preferences"
const PREFERENCES_USER = "login_info"
const PREFERENCES_HISTORY = "history"
const KEY_SELECTED_TREE_FIRST = "selected_tree_first";
const KEY_SELECTED_TREE_SECOND = "selected_tree_second";

export default class PreferencesUtils {
  private preferences: dataPreferences.Preferences;
  private static instance: PreferencesUtils;

  private constructor(context: Context) {
    this.preferences = dataPreferences.getPreferencesSync(context, {
      name: PREFERENCES_NAME
    })
  }


  getUser():User | undefined{
    const json = this.preferences.getSync(PREFERENCES_USER, "") as string;
    if (json) {
      const user: User = JSON.parse(json)
      return user;
    } else {
      return undefined;
    }
  }

  putUser(user?:User){
    if (user) {
      this.preferences.putSync(PREFERENCES_USER, JSON.stringify(user));
    } else {
      this.preferences.deleteSync(PREFERENCES_USER);
    }
    this.preferences.flush();
  }


  //专栏  id
  getHistory(): Pair<number,number> {
    const first = this.preferences.getSync(KEY_SELECTED_TREE_FIRST, 0) as number;
    const second = this.preferences.getSync(KEY_SELECTED_TREE_SECOND, 0) as number;
    return {
      first:first,
      second:second
    };
  }

  putHistory(first: number,second:number) {
    this.preferences.putSync(KEY_SELECTED_TREE_FIRST, first)
    this.preferences.putSync(KEY_SELECTED_TREE_SECOND, second)
    this.preferences.flush()
  }

   static get(context: Context): PreferencesUtils {
    if (PreferencesUtils.instance == undefined) {
      PreferencesUtils.instance = new PreferencesUtils(context)
    }
    return PreferencesUtils.instance
  }
}