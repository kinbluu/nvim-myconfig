# AGENTS.md

## Konteks proyek

Ini konfigurasi Neovim pribadi Kien, ditulis dalam Lua untuk Neovim 0.12.6. `init.lua` adalah titik masuk. Di mesin ini `~/.config/nvim` mengarah ke checkout ini. Saat bekerja di checkout lain, periksa `vim.env.MYVIMRC` agar tes menjalankan config yang sedang diedit.

Gunakan `git status --short` sebelum mengedit dan pertahankan preferensi lokal pengguna, terutama di `lua/chadrc.lua`. Ikuti struktur modul yang sudah ada. Gunakan direktori sementara untuk fixture yang perlu menulis file.

## Jalur startup dan lokasi perubahan

| Kebutuhan | Lokasi dan tanggung jawab |
| --- | --- |
| Opsi, keymap, dan autocmd umum | `lua/kien/configs/` dimuat pertama. Leader adalah spasi. Sorotan yank memakai `TextYankPost` dan `vim.hl.on_yank()`. |
| Command line, pesan, dan completion | `init.lua` mengaktifkan UI2 eksperimental dengan `msg.targets`. Blink mengelola completion termasuk command line. `lua/kien/plugins/noice.lua` memakai Noice untuk tampilan LSP. |
| Instalasi dan konfigurasi plugin | `lua/kien/core/specs.lua` mendeklarasikan plugin. `lua/kien/core/pack.lua` memanggil `vim.pack.add()` sebelum memuat modul plugin. Tema dan NvChad UI dimuat berikutnya dari `init.lua`. |
| Parser dan highlighting | `lua/kien/plugins/treesitter.lua` berbagi satu daftar parser antara startup dan `:TSInstallAll`. Autocmd `FileType` menyalakan highlighting ketika parser tersedia. |
| LSP, tools, dan formatting | `lua/kien/plugins/lsp/mason.lua` mengelola instalasi. `lua/kien/plugins/lsp/lspconfig.lua` memakai `vim.lsp.config()` dan `vim.lsp.enable()` dengan capabilities Blink. Keymap `LspAttach` bersifat lokal ke buffer dan memakai Snacks untuk picker. Format-on-save ada di `lua/kien/plugins/conform-format.lua`. |

Repo memakai `vim.pack` sebagai pengelola plugin. Gunakan field `version` untuk branch atau batas versi, dan biarkan Neovim menghasilkan `nvim-pack-lock.json`. `:PackUpdate [nama]` membuka buffer tinjauan update. `:PackCheck` meninjau plugin nonaktif dan meminta konfirmasi sebelum menghapusnya. Startup pertama bisa memasang plugin, parser, dan tool yang belum tersedia. Lihat `:help vim.pack` untuk alur update atau pemulihan. Floaterm dan profil Triforce memakai `volt`.

Untuk mendiagnosis LSP, cek konfigurasi server, executable dan root proyek. Mason dimuat sebelum konfigurasi LSP karena path plugin TypeScript untuk Vue memakai `$MASON`. Daftar `ensure_installed` di Mason menentukan tool yang dipasang otomatis. Untuk API upstream, utamakan `:help` dari Neovim terpasang dan source plugin pada revisi lockfile. Plugin `vim.pack` biasanya ada di `stdpath('data')` di bawah `site/pack/core/opt/`.

## Tema wallpaper dan NvChad UI

- `lua/kien/plugins/tokyonight.lua` menerapkan gaya Moon dan mewarnainya dengan palet dari `$XDG_CACHE_HOME/ryoku/colors.json` atau `~/.cache/ryoku/colors.json`. Ryoku adalah penulis file itu. Config membaca palet saja, memantau direktori dengan `vim.uv` agar penggantian atomik terdeteksi, lalu menjadwalkan reload colorscheme. Palet hilang saat startup memakai warna bawaan Tokyo Night. Saat file palet hilang atau rusak, sesi berjalan mempertahankan palet valid terakhir. Pembaruan palet menghormati pilihan colorscheme manual.
- `lua/kien/plugins/nvchad-ui.lua` dimuat setelah colorscheme. Pertahankan integrasi langsung ke statusline dan tabufline. Entry point `require('nvchad')` juga mengaktifkan fitur lain seperti command dashboard dan autocmd reload global. Base46 menyediakan highlight kedua bar dari `lua/themes/kien.lua` dan cache `tbline` sementara milik sesi. Event `ColorScheme` menerapkan ulang highlight agar kedua bar mengikuti palet terbaru.
- `lua/chadrc.lua` berisi opsi tampilan yang dibaca `nvconfig`. Menyimpan file ini dari Neovim memuat ulang statusline. Jika Lua gagal diparse atau renderer gagal dimuat, statusline mempertahankan renderer sebelumnya. Uji perubahan tabufline atau Base46 dengan startup baru. `lua/kien/plugins/nvchad.lua` berisi pengaturan Showkeys lama dan berada di luar jalur startup UI saat ini.

## Verifikasi

Jalankan dari root repo. Gunakan StyLua pada berkas Lua yang disentuh. Contoh untuk perubahan NvChad UI:

```sh
nvim --version | head -n 1
nvim --headless -i NONE \
  '+lua print(vim.fn.resolve(vim.env.MYVIMRC), vim.g.colors_name)' \
  '+if !empty(v:errmsg) | cquit | endif' +qa!
stylua --check lua/chadrc.lua lua/kien/plugins/nvchad-ui.lua lua/themes/kien.lua
git diff --check
```

- Untuk skrip tes Lua yang harus memuat config aktif, gunakan `nvim --headless -i NONE -S /path/ke/smoke.lua +qa!`. Pakai `cquit` pada kegagalan assertion agar hasil shell mencerminkan kegagalan. Mode `-l` melewati startup config pengguna.
- Untuk perubahan UI, cek hasil `nvim_eval_statusline()` dan buka sesi TUI sementara jika menguji klik, pemisahan buffer per tab, atau UI2. Untuk reload `chadrc`, gunakan salinan file di `XDG_CONFIG_HOME` sementara. Untuk tema, ganti `colors.json` di `XDG_CACHE_HOME` sementara dan cek `Normal`, `StatusLine`, serta `TbBufOn` sebelum dan sesudah reload.
- Untuk perubahan LSP atau parser, buka fixture dengan filetype dan root proyek yang sesuai. Cek client yang benar-benar attach dengan `vim.lsp.get_clients()` dan coba keymap atau fitur yang diubah.

Referensi versi [Neovim 0.12.6](https://github.com/neovim/neovim/tree/v0.12.6/runtime/doc) dan [NvChad UI v3.0](https://github.com/NvChad/ui/blob/v3.0/doc/nvui.txt).
