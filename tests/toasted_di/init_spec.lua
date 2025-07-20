local pkg = require("toasted_di")

describe("toasted_di package entrypoint", function()
    it("includes Container", function()
        assert.is_table(pkg)
        assert.is_table(pkg.Container)
        assert.is_function(pkg.Container.new)
    end)
end)
