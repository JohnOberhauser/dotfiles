hl.layer_rule({
    name  = "okshell-blur",
    match = { namespace = [[\bokshell(?!-screenshot)\b[\w-]*]] },
    blur         = true,
    ignore_alpha = 0,
})