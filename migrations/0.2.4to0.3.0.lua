if global.allowMigration == false then return end
-- Set the Maximum amount of Product for all Data Assembler --
for _, da in pairs (global.dataAssemblerTable or {}) do
    for _, recipe in pairs (da.recipeTable) do
        if recipe.amount ~= nil and recipe.amount ~= 0 then
            for _, product in pairs (recipe.products) do
                product.max = recipe.amount
            end
        end
    end
end