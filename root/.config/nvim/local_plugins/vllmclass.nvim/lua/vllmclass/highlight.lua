-- 在文件首尾 5 行内放置独占行 <!-- vllmclass --> 即可启用；删除标记即清除。
-- 保留原 filetype/syntax，Markdown 渲染插件继续负责原有排版。
-- 标记按文本识别，不区分代码块；标题样式完全交给 Markdown 渲染插件。
local M = {}
local ns = vim.api.nvim_create_namespace("vllmclass")

-- 类名按职责分组，方法名保持原样；Request 数据组用紫色斜体，不表示追踪主线。
-- 围栏内 Python 语法由 Tree-sitter 负责；斜体显示需要终端与字体支持。
local groups = {
	{
		"Engine",
		"Function",
		"LLMEngine AsyncLLM EngineCore EngineCoreOutputs EngineCoreProc InprocClient SyncMPClient AsyncMPClient EngineCoreClient AsyncLLMEngine",
	},
	{ "Scheduler", "Statement", "Scheduler AsyncScheduler SchedulerOutput FCFSRequestQueue" },
	{
		"KV",
		"Type",
		"KVCacheManager KVCacheCoordinator UnitaryKVCacheCoordinator HybridKVCacheCoordinator SingleTypeKVCacheManager FullAttentionManager BlockPool KVCacheBlock KVCacheBlocks EncoderCacheManager",
	},
	{ "Worker", "Todo", "UniProcExecutor MultiprocExecutor WorkerWrapperBase Worker" },
	{
		"ModelRunner",
		"vllmClassModelRunnerColor",
		"ModelRunner GPUModelRunner XPUModelRunner CPUModelRunner NPUModelRunner NPUModelRunner310 NPUModelRunner310V2",
	},
	{
		"Model",
		"Constant",
		"DeepseekV2ForCausalLM DeepseekV32ForCausalLM DeepseekV32Model DeepseekV32DecoderLayer DeepseekV32Attention",
	},
	{
		"AttentionBackend",
		"vllmClassAttentionBackendColor",
		"AttentionBackend AttentionImplBase AttentionImpl MLAAttentionImpl AttentionMetadataBuilder FlashAttentionBackend FlashAttentionImpl FlashAttentionMetadataBuilder FlashInferBackend FlashInferImpl FlashInferMetadataBuilder MLACommonBackend MLACommonBaseImpl MLACommonImpl MLACommonMetadataBuilder SparseMLACommonImpl SparseMLACommonMetadataBuilder FlashAttnMLABackend FlashAttnMLAImpl FlashAttnMLAMetadataBuilder FlashInferMLABackend FlashInferMLAImpl FlashInferMLAMetadataBuilder FlashInferMLASparseSM120Backend FlashInferMLASparseSM120Impl FlashInferMLASparseMetadataBuilder CPUMLABackend CPUMLAImpl",
	},
	{
		"HiSparseCoordinator",
		"Special",
		"HiSparseCoordinator HiSparseSourceManager HiSparseHotManager HiSparseResidentManager _HiSparseAuxiliaryManager",
	},
	{ "KVConnector", "vllmClassKVConnectorColor", "KVConnectorBase_V1 ActiveKVConnector HiSparseConnector" },
	{
		"HiSparseConnector",
		"vllmClassConnectorColor",
		"HiSparseConnectorScheduler HiSparseConnectorWorker",
	},
	{
		"HiSparseRuntime",
		"Underlined",
		"HiSparseRuntime HiSparseCacheHandle HiSparseIndexGroup HiSparseMLAIndexGroup HiSparseHostPool",
	},
	{ "Output", "Added", "OutputProcessor RequestOutput StructuredOutputManager" },
	{ "Config", "vllmClassConfigColor", "VllmConfig" },
	{ "Request", "vllmClassRequestColor", "Request NewRequestData", italic = true },
	{ "Module", "vllmClassModuleColor", "Module", italic = true },
}
local keywords, names = {}, {}
for _, group in ipairs(groups) do
	for word in group[3]:gmatch("%S+") do
		keywords[word] = "vllmClass" .. group[1]
		names[#names + 1] = word
	end
end
local pattern = "\\C\\<\\%(" .. table.concat(names, "\\|") .. "\\)\\>"

local function define_highlights()
	-- 配置集合跨模块使用独立浅蓝色；固定色避免与当前主题各职责颜色重合。
	vim.api.nvim_set_hl(0, "vllmClassConfigColor", { fg = "#87afff", ctermfg = 111 })
	-- 通用 KV 传输接口用亮橙色，与本地 KV 管理及 HiSparse 实现区分。
	vim.api.nvim_set_hl(0, "vllmClassKVConnectorColor", { fg = "#ffaf5f", ctermfg = 215 })
	-- 当前主题 Special 与 PreProc 同色；Connector 单独用珊瑚红区分 Coordinator。
	vim.api.nvim_set_hl(0, "vllmClassConnectorColor", { fg = "#ff5f5f", ctermfg = 203 })
	-- 模型执行编排独立于 Worker 环境管理及具体模型实现，用淡青色标出边界。
	vim.api.nvim_set_hl(0, "vllmClassModelRunnerColor", { fg = "#87d7d7", ctermfg = 116 })
	-- 后端描述、执行实现与元数据构建同属 Attention 子系统，区别于具体模型层。
	vim.api.nvim_set_hl(0, "vllmClassAttentionBackendColor", { fg = "#d787af", ctermfg = 175 })
	-- 请求数据跨模块流动，用独立紫色与斜体区分职责组件，不绑定某棵树的追踪目标。
	vim.api.nvim_set_hl(0, "vllmClassRequestColor", { fg = "#d787ff", ctermfg = 177 })
	-- 通用框架基类用灰色斜体弱化，与具体模型实现的职责色区分。
	vim.api.nvim_set_hl(0, "vllmClassModuleColor", { fg = "#949494", ctermfg = 246 })
	-- 辅助信息使用独立灰色，不跟随偏亮的 LSP 内联提示配色。
	vim.api.nvim_set_hl(0, "vllmClassMetadata", { fg = "#706865", ctermfg = 243 })
	for _, group in ipairs(groups) do
		local source = vim.api.nvim_get_hl(0, { name = group[2], link = false })
		-- 默认仅复制前景色；数据类与框架基类额外用斜体，不覆盖 Markdown 背景/下划线。
		vim.api.nvim_set_hl(0, "vllmClass" .. group[1], { fg = source.fg, ctermfg = source.ctermfg, italic = group.italic })
	end
end

local function has_marker(buf)
	local count = vim.api.nvim_buf_line_count(buf)
	local function marked(first, last)
		for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, first, last, false)) do
			if line:match("^%s*<!%-%-%s*vllmclass%s*%-%->%s*$") then
				return true
			end
		end
		return false
	end
	return marked(0, math.min(5, count)) or marked(math.max(0, count - 5), count)
