local map = vim.keymap.set

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
map("n", "|d", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
map("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
map("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
map("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
map("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Move focus to the upper window" })

map("n", "]t", "<cmd>tabnext<CR>", { desc = "Move focus to the next window" })
map("n", "[t", "<cmd>tabprevious<CR>", { desc = "Move focus to the previous window" })

map("n", "]b", "<cmd>bnext<CR>", { desc = "Go to the next [B]uffer" })
map("n", "[b", "<cmd>bprevious<CR>", { desc = "Go to the previous [B]uffer" })
map("n", "]c", "<cmd>cnext<CR>", { desc = "Go to the next qui[C]k fix" })
map("n", "[c", "<cmd>cprevious<CR>", { desc = "Go to the previous qui[C]k fix" })

map("n", "<C-d>", "<C-d>zz", { desc = "Center screen when scrolling down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Center screen when scrolling up" })
map("n", "G", "Gzz", { desc = "center screen after Goto End" })

map("n", "<M-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<M-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("v", "<M-j>", "<cmd>m '>+1<cr>gv=gv", { desc = "Move down block" })
map("v", "<M-k>", "<cdm>m '<-2<cr>gv=gv", { desc = "Move up block" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Select all
map("n", "<C-a>", "ggVG")

-- Кириллица
local cmap = function(lhs, rhs, desc)
  -- 'c', 'n', 'o', 'v'
  map({ "c", "n", "v", "s", "o" }, lhs, rhs, { desc = desc, remap = true })
  -- vim.cmd.oremap(lhs, rhs)
end

cmap("Ж", ":", "Command mode")
cmap("м", "v", "Visual mode")
cmap("М", "V", "Visual line Mode")
cmap("<C-м>", "<C-v>", "Visual block Mode")

-- hjkl
cmap("р", "h", "Left")
cmap("о", "j", "Down")
cmap("л", "k", "Up")
cmap("д", "l", "Right")

cmap("ц", "w", "word")
cmap("Ц", "W", "word extended")
cmap("у", "e", "end")
cmap("У", "E", "end extended")
cmap("и", "b", "begin")
cmap("И", "B", "begin extended")

cmap("<C-в>", "<C-d>", "Half page down")
cmap("<C-г>", "<C-u>", "Half page up")
cmap("п", "g", "Go")
cmap("П", "G", "Go tot the end of buffer")
cmap("е", "t", "To")
cmap("Е", "T", "Backwards To")
cmap("а", "f", "Find")
cmap("А", "F", "Backwards Find")
cmap("ж", ";", "Find Next")
cmap("б", ",", "Find Next")
cmap("т", "n", "Next")
cmap("Т", "N", "Previous")

--
cmap("ф", "a", "Append")
cmap("Ф", "A", "Append at the end of the line")
cmap("ш", "i", "Insert")
cmap("Ш", "I", "Insert at the start of the line")
cmap("к", "r", "Replace one")
cmap("К", "R", "Replace")
cmap("с", "c", "Change")
cmap("С", "C", "Change line")
cmap("в", "d", "Delete")
cmap("В", "D", "Delete line")
cmap("ч", "x", "Delete character")
cmap("ю", ".", "Redo last change")

cmap("щ", "o", "Open line")
cmap("Щ", "O", "Open line above")

-- yank /paste
cmap("н", "y", "Yank")
cmap("з", "p", "Paste")
cmap("З", "P", "Paste & and keep register")
cmap("г", "u", "Undo")
cmap("Г", "U", "Undo line")
cmap("<C-к>", "<C-r>", "Redo")

-- text objects
cmap("й", "q", "quote")
cmap("э", "'", "single quote")
cmap("Э", '"', "single quote")

--
cmap("О", "J", "Squash lines")
