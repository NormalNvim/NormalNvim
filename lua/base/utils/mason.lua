--- ### Mason utils
--
--  DESCRIPTION:
--  Functions called by the plugin mason in ../../plugins/3-dev-core.lua
--
--  Thiese couple functions are a re-implementation of mason functions for
--  better UX. Frindly notifications and stuff, so you know what's going on.
--
--  While you could technically delete this file, we encourage you to keep it
--  unless it become deprecated it the future or cause any kind of trouble.

--    Functions:
--      -> update      → update a single mason package.
--      -> updateall   → update all mason packages.
--

local M = {}

local utils = require "base.utils"

--- Update specified mason packages, or just update the registries
--- if no packages are listed.
---@param pkg_names? string|string[] The package names as defined in Mason
---                                  (Not mason-lspconfig or mason-null-ls)
---                                  if the value is nil then it will just
---                                  update the registries.
---@param auto_install? boolean whether or not to install a package that is not
---                             currently installed (default: True)
function M.update(pkg_names, auto_install)
  pkg_names = pkg_names or {}
  if type(pkg_names) == "string" then pkg_names = { pkg_names } end
  if auto_install == nil then auto_install = true end
  local registry_avail, registry = pcall(require, "mason-registry")
  if not registry_avail then
    vim.api.nvim_err_writeln "Unable to access mason registry"
    return
  end

  registry.update(vim.schedule_wrap(function(success, updated_registries)
    if success then
      local count = #updated_registries
      if vim.tbl_count(pkg_names) == 0 then
        utils.notify(
          ("Successfully updated %d %s."):format(
            count,
            count == 1 and "registry" or "registries"
          )
        )
      end
      for _, pkg_name in ipairs(pkg_names) do
        local pkg_avail, pkg = pcall(registry.get_package, pkg_name)
        if not pkg_avail then
          utils.notify(
            ("Mason: %s is not available"):format(pkg_name),
            vim.log.levels.ERROR
          )
        else
          if not pkg:is_installed() then
            if auto_install then
              utils.notify(("Mason: Installing %s"):format(pkg.name))
              pkg:install()
            else
              utils.notify(
                ("Mason: %s not installed"):format(pkg.name),
                vim.log.levels.WARN
              )
            end
          else
            pkg:check_new_version(function(update_available, version)
              if update_available then
                utils.notify(
                  ("Mason: Updating %s to %s"):format(
                    pkg.name,
                    version.latest_version
                  )
                )
                pkg:install():on(
                  "closed",
                  function()
                    utils.notify(("Mason: Updated %s"):format(pkg.name))
                  end
                )
              else
                utils.notify(
                  ("Mason: No updates available for %s"):format(pkg.name)
                )
              end
            end)
          end
        end
      end
    else
      utils.notify(
        ("Failed to update registries: %s"):format(updated_registries),
        vim.log.levels.ERROR
      )
    end
  end))
end

--- Update all packages in Mason
function M.update_all()
  local registry_avail, registry = pcall(require, "mason-registry")
  if not registry_avail then
    vim.api.nvim_err_writeln "Unable to access mason registry"
    return
  end

  utils.notify "Mason: Checking for package updates..."
  registry.update(vim.schedule_wrap(function(success, updated_registries)
    if success then
      local installed_pkgs = registry.get_installed_packages()
      local running = #installed_pkgs
      local no_pkgs = running == 0

      if no_pkgs then
        utils.notify("Mason: No updates available")
        utils.event("MasonUpdateCompleted")
      else
        local updated = false
        for _, pkg in ipairs(installed_pkgs) do
          pkg:check_new_version(function(update_available, version)
            if update_available then
              updated = true
              utils.notify(
                ("Mason: Updating %s to %s"):format(
                  pkg.name,
                  version.latest_version
                )
              )
              pkg:install():on("closed", function()
                running = running - 1
                if running == 0 then
                  utils.notify "Mason: Update Complete"
                  utils.event("MasonUpdateCompleted")
                end
              end)
            else
              running = running - 1
              if running == 0 then
                if updated then
                  utils.notify "Mason: Update Complete"
                else
                  utils.notify "Mason: No updates available"
                end
                utils.event("MasonUpdateCompleted")
              end
            end
          end)
        end
      end
    else
      utils.notify(
        ("Failed to update registries: %s"):format(updated_registries),
        vim.log.levels.ERROR
      )
    end
  end))
end

return M