end
-- 只识别生成器的节点尾缀；不把源码里的括号、数字或续行当成辅助信息。
local function metadata_start(line)
	if not (line:find("├─", 1, true) or line:find("└─", 1, true)) or not line:match(" events=%d+%.%.%d+%s*$") then
		return nil
	end
	for _, marker in ipairs({ "🎯", "🚥", "🚩" }) do
		local first = line:find(" " .. marker .. "%[%d+%] ")
		if first then
			return first
		end
	end
	return line:find(" %(.+%)%s+.*samples=%d+")
end

local function refresh(buf)
	if not vim.api.nvim_buf_is_loaded(buf) then
		return
	end
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
	if vim.bo[buf].buftype ~= "" or not has_marker(buf) then
		return
	end
	local fence, fence_length, in_tree = nil, 0, false
	for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
		local delimiter, info = line:match("^%s*([`~]+)(.*)$")
		if delimiter and #delimiter >= 3 and delimiter:match("^" .. delimiter:sub(1, 1) .. "+$") then
			if not fence then
				fence, fence_length = delimiter:sub(1, 1), #delimiter
				in_tree = info:match("^%s*vllmclass%s*$") ~= nil
			elseif delimiter:sub(1, 1) == fence and #delimiter >= fence_length and info:match("^%s*$") then
				fence, in_tree = nil, false
			end
		end
		local metadata = in_tree and metadata_start(line) or nil
		if metadata then
			vim.api.nvim_buf_set_extmark(buf, ns, i - 1, metadata - 1, {
				end_row = i - 1,
				end_col = #line,
				hl_group = "vllmClassMetadata",
				priority = 10011,
			})
		end
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
	local parser = vim.api.nvim_get_runtime_file("parser/python.so", false)[1]
	vim.treesitter.language.add("vllmclass", { path = parser, symbol_name = "python" })
	vim.treesitter.language.register("vllmclass", "vllmclass")
	vim.treesitter.query.set(
		"vllmclass",
		"highlights",
		[[
    "class" @keyword.type.python
    "def" @keyword.function.python
    ["if" "elif" "else"] @keyword.conditional.python
    ["for" "while" "break" "continue"] @keyword.repeat.python
    ["and" "not" "or" "in" "is"] @keyword.operator.python
    ["return" "yield"] @keyword.return.python
    ["try" "except" "finally" "raise" "assert"] @keyword.exception.python
    ["import" "from"] @keyword.import.python
    ["as" "with" "pass" "del" "global" "nonlocal" "lambda" "async" "await"] @keyword.python
    ((identifier) @variable.builtin.python
      (#any-of? @variable.builtin.python "self" "cls"))
    (comment) @comment.python
  ]]
	)
	define_highlights()
	local group = vim.api.nvim_create_augroup("VllmClass", { clear = true })
	vim.api.nvim_create_autocmd(
		{ "BufReadPost", "BufNewFile", "BufEnter", "FileType", "TextChanged", "TextChangedI", "TextChangedP" },
		{
			group = group,
			callback = function(event)
				refresh(event.buf)
			end,
		}
	)
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = define_highlights,
	})
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		refresh(buf)
	end
end

return M
