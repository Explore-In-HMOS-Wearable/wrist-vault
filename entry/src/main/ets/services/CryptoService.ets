import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { util } from '@kit.ArkTS';

export class CryptoService {
  async hashPassword(password: string): Promise<string> {
    const md = cryptoFramework.createMd('SHA256');
    const textEncoder = new util.TextEncoder();
    await md.update({ data: new Uint8Array(textEncoder.encodeInto(password)) });
    const result = await md.digest();
    const base64Helper = new util.Base64Helper();
    return base64Helper.encodeToStringSync(result.data);
  }
}