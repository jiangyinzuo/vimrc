-- 在文件首尾 5 行内放置独占行 <!-- vllmclass --> 即可启用；删除标记即清除。
-- 保留原 filetype/syntax，Markdown 渲染插件继续负责原有排版。
-- 标记按文本识别，不区分代码块；标题样式完全交给 Markdown 渲染插件。
local M = {}
local ns = vim.api.nvim_create_namespace('vllmclass')

-- 类名按职责分组，方法名保持原样；围栏内 Python 语法由 Tree-sitter 负责。
local groups = {
  { 'Engine', 'Function', 'LLMEngine AsyncLLM EngineCore EngineCoreOutputs EngineCoreProc InprocClient SyncMPClient AsyncMPClient EngineCoreClient AsyncLLMEngine' },
  { 'Scheduler', 'Statement', 'Scheduler SchedulerOutput' },
  { 'KV', 'Type', 'KVCacheManager KVCacheCoordinator UnitaryKVCacheCoordinator HybridKVCacheCoordinator SingleTypeKVCacheManager FullAttentionManager BlockPool KVCacheBlock KVCacheBlocks' },
  { 'Worker', 'Todo', 'UniProcExecutor MultiprocExecutor WorkerWrapperBase Worker GPUModelRunner' },
  { 'Model', 'Constant', 'DeepseekV2ForCausalLM DeepseekV32ForCausalLM DeepseekV32Model DeepseekV32DecoderLayer DeepseekV32Attention' },
  { 'HiSparseCoordinator', 'Special', 'HiSparseCoordinator HiSparseSourceManager HiSparseHotManager HiSparseResidentManager' },
  { 'HiSparseConnector', 'vllmClassConnectorColor', 'HiSparseConnector HiSparseConnectorScheduler HiSparseConnectorWorker' },
  { 'HiSparseRuntime', 'Underlined', 'HiSparseRuntime HiSparseCacheHandle HiSparseIndexGroup HiSparseMLAIndexGroup HiSparseHostPool' },
  { 'Output', 'Added', 'OutputProcessor RequestOutput' },
  { 'Config', 'vllmClassConfigColor', 'VllmConfig' },
}
local keywords, names = {}, {}
for _, group in ipairs(groups) do
  for word in group[3]:gmatch('%S+') do
    keywords[word] = 'vllmClass' .. group[1]
    names[#names + 1] = word
  end
end
local pattern = '\\C\\<\\%(' .. table.concat(names, '\\|') .. '\\)\\>'

local function define_highlights()
  -- 配置集合跨模块使用独立浅蓝色；固定色避免与当前主题各职责颜色重合。
  vim.api.nvim_set_hl(0, 'vllmClassConfigColor', { fg = '#87afff', ctermfg = 111 })
  -- 当前主题 Special 与 PreProc 同色；Connector 单独用珊瑚红区分 Coordinator。
  vim.api.nvim_set_hl(0, 'vllmClassConnectorColor', { fg = '#ff5f5f', ctermfg = 203 })
  for _, group in ipairs(groups) do
    local source = vim.api.nvim_get_hl(0, { name = group[2], link = false })
    -- 仅复制前景色，避免主题中的背景/下划线覆盖 Markdown 渲染属性。
    vim.api.nvim_set_hl(0, 'vllmClass' .. group[1], { fg = source.fg, ctermfg = source.ctermfg })
  end
end

local function has_marker(buf)
  local count = vim.api.nvim_buf_line_count(buf)
  local function marked(first, last)
    for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, first, last, false)) do
      if line:match('^%s*<!%-%-%s*vllmclass%s*%-%->%s*$') then
        return true
      end
    end
    return false
  end
  return marked(0, math.min(5, count)) or marked(math.max(0, count - 5), count)
end

local function refresh(buf)
  if not vim.api.nvim_buf_is_loaded(buf) then
    return
  end
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  if vim.bo[buf].buftype ~= '' or not has_marker(buf) then
    return
  end
  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local offset = 0
    while offset < #line do
      local match = vim.fn.matchstrpos(line, pattern, offset)
      if match[2] < 0 then
        break
      end
      vim.api.nvim_buf_set_extmark(buf, ns, i - 1, match[2], {
        end_row = i - 1,
        end_col = match[3],
        hl_group = keywords[match[1]],
        -- 高于 render-markdown 的内置优先级。
        priority = 10010,
      })
      offset = match[3]
    end
  end
end

function M.setup()
  -- 复用 Python parser 的二进制，但隔离查询，不能覆盖普通 Python 的高亮。
  local parser = vim.api.nvim_get_runtime_file('parser/python.so', false)[1]
  vim.treesitter.language.add('vllmclass', { path = parser, symbol_name = 'python' })
  vim.treesitter.language.register('vllmclass', 'vllmclass')
  vim.treesitter.query.set('vllmclass', 'highlights', [[
    "class" @keyword.type.python
    "def" @keyword.function.python
    ((identifier) @variable.builtin.python
      (#any-of? @variable.builtin.python "self" "cls"))
    (comment) @comment.python
  ]])
  define_highlights()
  local group = vim.api.nvim_create_augroup('VllmClass', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile', 'BufEnter', 'FileType', 'TextChanged', 'TextChangedI', 'TextChangedP' }, {
    group = group,
    callback = function(event)
      refresh(event.buf)
    end,
  })
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = group,
    callback = define_highlights,
  })
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    refresh(buf)
  end
end

return M
