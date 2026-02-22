-- In your plugin spec (lazy.nvim example)
return {
    "sphamba/smear-cursor.nvim",
    opts = {
        -- Core feel
        stiffness = 0.85,
        trailing_stiffness = 0.45,
        damping = 0.75,
        fps = 60,
        time_interval = 12,

        -- Looks & effects
        legacy_computing_symbols_support = true, -- less blocky
        particles_enabled = false,
        particle_density = 0.6,

        -- Behavior
        smear_between_buffers = true,
        smear_between_delete = true,
        hide_target_hack = true,
    },
}
