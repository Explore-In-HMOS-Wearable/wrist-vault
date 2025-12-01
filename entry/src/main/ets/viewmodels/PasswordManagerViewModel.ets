import { CryptoService } from '../services/CryptoService';
import { StorageService } from '../services/StorageService';
import { PasswordEntry } from '../models/PasswordEntry';
import { common } from '@kit.AbilityKit';

@Observed
export class PasswordManagerViewModel {
  private cryptoService: CryptoService;
  private storageService: StorageService;

  public isUnlocked: boolean = false;
  public setupMode: boolean = true;
  public passwords: PasswordEntry[] = [];
  public errorMsg: string = '';

  constructor(context: common.UIAbilityContext) {
    this.cryptoService = new CryptoService();
    this.storageService = new StorageService(context);
  }

  async initialize(): Promise<void> {
    const masterHash: string = await this.storageService.getMasterHash();
    this.setupMode = masterHash === '';
  }

  async setupMasterPassword(password: string): Promise<boolean> {
    if (password.length < 6) {
      this.errorMsg = 'Password must be at least 6 characters';
      return false;
    }

    const hash: string = await this.cryptoService.hashPassword(password);
    await this.storageService.setMasterHash(hash);

    this.setupMode = false;
    this.isUnlocked = true;
    this.errorMsg = '';
    await this.loadPasswords();
    return true;
  }

  async unlock(password: string): Promise<boolean> {
    const storedHash: string = await this.storageService.getMasterHash();
    const inputHash: string = await this.cryptoService.hashPassword(password);

    if (inputHash === storedHash) {
      this.isUnlocked = true;
      this.errorMsg = '';
      await this.loadPasswords();
      return true;
    } else {
      this.errorMsg = 'Incorrect password';
      return false;
    }
  }

  async loadPasswords(): Promise<void> {
    this.passwords = await this.storageService.getPasswords();
  }

  async addPassword(name: string, password: string): Promise<boolean> {
    if (!name || !password) {
      this.errorMsg = 'Name and password required';
      return false;
    }

    const newEntry: PasswordEntry = new PasswordEntry(
      Date.now().toString(),
      name,
      password,
      new Date().toISOString()
    );

    this.passwords = [...this.passwords, newEntry];

    await this.storageService.savePasswords(this.passwords);
    this.errorMsg = '';
    return true;
  }

  async deletePassword(id: string): Promise<void> {
    this.passwords = this.passwords.filter((p: PasswordEntry) => p.id !== id);
    await this.storageService.savePasswords(this.passwords);
  }

  clearError(): void {
    this.errorMsg = '';
  }
}