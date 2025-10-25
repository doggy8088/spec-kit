#!/bin/bash

# ============================================================================
# 自動化更新與翻譯 spec-kit 專案腳本
# ============================================================================
# 此腳本會自動執行以下流程：
# 1. 從 upstream 更新 spec-kit-main 的內容
# 2. 自動翻譯更新的 Markdown 文件
# 3. 複製翻譯結果到 spec-kit-zh-tw
# 4. 提交並推送變更
# ============================================================================

set -e  # 遇到錯誤立即退出

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 設定專案路徑
SPEC_KIT_MAIN="/home/will/projects/t-1/spec-kit-main"
SPEC_KIT_ZH_TW="/home/will/projects/t-1/spec-kit-zh-tw"
TEMP_DIR="/tmp"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TRANSLATE_LIST="${TEMP_DIR}/translate-update-list-${TIMESTAMP}.txt"
LOG_FILE="${SPEC_KIT_ZH_TW}/logs/update-translate-${TIMESTAMP}.log"

# 建立日誌目錄
mkdir -p "${SPEC_KIT_ZH_TW}/logs"

# ============================================================================
# 日誌與輸出函數
# ============================================================================

# 同時輸出到 Console 和 Log 檔案
log() {
    local message="$1"
    local color="${2:-$NC}"
    echo -e "${color}${message}${NC}" | tee -a "${LOG_FILE}"
}

log_info() {
    log "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1" "${CYAN}"
}

log_success() {
    log "[SUCCESS] $(date '+%Y-%m-%d %H:%M:%S') - $1" "${GREEN}"
}

log_warning() {
    log "[WARNING] $(date '+%Y-%m-%d %H:%M:%S') - $1" "${YELLOW}"
}

log_error() {
    log "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $1" "${RED}"
}

log_section() {
    log "\n============================================================================" "${BLUE}"
    log "$1" "${BLUE}"
    log "============================================================================\n" "${BLUE}"
}

# 執行命令並記錄
run_cmd() {
    local cmd="$1"
    local description="$2"

    log_info "${description}"
    log_info "執行命令: ${cmd}"

    if eval "${cmd}" >> "${LOG_FILE}" 2>&1; then
        log_success "${description} - 完成"
        return 0
    else
        log_error "${description} - 失敗"
        return 1
    fi
}

# ============================================================================
# 主要流程
# ============================================================================

