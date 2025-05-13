local function get_os()
    local sysname = vim.loop.os_uname().sysname
    if sysname == "Windows_NT" then
        return "win"
    elseif sysname == "Darwin" then
        return "mac"
    else
        return "linux"
    end
end

local function get_jdtls()
    local mason_registy = require("mason-registry") -- Mason Registry
    local jdtls = mason_registy.get_package("jdtls") -- JDTLS
    local jdtls_path = jdtls:get_install_path() -- JDTLS Path
    local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar") -- JDTLS Launcher
    local SYSTEM = get_os()
    local config = jdtls_path .. "/config_" .. SYSTEM -- JDTLS Config
    local lombok = jdtls_path .. "/lombok.jar" -- Lombok path
    return launcher, config, lombok
end

local function get_bundles()
    local mason_registy = require("mason-registry") -- Mason Registry
    local java_debug = mason_registy.get_package("java-debug-adapter") -- Java Debug
    local java_debug_path = java_debug:get_install_path() -- Java Debug Path

    local bundles = {
        vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",1),
    }

    local java_test = mason_registy.get_package("java-test") -- Java Test
    local java_test_path = java_test:get_install_path() -- Java Test Path

    -- Add all JAR files for running tests in debug mode to de bundle list
    -- I'm not knowing what I'm doing here ¯\_(ツ)_/¯
    vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", 1), "\n"))

    return bundles
end

local function get_workspace()
    local home = os.getenv("HOME") or os.getenv("USERPROFILE")
    local workspace = home .. "/workbench/" -- My Workspace
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t") -- More dark magic (¬_¬)
    local workspace_path = workspace .. project_name
    return workspace_path
end

local function java_keymaps()
    -- Run JdtCompile to compile the project
    vim.cmd("command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)")
    -- Run JdtUpdateConfig to update the JDTLS config
    vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
    -- Run JdtBytecode
    vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
    -- Run JdtJshell
    vim.cmd("command! -buffer JdtJshell lua require('jdtls').jshell()")

    -- Set a Vim motion to <Space> + <Shift>J + o to organize imports in normal mode
    vim.keymap.set('n', '<leader>Jo', "<Cmd> lua require('jdtls').organize_imports()<CR>", { desc = "[J]ava [O]rganize Imports" })
    -- Set a Vim motion to <Space> + <Shift>J + v to extract the code under the cursor to a variable
    vim.keymap.set('n', '<leader>Jv', "<Cmd> lua require('jdtls').extract_variable()<CR>", { desc = "[J]ava Extract [V]ariable" })
    -- Set a Vim motion to <Space> + <Shift>J + v to extract the code selected in visual mode to a variable
    vim.keymap.set('v', '<leader>Jv', "<Esc><Cmd> lua require('jdtls').extract_variable(true)<CR>", { desc = "[J]ava Extract [V]ariable" })
    -- Set a Vim motion to <Space> + <Shift>J + <Shift>C to extract the code under the cursor to a static variable
    vim.keymap.set('n', '<leader>JC', "<Cmd> lua require('jdtls').extract_constant()<CR>", { desc = "[J]ava Extract [C]onstant" })
    -- Set a Vim motion to <Space> + <Shift>J + <Shift>C to extract the code selected in visual mode to a static variable
    vim.keymap.set('v', '<leader>JC', "<Esc><Cmd> lua require('jdtls').extract_constant(true)<CR>", { desc = "[J]ava Extract [C]onstant" })
    -- Set a Vim motion to <Space> + <Shift>J + t to run the test method currently under the cursor
    vim.keymap.set('n', '<leader>Jt', "<Cmd> lua require('jdtls').test_nearest_method()<CR>", { desc = "[J]ava [T]est Method" })
    -- Set a Vim motion to <Space> + <Shift>J + t to run the test method that is currently selected in visual mode
    vim.keymap.set('v', '<leader>Jt', "<Esc><Cmd> lua require('jdtls').test_nearest_method(true)<CR>", { desc = "[J]ava [T]est Method" })
    -- Set a Vim motion to <Space> + <Shift>J + <Shift>T to run an entire test suite (class)
    vim.keymap.set('n', '<leader>JT', "<Cmd> lua require('jdtls').test_class()<CR>", { desc = "[J]ava [T]est Class" })
    -- Set a Vim motion to <Space> + <Shift>J + u to update the project configuration
    vim.keymap.set('n', '<leader>Ju', "<Cmd> JdtUpdateConfig<CR>", { desc = "[J]ava [U]pdate Config" })
end

