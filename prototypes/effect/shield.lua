shFX = {}
shFX.name = "mfShield"
shFX.type = "trivial-smoke"
shFX.flags = {"not-repairable", "not-blueprintable", "not-deconstructable", "placeable-off-grid", "not-on-map", "placeable-neutral"}
shFX.duration = 8
shFX.fade_in_duration = 4
shFX.fade_away_duration = 4
shFX.spread_duration = 0
shFX.start_scale = 1
shFX.end_scale = 1
shFX.cyclic = true
shFX.affected_by_wind = false
shFX.movement_slow_down_factor = 1
shFX.show_when_smoke_off = true
shFX.render_layer = "wires-above"
shFX.animation =
{
	size = 556,
	frame_count = 1,
	scale = 0.8,
	filename = "__Mobile_Factory__/graphics/effects/shield.png",
	flags = { "smoke" },
	tint = {r=1, g=1, b=1, a=0.1}
}
data:extend{shFX}