local htmlEntities = require("htmlEntities")

describe("htmlEntities.ASCII_HEX, htmlEntities.ASCII_DEC", function()
    describe("Same HEX and DEC should output the same entitie.", function()
        for hex = 33, 255 do
            local dec = ("%02X"):format(hex)
            it(('HEX: "%s" DEC: "%s"'):format(hex, dec), function()
                assert.are.equal(htmlEntities.ASCII_HEX(hex), htmlEntities.ASCII_DEC(dec))
            end)
        end
    end)
end)

describe("htmlEntities.decode", function()
    describe("Ignore empty html entities.", function()
        assert.equals(htmlEntities.decode("&#;"), "&#;")
    end)

    describe("Should only decode the HTML entity string.", function()
        assert.are.equal(htmlEntities.decode("a=1&b=2&c=3&amp;d=4"), "a=1&b=2&c=3&d=4")
    end)

    -- might need to remove beleow
    it("should decode HTML entities", function()
        assert.are.equal(
            "<script>alert('Hello World!')</script>",
            htmlEntities.decode("&lt;script&gt;alert(&apos;Hello World!&apos;)&lt;/script&gt;")
        )
    end)

    it("should not decode ASCII entities if decodeASCII is false", function()
        assert.are.equal(
            "&#67;&#111;&#109;&#109;&#97;&#110;&#100;&#99;&#114;&#97;&#99;&#107;&#101;&#114;",
            htmlEntities.decode(
                "&#67;&#111;&#109;&#109;&#97;&#110;&#100;&#99;&#114;&#97;&#99;&#107;&#101;&#114;",
                false
            )
        )
    end)

    it("should decode ASCII entities to characters if decodeASCII is true", function()
        assert.are.equal(
            "Commandcracker",
            htmlEntities.decode("&#67;&#111;&#109;&#109;&#97;&#110;&#100;&#99;&#114;&#97;&#99;&#107;&#101;&#114;", true)
        )
    end)
end)

-- TODO: fix
describe("Entity should be the same after encode and decode.", function()
    for entity, char in pairs(htmlEntities.gethtmlEntities_table()) do
        local decodedEntity = htmlEntities.decode(entity)
        local reencodedEntity = htmlEntities.encode(decodedEntity)

        it(
            ('entity: "%s" char "%s" decodedEntity: "%s" reencodedEntity: "%s"'):format(
                entity,
                char,
                decodedEntity,
                reencodedEntity
            ),
            function()
                assert.are.equal(reencodedEntity, decodedEntity) -- assert.are.equal(reencodedEntity, entity)
                assert.are.equal(char, decodedEntity)
            end
        )
    end
end)

-- might be junk
describe("htmlEntities.encode", function()
    -- might need to remove beleow

    --[[
    it("should encode special characters to HTML entities", function()
        assert.are.equal(
            "&lt;script&gt;alert(&apos;Hello World!&apos;)&lt;/script&gt;",
            htmlEntities.encode("<script>alert('Hello World!')</script>")
        )
    end)
    ]]
    --[[
    it("should not encode ASCII characters if encodeASCII is false", function()
        assert.are.equal(
            "Commandcracker",
            htmlEntities.encode("Commandcracker", false)
        )
    end)
    ]]
    it("should encode ASCII characters to numeric entities if encodeASCII is true", function()
        assert.are.equal(
            "&#67;&#111;&#109;&#109;&#97;&#110;&#100;&#99;&#114;&#97;&#99;&#107;&#101;&#114;",
            htmlEntities.encode("Commandcracker", true)
        )
    end)
end)

describe("htmlEntities.escape", function()
    it("Should only escape special characters & < >", function()
        assert.are.equal("Test &amp;&lt;&gt;", htmlEntities.escape("Test &<>"))
    end)

    describe("Quotes enabled", function()
        local input = "Test " .. '"' .. "&'"
        local expectedOutput = "Test &quot;&amp;&#x27;"

        it("Should escape quotes when enabled", function()
            assert.are.equal(expectedOutput, htmlEntities.escape(input))
        end)

        it("Escape quotes by default", function()
            assert.are.equal(htmlEntities.escape(input, true), htmlEntities.escape(input))
        end)
    end)

    it("Should not escape quotes when disabled", function()
        local quotes = 'Test "' .. "'"
        assert.are.equal(quotes, htmlEntities.escape(quotes, false))
    end)
end)