main() {
    log_section "開始自動化更新與翻譯流程"
    log_info "日誌檔案: ${LOG_FILE}"
    log_info "時間戳記: ${TIMESTAMP}"

    # ------------------------------------------------------------------------
    # 步驟 1: 切換到 spec-kit-main 目錄
    # ------------------------------------------------------------------------
    log_section "步驟 1: 切換到 spec-kit-main 目錄"

    if [ ! -d "${SPEC_KIT_MAIN}" ]; then
        log_error "目錄不存在: ${SPEC_KIT_MAIN}"
        exit 1
    fi

    cd "${SPEC_KIT_MAIN}" || exit 1
    log_success "已切換到: $(pwd)"

    # ------------------------------------------------------------------------
    # 步驟 2: 統計現有翻譯檔案數量
    # ------------------------------------------------------------------------
    log_section "步驟 2: 統計現有翻譯檔案"

    TOTAL_MD=$(find . -name '*.md' | grep -v _zh-tw | wc -l)
    TRANSLATED_MD=$(find . -name '*_zh-tw.md' | wc -l)

    log_info "Markdown 檔案總數（不含翻譯）: ${TOTAL_MD}"
    log_info "已翻譯的檔案數量: ${TRANSLATED_MD}"

    # ------------------------------------------------------------------------
    # 步驟 3: 更新 upstream 分支
    # ------------------------------------------------------------------------
    log_section "步驟 3: 從 upstream 更新 main 分支"

    run_cmd "git fetch upstream main" "取得 upstream/main 最新內容"

    # 計算版本差異
    COMMITS_BEHIND=$(git rev-list --count main..upstream/main)
    log_info "落後 upstream/main ${COMMITS_BEHIND} 個 commit"

    if [ "${COMMITS_BEHIND}" -eq 0 ]; then
        log_warning "已經是最新版本，無需更新"
    else
        # 顯示差異摘要
        log_info "正在生成差異摘要..."
        git --no-pager diff main..upstream/main --stat | tee -a "${LOG_FILE}"

        # 列出有差異的 Markdown 檔案
        log_info "列出有差異的 Markdown 檔案..."
        git diff --name-only main upstream/main -- '*.md' | tee "${TRANSLATE_LIST}" | tee -a "${LOG_FILE}"

        CHANGED_FILES=$(wc -l < "${TRANSLATE_LIST}")
        log_info "需要翻譯的檔案數量: ${CHANGED_FILES}"

        # 執行 rebase
        run_cmd "git rebase upstream/main --verbose" "Rebase 到 upstream/main"
        run_cmd "git push origin main" "推送到 origin/main"
    fi

    # ------------------------------------------------------------------------
    # 步驟 4: 準備翻譯環境
    # ------------------------------------------------------------------------
    log_section "步驟 4: 準備翻譯環境"

    if [ -f ~/.translator-spec-kit.bash ]; then
        source ~/.translator-spec-kit.bash
        log_success "已載入翻譯工具環境設定"
    else
        log_warning "找不到 ~/.translator-spec-kit.bash，繼續執行..."
    fi

    # 檢查 translator 是否可用
    if command -v translator &> /dev/null; then
        log_success "translator 工具已就緒"
        translator --print-config | tee -a "${LOG_FILE}"
    else
        log_error "找不到 translator 工具，請先安裝"
        exit 1
    fi

    # ------------------------------------------------------------------------
    # 步驟 5: 執行翻譯（如果有需要更新的檔案）
    # ------------------------------------------------------------------------
    if [ "${COMMITS_BEHIND}" -eq 0 ]; then
        log_section "步驟 5: 跳過翻譯（無新內容）"
    else
        log_section "步驟 5: 執行翻譯"

        # Dry run 檢查
        log_info "執行 Dry Run 檢查..."
        if translator -f "${TRANSLATE_LIST}" --force --dry-run >> "${LOG_FILE}" 2>&1; then
            log_success "Dry Run 檢查通過"
        else
            log_error "Dry Run 檢查失敗，請檢查日誌"
            exit 1
        fi

        # 實際執行翻譯
        log_info "開始執行翻譯（並發數: 27）..."
        if translator -f "${TRANSLATE_LIST}" --force --concurrent-limit 27 2>&1 | tee -a "${LOG_FILE}"; then
            log_success "翻譯完成"
        else
            log_error "翻譯過程發生錯誤"
            exit 1
        fi

        # 統計翻譯結果
        NEW_TRANSLATED=$(find . -name '*_zh-tw.md' | wc -l)
        log_info "翻譯後的檔案數量: ${NEW_TRANSLATED}"
        log_info "新增翻譯檔案: $((NEW_TRANSLATED - TRANSLATED_MD))"
    fi

    # ------------------------------------------------------------------------
    # 步驟 6: 複製翻譯檔案到 spec-kit-zh-tw
    # ------------------------------------------------------------------------
    log_section "步驟 6: 複製翻譯檔案到 spec-kit-zh-tw"

    # 檢查 copy-glob 是否可用
    if ! command -v copy-glob &> /dev/null; then
        log_error "找不到 copy-glob 工具，請先安裝"
        exit 1
    fi

    run_cmd "copy-glob -i '**/*_zh-tw.md' -o ${SPEC_KIT_ZH_TW}/ --remove-suffix '_zh-tw' --force --verbose" \
            "複製翻譯檔案"

    # ------------------------------------------------------------------------
    # 步驟 7: 切換到 spec-kit-zh-tw 並提交變更
    # ------------------------------------------------------------------------
    log_section "步驟 7: 提交並推送變更到 spec-kit-zh-tw"

    cd "${SPEC_KIT_ZH_TW}" || exit 1
    log_success "已切換到: $(pwd)"

    # 檢查是否有變更
    if [ -z "$(git status --porcelain)" ]; then
        log_warning "沒有檔案變更，跳過提交"
    else
        # 顯示變更統計
        CHANGED_COUNT=$(git status --porcelain | wc -l)
        log_info "變更的檔案數量: ${CHANGED_COUNT}"

        git status --short | tee -a "${LOG_FILE}"

        # 提交訊息使用今天的日期
        COMMIT_DATE=$(date +"%Y-%m-%d")
        COMMIT_MSG="更新翻譯 ${COMMIT_DATE}"

        log_info "準備提交..."
        run_cmd "git add ." "加入所有變更到暫存區"
        run_cmd "git commit -m '${COMMIT_MSG}'" "提交變更"
        run_cmd "git push origin zh-tw" "推送到 origin/zh-tw"

        log_success "Git 操作完成"
    fi

    # ------------------------------------------------------------------------
    # 完成
    # ------------------------------------------------------------------------
    log_section "流程執行完畢"
    log_success "所有步驟已完成！"
    log_info "日誌檔案已儲存至: ${LOG_FILE}"

    # 顯示最終統計
    echo ""
    log_info "=== 執行摘要 ==="
    log_info "原始 Markdown 檔案數: ${TOTAL_MD}"
    log_info "翻譯前已有檔案數: ${TRANSLATED_MD}"
    if [ "${COMMITS_BEHIND}" -ne 0 ]; then
        log_info "本次更新 commits 數: ${COMMITS_BEHIND}"
        log_info "本次翻譯檔案數: ${CHANGED_FILES}"
        log_info "翻譯後總檔案數: ${NEW_TRANSLATED}"
    fi
    log_info "變更的檔案數量: ${CHANGED_COUNT:-0}"

    echo ""
    log_success "🎉 自動化流程執行成功！"
}

# ============================================================================
# 錯誤處理
# ============================================================================

trap 'log_error "腳本執行過程發生錯誤，於第 ${LINENO} 行"; exit 1' ERR

# ============================================================================
# 執行主程式
# ============================================================================

main "$@"
