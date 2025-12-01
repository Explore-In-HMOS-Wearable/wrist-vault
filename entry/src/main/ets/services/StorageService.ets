import { preferences } from '@kit.ArkData';
import { PasswordEntry } from '../models/PasswordEntry';
import { common } from '@kit.AbilityKit';

export class StorageService {
  private prefsName: string = 'password_store';
  private context: common.UIAbilityContext;

  constructor(context: common.UIAbilityContext) {
    this.context = context;
  }

  async getMasterHash(): Promise<string> {
    const prefs = await preferences.getPreferences(this.context, this.prefsName);
    return await prefs.get('master_hash', '') as string;
  }

  async setMasterHash(hash: string): Promise<void> {
    const prefs = await preferences.getPreferences(this.context, this.prefsName);
    await prefs.put('master_hash', hash);
    await prefs.flush();
  }

  async getPasswords(): Promise<PasswordEntry[]> {
    const prefs = await preferences.getPreferences(this.context, this.prefsName);
    const data: string = await prefs.get('passwords', '[]') as string;
    return JSON.parse(data) as PasswordEntry[];
  }

  async savePasswords(passwords: PasswordEntry[]): Promise<void> {
    const prefs = await preferences.getPreferences(this.context, this.prefsName);
    await prefs.put('passwords', JSON.stringify(passwords));
    await prefs.flush();
  }
}