local function setup_jdtls()
    local jdtls = require("jdtls")
    local launcher, config_os, lombok = get_jdtls()
    local workspace_path = get_workspace()
    local bundles = get_bundles()
    -- Usa siempre '/' como separador (Neovim maneja bien eso)
    local google_style_url = "file://" .. vim.fn.stdpath("config"):gsub("\\", "/") .. "/lang_servers/intellij-java-google-style.xml"


    local root_dir = jdtls.setup.find_root({'.git', 'pom.xml', 'build.gradle', 'mvnw', 'gradlew'})

    local capabilities = {
        workspace = {
            configuration = true
        }
    }

    local extendedClientCapabilities = jdtls.extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    local cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        -- "--add-opens java.base/java.util=ALL-UNNAMED",
        -- "--add-opens java.base/java.lang=ALL-UNNAMED",
        "-javaagent:" .. lombok,
        "-jar",
        launcher,
        "-configuration",
        config_os,
        "-data",
        workspace_path
    }

    local settings = {
        java = {
            -- Enable code formatting
            format = {
                enabled = true,
                -- Use the Google Style guide for code formattingh
                settings = {
                    url = google_style_url
                    -- profile = "GoogleStyle"
                }
            },
            -- Enable downloading archives from eclipse automatically
            eclipse = {
                downloadSource = true
            },
            -- Enable downloading archives from maven automatically
            maven = {
                downloadSources = true
            },
            -- Enable method signature help
            signatureHelp = {
                enabled = true
            },
            -- Use the fernflower decompiler when using the javap command to decompile byte code back to java code
            contentProvider = {
                preferred = "fernflower"
            },
            -- Setup automatical package import oranization on file save
            saveActions = {
                organizeImports = true
            },
            -- Customize completion options
            completion = {
                -- When using an unimported static method, how should the LSP rank possible places to import the static method from
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*",
                },
                -- Try not to suggest imports from these packages in the code action window
                filteredTypes = {
                    "com.sun.*",
                    "io.micrometer.shaded.*",
                    "java.awt.*",
                    "jdk.*",
                    "sun.*",
                },
                -- Set the order in which the language server should organize imports
                importOrder = {
                    "java",
                    "jakarta",
                    "javax",
                    "com",
                    "org",
                }
            },
            sources = {
                -- How many classes from a specific package should be imported before automatic imports combine them all into a single import
                organizeImports = {
                    starThreshold = 9999,
                    staticThreshold = 9999
                }
            },
            -- How should different pieces of code be generated?
            codeGeneration = {
                -- When generating toString use a json format
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
                },
                -- When generating hashCode and equals methods use the java 7 objects method
                hashCodeEquals = {
                    useJava7Objects = true
                },
                -- When generating code use code blocks
                useBlocks = true
            },
             -- If changes to the project will require the developer to update the projects configuration advise the developer before accepting the change
            configuration = {
                updateBuildConfiguration = "interactive"
            },
            -- enable code lens in the lsp
            referencesCodeLens = {
                enabled = true
            },
            -- enable inlay hints for parameter names,
            inlayHints = {
                parameterNames = {
                    enabled = "all"
                }
            }
        }
    }

    local init_options = {
        bundles = bundles,
        extendedClientCapabilities = extendedClientCapabilities
    }

    -- Function that will be ran once the language server is attached
    local on_attach = function(_, bufnr)
        -- Map the Java specific key mappings once the server is attached
        java_keymaps()

        -- Setup the java debug adapter of the JDTLS server
        require('jdtls.dap').setup_dap()

        -- Find the main method(s) of the application so the debug adapter can successfully start up the application
        -- Sometimes this will randomly fail if language server takes to long to startup for the project, if a ClassDefNotFoundException occurs when running
        -- the debug tool, attempt to run the debug tool while in the main class of the application, or restart the neovim instance
        -- Unfortunately I have not found an elegant way to ensure this works 100%
        require('jdtls.dap').setup_dap_main_class_configs()
        -- Enable jdtls commands to be used in Neovim
        require 'jdtls.setup'.add_commands()
        -- Refresh the codelens
        -- Code lens enables features such as code reference counts, implemenation counts, and more.
        vim.lsp.codelens.refresh()

        -- Setup a function that automatically runs every time a java file is saved to refresh the code lens
        vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.java" },
            callback = function()
                local _, _ = pcall(vim.lsp.codelens.refresh)
            end
        })
    end

    -- Create the configuration table for the start or attach function
    local config = {
        cmd = cmd,
        root_dir = root_dir,
        settings = settings,
        capabilities = capabilities,
        init_options = init_options,
        on_attach = on_attach
    }

    -- Start the JDTLS server
    require('jdtls').start_or_attach(config)
end

return {
    setup_jdtls = setup_jdtls,
}

