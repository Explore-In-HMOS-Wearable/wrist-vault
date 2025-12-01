import { PasswordManagerViewModel } from '../viewmodels/PasswordManagerViewModel';
import { SetupView } from '../views/SetupView';
import { UnlockView } from '../views/UnlockView';
import { PasswordListView } from '../views/PasswordListView';

@Entry
@Component
struct PasswordManager {
  @State @Watch('onViewModelChange') viewModel: PasswordManagerViewModel = new PasswordManagerViewModel();

  onViewModelChange(): void {
    // Force UI refresh when viewModel changes
  }

  async aboutToAppear(): Promise<void> {
    await this.viewModel.initialize();
  }

  build() {
    Column() {
      if (this.viewModel.setupMode) {
        SetupView({ viewModel: this.viewModel })
      } else if (!this.viewModel.isUnlocked) {
        UnlockView({ viewModel: this.viewModel })
      } else {
        PasswordListView({ viewModel: this.viewModel })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#1a1a1a')
  }
}