# Personal Config Branch (`personal`)

`personal` 分支在上游 nvimdots(main) 基础上叠加了本容器环境的定制，用于在其他环境快速还原相同的 Neovim 工作区。

## 定制内容

- `lua/user/settings.lua`
  - `use_ssh = false`（HTTPS 拉取插件）
  - `use_copilot = false`（禁用 Copilot，避免每次启动下载 language server）
  - 依赖裁剪（**注意**：nvimdots 对用户列表是 `list_extend` 追加合并，见 `modules/utils/init.lua` 的 `tbl_recursive_merge`，因此用**函数式覆盖**返回精简列表）：
    - `lsp_deps` → `clangd, ruff, pyrefly, lua_ls`
    - `null_ls_deps` → `clang_format`
    - `dap_deps` → `codelldb, python`
  - AI 适配为 OpenRouter 占位配置（`ai_api_key` 为占位符，使用时自行替换，勿提交真实 key）
- `lua/user/configs/lsp.lua`
  - Workaround：Neovim 0.12 的 `vim.lsp.enable()` 不附加"配置注册前就已打开"的 buffer，且新版 nvim-lspconfig 已移除 `:LspStart`；此文件在所有 server 注册后重发 `FileType` 事件完成附加
- `lazy-lock.json`：插件版本锁定，新环境安装结果与本环境一致

## 新环境还原步骤

### 1. Neovim ≥ 0.12

Ubuntu 自带版本过旧，用官方 release：

```bash
curl -LO https://github.com/neovim/neovim/releases/download/v0.12.5/nvim-linux-x86_64.tar.gz
tar -C /opt -xzf nvim-linux-x86_64.tar.gz
ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
```

### 2. 系统依赖

```bash
apt install -y ripgrep fd-find xclip unzip
ln -sf /usr/bin/fdfind /usr/local/bin/fd
npm install -g tree-sitter-cli        # treesitter 语法编译需要
# lazygit（可选）: 从 github.com/jesseduffield/lazygit/releases 下载
```

### 3. 克隆配置

```bash
git clone -b personal https://github.com/KDC202/nvimdots ~/.config/nvim
```

### 4. 首次启动

- 打开 `nvim`，`lazy.nvim` 自动安装全部插件（网络差时多按几次 `:Lazy sync`）
- Mason 会按裁剪后的列表自动安装 `clangd / ruff / pyrefly / lua_ls / codelldb / debugpy`
  - GitHub release 下载慢/易断（clangd 达 112MB），失败时进 `:Mason` 重试
  - clangd 兜底方案：`apt install clangd-18` 后软链 `/usr/local/bin/clangd -> /usr/bin/clangd-18`，并手动伪造 Mason 包结构（`packages/clangd/clangd_18.1.3/bin/clangd` + `mason-receipt.json`），详见容器内实施记录

### 5. 终端字体

使用 Nerd Font（如 JetBrainsMono Nerd Font），否则图标显示为方块。

## CANN 算子工程 `.clangd` 模板

放工程根目录，使 clangd 正确解析算子代码（参数取自 `build/CMakeFiles/*/flags.make`）：

```yaml
CompileFlags:
  Add:
    - -std=c++17
    - -fPIC
    - -D_GLIBCXX_USE_CXX11_ABI=0
    - -DBUILD_SOC_VERSION=Ascend950
    - -DOP_TILING_LIB
    - -DOP_PROTO_LIB
    - -I/home/developer/Ascend/cann-9.1.0/include
    - -I/home/developer/Ascend/cann-9.1.0/x86_64-linux/include
    - -I/home/developer/Ascend/cann-9.1.0/x86_64-linux/include/pkg_inc
    - -I/home/developer/Ascend/cann-9.1.0/x86_64-linux/include/aclnn
    - -I/home/developer/Ascend/cann-9.1.0/x86_64-linux/include/aclnnop
    - -I/home/developer/Ascend/cann-9.1.0/x86_64-linux/pkg_inc/base
    - -I/home/developer/Ascend/cann-9.1.0/x86_64-linux/pkg_inc/aicpu
    # -I <算子包根目录/op_host/op_graph/op_kernel>，按工程实际路径补充
Diagnostics:
  ClangTidy:
    Remove: "*"
---
If:
  PathMatch: .*op_kernel/.*\.cpp
CompileFlags:
  Add: [-D__CCE_KT_TEST__]
```
