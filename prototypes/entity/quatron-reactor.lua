---------------------------------- QUATRON REACTOR ----------------------------------

-- Entity --
local qrE = {}
qrE.name = "QuatronReactor"
qrE.type = "generator"
qrE.icon = "__Mobile_Factory_Graphics__/graphics/energy/QuatronReactorI.png"
qrE.icon_size = 128
qrE.flags = {"placeable-neutral", "player-creation"}
qrE.minable = {mining_time = 1, result = "QuatronReactor"}
qrE.max_health = 350
qrE.corpse = "accumulator-remnants"
qrE.collision_box = {{-1.9, -1.9}, {1.9, 1.9}}
qrE.selection_box = {{-2, -2}, {2, 2}}
qrE.max_power_output = "1J"
qrE.energy_source =
{
  type = "electric",
  buffer_capacity = "0J",
  usage_priority = "tertiary",
  input_flow_limit = "0MW",
  output_flow_limit = "0MW",
  render_no_power_icon = false,
  render_no_network_icon = false
}
qrE.fluid_box =
{
    base_area = 100,
    height = 1,
    base_level = -1,
    production_type = "input",
    pipe_connections =
    {
        {position={-2.2,0.5}},
        {position={2.2,0.5}}
    }
}
qrE.horizontal_animation =
{
    layers =
    {
        {
        frame_count = 1,
        filename = "__Mobile_Factory_Graphics__/graphics/energy/QuatronReactorE.png",
        priority = "extra-high",
        width = 600,
        height = 600,
        animation_speed = 1,
        line_length = 1,
        shift = {0,-0.85},
        scale = 0.30
        },
        {
        frame_count = 1,
        filename = "__Mobile_Factory_Graphics__/graphics/energy/QuatronReactorS.png",
        priority = "extra-high",
        width = 600,
        height = 600,
        animation_speed = 1,
        line_length = 1,
        shift = {0.2,-0.50},
        scale = 0.30,
        draw_as_shadow = true
        }
    }
}
qrE.vertical_animation = qrE.horizontal_animation
qrE.effectivity = 0
qrE.fluid_usage_per_tick = 0
qrE.maximum_temperature = 999999999
data:extend{qrE}

-- Item --
local qrI = {}
qrI.type = "item"
qrI.name = "QuatronReactor"
qrI.place_result = "QuatronReactor"
qrI.icon = "__Mobile_Factory_Graphics__/graphics/energy/QuatronReactorI.png"
qrI.icon_size = 128
qrI.subgroup = "QuatronLogistic"
qrI.order = "d"
qrI.stack_size = 1
data:extend{qrI}

-- Recipe --
local ec1R = {}
ec1R.type = "recipe"
ec1R.name = "QuatronReactor"
ec1R.energy_required = 5
ec1R.enabled = false
ec1R.ingredients =
{
    {"DimensionalCircuit", 60},
    {"MachineFrame2", 30}
}
ec1R.result = "QuatronReactor"
data:extend{ec1R}

-- Create all Sprites --
local x = 0
local y = 0
for i = 0, 13 do
	local qrS = {}
	qrS.type = "sprite"
	qrS.name = "QuatronReactorSprite" .. i
	qrS.filename = "__Mobile_Factory_Graphics__/graphics/energy/QuatronReactorSprite.png"
    qrS.size = 600
    qrS.scale = 0.30
    qrS.x = x
    qrS.y = y
    qrS.shift = {0,-0.85}
    x = x + 600
    if i == 6 then
        x = 0
        y = 600
    end
	data:extend{qrS}
end