-- HOW TO CONFIGURE THE JAVA DEBUGGER
-- -------------------------------------------------------------------------
-- https://github.com/mfussenegger/nvim-jdtls#configuration-quickstart
-- -------------------------------------------------------------------------
--
-- YOU MUST:
-- * Install the system dependency 'jdtls' in your operative system.
-- * Set the right path of your jdtls executable below in 'cmd'.
--
-- IF STILL FAILS CHECK:
-- * You have installed 'java-debug-adapter' on mason.
-- * The path of "bundles" if correct.

local config = {
    cmd = {'/usr/bin/jdtls'},
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
    init_options = {
      bundles = {
            vim.fn.glob(vim.fn.stdpath('data')..'/mason/packages/java-test/extension/server/*.jar', true ),
            vim.fn.glob(vim.fn.stdpath('data')..'/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', true ),
        }
    }
}
require('jdtls').start_or_attach(config)

-- Give enough time for jdt to fully load the project, or it will fail with
-- "No LSP client found"
local timer = 2500
for i = 0, 12, 1 do
  vim.defer_fn(function() test = require('jdtls.dap').setup_dap_main_class_configs()
    end, timer)
  timer = timer + 2500
end
