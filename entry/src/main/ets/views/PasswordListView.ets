import { PasswordManagerViewModel } from '../viewmodels/PasswordManagerViewModel';
import { PasswordEntry } from '../models/PasswordEntry';
import { ArcList, ArcListAttribute, ArcListItem, LengthMetrics } from '@kit.ArkUI';

@Component
export struct PasswordListView {
  @Link viewModel: PasswordManagerViewModel;
  @State showAddDialog: boolean = false;
  @State newName: string = '';
  @State newPassword: string = '';
  @State expandedId: string = '';

  build() {
    Stack() {
      ArcList() {
        // Header
        ArcListItem() {
          Row() {
            Text('Passwords')
              .fontSize(18)
              .fontColor('#ffffff')
              .fontWeight(FontWeight.Bold)
              .layoutWeight(1)

            // Better Add button
            Button('Add', { type: ButtonType.Capsule })
              .onClick(() => { this.showAddDialog = true; })
              .backgroundColor('#007AFF')
              .fontSize(12)
              .height(32)
              .padding({ left: 12, right: 12 })
          }
          .width('85%')
          .padding({ top: 16, bottom: 8 })
        }

        // Password list items
        ForEach(this.viewModel.passwords, (item: PasswordEntry) => {
          ArcListItem() {
            Column({ space: 6 }) {
              Row() {
                // Name only
                Text(item.name)
                  .fontSize(14)
                  .fontColor('#ffffff')
                  .fontWeight(FontWeight.Medium)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .layoutWeight(1)

                // Delete button
                Button('Del', { type: ButtonType.Capsule })
                  .onClick(async () => {
                    await this.viewModel.deletePassword(item.id);
                    if (this.expandedId === item.id) {
                      this.expandedId = '';
                    }
                  })
                  .backgroundColor('#ff3b30')
                  .fontSize(10)
                  .height(28)
                  .padding({ left: 10, right: 10 })
              }

              // Password row (inside the same Column)
              if (this.expandedId === item.id) {
                Text(item.password)
                  .fontSize(13)
                  .fontColor('#00e676') // revealed
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              } else {
                Text('••••••••')
                  .fontSize(13)
                  .fontColor('#888888')
              }
            }
            .width('85%')
            .padding(10)
            .backgroundColor('#2a2a2a')
            .borderRadius(16)
            .onClick(() => {
              // toggle reveal; clicking the card shows/hides password
              this.expandedId = (this.expandedId === item.id) ? '' : item.id;
            })
          }
        }, (item: PasswordEntry) => item.id)

        // Empty state
        if (this.viewModel.passwords.length === 0) {
          ArcListItem() {
            Column({ space: 8 }) {
              Text('No passwords yet')
                .fontSize(14)
                .fontColor('#888888')

              Text('Tap Add to create one')
                .fontSize(12)
                .fontColor('#666666')
            }
            .padding(20)
          }
        }
      }
      .width('100%')
      .height('100%')
      .space(LengthMetrics.vp(8))

      // Add Dialog Overlay
      if (this.showAddDialog) {
        Column() {
          this.AddPasswordDialog()
        }
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.7)')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder AddPasswordDialog() {
    Column({ space: 10 }) {
      Text('Add Password')
        .fontSize(14)
        .fontColor('#ffffff')
        .fontWeight(FontWeight.Bold)

      TextInput({ placeholder: 'Name (e.g. Home Wi-Fi)' })
        .onChange((val) => { this.newName = val; })
        .backgroundColor('#1a1a1a')
        .fontColor('#ffffff')
        .height(36)
        .fontSize(12)

      TextInput({ placeholder: 'Password' })
        .type(InputType.Password)
        .onChange((val) => { this.newPassword = val; })
        .backgroundColor('#1a1a1a')
        .fontColor('#ffffff')
        .height(36)
        .fontSize(12)

      if (this.viewModel.errorMsg) {
        Text(this.viewModel.errorMsg)
          .fontSize(10)
          .fontColor('#ff4444')
      }

      Row({ space: 8 }) {
        Button('Cancel', { type: ButtonType.Capsule })
          .onClick(() => {
            this.showAddDialog = false;
            this.viewModel.clearError();
          })
          .backgroundColor('#666666')
          .layoutWeight(1)
          .height(36)
          .fontSize(12)

        Button('Save', { type: ButtonType.Capsule })
          .onClick(async () => {
            const success = await this.viewModel.addPassword(
              this.newName,
              this.newPassword
            );
            if (success) {
              this.showAddDialog = false;
              this.newName = '';
              this.newPassword = '';
            }
          })
          .backgroundColor('#007AFF')
          .layoutWeight(1)
          .height(36)
          .fontSize(12)
      }
      .width('100%')
    }
    .width('80%')
    .padding(16)
    .backgroundColor('#2a2a2a')
    .borderRadius(16)
    .border({ width: 1, color: '#444444' })
  }
}