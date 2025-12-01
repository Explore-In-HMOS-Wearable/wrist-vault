import { PasswordManagerViewModel } from '../viewmodels/PasswordManagerViewModel';
import { ArcList, ArcListAttribute, ArcListItem, LengthMetrics } from '@kit.ArkUI';

@Component
export struct UnlockView {
  @Link viewModel: PasswordManagerViewModel;
  @State masterPassword: string = '';

  build() {
    ArcList() {
      ArcListItem() {
        Column({ space: 12 }) {
          Text('🔐')
            .fontSize(48)
            .margin({ top: 20 })

          Text('Password')
            .fontSize(18)
            .fontColor('#ffffff')
            .fontWeight(FontWeight.Bold)

          Text('Manager')
            .fontSize(18)
            .fontColor('#ffffff')
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .padding(16)
      }

      ArcListItem() {
        TextInput({ placeholder: 'Master Password' })
          .type(InputType.Password)
          .onChange((val) => { this.masterPassword = val; })
          .backgroundColor('#2a2a2a')
          .fontColor('#ffffff')
          .width('85%')
          .height(44)
          .borderRadius(22)
      }

      if (this.viewModel.errorMsg) {
        ArcListItem() {
          Text(this.viewModel.errorMsg)
            .fontSize(12)
            .fontColor('#ff4444')
            .textAlign(TextAlign.Center)
            .width('80%')
        }
      }

      ArcListItem() {
        Button('Unlock')
          .onClick(async () => {
            await this.viewModel.unlock(this.masterPassword);
          })
          .backgroundColor('#007AFF')
          .width('70%')
          .height(44)
          .borderRadius(22)
          .fontSize(16)
      }
    }
    .width('100%')
    .height('100%')
    .space(LengthMetrics.vp(12))
  }
}