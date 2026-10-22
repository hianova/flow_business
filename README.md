# FLOW Business — Six-Pillar Enterprise Forensic Sidecar & Ownership Control Plane

[![Pure Lean 4](https://img.shields.io/badge/Core-Pure%20.lean%20(Zero%20Sorry)-blue.svg)](src/flow_business.lean)
[![ABI](https://img.shields.io/badge/ABI-64--Byte%20Cache--Line%20Zero--Copy-success.svg)](src/flow_business.lean)
[![Architecture](https://img.shields.io/badge/Pillars-6%20Enterprise%20Lines%20(10%20Modules)-purple.svg)](src/flow_business.lean)

**FLOW Business** 是建立在 **FLOW 純 `.lean` 單一真相源（Single Source of Truth）** 之上的企業級「**確定性法醫外掛（Forensic Sidecar）+ 最小妥協反例生成（Min-Cut Counterfactual Engine）+ Ownership 簽章歸責控制面（Executive Liability Control Plane）**」。

本專案完整實作 **十大企業風控與合規模組（六大企業確定性防線）**，解決傳統形式化驗證在企業落地時最大的致命傷——「過度剛性（Over-Rigidity）導致業務停擺」，將數學證明從「阻擋交易的絆腳石」轉化為「**保護高管不背黑鍋、防止營收流失與交叉違約的防彈衣**」。

---

## 1. 六大企業確定性防線（Six Enterprise Pillars — 10 Core Modules）

| 防線編號 | 涵蓋模組 | 核心業務場景與防衛機制 | 對應 Pure `.lean` 定理（零 `sorry`） | 目標買家 (C-Suite) |
| :--- | :--- | :--- | :--- | :--- |
| **Pillar 1** | **Modules 1–5**<br>P2P 採購防呆、鬆弛預算、最小反例與 Ownership | • **鬆弛預算池（Slack Budget Pool）**：部門年度例外容忍額度守恆<br>• **三態法醫狀態機（Tri-State）**：微幅溢價絕不自動斷單，轉入 `FORENSIC_HOLD`<br>• **最小反例（Min-Cut）**：自動給出「砍數量 $\Delta Q$」或「補預算 $\Delta B$」<br>• **職權分離（SoD）與複式責任帳本** | [`slack_budget_conservation_sound`](src/flow_business.lean)<br>[`forensic_tristate_never_auto_terminates_minor_breach`](src/flow_business.lean)<br>[`min_cut_remediation_restores_polytope`](src/flow_business.lean)<br>[`ownership_sod_rejects_self_approval`](src/flow_business.lean)<br>[`ownership_liability_ledger_conservation`](src/flow_business.lean) | **CFO / CPO / 內控稽核長** |
| **Pillar 2** | **Module 9-I**<br>O2C 訂單到收款與 SLA 動態計價 | • **階梯返利單調性（Rebate Monotonicity）**：跨階梯採購不會因折扣跳階而少付錢<br>• **防漏開票（Zero Revenue Leakage）**：業務多重折扣疊加後低於底線自動攔截<br>• **3PL 延遲 SLA 運費折讓自動扣減** | [`rebate_tier_monotonic_sample`](src/flow_business.lean)<br>[`o2c_invoice_no_revenue_leakage`](src/flow_business.lean) | **CRO / 營收長 / 銷售營運 VP** |
| **Pillar 3** | **Module 9-II**<br>企業司庫（Treasury）與聯貸財務承諾（Covenants） | • **流動比率防線**：$\text{Current Ratio} \ge 1.20\times$<br>• **最壞匯率衝擊下之利息保障倍數**：$\text{Worst-Case Interest Coverage} \ge 3.50\times$<br>• **提前阻斷技術性交叉違約（Cross-Default）** | [`treasury_covenant_prevents_cross_default`](src/flow_business.lean) | **CFO / 集團司庫長 (Group Treasurer)** |
| **Pillar 4** | **Module 9-III**<br>跨國供應鏈與關稅原產地（USMCA / RCEP RVC） | • **動態 BOM 區域價值含量（RVC）**：$\text{RVC} = \frac{\text{TV} - \text{VNM}}{\text{TV}} \ge 60.0\%$<br>• **防範供應商零件漲價導致免稅資格失效與海關扣貨** | [`trade_rvc_prevents_customs_seizure`](src/flow_business.lean) | **全球供應鏈 VP / 關務法遵長** |
| **Pillar 5** | **Modules 6–8**<br>HR 反歧視安全港、Bar-Raiser 校準與生科數據鑑識 | • **EEOC 4/5 法則（80% Rule）**與因果 DAG 後門路徑阻斷<br>• **Oaxaca-Blinder 同工同酬殘差** $\le 1.5\%$<br>• **大廠面試官給分膨脹校準 + Bar-Raiser 一票否決**<br>• **CRediT 學術/研發真實貢獻度與 Western Blot 影像拼接偵測** | [`eeoc_and_oaxaca_safe_harbor_sound`](src/flow_business.lean)<br>[`bar_raiser_and_bio_audit_sound`](src/flow_business.lean) | **CHRO / 法務長 (CLO) / 生技研發長** |
| **Pillar 6** | **Module 10**<br>數位行銷反作弊（IVT）與銀行金流歸因 | • **5ms 邊緣端無頭爬蟲（Headless Bot）滑鼠熵值過濾**<br>• **銀行入帳減除退貨（Net Bank Truth）之確定性真實 ROAS 核算** | [`marketing_ivt_and_bank_attribution_sound`](src/flow_business.lean) | **CMO / 成長駭客負責人** |

---

## 2. 系統架構與目錄結構

```text
flow_business/
├── src/
│   └── flow_business.lean       # 唯一真相源：Pillar 1–6 算子 + 11 條零 sorry 定理 + 1PB 零拷貝核函數
├── dashboard/
│   ├── server.py                # 零外部依賴 Python HTTP API (ctypes 綁定 libflow_business.so + 10 項自檢)
│   └── index.html               # CFO & Ownership 互動式六大防線戰情室 (Web UI)
├── build/                       # 由 ./build.sh 自動從 src/flow_business.lean 生成
│   ├── libflow_business.so      # 原生 C17 + QSBR 共享動態庫
│   ├── flow_business.c / .h     # C17 實作與 64-byte Cache-Line 對齊之 ABI 標頭檔
│   ├── flow_business.rs         # Rust 零拷貝 FFI 模組
│   ├── flow_business.py         # Python ctypes 零拷貝模組
│   ├── flow_business.js         # Node.js / Bun 零拷貝模組
│   ├── flow_business.cuh        # CUDA Pinned Host-Stream 標頭檔
│   └── flow_business_cert.lean  # 自動合成之 Lean 4 形式化證明證書
├── build.sh                     # 一鍵編譯、1PB 零拷貝驗證、10 階段自檢與 Dashboard 啟動腳本
└── README.md                    # 本說明文件
```

---

## 3. 快速開始（Quick Start）

### 一鍵編譯與執行完整驗收（含 1PB 零拷貝測試與 10 項六大防線自檢）

```bash
./build.sh
```

執行後將自動完成：
1. **`flowc` 純 `.lean` 多目標合成**：從 [`src/flow_business.lean`](src/flow_business.lean) 產出 C17、Rust、Python、JS、CUDA 與 Lean 4 證明證書，並編譯 `build/libflow_business.so`。
2. **`flowy` 原生直跑驗證**：直接執行 [`src/flow_business.lean`](src/flow_business.lean) 輸出六大防線基準驗證結果。
3. **1PB (`1 << 50` bytes) `FlowExtentDescriptor` 零拷貝驗證**：驗證 64-byte 步長（`stride_bytes = 64`）O(1) 通過、非法步長（`stride_bytes = 32`）由定理錨定核函數確定性攔截。
4. **10 階段六大防線與 Ownership 自動化自檢（`dashboard/server.py --selftest`）**：驗證 P2P、SoD、L1–L3 升級、O2C 防漏、司庫 Covenants、USMCA RVC、HR EEOC/Bar-Raiser/Biotech 及 Marketing IVT。

### 啟動互動式戰情室（Six-Pillar Control Plane Web UI）

```bash
./build.sh dashboard 8090
```

啟動後打開瀏覽器訪問 `http://127.0.0.1:8090` 即可：
- 即時檢視 **Pillar 1–6 六大企業防線** 的健康狀態、對應買家與 Lean 4 定理。
- 點擊上方五顆壓力測試按鈕（Simulate O2C Revenue Leakage / FX Covenant Shock / USMCA RVC < 60% / EEOC & Bar-Raiser Audit / Headless Bot IVT Attack）直接呼叫底層 `libflow_business.so` C ABI 算子。
- 在 **Forensic Tri-State Queue** 測試高管一鍵簽署豁免（`Sign & Absorb Liability`）與職權分離自簽攔截（`Test SoD Self-Sign`）。
