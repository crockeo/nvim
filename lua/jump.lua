-- This file adds a go-to-definition implementation
-- that saves up to 26 of the most recent positions
-- by using Vim's mark system. See:
-- https://vim.fandom.com/wiki/Using_marks

local stack_position = 0

local function current_stack_mark()
    return string.char(stack_position + string.byte('A'))
end

local function jump_to_definition()
    vim.api.nvim_command("mark " .. current_stack_mark())
    stack_position = (stack_position + 1) % 26
    vim.api.nvim_command("call CocActionAsync('jumpDefinition')")
end

local function jump_from_definition()
    stack_position = (stack_position - 1) % 26
    vim.api.nvim_command("normal! `" .. current_stack_mark())
    vim.api.nvim_command("delmarks " .. current_stack_mark())
end

return {
    jump_to_definition = jump_to_definition,
    jump_from_definition = jump_from_definition,
}
