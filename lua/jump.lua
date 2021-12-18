-- This file adds a go-to-definition implementation
-- that saves up to 26 of the most recent positions
-- by using Vim's mark system. See:
-- https://vim.fandom.com/wiki/Using_marks

local stack_position = 0

local function current_stack_mark()
    return string.char(stack_position + string.byte('A'))
end

local function mark_current_pos()
    vim.api.nvim_command("mark " .. current_stack_mark())
    stack_position = (stack_position + 1) % 26
end

local function jump_def()
    mark_current_pos()
    vim.lsp.buf.definition()
end

local function jump_impl()
    mark_current_pos()
    vim.lsp.buf.implementation()
end

local function jump_ref()
    mark_current_pos()
    vim.lsp.buf.references()
end

local function jump_back()
    stack_position = (stack_position - 1) % 26
    vim.api.nvim_command("normal! `" .. current_stack_mark())
    vim.api.nvim_command("delmarks " .. current_stack_mark())
end

return {
    jump_def = jump_def,
    jump_impl = jump_impl,
    jump_ref = jump_ref,
    jump_back = jump_back,
}
