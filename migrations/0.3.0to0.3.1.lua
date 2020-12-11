if global.allowMigration == false then return end

for _, obj in pairs(global.entsTable or {}) do
  if obj.ent ~= nil and obj.ent.valid == true then
    if tostring(obj.quatronCharge == "nan") then
        obj.quatronCharge = 0
    end
    if tostring(obj.quatronLevel == "nan") then
        obj.quatronLevel = 1
    end
    if tostring(obj.quatronConsuption == "nan") then
        obj.quatronConsuption = 0
    end
  end
end