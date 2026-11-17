# 發布套件組

請發布具版本的套件組成品，測試其散佈途徑，再透過 Bundle Submission issue 提交中繼資料。新項目、版本更新與修復都使用相同的 issue 流程。請勿以手動編輯社群型錄或其文件表格來取代提交。

社群發布不是程式碼認證。維護者會檢查中繼資料、連結、成品一致性與提交的安裝證據；他們不會審查、稽核、背書或支援套件組程式碼或其安裝的元件。使用者在安裝前必須自行審查這些元件。

## 準備 release

請提供一個公開的 GitHub 儲存庫，其中包含 `bundle.yml`、`README.md` 與授權檔案（`LICENSE`、`LICENSE.md` 或 `LICENSE.txt`）。README 必須說明預定角色、已安裝的元件、所需的型錄，以及安裝與使用步驟。

請使用符合資訊清單契約的安全套件組 ID。社群提交的版本必須是數字的 `X.Y.Z`，不含 `v` 前綴。這比資訊清單解析器一般的 SemVer 支援更嚴格。請選擇二至五個小寫標籤。

請在線上驗證並建置具版本的成品：

```bash
specify bundle validate --path ./team-setup
specify bundle build --path ./team-setup --output ./dist
```

請解決警告，並確認預定的元件 release 皆可取得。建置只做結構檢查；建置完成的 ZIP 不是安裝證據。請將資訊清單與 README 以一般檔案（而非符號連結）納入。

建立標籤與 GitHub release，再附加產生的 `team-setup-1.0.0.zip`。社群下載 URL 必須屬於提交的儲存庫，並遵循以下形式：

```text
https://github.com/<owner>/<repo>/releases/download/<tag>/<id>-<version>.zip
```

標籤必須與提交的版本相符：`v1.0.0`、`1.0.0`，或帶有相符後綴的範圍標籤，例如 `team-setup-v1.0.0`。浮動的 `releases/latest/` URL 與原始碼封存檔不屬於社群套件組成品契約。該 release 與確切附加的 ZIP 成品必須存在。

## 測試散佈途徑

請在具備預定整合、且已註冊所有必需的已審查元件型錄的乾淨 Spec Kit 專案中測試。安裝 release 成品必須能成功，且不依賴作者專案中殘留的元件。

例如，在審查來源之後：

```bash
specify init --here --integration copilot
specify preset catalog add https://example.com/presets.json \
  --name team --install-allowed
specify extension catalog add https://example.com/extensions.json \
  --name team --install-allowed
curl -L -o team-setup-1.0.0.zip \
  https://github.com/example/team-setup/releases/download/v1.0.0/team-setup-1.0.0.zip
specify bundle install ./team-setup-1.0.0.zip
specify bundle list --json
```

請只使用你的套件組實際需要的型錄命令，適用時包括工作流程與步驟型錄。若每個元件都能從隨附或預設來源解析，請將必需的元件型錄回報為 `None`。

若要提議套件組型錄項目，請在另一個乾淨專案中，從允許安裝的型錄測試以 ID 安裝：

```bash
specify bundle catalog add https://example.com/bundles.json \
  --id team --policy install-allowed
specify bundle install team-setup
```

也請在該專案中註冊必需的元件型錄。套件組型錄只負責定位資訊清單，不會註冊配套型錄。內建社群型錄在發布後仍維持僅供探索。

請說明驗證、建置、成品安裝、適用時的型錄 ID 安裝、已安裝命令／工作流程的實際使用，以及移除。請在提交的測試細節中包含測試過的 Spec Kit 版本、作業系統、整合，以及任何相依型錄。

## 提交中繼資料

請開啟 [Bundle Submission issue](https://github.com/github/spec-kit/issues/new?template=bundle_submission.yml)。請提供 ID、名稱、版本、角色／團隊、描述、作者、儲存庫 URL、下載 URL、文件 URL、授權、必需的 Spec Kit 版本、選用的整合目標、元件摘要、必需的型錄、標籤、主要功能、測試細節、範例用法，以及提議的型錄項目。

請完成每個必需的測試與提交核取方塊。資訊清單、README、issue 中繼資料、型錄提議與測試證據必須一致。必需的配套型錄必須有 HTTPS URL 與記載的設定命令；提交自動化不會註冊它們。

選用的提交檢查碼可以 `sha256` 形式放在提議的型錄項目中，或放在附加的 `### SHA-256` 標題之下。它必須恰好包含 64 個十六進位字元。若兩個位置都有提供，去除空白並正規化大小寫後必須一致。格式錯誤或不符的檢查碼會使驗證失敗，不會被無聲取代。

## 提交之後會發生什麼事

1. issue 表單會套用 `triage-must-have` 的收件判定。這不會啟動型錄驗證。
2. 維護者在分流期間審查 issue，並另外套用 `bundle-submission` 以啟動自動化工作流程。貢獻者不需要自行套用或要求該標籤。
3. 自動化會驗證欄位、儲存庫／文件可用性、資訊清單一致性、授權可用性、release 釘選、實際成品下載與選用的檢查碼、型錄形狀、必需的型錄，以及測試證明。它不會執行下載的內容，也不會稽核程式碼。
4. 成功時，自動化會提議一份更新 `bundles/catalog.community.json` 與 `docs/community/bundles.md` 的草稿 pull request。它會記錄實際下載的封存檔 SHA-256，並保持 `verified: false`。
5. 維護者審查型錄變更，核准後合併。該項目便可透過 `specify bundle search` 探索。

確認的提交缺陷會收到 `validation-failed` 與修正細節。權限、網路或工具阻礙會回報為 blocked，不是通過的檢查，也不必然是套件組的缺陷。檢查碼不符或觀察到成品遺失，屬於提交失敗。

## 更新與修復

請發布新的不可變標籤 release，更新資訊清單與 README 的參照，並重新測試確切的成品與適用的型錄安裝途徑。請再提交一份 Bundle Submission issue，並指明正在更新的既有項目。除非 issue 明確說明是同版本的僅中繼資料修正，否則版本必須前進。

對於你自行營運的私人型錄，請依循型錄參考中關於目前與歷史 release 紀錄的說明。請勿假設社群提交流程會保留舊 release，或將內建來源改為允許安裝。

## 另請參閱

- [開發與測試套件組](developing.md)
- [資訊清單 API](api.md)
- [型錄項目與 release 歷史](catalogs.md)
- [CLI 參考](cli.md)
- [社群套件組清單](../community/bundles.md)
- [套件組總覽](overview.md)
