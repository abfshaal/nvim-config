return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require("cmp")
    
    -- Remove the Enter key mapping from completion
    opts.mapping = opts.mapping or {}
    opts.mapping["<CR>"] = nil
    
    -- Optionally, you can use Tab to confirm completions instead
    opts.mapping["<Tab>"] = cmp.mapping.confirm({ select = true })
    
    return opts
  end,
}