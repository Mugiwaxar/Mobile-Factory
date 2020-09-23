data:extend({
  {
	type = "string-setting",
	name = "MF-first-MF",
	setting_type = "startup",
	default_value = "player creation",
	allowed_values = {"player creation", "craft"},
	order = "aga" -- general, at the top
  },
  {
	type = "string-setting",
	name = "MF-lab-science-packs",
	setting_type = "startup",
	default_value = "all",
	allowed_values = {"all", "add vanilla", "dimensional only"},
	order = "agb"
  },
--   {
-- 	type = "bool-setting",
-- 	name = "MF-enable-erya",
-- 	setting_type = "startup",
-- 	default_value = true,
-- 	order = "agc"
--   },
  {
	type = "bool-setting",
	name = "MF-initial-research-complete",
	setting_type = "startup",
	default_value = true,
	order = "agd"
  }
})