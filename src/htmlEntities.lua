--[[- HTML entities decoding/encoding for [ComputerCraft](https://tweaked.cc/).
    @module htmlEntities
    @usage Example encode:

        local htmlEntities = require("htmlEntities")
        print(htmlEntities.encode("Commandcracker"))

    @usage Example decode:

        local htmlEntities = require("htmlEntities")
        print(htmlEntities.decode("&amp;#67;&amp;#111;&amp;#109;&amp;#109;&amp;#97;&amp;#110;&amp;#100;&amp;#99;&amp;#114;&amp;#97;&amp;#99;&amp;#107;&amp;#101;&amp;#114;"))
]]
local htmlEntities = {
    about = "HTML entities decoding/encoding",
    version = "2.0.0",
    name = "htmlEntities-for-lua",
    author = "Tiago Danin, Commandcracker",
    license = "MIT",
    page = "https://github.com/Commandcracker/cc-htmlEntities",

    --[[
    _COPYRIGHT = "Copyright (C) 2004-2010 Kepler Project, 2011-2013 Neopallium, 2020-2023 Thijs Schreijer",
    _DESCRIPTION = "A simple API to use logging features in Lua",
    _VERSION = "LuaLogging 1.8.2",

	_COPYRIGHT = "Copyright (C) 2003-2009 Kepler Project; Copyright (C) 2010-2022 The CGILua Authors.",
	_DESCRIPTION = "CGILua is a tool for creating dynamic Web pages and manipulating input data from forms",
	_VERSION = "CGILua 6.0",

    cosocket._COPYRIGHT   = "Copyright (C) 2004-2006 Kepler Project"
    cosocket._DESCRIPTION = "Coroutine Oriented Portable Asynchronous Services Wrapper for socket module"
    cosocket._NAME        = "Copas.cosocket"
    cosocket._VERSION     = "0.1"

    assert._COPYRIGHT   = "Copyright (c) 2018 Olivine Labs, LLC."
    assert._DESCRIPTION = "Extends Lua's built-in assertions to provide additional tests and the ability to create your own."
    assert._VERSION     = "Luassert 1.8.0"
]]
}

-- TODO: coppy from python
-- https://github.com/python/cpython/blob/3.11/Lib/html/entities.py
-- https://github.com/python/cpython/blob/3.11/Lib/html/__init__.py
-- https://github.com/python/cpython/blob/b87ccc38fe3ab4eca6e026b76f868db4d53c963f/Lib/html/entities.py#L769-L772

local function table_invert(t)
    local s = {}
    for k, v in pairs(t) do
        s[v] = k
    end
    return s
end

local function replace(self, replacements)
    local tbl = {}
    local tbl_i = 1
    local current_pos = 1

    for _ = 1, #self do
        local start_pos, end_pos
        local replacement
        local shortest = math.huge

        for _, sep in ipairs(replacements) do
            local start_pos2, end_pos2 = self:find(sep[1], current_pos, true)

            if start_pos2 and start_pos2 < shortest then
                shortest = start_pos2

                start_pos = start_pos2
                end_pos = end_pos2

                replacement = sep[2]
            end
        end

        if not start_pos then
            break
        end

        tbl[tbl_i] = self:sub(current_pos, start_pos - 1)
        tbl_i = tbl_i + 1
        tbl[tbl_i] = replacement
        tbl_i = tbl_i + 1

        current_pos = end_pos + 1
    end

    tbl[#tbl + 1] = self:sub(current_pos)

    return table.concat(tbl)
end

local htmlEntities_table = {
    ["&Tab;"] = " ",
    ["&NewLine;"] = "\n",
    ["&excl;"] = "!",
    ["&QUOT;"] = '"',
    ["&QUOT"] = '"',
    ["&quot;"] = '"',
    ["&quot"] = '"',
    ["&num;"] = "#",
    ["&dollar;"] = "$",
    ["&percnt;"] = "%%",
    ["&AMP;"] = "&",
    ["&AMP"] = "&",
    ["&amp;"] = "&",
    ["&amp"] = "&",
    ["&apos;"] = "'",
    ["&lpar;"] = "(",
    ["&rpar;"] = ")",
    ["&ast;"] = "*",
    ["&midast;"] = "*",
    ["&plus;"] = "+",
    ["&comma;"] = ",",
    ["&period;"] = ".",
    ["&sol;"] = "/",
    ["&colon;"] = ":",
    ["&semi;"] = ";",
    ["&LT;"] = "<",
    ["&LT"] = "<",
    ["&lt;"] = "<",
    ["&lt"] = "<",
    ["&nvlt;"] = "<⃒",
    ["&equals;"] = "=",
    ["&bne;"] = "=⃥",
    ["&GT;"] = ">",
    ["&GT"] = ">",
    ["&gt;"] = ">",
    ["&gt"] = ">",
    ["&nvgt;"] = ">⃒",
    ["&quest;"] = "?",
    ["&commat;"] = "@",
    ["&lbrack;"] = "[",
    ["&lsqb;"] = "[",
    ["&bsol;"] = "\\",
    ["&rbrack;"] = "]",
    ["&rsqb;"] = "]",
    ["&Hat;"] = "^",
    ["&UnderBar;"] = "_",
    ["&lowbar;"] = "_",
    ["&DiacriticalGrave;"] = "`",
    ["&grave;"] = "`",
    ["&fjlig;"] = "fj",
    ["&lbrace;"] = "{",
    ["&lcub;"] = "{",
    ["&VerticalLine;"] = "|",
    ["&verbar;"] = "|",
    ["&vert;"] = "|",
    ["&rbrace;"] = "}",
    ["&rcub;"] = "}",
    ["&NonBreakingSpace;"] = " ",
    ["&nbsp;"] = " ",
    ["&nbsp"] = " ",
    ["&iexcl;"] = "¡",
    ["&iexcl"] = "¡",
    ["&cent;"] = "¢",
    ["&cent"] = "¢",
    ["&pound;"] = "£",
    ["&pound"] = "£",
    ["&curren;"] = "¤",
    ["&curren"] = "¤",
    ["&yen;"] = "¥",
    ["&yen"] = "¥",
    ["&brvbar;"] = "¦",
    ["&brvbar"] = "¦",
    ["&sect;"] = "§",
    ["&sect"] = "§",
    ["&Dot;"] = "¨",
    ["&DoubleDot;"] = "¨",
    ["&die;"] = "¨",
    ["&uml;"] = "¨",
    ["&uml"] = "¨",
    ["&COPY;"] = "©",
    ["&COPY"] = "©",
    ["&copy;"] = "©",
    ["&copy"] = "©",
    ["&ordf;"] = "ª",
    ["&ordf"] = "ª",
    ["&laquo;"] = "«",
    ["&laquo"] = "«",
    ["&not;"] = "¬",
    ["&not"] = "¬",
    ["&shy;"] = "­",
    ["&shy"] = "­",
    ["&REG;"] = "®",
    ["&REG"] = "®",
    ["&circledR;"] = "®",
    ["&reg;"] = "®",
    ["&reg"] = "®",
    ["&macr;"] = "¯",
    ["&macr"] = "¯",
    ["&strns;"] = "¯",
    ["&deg;"] = "°",
    ["&deg"] = "°",
    ["&PlusMinus;"] = "±",
    ["&plusmn;"] = "±",
    ["&plusmn"] = "±",
    ["&pm;"] = "±",
    ["&sup2;"] = "²",
    ["&sup2"] = "²",
    ["&sup3;"] = "³",
    ["&sup3"] = "³",
    ["&DiacriticalAcute;"] = "´",
    ["&acute;"] = "´",
    ["&acute"] = "´",
    ["&micro;"] = "µ",
    ["&micro"] = "µ",
    ["&para;"] = "¶",
    ["&para"] = "¶",
    ["&CenterDot;"] = "·",
    ["&centerdot;"] = "·",
    ["&middot;"] = "·",
    ["&middot"] = "·",
    ["&Cedilla;"] = "¸",
    ["&cedil;"] = "¸",
    ["&cedil"] = "¸",
    ["&sup1;"] = "¹",
    ["&sup1"] = "¹",
    ["&ordm;"] = "º",
    ["&ordm"] = "º",
    ["&raquo;"] = "»",
    ["&raquo"] = "»",
    ["&frac14;"] = "¼",
    ["&frac14"] = "¼",
    ["&frac12;"] = "½",
    ["&frac12"] = "½",
    ["&half;"] = "½",
    ["&frac34;"] = "¾",
    ["&frac34"] = "¾",
    ["&iquest;"] = "¿",
    ["&iquest"] = "¿",
    ["&Agrave;"] = "À",
    ["&Agrave"] = "À",
    ["&Aacute;"] = "Á",
    ["&Aacute"] = "Á",
    ["&Acirc;"] = "Â",
    ["&Acirc"] = "Â",
    ["&Atilde;"] = "Ã",
    ["&Atilde"] = "Ã",
    ["&Auml;"] = "Ä",
    ["&Auml"] = "Ä",
    ["&Aring;"] = "Å",
    ["&Aring"] = "Å",
    ["&angst;"] = "Å",
    ["&AElig;"] = "Æ",
    ["&AElig"] = "Æ",
    ["&Ccedil;"] = "Ç",
    ["&Ccedil"] = "Ç",
    ["&Egrave;"] = "È",
    ["&Egrave"] = "È",
    ["&Eacute;"] = "É",
    ["&Eacute"] = "É",
    ["&Ecirc;"] = "Ê",
    ["&Ecirc"] = "Ê",
    ["&Euml;"] = "Ë",
    ["&Euml"] = "Ë",
    ["&Igrave;"] = "Ì",
    ["&Igrave"] = "Ì",
    ["&Iacute;"] = "Í",
    ["&Iacute"] = "Í",
    ["&Icirc;"] = "Î",
    ["&Icirc"] = "Î",
    ["&Iuml;"] = "Ï",
    ["&Iuml"] = "Ï",
    ["&ETH;"] = "Ð",
    ["&ETH"] = "Ð",
    ["&Ntilde;"] = "Ñ",
    ["&Ntilde"] = "Ñ",
    ["&Ograve;"] = "Ò",
    ["&Ograve"] = "Ò",
    ["&Oacute;"] = "Ó",
    ["&Oacute"] = "Ó",
    ["&Ocirc;"] = "Ô",
    ["&Ocirc"] = "Ô",
    ["&Otilde;"] = "Õ",
    ["&Otilde"] = "Õ",
    ["&Ouml;"] = "Ö",
    ["&Ouml"] = "Ö",
    ["&times;"] = "×",
    ["&times"] = "×",
    ["&Oslash;"] = "Ø",
    ["&Oslash"] = "Ø",
    ["&Ugrave;"] = "Ù",
    ["&Ugrave"] = "Ù",
    ["&Uacute;"] = "Ú",
    ["&Uacute"] = "Ú",
    ["&Ucirc;"] = "Û",
    ["&Ucirc"] = "Û",
    ["&Uuml;"] = "Ü",
    ["&Uuml"] = "Ü",
    ["&Yacute;"] = "Ý",
    ["&Yacute"] = "Ý",
    ["&THORN;"] = "Þ",
    ["&THORN"] = "Þ",
    ["&szlig;"] = "ß",
    ["&szlig"] = "ß",
    ["&agrave;"] = "à",
    ["&agrave"] = "à",
    ["&aacute;"] = "á",
    ["&aacute"] = "á",
    ["&acirc;"] = "â",
    ["&acirc"] = "â",
    ["&atilde;"] = "ã",
    ["&atilde"] = "ã",
    ["&auml;"] = "ä",
    ["&auml"] = "ä",
    ["&aring;"] = "å",
    ["&aring"] = "å",
    ["&aelig;"] = "æ",
    ["&aelig"] = "æ",
    ["&ccedil;"] = "ç",
    ["&ccedil"] = "ç",
    ["&egrave;"] = "è",
    ["&egrave"] = "è",
    ["&eacute;"] = "é",
    ["&eacute"] = "é",
    ["&ecirc;"] = "ê",
    ["&ecirc"] = "ê",
    ["&euml;"] = "ë",
    ["&euml"] = "ë",
    ["&igrave;"] = "ì",
    ["&igrave"] = "ì",
    ["&iacute;"] = "í",
    ["&iacute"] = "í",
    ["&icirc;"] = "î",
    ["&icirc"] = "î",
    ["&iuml;"] = "ï",
    ["&iuml"] = "ï",
    ["&eth;"] = "ð",
    ["&eth"] = "ð",
    ["&ntilde;"] = "ñ",
    ["&ntilde"] = "ñ",
    ["&ograve;"] = "ò",
    ["&ograve"] = "ò",
    ["&oacute;"] = "ó",
    ["&oacute"] = "ó",
    ["&ocirc;"] = "ô",
    ["&ocirc"] = "ô",
    ["&otilde;"] = "õ",
    ["&otilde"] = "õ",
    ["&ouml;"] = "ö",
    ["&ouml"] = "ö",
    ["&div;"] = "÷",
    ["&divide;"] = "÷",
    ["&divide"] = "÷",
    ["&oslash;"] = "ø",
    ["&oslash"] = "ø",
    ["&ugrave;"] = "ù",
    ["&ugrave"] = "ù",
    ["&uacute;"] = "ú",
    ["&uacute"] = "ú",
    ["&ucirc;"] = "û",
    ["&ucirc"] = "û",
    ["&uuml;"] = "ü",
    ["&uuml"] = "ü",
    ["&yacute;"] = "ý",
    ["&yacute"] = "ý",
    ["&thorn;"] = "þ",
    ["&thorn"] = "þ",
    ["&yuml;"] = "ÿ",
    ["&yuml"] = "ÿ",
    ["&Amacr;"] = "Ā",
    ["&amacr;"] = "ā",
    ["&Abreve;"] = "Ă",
    ["&abreve;"] = "ă",
    ["&Aogon;"] = "Ą",
    ["&aogon;"] = "ą",
    ["&Cacute;"] = "Ć",
    ["&cacute;"] = "ć",
    ["&Ccirc;"] = "Ĉ",
    ["&ccirc;"] = "ĉ",
    ["&Cdot;"] = "Ċ",
    ["&cdot;"] = "ċ",
    ["&Ccaron;"] = "Č",
    ["&ccaron;"] = "č",
    ["&Dcaron;"] = "Ď",
    ["&dcaron;"] = "ď",
    ["&Dstrok;"] = "Đ",
    ["&dstrok;"] = "đ",
    ["&Emacr;"] = "Ē",
    ["&emacr;"] = "ē",
    ["&Edot;"] = "Ė",
    ["&edot;"] = "ė",
    ["&Eogon;"] = "Ę",
    ["&eogon;"] = "ę",
    ["&Ecaron;"] = "Ě",
    ["&ecaron;"] = "ě",
    ["&Gcirc;"] = "Ĝ",
    ["&gcirc;"] = "ĝ",
    ["&Gbreve;"] = "Ğ",
    ["&gbreve;"] = "ğ",
    ["&Gdot;"] = "Ġ",
    ["&gdot;"] = "ġ",
    ["&Gcedil;"] = "Ģ",
    ["&Hcirc;"] = "Ĥ",
    ["&hcirc;"] = "ĥ",
    ["&Hstrok;"] = "Ħ",
    ["&hstrok;"] = "ħ",
    ["&Itilde;"] = "Ĩ",
    ["&itilde;"] = "ĩ",
    ["&Imacr;"] = "Ī",
    ["&imacr;"] = "ī",
    ["&Iogon;"] = "Į",
    ["&iogon;"] = "į",
    ["&Idot;"] = "İ",
    ["&imath;"] = "ı",
    ["&inodot;"] = "ı",
    ["&IJlig;"] = "Ĳ",
    ["&ijlig;"] = "ĳ",
    ["&Jcirc;"] = "Ĵ",
    ["&jcirc;"] = "ĵ",
    ["&Kcedil;"] = "Ķ",
    ["&kcedil;"] = "ķ",
    ["&kgreen;"] = "ĸ",
    ["&Lacute;"] = "Ĺ",
    ["&lacute;"] = "ĺ",
    ["&Lcedil;"] = "Ļ",
    ["&lcedil;"] = "ļ",
    ["&Lcaron;"] = "Ľ",
    ["&lcaron;"] = "ľ",
    ["&Lmidot;"] = "Ŀ",
    ["&lmidot;"] = "ŀ",
    ["&Lstrok;"] = "Ł",
    ["&lstrok;"] = "ł",
    ["&Nacute;"] = "Ń",
    ["&nacute;"] = "ń",
    ["&Ncedil;"] = "Ņ",
    ["&ncedil;"] = "ņ",
    ["&Ncaron;"] = "Ň",
    ["&ncaron;"] = "ň",
    ["&napos;"] = "ŉ",
    ["&ENG;"] = "Ŋ",
    ["&eng;"] = "ŋ",
    ["&Omacr;"] = "Ō",
    ["&omacr;"] = "ō",
    ["&Odblac;"] = "Ő",
    ["&odblac;"] = "ő",
    ["&OElig;"] = "Œ",
    ["&oelig;"] = "œ",
    ["&Racute;"] = "Ŕ",
    ["&racute;"] = "ŕ",
    ["&Rcedil;"] = "Ŗ",
    ["&rcedil;"] = "ŗ",
    ["&Rcaron;"] = "Ř",
    ["&rcaron;"] = "ř",
    ["&Sacute;"] = "Ś",
    ["&sacute;"] = "ś",
    ["&Scirc;"] = "Ŝ",
    ["&scirc;"] = "ŝ",
    ["&Scedil;"] = "Ş",
    ["&scedil;"] = "ş",
    ["&Scaron;"] = "Š",
    ["&scaron;"] = "š",
    ["&Tcedil;"] = "Ţ",
    ["&tcedil;"] = "ţ",
    ["&Tcaron;"] = "Ť",
    ["&tcaron;"] = "ť",
    ["&Tstrok;"] = "Ŧ",
    ["&tstrok;"] = "ŧ",
    ["&Utilde;"] = "Ũ",
    ["&utilde;"] = "ũ",
    ["&Umacr;"] = "Ū",
    ["&umacr;"] = "ū",
    ["&Ubreve;"] = "Ŭ",
    ["&ubreve;"] = "ŭ",
    ["&Uring;"] = "Ů",
    ["&uring;"] = "ů",
    ["&Udblac;"] = "Ű",
    ["&udblac;"] = "ű",
    ["&Uogon;"] = "Ų",
    ["&uogon;"] = "ų",
    ["&Wcirc;"] = "Ŵ",
    ["&wcirc;"] = "ŵ",
    ["&Ycirc;"] = "Ŷ",
    ["&ycirc;"] = "ŷ",
    ["&Yuml;"] = "Ÿ",
    ["&Zacute;"] = "Ź",
    ["&zacute;"] = "ź",
    ["&Zdot;"] = "Ż",
    ["&zdot;"] = "ż",
    ["&Zcaron;"] = "Ž",
    ["&zcaron;"] = "ž",
    ["&fnof;"] = "ƒ",
    ["&imped;"] = "Ƶ",
    ["&gacute;"] = "ǵ",
    ["&jmath;"] = "ȷ",
    ["&circ;"] = "ˆ",
    ["&Hacek;"] = "ˇ",
    ["&caron;"] = "ˇ",
    ["&Breve;"] = "˘",
    ["&breve;"] = "˘",
    ["&DiacriticalDot;"] = "˙",
    ["&dot;"] = "˙",
    ["&ring;"] = "˚",
    ["&ogon;"] = "˛",
    ["&DiacriticalTilde;"] = "˜",
    ["&tilde;"] = "˜",
    ["&DiacriticalDoubleAcute;"] = "˝",
    ["&dblac;"] = "˝",
    ["&DownBreve;"] = "̑",
    ["&Alpha;"] = "Α",
    ["&Beta;"] = "Β",
    ["&Gamma;"] = "Γ",
    ["&Delta;"] = "Δ",
    ["&Epsilon;"] = "Ε",
    ["&Zeta;"] = "Ζ",
    ["&Eta;"] = "Η",
    ["&Theta;"] = "Θ",
    ["&Iota;"] = "Ι",
    ["&Kappa;"] = "Κ",
    ["&Lambda;"] = "Λ",
    ["&Mu;"] = "Μ",
    ["&Nu;"] = "Ν",
    ["&Xi;"] = "Ξ",
    ["&Omicron;"] = "Ο",
    ["&Pi;"] = "Π",
    ["&Rho;"] = "Ρ",
    ["&Sigma;"] = "Σ",
    ["&Tau;"] = "Τ",
    ["&Upsilon;"] = "Υ",
    ["&Phi;"] = "Φ",
    ["&Chi;"] = "Χ",
    ["&Psi;"] = "Ψ",
    ["&Omega;"] = "Ω",
    ["&ohm;"] = "Ω",
    ["&alpha;"] = "α",
    ["&beta;"] = "β",
    ["&gamma;"] = "γ",
    ["&delta;"] = "δ",
    ["&epsi;"] = "ε",
    ["&epsilon;"] = "ε",
    ["&zeta;"] = "ζ",
    ["&eta;"] = "η",
    ["&theta;"] = "θ",
    ["&iota;"] = "ι",
    ["&kappa;"] = "κ",
    ["&lambda;"] = "λ",
    ["&mu;"] = "μ",
    ["&nu;"] = "ν",
    ["&xi;"] = "ξ",
    ["&omicron;"] = "ο",
    ["&pi;"] = "π",
    ["&rho;"] = "ρ",
    ["&sigmaf;"] = "ς",
    ["&sigmav;"] = "ς",
    ["&varsigma;"] = "ς",
    ["&sigma;"] = "σ",
    ["&tau;"] = "τ",
    ["&upsi;"] = "υ",
    ["&upsilon;"] = "υ",
    ["&phi;"] = "φ",
    ["&chi;"] = "χ",
    ["&psi;"] = "ψ",
    ["&omega;"] = "ω",
    ["&thetasym;"] = "ϑ",
    ["&thetav;"] = "ϑ",
    ["&vartheta;"] = "ϑ",
    ["&Upsi;"] = "ϒ",
    ["&upsih;"] = "ϒ",
    ["&phiv;"] = "ϕ",
    ["&straightphi;"] = "ϕ",
    ["&varphi;"] = "ϕ",
    ["&piv;"] = "ϖ",
    ["&varpi;"] = "ϖ",
    ["&Gammad;"] = "Ϝ",
    ["&digamma;"] = "ϝ",
    ["&gammad;"] = "ϝ",
    ["&kappav;"] = "ϰ",
    ["&varkappa;"] = "ϰ",
    ["&rhov;"] = "ϱ",
    ["&varrho;"] = "ϱ",
    ["&epsiv;"] = "ϵ",
    ["&straightepsilon;"] = "ϵ",
    ["&varepsilon;"] = "ϵ",
    ["&backepsilon;"] = "϶",
    ["&bepsi;"] = "϶",
    ["&IOcy;"] = "Ё",
    ["&DJcy;"] = "Ђ",
    ["&GJcy;"] = "Ѓ",
    ["&Jukcy;"] = "Є",
    ["&DScy;"] = "Ѕ",
    ["&Iukcy;"] = "І",
    ["&YIcy;"] = "Ї",
    ["&Jsercy;"] = "Ј",
    ["&LJcy;"] = "Љ",
    ["&NJcy;"] = "Њ",
    ["&TSHcy;"] = "Ћ",
    ["&KJcy;"] = "Ќ",
    ["&Ubrcy;"] = "Ў",
    ["&DZcy;"] = "Џ",
    ["&Acy;"] = "А",
    ["&Bcy;"] = "Б",
    ["&Vcy;"] = "В",
    ["&Gcy;"] = "Г",
    ["&Dcy;"] = "Д",
    ["&IEcy;"] = "Е",
    ["&ZHcy;"] = "Ж",
    ["&Zcy;"] = "З",
    ["&Icy;"] = "И",
    ["&Jcy;"] = "Й",
    ["&Kcy;"] = "К",
    ["&Lcy;"] = "Л",
    ["&Mcy;"] = "М",
    ["&Ncy;"] = "Н",
    ["&Ocy;"] = "О",
    ["&Pcy;"] = "П",
    ["&Rcy;"] = "Р",
    ["&Scy;"] = "С",
    ["&Tcy;"] = "Т",
    ["&Ucy;"] = "У",
    ["&Fcy;"] = "Ф",
    ["&KHcy;"] = "Х",
    ["&TScy;"] = "Ц",
    ["&CHcy;"] = "Ч",
    ["&SHcy;"] = "Ш",
    ["&SHCHcy;"] = "Щ",
    ["&HARDcy;"] = "Ъ",
    ["&Ycy;"] = "Ы",
    ["&SOFTcy;"] = "Ь",
    ["&Ecy;"] = "Э",
    ["&YUcy;"] = "Ю",
    ["&YAcy;"] = "Я",
    ["&acy;"] = "а",
    ["&bcy;"] = "б",
    ["&vcy;"] = "в",
    ["&gcy;"] = "г",
    ["&dcy;"] = "д",
    ["&iecy;"] = "е",
    ["&zhcy;"] = "ж",
    ["&zcy;"] = "з",
    ["&icy;"] = "и",
    ["&jcy;"] = "й",
    ["&kcy;"] = "к",
    ["&lcy;"] = "л",
    ["&mcy;"] = "м",
    ["&ncy;"] = "н",
    ["&ocy;"] = "о",
    ["&pcy;"] = "п",
    ["&rcy;"] = "р",
    ["&scy;"] = "с",
    ["&tcy;"] = "т",
    ["&ucy;"] = "у",
    ["&fcy;"] = "ф",
    ["&khcy;"] = "х",
    ["&tscy;"] = "ц",
    ["&chcy;"] = "ч",
    ["&shcy;"] = "ш",
    ["&shchcy;"] = "щ",
    ["&hardcy;"] = "ъ",
    ["&ycy;"] = "ы",
    ["&softcy;"] = "ь",
    ["&ecy;"] = "э",
    ["&yucy;"] = "ю",
    ["&yacy;"] = "я",
    ["&iocy;"] = "ё",
    ["&djcy;"] = "ђ",
    ["&gjcy;"] = "ѓ",
    ["&jukcy;"] = "є",
    ["&dscy;"] = "ѕ",
    ["&iukcy;"] = "і",
    ["&yicy;"] = "ї",
    ["&jsercy;"] = "ј",
    ["&ljcy;"] = "љ",
    ["&njcy;"] = "њ",
    ["&tshcy;"] = "ћ",
    ["&kjcy;"] = "ќ",
    ["&ubrcy;"] = "ў",
    ["&dzcy;"] = "џ",
    ["&ensp;"] = " ",
    ["&emsp;"] = " ",
    ["&emsp13;"] = " ",
    ["&emsp14;"] = " ",
    ["&numsp;"] = " ",
    ["&puncsp;"] = " ",
    ["&ThinSpace;"] = " ",
    ["&thinsp;"] = " ",
    ["&VeryThinSpace;"] = " ",
    ["&hairsp;"] = " ",
    ["&NegativeMediumSpace;"] = "​",
    ["&NegativeThickSpace;"] = "​",
    ["&NegativeThinSpace;"] = "​",
    ["&NegativeVeryThinSpace;"] = "​",
    ["&ZeroWidthSpace;"] = "​",
    ["&zwnj;"] = "‌",
    ["&zwj;"] = "‍",
    ["&lrm;"] = "‎",
    ["&rlm;"] = "‏",
    ["&dash;"] = "‐",
    ["&hyphen;"] = "‐",
    ["&ndash;"] = "–",
    ["&mdash;"] = "—",
    ["&horbar;"] = "―",
    ["&Verbar;"] = "‖",
    ["&Vert;"] = "‖",
    ["&OpenCurlyQuote;"] = "‘",
    ["&lsquo;"] = "‘",
    ["&CloseCurlyQuote;"] = "’",
    ["&rsquo;"] = "’",
    ["&rsquor;"] = "’",
    ["&lsquor;"] = "‚",
    ["&sbquo;"] = "‚",
    ["&OpenCurlyDoubleQuote;"] = "“",
    ["&ldquo;"] = "“",
    ["&CloseCurlyDoubleQuote;"] = "”",
    ["&rdquo;"] = "”",
    ["&rdquor;"] = "”",
    ["&bdquo;"] = "„",
    ["&ldquor;"] = "„",
    ["&dagger;"] = "†",
    ["&Dagger;"] = "‡",
    ["&ddagger;"] = "‡",
    ["&bull;"] = "•",
    ["&bullet;"] = "•",
    ["&nldr;"] = "‥",
    ["&hellip;"] = "…",
    ["&mldr;"] = "…",
    ["&permil;"] = "‰",
    ["&pertenk;"] = "‱",
    ["&prime;"] = "′",
    ["&Prime;"] = "″",
    ["&tprime;"] = "‴",
    ["&backprime;"] = "‵",
    ["&bprime;"] = "‵",
    ["&lsaquo;"] = "‹",
    ["&rsaquo;"] = "›",
    ["&OverBar;"] = "‾",
    ["&oline;"] = "‾",
    ["&caret;"] = "⁁",
    ["&hybull;"] = "⁃",
    ["&frasl;"] = "⁄",
    ["&bsemi;"] = "⁏",
    ["&qprime;"] = "⁗",
    ["&MediumSpace;"] = " ",
    ["&ThickSpace;"] = "  ",
    ["&NoBreak;"] = "⁠",
    ["&ApplyFunction;"] = "⁡",
    ["&af;"] = "⁡",
    ["&InvisibleTimes;"] = "⁢",
    ["&it;"] = "⁢",
    ["&InvisibleComma;"] = "⁣",
    ["&ic;"] = "⁣",
    ["&euro;"] = "€",
    ["&TripleDot;"] = "⃛",
    ["&tdot;"] = "⃛",
    ["&DotDot;"] = "⃜",
    ["&Copf;"] = "ℂ",
    ["&complexes;"] = "ℂ",
    ["&incare;"] = "℅",
    ["&gscr;"] = "ℊ",
    ["&HilbertSpace;"] = "ℋ",
    ["&Hscr;"] = "ℋ",
    ["&hamilt;"] = "ℋ",
    ["&Hfr;"] = "ℌ",
    ["&Poincareplane;"] = "ℌ",
    ["&Hopf;"] = "ℍ",
    ["&quaternions;"] = "ℍ",
    ["&planckh;"] = "ℎ",
    ["&hbar;"] = "ℏ",
    ["&hslash;"] = "ℏ",
    ["&planck;"] = "ℏ",
    ["&plankv;"] = "ℏ",
    ["&Iscr;"] = "ℐ",
    ["&imagline;"] = "ℐ",
    ["&Ifr;"] = "ℑ",
    ["&Im;"] = "ℑ",
    ["&image;"] = "ℑ",
    ["&imagpart;"] = "ℑ",
    ["&Laplacetrf;"] = "ℒ",
    ["&Lscr;"] = "ℒ",
    ["&lagran;"] = "ℒ",
    ["&ell;"] = "ℓ",
    ["&Nopf;"] = "ℕ",
    ["&naturals;"] = "ℕ",
    ["&numero;"] = "№",
    ["&copysr;"] = "℗",
    ["&weierp;"] = "℘",
    ["&wp;"] = "℘",
    ["&Popf;"] = "ℙ",
    ["&primes;"] = "ℙ",
    ["&Qopf;"] = "ℚ",
    ["&rationals;"] = "ℚ",
    ["&Rscr;"] = "ℛ",
    ["&realine;"] = "ℛ",
    ["&Re;"] = "ℜ",
    ["&Rfr;"] = "ℜ",
    ["&real;"] = "ℜ",
    ["&realpart;"] = "ℜ",
    ["&Ropf;"] = "ℝ",
    ["&reals;"] = "ℝ",
    ["&rx;"] = "℞",
    ["&TRADE;"] = "™",
    ["&trade;"] = "™",
    ["&Zopf;"] = "ℤ",
    ["&integers;"] = "ℤ",
    ["&mho;"] = "℧",
    ["&Zfr;"] = "ℨ",
    ["&zeetrf;"] = "ℨ",
    ["&iiota;"] = "℩",
    ["&Bernoullis;"] = "ℬ",
    ["&Bscr;"] = "ℬ",
    ["&bernou;"] = "ℬ",
    ["&Cayleys;"] = "ℭ",
    ["&Cfr;"] = "ℭ",
    ["&escr;"] = "ℯ",
    ["&Escr;"] = "ℰ",
    ["&expectation;"] = "ℰ",
    ["&Fouriertrf;"] = "ℱ",
    ["&Fscr;"] = "ℱ",
    ["&Mellintrf;"] = "ℳ",
    ["&Mscr;"] = "ℳ",
    ["&phmmat;"] = "ℳ",
    ["&order;"] = "ℴ",
    ["&orderof;"] = "ℴ",
    ["&oscr;"] = "ℴ",
    ["&alefsym;"] = "ℵ",
    ["&aleph;"] = "ℵ",
    ["&beth;"] = "ℶ",
    ["&gimel;"] = "ℷ",
    ["&daleth;"] = "ℸ",
    ["&CapitalDifferentialD;"] = "ⅅ",
    ["&DD;"] = "ⅅ",
    ["&DifferentialD;"] = "ⅆ",
    ["&dd;"] = "ⅆ",
    ["&ExponentialE;"] = "ⅇ",
    ["&ee;"] = "ⅇ",
    ["&exponentiale;"] = "ⅇ",
    ["&ImaginaryI;"] = "ⅈ",
    ["&ii;"] = "ⅈ",
    ["&frac13;"] = "⅓",
    ["&frac23;"] = "⅔",
    ["&frac15;"] = "⅕",
    ["&frac25;"] = "⅖",
    ["&frac35;"] = "⅗",
    ["&frac45;"] = "⅘",
    ["&frac16;"] = "⅙",
    ["&frac56;"] = "⅚",
    ["&frac18;"] = "⅛",
    ["&frac38;"] = "⅜",
    ["&frac58;"] = "⅝",
    ["&frac78;"] = "⅞",
    ["&LeftArrow;"] = "←",
    ["&ShortLeftArrow;"] = "←",
    ["&larr;"] = "←",
    ["&leftarrow;"] = "←",
    ["&slarr;"] = "←",
    ["&ShortUpArrow;"] = "↑",
    ["&UpArrow;"] = "↑",
    ["&uarr;"] = "↑",
    ["&uparrow;"] = "↑",
    ["&RightArrow;"] = "→",
    ["&ShortRightArrow;"] = "→",
    ["&rarr;"] = "→",
    ["&rightarrow;"] = "→",
    ["&srarr;"] = "→",
    ["&DownArrow;"] = "↓",
    ["&ShortDownArrow;"] = "↓",
    ["&darr;"] = "↓",
    ["&downarrow;"] = "↓",
    ["&LeftRightArrow;"] = "↔",
    ["&harr;"] = "↔",
    ["&leftrightarrow;"] = "↔",
    ["&UpDownArrow;"] = "↕",
    ["&updownarrow;"] = "↕",
    ["&varr;"] = "↕",
    ["&UpperLeftArrow;"] = "↖",
    ["&nwarr;"] = "↖",
    ["&nwarrow;"] = "↖",
    ["&UpperRightArrow;"] = "↗",
    ["&nearr;"] = "↗",
    ["&nearrow;"] = "↗",
    ["&LowerRightArrow;"] = "↘",
    ["&searr;"] = "↘",
    ["&searrow;"] = "↘",
    ["&LowerLeftArrow;"] = "↙",
    ["&swarr;"] = "↙",
    ["&swarrow;"] = "↙",
    ["&nlarr;"] = "↚",
    ["&nleftarrow;"] = "↚",
    ["&nrarr;"] = "↛",
    ["&nrightarrow;"] = "↛",
    ["&rarrw;"] = "↝",
    ["&rightsquigarrow;"] = "↝",
    ["&nrarrw;"] = "↝̸",
    ["&Larr;"] = "↞",
    ["&twoheadleftarrow;"] = "↞",
    ["&Uarr;"] = "↟",
    ["&Rarr;"] = "↠",
    ["&twoheadrightarrow;"] = "↠",
    ["&Darr;"] = "↡",
    ["&larrtl;"] = "↢",
    ["&leftarrowtail;"] = "↢",
    ["&rarrtl;"] = "↣",
    ["&rightarrowtail;"] = "↣",
    ["&LeftTeeArrow;"] = "↤",
    ["&mapstoleft;"] = "↤",
    ["&UpTeeArrow;"] = "↥",
    ["&mapstoup;"] = "↥",
    ["&RightTeeArrow;"] = "↦",
    ["&map;"] = "↦",
    ["&mapsto;"] = "↦",
    ["&DownTeeArrow;"] = "↧",
    ["&mapstodown;"] = "↧",
    ["&hookleftarrow;"] = "↩",
    ["&larrhk;"] = "↩",
    ["&hookrightarrow;"] = "↪",
    ["&rarrhk;"] = "↪",
    ["&larrlp;"] = "↫",
    ["&looparrowleft;"] = "↫",
    ["&looparrowright;"] = "↬",
    ["&rarrlp;"] = "↬",
    ["&harrw;"] = "↭",
    ["&leftrightsquigarrow;"] = "↭",
    ["&nharr;"] = "↮",
    ["&nleftrightarrow;"] = "↮",
    ["&Lsh;"] = "↰",
    ["&lsh;"] = "↰",
    ["&Rsh;"] = "↱",
    ["&rsh;"] = "↱",
    ["&ldsh;"] = "↲",
    ["&rdsh;"] = "↳",
    ["&crarr;"] = "↵",
    ["&cularr;"] = "↶",
    ["&curvearrowleft;"] = "↶",
    ["&curarr;"] = "↷",
    ["&curvearrowright;"] = "↷",
    ["&circlearrowleft;"] = "↺",
    ["&olarr;"] = "↺",
    ["&circlearrowright;"] = "↻",
    ["&orarr;"] = "↻",
    ["&LeftVector;"] = "↼",
    ["&leftharpoonup;"] = "↼",
    ["&lharu;"] = "↼",
    ["&DownLeftVector;"] = "↽",
    ["&leftharpoondown;"] = "↽",
    ["&lhard;"] = "↽",
    ["&RightUpVector;"] = "↾",
    ["&uharr;"] = "↾",
    ["&upharpoonright;"] = "↾",
    ["&LeftUpVector;"] = "↿",
    ["&uharl;"] = "↿",
    ["&upharpoonleft;"] = "↿",
    ["&RightVector;"] = "⇀",
    ["&rharu;"] = "⇀",
    ["&rightharpoonup;"] = "⇀",
    ["&DownRightVector;"] = "⇁",
    ["&rhard;"] = "⇁",
    ["&rightharpoondown;"] = "⇁",
    ["&RightDownVector;"] = "⇂",
    ["&dharr;"] = "⇂",
    ["&downharpoonright;"] = "⇂",
    ["&LeftDownVector;"] = "⇃",
    ["&dharl;"] = "⇃",
    ["&downharpoonleft;"] = "⇃",
    ["&RightArrowLeftArrow;"] = "⇄",
    ["&rightleftarrows;"] = "⇄",
    ["&rlarr;"] = "⇄",
    ["&UpArrowDownArrow;"] = "⇅",
    ["&udarr;"] = "⇅",
    ["&LeftArrowRightArrow;"] = "⇆",
    ["&leftrightarrows;"] = "⇆",
    ["&lrarr;"] = "⇆",
    ["&leftleftarrows;"] = "⇇",
    ["&llarr;"] = "⇇",
    ["&upuparrows;"] = "⇈",
    ["&uuarr;"] = "⇈",
    ["&rightrightarrows;"] = "⇉",
    ["&rrarr;"] = "⇉",
    ["&ddarr;"] = "⇊",
    ["&downdownarrows;"] = "⇊",
    ["&ReverseEquilibrium;"] = "⇋",
    ["&leftrightharpoons;"] = "⇋",
    ["&lrhar;"] = "⇋",
    ["&Equilibrium;"] = "⇌",
    ["&rightleftharpoons;"] = "⇌",
    ["&rlhar;"] = "⇌",
    ["&nLeftarrow;"] = "⇍",
    ["&nlArr;"] = "⇍",
    ["&nLeftrightarrow;"] = "⇎",
    ["&nhArr;"] = "⇎",
    ["&nRightarrow;"] = "⇏",
    ["&nrArr;"] = "⇏",
    ["&DoubleLeftArrow;"] = "⇐",
    ["&Leftarrow;"] = "⇐",
    ["&lArr;"] = "⇐",
    ["&DoubleUpArrow;"] = "⇑",
    ["&Uparrow;"] = "⇑",
    ["&uArr;"] = "⇑",
    ["&DoubleRightArrow;"] = "⇒",
    ["&Implies;"] = "⇒",
    ["&Rightarrow;"] = "⇒",
    ["&rArr;"] = "⇒",
    ["&DoubleDownArrow;"] = "⇓",
    ["&Downarrow;"] = "⇓",
    ["&dArr;"] = "⇓",
    ["&DoubleLeftRightArrow;"] = "⇔",
    ["&Leftrightarrow;"] = "⇔",
    ["&hArr;"] = "⇔",
    ["&iff;"] = "⇔",
    ["&DoubleUpDownArrow;"] = "⇕",
    ["&Updownarrow;"] = "⇕",
    ["&vArr;"] = "⇕",
    ["&nwArr;"] = "⇖",
    ["&neArr;"] = "⇗",
    ["&seArr;"] = "⇘",
    ["&swArr;"] = "⇙",
    ["&Lleftarrow;"] = "⇚",
    ["&lAarr;"] = "⇚",
    ["&Rrightarrow;"] = "⇛",
    ["&rAarr;"] = "⇛",
    ["&zigrarr;"] = "⇝",
    ["&LeftArrowBar;"] = "⇤",
    ["&larrb;"] = "⇤",
    ["&RightArrowBar;"] = "⇥",
    ["&rarrb;"] = "⇥",
    ["&DownArrowUpArrow;"] = "⇵",
    ["&duarr;"] = "⇵",
    ["&loarr;"] = "⇽",
    ["&roarr;"] = "⇾",
    ["&hoarr;"] = "⇿",
    ["&ForAll;"] = "∀",
    ["&forall;"] = "∀",
    ["&comp;"] = "∁",
    ["&complement;"] = "∁",
    ["&PartialD;"] = "∂",
    ["&part;"] = "∂",
    ["&npart;"] = "∂̸",
    ["&Exists;"] = "∃",
    ["&exist;"] = "∃",
    ["&NotExists;"] = "∄",
    ["&nexist;"] = "∄",
    ["&nexists;"] = "∄",
    ["&empty;"] = "∅",
    ["&emptyset;"] = "∅",
    ["&emptyv;"] = "∅",
    ["&varnothing;"] = "∅",
    ["&Del;"] = "∇",
    ["&nabla;"] = "∇",
    ["&Element;"] = "∈",
    ["&in;"] = "∈",
    ["&isin;"] = "∈",
    ["&isinv;"] = "∈",
    ["&NotElement;"] = "∉",
    ["&notin;"] = "∉",
    ["&notinva;"] = "∉",
    ["&ReverseElement;"] = "∋",
    ["&SuchThat;"] = "∋",
    ["&ni;"] = "∋",
    ["&niv;"] = "∋",
    ["&NotReverseElement;"] = "∌",
    ["&notni;"] = "∌",
    ["&notniva;"] = "∌",
    ["&Product;"] = "∏",
    ["&prod;"] = "∏",
    ["&Coproduct;"] = "∐",
    ["&coprod;"] = "∐",
    ["&Sum;"] = "∑",
    ["&sum;"] = "∑",
    ["&minus;"] = "−",
    ["&MinusPlus;"] = "∓",
    ["&mnplus;"] = "∓",
    ["&mp;"] = "∓",
    ["&dotplus;"] = "∔",
    ["&plusdo;"] = "∔",
    ["&Backslash;"] = "∖",
    ["&setminus;"] = "∖",
    ["&setmn;"] = "∖",
    ["&smallsetminus;"] = "∖",
    ["&ssetmn;"] = "∖",
    ["&lowast;"] = "∗",
    ["&SmallCircle;"] = "∘",
    ["&compfn;"] = "∘",
    ["&Sqrt;"] = "√",
    ["&radic;"] = "√",
    ["&Proportional;"] = "∝",
    ["&prop;"] = "∝",
    ["&propto;"] = "∝",
    ["&varpropto;"] = "∝",
    ["&vprop;"] = "∝",
    ["&infin;"] = "∞",
    ["&angrt;"] = "∟",
    ["&ang;"] = "∠",
    ["&angle;"] = "∠",
    ["&nang;"] = "∠⃒",
    ["&angmsd;"] = "∡",
    ["&measuredangle;"] = "∡",
    ["&angsph;"] = "∢",
    ["&VerticalBar;"] = "∣",
    ["&mid;"] = "∣",
    ["&shortmid;"] = "∣",
    ["&smid;"] = "∣",
    ["&NotVerticalBar;"] = "∤",
    ["&nmid;"] = "∤",
    ["&nshortmid;"] = "∤",
    ["&nsmid;"] = "∤",
    ["&DoubleVerticalBar;"] = "∥",
    ["&par;"] = "∥",
    ["&parallel;"] = "∥",
    ["&shortparallel;"] = "∥",
    ["&spar;"] = "∥",
    ["&NotDoubleVerticalBar;"] = "∦",
    ["&npar;"] = "∦",
    ["&nparallel;"] = "∦",
    ["&nshortparallel;"] = "∦",
    ["&nspar;"] = "∦",
    ["&and;"] = "∧",
    ["&wedge;"] = "∧",
    ["&or;"] = "∨",
    ["&vee;"] = "∨",
    ["&cap;"] = "∩",
    ["&caps;"] = "∩︀",
    ["&cup;"] = "∪",
    ["&cups;"] = "∪︀",
    ["&Integral;"] = "∫",
    ["&int;"] = "∫",
    ["&Int;"] = "∬",
    ["&iiint;"] = "∭",
    ["&tint;"] = "∭",
    ["&ContourIntegral;"] = "∮",
    ["&conint;"] = "∮",
    ["&oint;"] = "∮",
    ["&Conint;"] = "∯",
    ["&DoubleContourIntegral;"] = "∯",
    ["&Cconint;"] = "∰",
    ["&cwint;"] = "∱",
    ["&ClockwiseContourIntegral;"] = "∲",
    ["&cwconint;"] = "∲",
    ["&CounterClockwiseContourIntegral;"] = "∳",
    ["&awconint;"] = "∳",
    ["&Therefore;"] = "∴",
    ["&there4;"] = "∴",
    ["&therefore;"] = "∴",
    ["&Because;"] = "∵",
    ["&becaus;"] = "∵",
    ["&because;"] = "∵",
    ["&ratio;"] = "∶",
    ["&Colon;"] = "∷",
    ["&Proportion;"] = "∷",
    ["&dotminus;"] = "∸",
    ["&minusd;"] = "∸",
    ["&mDDot;"] = "∺",
    ["&homtht;"] = "∻",
    ["&Tilde;"] = "∼",
    ["&sim;"] = "∼",
    ["&thicksim;"] = "∼",
    ["&thksim;"] = "∼",
    ["&nvsim;"] = "∼⃒",
    ["&backsim;"] = "∽",
    ["&bsim;"] = "∽",
    ["&race;"] = "∽̱",
    ["&ac;"] = "∾",
    ["&mstpos;"] = "∾",
    ["&acE;"] = "∾̳",
    ["&acd;"] = "∿",
    ["&VerticalTilde;"] = "≀",
    ["&wr;"] = "≀",
    ["&wreath;"] = "≀",
    ["&NotTilde;"] = "≁",
    ["&nsim;"] = "≁",
    ["&EqualTilde;"] = "≂",
    ["&eqsim;"] = "≂",
    ["&esim;"] = "≂",
    ["&nesim;"] = "≂̸",
    ["&NotEqualTilde;"] = "≂̸",
    ["&TildeEqual;"] = "≃",
    ["&sime;"] = "≃",
    ["&simeq;"] = "≃",
    ["&NotTildeEqual;"] = "≄",
    ["&nsime;"] = "≄",
    ["&nsimeq;"] = "≄",
    ["&TildeFullEqual;"] = "≅",
    ["&cong;"] = "≅",
    ["&simne;"] = "≆",
    ["&NotTildeFullEqual;"] = "≇",
    ["&ncong;"] = "≇",
    ["&TildeTilde;"] = "≈",
    ["&ap;"] = "≈",
    ["&approx;"] = "≈",
    ["&asymp;"] = "≈",
    ["&thickapprox;"] = "≈",
    ["&thkap;"] = "≈",
    ["&NotTildeTilde;"] = "≉",
    ["&nap;"] = "≉",
    ["&napprox;"] = "≉",
    ["&ape;"] = "≊",
    ["&approxeq;"] = "≊",
    ["&apid;"] = "≋",
    ["&napid;"] = "≋̸",
    ["&backcong;"] = "≌",
    ["&bcong;"] = "≌",
    ["&CupCap;"] = "≍",
    ["&asympeq;"] = "≍",
    ["&nvap;"] = "≍⃒",
    ["&Bumpeq;"] = "≎",
    ["&HumpDownHump;"] = "≎",
    ["&bump;"] = "≎",
    ["&nbump;"] = "≎̸",
    ["&NotHumpDownHump;"] = "≎̸",
    ["&HumpEqual;"] = "≏",
    ["&bumpe;"] = "≏",
    ["&bumpeq;"] = "≏",
    ["&nbumpe;"] = "≏̸",
    ["&NotHumpEqual;"] = "≏̸",
    ["&DotEqual;"] = "≐",
    ["&doteq;"] = "≐",
    ["&esdot;"] = "≐",
    ["&nedot;"] = "≐̸",
    ["&doteqdot;"] = "≑",
    ["&eDot;"] = "≑",
    ["&efDot;"] = "≒",
    ["&fallingdotseq;"] = "≒",
    ["&erDot;"] = "≓",
    ["&risingdotseq;"] = "≓",
    ["&Assign;"] = "≔",
    ["&colone;"] = "≔",
    ["&coloneq;"] = "≔",
    ["&ecolon;"] = "≕",
    ["&eqcolon;"] = "≕",
    ["&ecir;"] = "≖",
    ["&eqcirc;"] = "≖",
    ["&circeq;"] = "≗",
    ["&cire;"] = "≗",
    ["&wedgeq;"] = "≙",
    ["&veeeq;"] = "≚",
    ["&triangleq;"] = "≜",
    ["&trie;"] = "≜",
    ["&equest;"] = "≟",
    ["&questeq;"] = "≟",
    ["&NotEqual;"] = "≠",
    ["&ne;"] = "≠",
    ["&Congruent;"] = "≡",
    ["&equiv;"] = "≡",
    ["&bnequiv;"] = "≡⃥",
    ["&NotCongruent;"] = "≢",
    ["&nequiv;"] = "≢",
    ["&le;"] = "≤",
    ["&leq;"] = "≤",
    ["&nvle;"] = "≤⃒",
    ["&GreaterEqual;"] = "≥",
    ["&ge;"] = "≥",
    ["&geq;"] = "≥",
    ["&nvge;"] = "≥⃒",
    ["&LessFullEqual;"] = "≦",
    ["&lE;"] = "≦",
    ["&leqq;"] = "≦",
    ["&nlE;"] = "≦̸",
    ["&nleqq;"] = "≦̸",
    ["&GreaterFullEqual;"] = "≧",
    ["&gE;"] = "≧",
    ["&geqq;"] = "≧",
    ["&ngE;"] = "≧̸",
    ["&ngeqq;"] = "≧̸",
    ["&NotGreaterFullEqual;"] = "≧̸",
    ["&lnE;"] = "≨",
    ["&lneqq;"] = "≨",
    ["&lvertneqq;"] = "≨︀",
    ["&lvnE;"] = "≨︀",
    ["&gnE;"] = "≩",
    ["&gneqq;"] = "≩",
    ["&gvertneqq;"] = "≩︀",
    ["&gvnE;"] = "≩︀",
    ["&Lt;"] = "≪",
    ["&NestedLessLess;"] = "≪",
    ["&ll;"] = "≪",
    ["&nLtv;"] = "≪̸",
    ["&NotLessLess;"] = "≪̸",
    ["&nLt;"] = "≪⃒",
    ["&Gt;"] = "≫",
    ["&NestedGreaterGreater;"] = "≫",
    ["&gg;"] = "≫",
    ["&nGtv;"] = "≫̸",
    ["&NotGreaterGreater;"] = "≫̸",
    ["&nGt;"] = "≫⃒",
    ["&between;"] = "≬",
    ["&twixt;"] = "≬",
    ["&NotCupCap;"] = "≭",
    ["&NotLess;"] = "≮",
    ["&nless;"] = "≮",
    ["&nlt;"] = "≮",
    ["&NotGreater;"] = "≯",
    ["&ngt;"] = "≯",
    ["&ngtr;"] = "≯",
    ["&NotLessEqual;"] = "≰",
    ["&nle;"] = "≰",
    ["&nleq;"] = "≰",
    ["&NotGreaterEqual;"] = "≱",
    ["&nge;"] = "≱",
    ["&ngeq;"] = "≱",
    ["&LessTilde;"] = "≲",
    ["&lesssim;"] = "≲",
    ["&lsim;"] = "≲",
    ["&GreaterTilde;"] = "≳",
    ["&gsim;"] = "≳",
    ["&gtrsim;"] = "≳",
    ["&NotLessTilde;"] = "≴",
    ["&nlsim;"] = "≴",
    ["&NotGreaterTilde;"] = "≵",
    ["&ngsim;"] = "≵",
    ["&LessGreater;"] = "≶",
    ["&lessgtr;"] = "≶",
    ["&lg;"] = "≶",
    ["&GreaterLess;"] = "≷",
    ["&gl;"] = "≷",
    ["&gtrless;"] = "≷",
    ["&NotLessGreater;"] = "≸",
    ["&ntlg;"] = "≸",
    ["&NotGreaterLess;"] = "≹",
    ["&ntgl;"] = "≹",
    ["&Precedes;"] = "≺",
    ["&pr;"] = "≺",
    ["&prec;"] = "≺",
    ["&Succeeds;"] = "≻",
    ["&sc;"] = "≻",
    ["&succ;"] = "≻",
    ["&PrecedesSlantEqual;"] = "≼",
    ["&prcue;"] = "≼",
    ["&preccurlyeq;"] = "≼",
    ["&SucceedsSlantEqual;"] = "≽",
    ["&sccue;"] = "≽",
    ["&succcurlyeq;"] = "≽",
    ["&PrecedesTilde;"] = "≾",
    ["&precsim;"] = "≾",
    ["&prsim;"] = "≾",
    ["&SucceedsTilde;"] = "≿",
    ["&scsim;"] = "≿",
    ["&succsim;"] = "≿",
    ["&NotSucceedsTilde;"] = "≿̸",
    ["&NotPrecedes;"] = "⊀",
    ["&npr;"] = "⊀",
    ["&nprec;"] = "⊀",
    ["&NotSucceeds;"] = "⊁",
    ["&nsc;"] = "⊁",
    ["&nsucc;"] = "⊁",
    ["&sub;"] = "⊂",
    ["&subset;"] = "⊂",
    ["&NotSubset;"] = "⊂⃒",
    ["&nsubset;"] = "⊂⃒",
    ["&vnsub;"] = "⊂⃒",
    ["&Superset;"] = "⊃",
    ["&sup;"] = "⊃",
    ["&supset;"] = "⊃",
    ["&NotSuperset;"] = "⊃⃒",
    ["&nsupset;"] = "⊃⃒",
    ["&vnsup;"] = "⊃⃒",
    ["&nsub;"] = "⊄",
    ["&nsup;"] = "⊅",
    ["&SubsetEqual;"] = "⊆",
    ["&sube;"] = "⊆",
    ["&subseteq;"] = "⊆",
    ["&SupersetEqual;"] = "⊇",
    ["&supe;"] = "⊇",
    ["&supseteq;"] = "⊇",
    ["&NotSubsetEqual;"] = "⊈",
    ["&nsube;"] = "⊈",
    ["&nsubseteq;"] = "⊈",
    ["&NotSupersetEqual;"] = "⊉",
    ["&nsupe;"] = "⊉",
    ["&nsupseteq;"] = "⊉",
    ["&subne;"] = "⊊",
    ["&subsetneq;"] = "⊊",
    ["&varsubsetneq;"] = "⊊︀",
    ["&vsubne;"] = "⊊︀",
    ["&supne;"] = "⊋",
    ["&supsetneq;"] = "⊋",
    ["&varsupsetneq;"] = "⊋︀",
    ["&vsupne;"] = "⊋︀",
    ["&cupdot;"] = "⊍",
    ["&UnionPlus;"] = "⊎",
    ["&uplus;"] = "⊎",
    ["&SquareSubset;"] = "⊏",
    ["&sqsub;"] = "⊏",
    ["&sqsubset;"] = "⊏",
    ["&NotSquareSubset;"] = "⊏̸",
    ["&SquareSuperset;"] = "⊐",
    ["&sqsup;"] = "⊐",
    ["&sqsupset;"] = "⊐",
    ["&NotSquareSuperset;"] = "⊐̸",
    ["&SquareSubsetEqual;"] = "⊑",
    ["&sqsube;"] = "⊑",
    ["&sqsubseteq;"] = "⊑",
    ["&SquareSupersetEqual;"] = "⊒",
    ["&sqsupe;"] = "⊒",
    ["&sqsupseteq;"] = "⊒",
    ["&SquareIntersection;"] = "⊓",
    ["&sqcap;"] = "⊓",
    ["&sqcaps;"] = "⊓︀",
    ["&SquareUnion;"] = "⊔",
    ["&sqcup;"] = "⊔",
    ["&sqcups;"] = "⊔︀",
    ["&CirclePlus;"] = "⊕",
    ["&oplus;"] = "⊕",
    ["&CircleMinus;"] = "⊖",
    ["&ominus;"] = "⊖",
    ["&CircleTimes;"] = "⊗",
    ["&otimes;"] = "⊗",
    ["&osol;"] = "⊘",
    ["&CircleDot;"] = "⊙",
    ["&odot;"] = "⊙",
    ["&circledcirc;"] = "⊚",
    ["&ocir;"] = "⊚",
    ["&circledast;"] = "⊛",
    ["&oast;"] = "⊛",
    ["&circleddash;"] = "⊝",
    ["&odash;"] = "⊝",
    ["&boxplus;"] = "⊞",
    ["&plusb;"] = "⊞",
    ["&boxminus;"] = "⊟",
    ["&minusb;"] = "⊟",
    ["&boxtimes;"] = "⊠",
    ["&timesb;"] = "⊠",
    ["&dotsquare;"] = "⊡",
    ["&sdotb;"] = "⊡",
    ["&RightTee;"] = "⊢",
    ["&vdash;"] = "⊢",
    ["&LeftTee;"] = "⊣",
    ["&dashv;"] = "⊣",
    ["&DownTee;"] = "⊤",
    ["&top;"] = "⊤",
    ["&UpTee;"] = "⊥",
    ["&bot;"] = "⊥",
    ["&bottom;"] = "⊥",
    ["&perp;"] = "⊥",
    ["&models;"] = "⊧",
    ["&DoubleRightTee;"] = "⊨",
    ["&vDash;"] = "⊨",
    ["&Vdash;"] = "⊩",
    ["&Vvdash;"] = "⊪",
    ["&VDash;"] = "⊫",
    ["&nvdash;"] = "⊬",
    ["&nvDash;"] = "⊭",
    ["&nVdash;"] = "⊮",
    ["&nVDash;"] = "⊯",
    ["&prurel;"] = "⊰",
    ["&LeftTriangle;"] = "⊲",
    ["&vartriangleleft;"] = "⊲",
    ["&vltri;"] = "⊲",
    ["&RightTriangle;"] = "⊳",
    ["&vartriangleright;"] = "⊳",
    ["&vrtri;"] = "⊳",
    ["&LeftTriangleEqual;"] = "⊴",
    ["&ltrie;"] = "⊴",
    ["&trianglelefteq;"] = "⊴",
    ["&nvltrie;"] = "⊴⃒",
    ["&RightTriangleEqual;"] = "⊵",
    ["&rtrie;"] = "⊵",
    ["&trianglerighteq;"] = "⊵",
    ["&nvrtrie;"] = "⊵⃒",
    ["&origof;"] = "⊶",
    ["&imof;"] = "⊷",
    ["&multimap;"] = "⊸",
    ["&mumap;"] = "⊸",
    ["&hercon;"] = "⊹",
    ["&intcal;"] = "⊺",
    ["&intercal;"] = "⊺",
    ["&veebar;"] = "⊻",
    ["&barvee;"] = "⊽",
    ["&angrtvb;"] = "⊾",
    ["&lrtri;"] = "⊿",
    ["&Wedge;"] = "⋀",
    ["&bigwedge;"] = "⋀",
    ["&xwedge;"] = "⋀",
    ["&Vee;"] = "⋁",
    ["&bigvee;"] = "⋁",
    ["&xvee;"] = "⋁",
    ["&Intersection;"] = "⋂",
    ["&bigcap;"] = "⋂",
    ["&xcap;"] = "⋂",
    ["&Union;"] = "⋃",
    ["&bigcup;"] = "⋃",
    ["&xcup;"] = "⋃",
    ["&Diamond;"] = "⋄",
    ["&diam;"] = "⋄",
    ["&diamond;"] = "⋄",
    ["&sdot;"] = "⋅",
    ["&Star;"] = "⋆",
    ["&sstarf;"] = "⋆",
    ["&divideontimes;"] = "⋇",
    ["&divonx;"] = "⋇",
    ["&bowtie;"] = "⋈",
    ["&ltimes;"] = "⋉",
    ["&rtimes;"] = "⋊",
    ["&leftthreetimes;"] = "⋋",
    ["&lthree;"] = "⋋",
    ["&rightthreetimes;"] = "⋌",
    ["&rthree;"] = "⋌",
    ["&backsimeq;"] = "⋍",
    ["&bsime;"] = "⋍",
    ["&curlyvee;"] = "⋎",
    ["&cuvee;"] = "⋎",
    ["&curlywedge;"] = "⋏",
    ["&cuwed;"] = "⋏",
    ["&Sub;"] = "⋐",
    ["&Subset;"] = "⋐",
    ["&Sup;"] = "⋑",
    ["&Supset;"] = "⋑",
    ["&Cap;"] = "⋒",
    ["&Cup;"] = "⋓",
    ["&fork;"] = "⋔",
    ["&pitchfork;"] = "⋔",
    ["&epar;"] = "⋕",
    ["&lessdot;"] = "⋖",
    ["&ltdot;"] = "⋖",
    ["&gtdot;"] = "⋗",
    ["&gtrdot;"] = "⋗",
    ["&Ll;"] = "⋘",
    ["&nLl;"] = "⋘̸",
    ["&Gg;"] = "⋙",
    ["&ggg;"] = "⋙",
    ["&nGg;"] = "⋙̸",
    ["&LessEqualGreater;"] = "⋚",
    ["&leg;"] = "⋚",
    ["&lesseqgtr;"] = "⋚",
    ["&lesg;"] = "⋚︀",
    ["&GreaterEqualLess;"] = "⋛",
    ["&gel;"] = "⋛",
    ["&gtreqless;"] = "⋛",
    ["&gesl;"] = "⋛︀",
    ["&cuepr;"] = "⋞",
    ["&curlyeqprec;"] = "⋞",
    ["&cuesc;"] = "⋟",
    ["&curlyeqsucc;"] = "⋟",
    ["&NotPrecedesSlantEqual;"] = "⋠",
    ["&nprcue;"] = "⋠",
    ["&NotSucceedsSlantEqual;"] = "⋡",
    ["&nsccue;"] = "⋡",
    ["&NotSquareSubsetEqual;"] = "⋢",
    ["&nsqsube;"] = "⋢",
    ["&NotSquareSupersetEqual;"] = "⋣",
    ["&nsqsupe;"] = "⋣",
    ["&lnsim;"] = "⋦",
    ["&gnsim;"] = "⋧",
    ["&precnsim;"] = "⋨",
    ["&prnsim;"] = "⋨",
    ["&scnsim;"] = "⋩",
    ["&succnsim;"] = "⋩",
    ["&NotLeftTriangle;"] = "⋪",
    ["&nltri;"] = "⋪",
    ["&ntriangleleft;"] = "⋪",
    ["&NotRightTriangle;"] = "⋫",
    ["&nrtri;"] = "⋫",
    ["&ntriangleright;"] = "⋫",
    ["&NotLeftTriangleEqual;"] = "⋬",
    ["&nltrie;"] = "⋬",
    ["&ntrianglelefteq;"] = "⋬",
    ["&NotRightTriangleEqual;"] = "⋭",
    ["&nrtrie;"] = "⋭",
    ["&ntrianglerighteq;"] = "⋭",
    ["&vellip;"] = "⋮",
    ["&ctdot;"] = "⋯",
    ["&utdot;"] = "⋰",
    ["&dtdot;"] = "⋱",
    ["&disin;"] = "⋲",
    ["&isinsv;"] = "⋳",
    ["&isins;"] = "⋴",
    ["&isindot;"] = "⋵",
    ["&notindot;"] = "⋵̸",
    ["&notinvc;"] = "⋶",
    ["&notinvb;"] = "⋷",
    ["&isinE;"] = "⋹",
    ["&notinE;"] = "⋹̸",
    ["&nisd;"] = "⋺",
    ["&xnis;"] = "⋻",
    ["&nis;"] = "⋼",
    ["&notnivc;"] = "⋽",
    ["&notnivb;"] = "⋾",
    ["&barwed;"] = "⌅",
    ["&barwedge;"] = "⌅",
    ["&Barwed;"] = "⌆",
    ["&doublebarwedge;"] = "⌆",
    ["&LeftCeiling;"] = "⌈",
    ["&lceil;"] = "⌈",
    ["&RightCeiling;"] = "⌉",
    ["&rceil;"] = "⌉",
    ["&LeftFloor;"] = "⌊",
    ["&lfloor;"] = "⌊",
    ["&RightFloor;"] = "⌋",
    ["&rfloor;"] = "⌋",
    ["&drcrop;"] = "⌌",
    ["&dlcrop;"] = "⌍",
    ["&urcrop;"] = "⌎",
    ["&ulcrop;"] = "⌏",
    ["&bnot;"] = "⌐",
    ["&profline;"] = "⌒",
    ["&profsurf;"] = "⌓",
    ["&telrec;"] = "⌕",
    ["&target;"] = "⌖",
    ["&ulcorn;"] = "⌜",
    ["&ulcorner;"] = "⌜",
    ["&urcorn;"] = "⌝",
    ["&urcorner;"] = "⌝",
    ["&dlcorn;"] = "⌞",
    ["&llcorner;"] = "⌞",
    ["&drcorn;"] = "⌟",
    ["&lrcorner;"] = "⌟",
    ["&frown;"] = "⌢",
    ["&sfrown;"] = "⌢",
    ["&smile;"] = "⌣",
    ["&ssmile;"] = "⌣",
    ["&cylcty;"] = "⌭",
    ["&profalar;"] = "⌮",
    ["&topbot;"] = "⌶",
    ["&ovbar;"] = "⌽",
    ["&solbar;"] = "⌿",
    ["&angzarr;"] = "⍼",
    ["&lmoust;"] = "⎰",
    ["&lmoustache;"] = "⎰",
    ["&rmoust;"] = "⎱",
    ["&rmoustache;"] = "⎱",
    ["&OverBracket;"] = "⎴",
    ["&tbrk;"] = "⎴",
    ["&UnderBracket;"] = "⎵",
    ["&bbrk;"] = "⎵",
    ["&bbrktbrk;"] = "⎶",
    ["&OverParenthesis;"] = "⏜",
    ["&UnderParenthesis;"] = "⏝",
    ["&OverBrace;"] = "⏞",
    ["&UnderBrace;"] = "⏟",
    ["&trpezium;"] = "⏢",
    ["&elinters;"] = "⏧",
    ["&blank;"] = "␣",
    ["&circledS;"] = "Ⓢ",
    ["&oS;"] = "Ⓢ",
    ["&HorizontalLine;"] = "─",
    ["&boxh;"] = "─",
    ["&boxv;"] = "│",
    ["&boxdr;"] = "┌",
    ["&boxdl;"] = "┐",
    ["&boxur;"] = "└",
    ["&boxul;"] = "┘",
    ["&boxvr;"] = "├",
    ["&boxvl;"] = "┤",
    ["&boxhd;"] = "┬",
    ["&boxhu;"] = "┴",
    ["&boxvh;"] = "┼",
    ["&boxH;"] = "═",
    ["&boxV;"] = "║",
    ["&boxdR;"] = "╒",
    ["&boxDr;"] = "╓",
    ["&boxDR;"] = "╔",
    ["&boxdL;"] = "╕",
    ["&boxDl;"] = "╖",
    ["&boxDL;"] = "╗",
    ["&boxuR;"] = "╘",
    ["&boxUr;"] = "╙",
    ["&boxUR;"] = "╚",
    ["&boxuL;"] = "╛",
    ["&boxUl;"] = "╜",
    ["&boxUL;"] = "╝",
    ["&boxvR;"] = "╞",
    ["&boxVr;"] = "╟",
    ["&boxVR;"] = "╠",
    ["&boxvL;"] = "╡",
    ["&boxVl;"] = "╢",
    ["&boxVL;"] = "╣",
    ["&boxHd;"] = "╤",
    ["&boxhD;"] = "╥",
    ["&boxHD;"] = "╦",
    ["&boxHu;"] = "╧",
    ["&boxhU;"] = "╨",
    ["&boxHU;"] = "╩",
    ["&boxvH;"] = "╪",
    ["&boxVh;"] = "╫",
    ["&boxVH;"] = "╬",
    ["&uhblk;"] = "▀",
    ["&lhblk;"] = "▄",
    ["&block;"] = "█",
    ["&blk14;"] = "░",
    ["&blk12;"] = "▒",
    ["&blk34;"] = "▓",
    ["&Square;"] = "□",
    ["&squ;"] = "□",
    ["&square;"] = "□",
    ["&FilledVerySmallSquare;"] = "▪",
    ["&blacksquare;"] = "▪",
    ["&squarf;"] = "▪",
    ["&squf;"] = "▪",
    ["&EmptyVerySmallSquare;"] = "▫",
    ["&rect;"] = "▭",
    ["&marker;"] = "▮",
    ["&fltns;"] = "▱",
    ["&bigtriangleup;"] = "△",
    ["&xutri;"] = "△",
    ["&blacktriangle;"] = "▴",
    ["&utrif;"] = "▴",
    ["&triangle;"] = "▵",
    ["&utri;"] = "▵",
    ["&blacktriangleright;"] = "▸",
    ["&rtrif;"] = "▸",
    ["&rtri;"] = "▹",
    ["&triangleright;"] = "▹",
    ["&bigtriangledown;"] = "▽",
    ["&xdtri;"] = "▽",
    ["&blacktriangledown;"] = "▾",
    ["&dtrif;"] = "▾",
    ["&dtri;"] = "▿",
    ["&triangledown;"] = "▿",
    ["&blacktriangleleft;"] = "◂",
    ["&ltrif;"] = "◂",
    ["&ltri;"] = "◃",
    ["&triangleleft;"] = "◃",
    ["&loz;"] = "◊",
    ["&lozenge;"] = "◊",
    ["&cir;"] = "○",
    ["&tridot;"] = "◬",
    ["&bigcirc;"] = "◯",
    ["&xcirc;"] = "◯",
    ["&ultri;"] = "◸",
    ["&urtri;"] = "◹",
    ["&lltri;"] = "◺",
    ["&EmptySmallSquare;"] = "◻",
    ["&FilledSmallSquare;"] = "◼",
    ["&bigstar;"] = "★",
    ["&starf;"] = "★",
    ["&star;"] = "☆",
    ["&phone;"] = "☎",
    ["&female;"] = "♀",
    ["&male;"] = "♂",
    ["&spades;"] = "♠",
    ["&spadesuit;"] = "♠",
    ["&clubs;"] = "♣",
    ["&clubsuit;"] = "♣",
    ["&hearts;"] = "♥",
    ["&heartsuit;"] = "♥",
    ["&diamondsuit;"] = "♦",
    ["&diams;"] = "♦",
    ["&sung;"] = "♪",
    ["&flat;"] = "♭",
    ["&natur;"] = "♮",
    ["&natural;"] = "♮",
    ["&sharp;"] = "♯",
    ["&check;"] = "✓",
    ["&checkmark;"] = "✓",
    ["&cross;"] = "✗",
    ["&malt;"] = "✠",
    ["&maltese;"] = "✠",
    ["&sext;"] = "✶",
    ["&VerticalSeparator;"] = "❘",
    ["&lbbrk;"] = "❲",
    ["&rbbrk;"] = "❳",
    ["&bsolhsub;"] = "⟈",
    ["&suphsol;"] = "⟉",
    ["&LeftDoubleBracket;"] = "⟦",
    ["&lobrk;"] = "⟦",
    ["&RightDoubleBracket;"] = "⟧",
    ["&robrk;"] = "⟧",
    ["&LeftAngleBracket;"] = "⟨",
    ["&lang;"] = "⟨",
    ["&langle;"] = "⟨",
    ["&RightAngleBracket;"] = "⟩",
    ["&rang;"] = "⟩",
    ["&rangle;"] = "⟩",
    ["&Lang;"] = "⟪",
    ["&Rang;"] = "⟫",
    ["&loang;"] = "⟬",
    ["&roang;"] = "⟭",
    ["&LongLeftArrow;"] = "⟵",
    ["&longleftarrow;"] = "⟵",
    ["&xlarr;"] = "⟵",
    ["&LongRightArrow;"] = "⟶",
    ["&longrightarrow;"] = "⟶",
    ["&xrarr;"] = "⟶",
    ["&LongLeftRightArrow;"] = "⟷",
    ["&longleftrightarrow;"] = "⟷",
    ["&xharr;"] = "⟷",
    ["&DoubleLongLeftArrow;"] = "⟸",
    ["&Longleftarrow;"] = "⟸",
    ["&xlArr;"] = "⟸",
    ["&DoubleLongRightArrow;"] = "⟹",
    ["&Longrightarrow;"] = "⟹",
    ["&xrArr;"] = "⟹",
    ["&DoubleLongLeftRightArrow;"] = "⟺",
    ["&Longleftrightarrow;"] = "⟺",
    ["&xhArr;"] = "⟺",
    ["&longmapsto;"] = "⟼",
    ["&xmap;"] = "⟼",
    ["&dzigrarr;"] = "⟿",
    ["&nvlArr;"] = "⤂",
    ["&nvrArr;"] = "⤃",
    ["&nvHarr;"] = "⤄",
    ["&Map;"] = "⤅",
    ["&lbarr;"] = "⤌",
    ["&bkarow;"] = "⤍",
    ["&rbarr;"] = "⤍",
    ["&lBarr;"] = "⤎",
    ["&dbkarow;"] = "⤏",
    ["&rBarr;"] = "⤏",
    ["&RBarr;"] = "⤐",
    ["&drbkarow;"] = "⤐",
    ["&DDotrahd;"] = "⤑",
    ["&UpArrowBar;"] = "⤒",
    ["&DownArrowBar;"] = "⤓",
    ["&Rarrtl;"] = "⤖",
    ["&latail;"] = "⤙",
    ["&ratail;"] = "⤚",
    ["&lAtail;"] = "⤛",
    ["&rAtail;"] = "⤜",
    ["&larrfs;"] = "⤝",
    ["&rarrfs;"] = "⤞",
    ["&larrbfs;"] = "⤟",
    ["&rarrbfs;"] = "⤠",
    ["&nwarhk;"] = "⤣",
    ["&nearhk;"] = "⤤",
    ["&hksearow;"] = "⤥",
    ["&searhk;"] = "⤥",
    ["&hkswarow;"] = "⤦",
    ["&swarhk;"] = "⤦",
    ["&nwnear;"] = "⤧",
    ["&nesear;"] = "⤨",
    ["&toea;"] = "⤨",
    ["&seswar;"] = "⤩",
    ["&tosa;"] = "⤩",
    ["&swnwar;"] = "⤪",
    ["&rarrc;"] = "⤳",
    ["&nrarrc;"] = "⤳̸",
    ["&cudarrr;"] = "⤵",
    ["&ldca;"] = "⤶",
    ["&rdca;"] = "⤷",
    ["&cudarrl;"] = "⤸",
    ["&larrpl;"] = "⤹",
    ["&curarrm;"] = "⤼",
    ["&cularrp;"] = "⤽",
    ["&rarrpl;"] = "⥅",
    ["&harrcir;"] = "⥈",
    ["&Uarrocir;"] = "⥉",
    ["&lurdshar;"] = "⥊",
    ["&ldrushar;"] = "⥋",
    ["&LeftRightVector;"] = "⥎",
    ["&RightUpDownVector;"] = "⥏",
    ["&DownLeftRightVector;"] = "⥐",
    ["&LeftUpDownVector;"] = "⥑",
    ["&LeftVectorBar;"] = "⥒",
    ["&RightVectorBar;"] = "⥓",
    ["&RightUpVectorBar;"] = "⥔",
    ["&RightDownVectorBar;"] = "⥕",
    ["&DownLeftVectorBar;"] = "⥖",
    ["&DownRightVectorBar;"] = "⥗",
    ["&LeftUpVectorBar;"] = "⥘",
    ["&LeftDownVectorBar;"] = "⥙",
    ["&LeftTeeVector;"] = "⥚",
    ["&RightTeeVector;"] = "⥛",
    ["&RightUpTeeVector;"] = "⥜",
    ["&RightDownTeeVector;"] = "⥝",
    ["&DownLeftTeeVector;"] = "⥞",
    ["&DownRightTeeVector;"] = "⥟",
    ["&LeftUpTeeVector;"] = "⥠",
    ["&LeftDownTeeVector;"] = "⥡",
    ["&lHar;"] = "⥢",
    ["&uHar;"] = "⥣",
    ["&rHar;"] = "⥤",
    ["&dHar;"] = "⥥",
    ["&luruhar;"] = "⥦",
    ["&ldrdhar;"] = "⥧",
    ["&ruluhar;"] = "⥨",
    ["&rdldhar;"] = "⥩",
    ["&lharul;"] = "⥪",
    ["&llhard;"] = "⥫",
    ["&rharul;"] = "⥬",
    ["&lrhard;"] = "⥭",
    ["&UpEquilibrium;"] = "⥮",
    ["&udhar;"] = "⥮",
    ["&ReverseUpEquilibrium;"] = "⥯",
    ["&duhar;"] = "⥯",
    ["&RoundImplies;"] = "⥰",
    ["&erarr;"] = "⥱",
    ["&simrarr;"] = "⥲",
    ["&larrsim;"] = "⥳",
    ["&rarrsim;"] = "⥴",
    ["&rarrap;"] = "⥵",
    ["&ltlarr;"] = "⥶",
    ["&gtrarr;"] = "⥸",
    ["&subrarr;"] = "⥹",
    ["&suplarr;"] = "⥻",
    ["&lfisht;"] = "⥼",
    ["&rfisht;"] = "⥽",
    ["&ufisht;"] = "⥾",
    ["&dfisht;"] = "⥿",
    ["&lopar;"] = "⦅",
    ["&ropar;"] = "⦆",
    ["&lbrke;"] = "⦋",
    ["&rbrke;"] = "⦌",
    ["&lbrkslu;"] = "⦍",
    ["&rbrksld;"] = "⦎",
    ["&lbrksld;"] = "⦏",
    ["&rbrkslu;"] = "⦐",
    ["&langd;"] = "⦑",
    ["&rangd;"] = "⦒",
    ["&lparlt;"] = "⦓",
    ["&rpargt;"] = "⦔",
    ["&gtlPar;"] = "⦕",
    ["&ltrPar;"] = "⦖",
    ["&vzigzag;"] = "⦚",
    ["&vangrt;"] = "⦜",
    ["&angrtvbd;"] = "⦝",
    ["&ange;"] = "⦤",
    ["&range;"] = "⦥",
    ["&dwangle;"] = "⦦",
    ["&uwangle;"] = "⦧",
    ["&angmsdaa;"] = "⦨",
    ["&angmsdab;"] = "⦩",
    ["&angmsdac;"] = "⦪",
    ["&angmsdad;"] = "⦫",
    ["&angmsdae;"] = "⦬",
    ["&angmsdaf;"] = "⦭",
    ["&angmsdag;"] = "⦮",
    ["&angmsdah;"] = "⦯",
    ["&bemptyv;"] = "⦰",
    ["&demptyv;"] = "⦱",
    ["&cemptyv;"] = "⦲",
    ["&raemptyv;"] = "⦳",
    ["&laemptyv;"] = "⦴",
    ["&ohbar;"] = "⦵",
    ["&omid;"] = "⦶",
    ["&opar;"] = "⦷",
    ["&operp;"] = "⦹",
    ["&olcross;"] = "⦻",
    ["&odsold;"] = "⦼",
    ["&olcir;"] = "⦾",
    ["&ofcir;"] = "⦿",
    ["&olt;"] = "⧀",
    ["&ogt;"] = "⧁",
    ["&cirscir;"] = "⧂",
    ["&cirE;"] = "⧃",
    ["&solb;"] = "⧄",
    ["&bsolb;"] = "⧅",
    ["&boxbox;"] = "⧉",
    ["&trisb;"] = "⧍",
    ["&rtriltri;"] = "⧎",
    ["&LeftTriangleBar;"] = "⧏",
    ["&NotLeftTriangleBar;"] = "⧏̸",
    ["&RightTriangleBar;"] = "⧐",
    ["&NotRightTriangleBar;"] = "⧐̸",
    ["&iinfin;"] = "⧜",
    ["&infintie;"] = "⧝",
    ["&nvinfin;"] = "⧞",
    ["&eparsl;"] = "⧣",
    ["&smeparsl;"] = "⧤",
    ["&eqvparsl;"] = "⧥",
    ["&blacklozenge;"] = "⧫",
    ["&lozf;"] = "⧫",
    ["&RuleDelayed;"] = "⧴",
    ["&dsol;"] = "⧶",
    ["&bigodot;"] = "⨀",
    ["&xodot;"] = "⨀",
    ["&bigoplus;"] = "⨁",
    ["&xoplus;"] = "⨁",
    ["&bigotimes;"] = "⨂",
    ["&xotime;"] = "⨂",
    ["&biguplus;"] = "⨄",
    ["&xuplus;"] = "⨄",
    ["&bigsqcup;"] = "⨆",
    ["&xsqcup;"] = "⨆",
    ["&iiiint;"] = "⨌",
    ["&qint;"] = "⨌",
    ["&fpartint;"] = "⨍",
    ["&cirfnint;"] = "⨐",
    ["&awint;"] = "⨑",
    ["&rppolint;"] = "⨒",
    ["&scpolint;"] = "⨓",
    ["&npolint;"] = "⨔",
    ["&pointint;"] = "⨕",
    ["&quatint;"] = "⨖",
    ["&intlarhk;"] = "⨗",
    ["&pluscir;"] = "⨢",
    ["&plusacir;"] = "⨣",
    ["&simplus;"] = "⨤",
    ["&plusdu;"] = "⨥",
    ["&plussim;"] = "⨦",
    ["&plustwo;"] = "⨧",
    ["&mcomma;"] = "⨩",
    ["&minusdu;"] = "⨪",
    ["&loplus;"] = "⨭",
    ["&roplus;"] = "⨮",
    ["&Cross;"] = "⨯",
    ["&timesd;"] = "⨰",
    ["&timesbar;"] = "⨱",
    ["&smashp;"] = "⨳",
    ["&lotimes;"] = "⨴",
    ["&rotimes;"] = "⨵",
    ["&otimesas;"] = "⨶",
    ["&Otimes;"] = "⨷",
    ["&odiv;"] = "⨸",
    ["&triplus;"] = "⨹",
    ["&triminus;"] = "⨺",
    ["&tritime;"] = "⨻",
    ["&intprod;"] = "⨼",
    ["&iprod;"] = "⨼",
    ["&amalg;"] = "⨿",
    ["&capdot;"] = "⩀",
    ["&ncup;"] = "⩂",
    ["&ncap;"] = "⩃",
    ["&capand;"] = "⩄",
    ["&cupor;"] = "⩅",
    ["&cupcap;"] = "⩆",
    ["&capcup;"] = "⩇",
    ["&cupbrcap;"] = "⩈",
    ["&capbrcup;"] = "⩉",
    ["&cupcup;"] = "⩊",
    ["&capcap;"] = "⩋",
    ["&ccups;"] = "⩌",
    ["&ccaps;"] = "⩍",
    ["&ccupssm;"] = "⩐",
    ["&And;"] = "⩓",
    ["&Or;"] = "⩔",
    ["&andand;"] = "⩕",
    ["&oror;"] = "⩖",
    ["&orslope;"] = "⩗",
    ["&andslope;"] = "⩘",
    ["&andv;"] = "⩚",
    ["&orv;"] = "⩛",
    ["&andd;"] = "⩜",
    ["&ord;"] = "⩝",
    ["&wedbar;"] = "⩟",
    ["&sdote;"] = "⩦",
    ["&simdot;"] = "⩪",
    ["&congdot;"] = "⩭",
    ["&ncongdot;"] = "⩭̸",
    ["&easter;"] = "⩮",
    ["&apacir;"] = "⩯",
    ["&apE;"] = "⩰",
    ["&napE;"] = "⩰̸",
    ["&eplus;"] = "⩱",
    ["&pluse;"] = "⩲",
    ["&Esim;"] = "⩳",
    ["&Colone;"] = "⩴",
    ["&Equal;"] = "⩵",
    ["&ddotseq;"] = "⩷",
    ["&eDDot;"] = "⩷",
    ["&equivDD;"] = "⩸",
    ["&ltcir;"] = "⩹",
    ["&gtcir;"] = "⩺",
    ["&ltquest;"] = "⩻",
    ["&gtquest;"] = "⩼",
    ["&LessSlantEqual;"] = "⩽",
    ["&leqslant;"] = "⩽",
    ["&les;"] = "⩽",
    ["&nleqslant;"] = "⩽̸",
    ["&nles;"] = "⩽̸",
    ["&NotLessSlantEqual;"] = "⩽̸",
    ["&GreaterSlantEqual;"] = "⩾",
    ["&geqslant;"] = "⩾",
    ["&ges;"] = "⩾",
    ["&ngeqslant;"] = "⩾̸",
    ["&nges;"] = "⩾̸",
    ["&NotGreaterSlantEqual;"] = "⩾̸",
    ["&lesdot;"] = "⩿",
    ["&gesdot;"] = "⪀",
    ["&lesdoto;"] = "⪁",
    ["&gesdoto;"] = "⪂",
    ["&lesdotor;"] = "⪃",
    ["&gesdotol;"] = "⪄",
    ["&lap;"] = "⪅",
    ["&lessapprox;"] = "⪅",
    ["&gap;"] = "⪆",
    ["&gtrapprox;"] = "⪆",
    ["&lne;"] = "⪇",
    ["&lneq;"] = "⪇",
    ["&gne;"] = "⪈",
    ["&gneq;"] = "⪈",
    ["&lnap;"] = "⪉",
    ["&lnapprox;"] = "⪉",
    ["&gnap;"] = "⪊",
    ["&gnapprox;"] = "⪊",
    ["&lEg;"] = "⪋",
    ["&lesseqqgtr;"] = "⪋",
    ["&gEl;"] = "⪌",
    ["&gtreqqless;"] = "⪌",
    ["&lsime;"] = "⪍",
    ["&gsime;"] = "⪎",
    ["&lsimg;"] = "⪏",
    ["&gsiml;"] = "⪐",
    ["&lgE;"] = "⪑",
    ["&glE;"] = "⪒",
    ["&lesges;"] = "⪓",
    ["&gesles;"] = "⪔",
    ["&els;"] = "⪕",
    ["&eqslantless;"] = "⪕",
    ["&egs;"] = "⪖",
    ["&eqslantgtr;"] = "⪖",
    ["&elsdot;"] = "⪗",
    ["&egsdot;"] = "⪘",
    ["&el;"] = "⪙",
    ["&eg;"] = "⪚",
    ["&siml;"] = "⪝",
    ["&simg;"] = "⪞",
    ["&simlE;"] = "⪟",
    ["&simgE;"] = "⪠",
    ["&LessLess;"] = "⪡",
    ["&NotNestedLessLess;"] = "⪡̸",
    ["&GreaterGreater;"] = "⪢",
    ["&NotNestedGreaterGreater;"] = "⪢̸",
    ["&glj;"] = "⪤",
    ["&gla;"] = "⪥",
    ["&ltcc;"] = "⪦",
    ["&gtcc;"] = "⪧",
    ["&lescc;"] = "⪨",
    ["&gescc;"] = "⪩",
    ["&smt;"] = "⪪",
    ["&lat;"] = "⪫",
    ["&smte;"] = "⪬",
    ["&smtes;"] = "⪬︀",
    ["&late;"] = "⪭",
    ["&lates;"] = "⪭︀",
    ["&bumpE;"] = "⪮",
    ["&PrecedesEqual;"] = "⪯",
    ["&pre;"] = "⪯",
    ["&preceq;"] = "⪯",
    ["&NotPrecedesEqual;"] = "⪯̸",
    ["&npre;"] = "⪯̸",
    ["&npreceq;"] = "⪯̸",
    ["&SucceedsEqual;"] = "⪰",
    ["&sce;"] = "⪰",
    ["&succeq;"] = "⪰",
    ["&NotSucceedsEqual;"] = "⪰̸",
    ["&nsce;"] = "⪰̸",
    ["&nsucceq;"] = "⪰̸",
    ["&prE;"] = "⪳",
    ["&scE;"] = "⪴",
    ["&precneqq;"] = "⪵",
    ["&prnE;"] = "⪵",
    ["&scnE;"] = "⪶",
    ["&succneqq;"] = "⪶",
    ["&prap;"] = "⪷",
    ["&precapprox;"] = "⪷",
    ["&scap;"] = "⪸",
    ["&succapprox;"] = "⪸",
    ["&precnapprox;"] = "⪹",
    ["&prnap;"] = "⪹",
    ["&scnap;"] = "⪺",
    ["&succnapprox;"] = "⪺",
    ["&Pr;"] = "⪻",
    ["&Sc;"] = "⪼",
    ["&subdot;"] = "⪽",
    ["&supdot;"] = "⪾",
    ["&subplus;"] = "⪿",
    ["&supplus;"] = "⫀",
    ["&submult;"] = "⫁",
    ["&supmult;"] = "⫂",
    ["&subedot;"] = "⫃",
    ["&supedot;"] = "⫄",
    ["&subE;"] = "⫅",
    ["&subseteqq;"] = "⫅",
    ["&nsubE;"] = "⫅̸",
    ["&nsubseteqq;"] = "⫅̸",
    ["&supE;"] = "⫆",
    ["&supseteqq;"] = "⫆",
    ["&nsupE;"] = "⫆̸",
    ["&nsupseteqq;"] = "⫆̸",
    ["&subsim;"] = "⫇",
    ["&supsim;"] = "⫈",
    ["&subnE;"] = "⫋",
    ["&subsetneqq;"] = "⫋",
    ["&varsubsetneqq;"] = "⫋︀",
    ["&vsubnE;"] = "⫋︀",
    ["&supnE;"] = "⫌",
    ["&supsetneqq;"] = "⫌",
    ["&varsupsetneqq;"] = "⫌︀",
    ["&vsupnE;"] = "⫌︀",
    ["&csub;"] = "⫏",
    ["&csup;"] = "⫐",
    ["&csube;"] = "⫑",
    ["&csupe;"] = "⫒",
    ["&subsup;"] = "⫓",
    ["&supsub;"] = "⫔",
    ["&subsub;"] = "⫕",
    ["&supsup;"] = "⫖",
    ["&suphsub;"] = "⫗",
    ["&supdsub;"] = "⫘",
    ["&forkv;"] = "⫙",
    ["&topfork;"] = "⫚",
    ["&mlcp;"] = "⫛",
    ["&Dashv;"] = "⫤",
    ["&DoubleLeftTee;"] = "⫤",
    ["&Vdashl;"] = "⫦",
    ["&Barv;"] = "⫧",
    ["&vBar;"] = "⫨",
    ["&vBarv;"] = "⫩",
    ["&Vbar;"] = "⫫",
    ["&Not;"] = "⫬",
    ["&bNot;"] = "⫭",
    ["&rnmid;"] = "⫮",
    ["&cirmid;"] = "⫯",
    ["&midcir;"] = "⫰",
    ["&topcir;"] = "⫱",
    ["&nhpar;"] = "⫲",
    ["&parsim;"] = "⫳",
    ["&parsl;"] = "⫽",
    ["&nparsl;"] = "⫽⃥",
    ["&fflig;"] = "ﬀ",
    ["&filig;"] = "ﬁ",
    ["&fllig;"] = "ﬂ",
    ["&ffilig;"] = "ﬃ",
    ["&ffllig;"] = "ﬄ",
    ["&Ascr;"] = "𝒜",
    ["&Cscr;"] = "𝒞",
    ["&Dscr;"] = "𝒟",
    ["&Gscr;"] = "𝒢",
    ["&Jscr;"] = "𝒥",
    ["&Kscr;"] = "𝒦",
    ["&Nscr;"] = "𝒩",
    ["&Oscr;"] = "𝒪",
    ["&Pscr;"] = "𝒫",
    ["&Qscr;"] = "𝒬",
    ["&Sscr;"] = "𝒮",
    ["&Tscr;"] = "𝒯",
    ["&Uscr;"] = "𝒰",
    ["&Vscr;"] = "𝒱",
    ["&Wscr;"] = "𝒲",
    ["&Xscr;"] = "𝒳",
    ["&Yscr;"] = "𝒴",
    ["&Zscr;"] = "𝒵",
    ["&ascr;"] = "𝒶",
    ["&bscr;"] = "𝒷",
    ["&cscr;"] = "𝒸",
    ["&dscr;"] = "𝒹",
    ["&fscr;"] = "𝒻",
    ["&hscr;"] = "𝒽",
    ["&iscr;"] = "𝒾",
    ["&jscr;"] = "𝒿",
    ["&kscr;"] = "𝓀",
    ["&lscr;"] = "𝓁",
    ["&mscr;"] = "𝓂",
    ["&nscr;"] = "𝓃",
    ["&pscr;"] = "𝓅",
    ["&qscr;"] = "𝓆",
    ["&rscr;"] = "𝓇",
    ["&sscr;"] = "𝓈",
    ["&tscr;"] = "𝓉",
    ["&uscr;"] = "𝓊",
    ["&vscr;"] = "𝓋",
    ["&wscr;"] = "𝓌",
    ["&xscr;"] = "𝓍",
    ["&yscr;"] = "𝓎",
    ["&zscr;"] = "𝓏",
    ["&Afr;"] = "𝔄",
    ["&Bfr;"] = "𝔅",
    ["&Dfr;"] = "𝔇",
    ["&Efr;"] = "𝔈",
    ["&Ffr;"] = "𝔉",
    ["&Gfr;"] = "𝔊",
    ["&Jfr;"] = "𝔍",
    ["&Kfr;"] = "𝔎",
    ["&Lfr;"] = "𝔏",
    ["&Mfr;"] = "𝔐",
    ["&Nfr;"] = "𝔑",
    ["&Ofr;"] = "𝔒",
    ["&Pfr;"] = "𝔓",
    ["&Qfr;"] = "𝔔",
    ["&Sfr;"] = "𝔖",
    ["&Tfr;"] = "𝔗",
    ["&Ufr;"] = "𝔘",
    ["&Vfr;"] = "𝔙",
    ["&Wfr;"] = "𝔚",
    ["&Xfr;"] = "𝔛",
    ["&Yfr;"] = "𝔜",
    ["&afr;"] = "𝔞",
    ["&bfr;"] = "𝔟",
    ["&cfr;"] = "𝔠",
    ["&dfr;"] = "𝔡",
    ["&efr;"] = "𝔢",
    ["&ffr;"] = "𝔣",
    ["&gfr;"] = "𝔤",
    ["&hfr;"] = "𝔥",
    ["&ifr;"] = "𝔦",
    ["&jfr;"] = "𝔧",
    ["&kfr;"] = "𝔨",
    ["&lfr;"] = "𝔩",
    ["&mfr;"] = "𝔪",
    ["&nfr;"] = "𝔫",
    ["&ofr;"] = "𝔬",
    ["&pfr;"] = "𝔭",
    ["&qfr;"] = "𝔮",
    ["&rfr;"] = "𝔯",
    ["&sfr;"] = "𝔰",
    ["&tfr;"] = "𝔱",
    ["&ufr;"] = "𝔲",
    ["&vfr;"] = "𝔳",
    ["&wfr;"] = "𝔴",
    ["&xfr;"] = "𝔵",
    ["&yfr;"] = "𝔶",
    ["&zfr;"] = "𝔷",
    ["&Aopf;"] = "𝔸",
    ["&Bopf;"] = "𝔹",
    ["&Dopf;"] = "𝔻",
    ["&Eopf;"] = "𝔼",
    ["&Fopf;"] = "𝔽",
    ["&Gopf;"] = "𝔾",
    ["&Iopf;"] = "𝕀",
    ["&Jopf;"] = "𝕁",
    ["&Kopf;"] = "𝕂",
    ["&Lopf;"] = "𝕃",
    ["&Mopf;"] = "𝕄",
    ["&Oopf;"] = "𝕆",
    ["&Sopf;"] = "𝕊",
    ["&Topf;"] = "𝕋",
    ["&Uopf;"] = "𝕌",
    ["&Vopf;"] = "𝕍",
    ["&Wopf;"] = "𝕎",
    ["&Xopf;"] = "𝕏",
    ["&Yopf;"] = "𝕐",
    ["&aopf;"] = "𝕒",
    ["&bopf;"] = "𝕓",
    ["&copf;"] = "𝕔",
    ["&dopf;"] = "𝕕",
    ["&eopf;"] = "𝕖",
    ["&fopf;"] = "𝕗",
    ["&gopf;"] = "𝕘",
    ["&hopf;"] = "𝕙",
    ["&iopf;"] = "𝕚",
    ["&jopf;"] = "𝕛",
    ["&kopf;"] = "𝕜",
    ["&lopf;"] = "𝕝",
    ["&mopf;"] = "𝕞",
    ["&nopf;"] = "𝕟",
    ["&oopf;"] = "𝕠",
    ["&popf;"] = "𝕡",
    ["&qopf;"] = "𝕢",
    ["&ropf;"] = "𝕣",
    ["&sopf;"] = "𝕤",
    ["&topf;"] = "𝕥",
    ["&uopf;"] = "𝕦",
    ["&vopf;"] = "𝕧",
    ["&wopf;"] = "𝕨",
    ["&xopf;"] = "𝕩",
    ["&yopf;"] = "𝕪",
    ["&zopf;"] = "𝕫",
    ["&#32;"] = " ",
    ["&#33;"] = "!",
    ["&#34;"] = '"',
    ["&#35;"] = "#",
    ["&#36;"] = "$",
    ["&#37;"] = "%%",
    ["&#38;"] = "&",
    ["&#39;"] = "'",
    ["&#40;"] = "(",
    ["&#41;"] = ")",
    ["&#42;"] = "*",
    ["&#43;"] = "+",
    ["&#44;"] = ",",
    ["&#45;"] = "-",
    ["&#46;"] = ".",
    ["&#47;"] = "/",
    ["&#160;"] = " ",
    ["&#338;"] = "Œ",
    ["&#339;"] = "œ",
    ["&#352;"] = "Š",
    ["&#353;"] = "š",
    ["&#376;"] = "Ÿ",
    ["&#402;"] = "ƒ",
    ["&#8211;"] = "–",
    ["&#8212;"] = "—",
    ["&#8216;"] = "‘",
    ["&#8217;"] = "’",
    ["&#8218;"] = "‚",
    ["&#8220;"] = "“",
    ["&#8221;"] = "”",
    ["&#8222;"] = "„",
    ["&#8224;"] = "†",
    ["&#8225;"] = "‡",
    ["&#8226;"] = "•",
    ["&#8230;"] = "…",
    ["&#8240;"] = "‰",
    ["&#8364;"] = "€",
    ["&#8482;"] = "™",
}

function htmlEntities.gethtmlEntities_table()
    return htmlEntities_table
end

-- TODO: do the same for numbers

function htmlEntities.replaceSomeMathSymbolsWithASCII()
    -- https://www.freeformatter.com/html-entities.html#math-symbols

    --[[
    htmlEntities_table["&forall;"] = ""  -- ∀
    htmlEntities_table["&part;"] = ""    -- ∂
    htmlEntities_table["&exist;"] = ""   -- ∃
    htmlEntities_table["&empty;"] = ""   -- ∅
    htmlEntities_table["&nabla;"] = ""   -- ∇
    htmlEntities_table["&isin;"] = ""    -- ∈
    htmlEntities_table["&notin;"] = ""   -- ∉
    htmlEntities_table["&ni;"] = ""      -- ∋
    htmlEntities_table["&prod;"] = ""    -- ∏
    htmlEntities_table["&sum;"] = ""     -- ∑
    ]]
    htmlEntities_table["&minus;"] = "-" -- −
    htmlEntities_table["&lowast;"] = "*" -- ∗
    --[[
    htmlEntities_table["&radic;"] = ""   -- √
    htmlEntities_table["&prop;"] = ""    -- ∝
    htmlEntities_table["&infin;"] = ""   -- ∞
    htmlEntities_table["&ang;"] = ""     -- ∠
    htmlEntities_table["&and;"] = ""     -- ∧
    htmlEntities_table["&or;"] = ""      -- ∨
    htmlEntities_table["&cap;"] = ""     -- ∩
    htmlEntities_table["&cup;"] = ""     -- ∪
    htmlEntities_table["&int;"] = ""     -- ∫
    htmlEntities_table["&there4;"] = ""  -- ∴
    ]]
    htmlEntities_table["&sim;"] = "~" -- ∼
    --[[
    htmlEntities_table["&cong;"] = ""    -- ≅
    htmlEntities_table["&asymp;"] = ""   -- ≈
    htmlEntities_table["&ne;"] = ""      -- ≠
    htmlEntities_table["&equiv;"] = ""   -- ≡
    ]]
    htmlEntities_table["&le;"] = "<=" -- ≤
    htmlEntities_table["&ge;"] = ">=" -- ≥
    --[[
    htmlEntities_table["&sub;"] = ""     -- ⊂
    htmlEntities_table["&sup;"] = ""     -- ⊃
    htmlEntities_table["&nsub;"] = ""    -- ⊄
    htmlEntities_table["&sube;"] = ""    -- ⊆
    htmlEntities_table["&supe;"] = ""    -- ⊇
    htmlEntities_table["&oplus;"] = ""   -- ⊕
    htmlEntities_table["&otimes;"] = ""  -- ⊗
    htmlEntities_table["&perp;"] = ""    -- ⊥
    ]]
    htmlEntities_table["&sdot;"] = "·" -- ⋅
end

function htmlEntities.replaceSomeGreekLettersWithASCII()
    -- https://www.freeformatter.com/html-entities.html#greek-letters

    htmlEntities_table["&Alpha;"] = "A" -- Α
    htmlEntities_table["&Beta;"] = "B" -- Β
    --[[
    htmlEntities_table["&Gamma;"] = ""    -- Γ
    htmlEntities_table["&Delta;"] = ""    -- Δ
    ]]
    htmlEntities_table["&Epsilon;"] = "E" -- Ε
    htmlEntities_table["&Zeta;"] = "Z" -- Ζ
    htmlEntities_table["&Eta;"] = "H" -- Η
    --htmlEntities_table["&Theta;"] = ""    -- Θ
    htmlEntities_table["&Iota;"] = "I" -- Ι
    htmlEntities_table["&Kappa;"] = "K" -- Κ
    --htmlEntities_table["&Lambda;"] = ""   -- Λ
    htmlEntities_table["&Mu;"] = "M" --Μ
    htmlEntities_table["&Nu;"] = "N" -- Ν
    --htmlEntities_table["&Xi;"] = ""       -- Ξ
    htmlEntities_table["&Omicron;"] = "O" -- Ο
    --htmlEntities_table["&Pi;"] = ""       -- Π
    htmlEntities_table["&Rho;"] = "P" -- Ρ
    --htmlEntities_table["&Sigma;"] = ""    -- Σ
    htmlEntities_table["&Tau;"] = "T" -- Τ
    htmlEntities_table["&Upsilon;"] = "Y" -- Υ
    --htmlEntities_table["&Phi;"] = ""      -- Φ
    htmlEntities_table["&Chi;"] = "X" -- Χ
    --[[
    htmlEntities_table["&Psi;"] = ""      -- Ψ
    htmlEntities_table["&Omega;"] = ""    -- Ω
    htmlEntities_table["&alpha;"] = ""    -- α
    ]]
    htmlEntities_table["&beta;"] = "ß" -- β
    htmlEntities_table["&gamma;"] = "Y" -- γ
    --[[
    htmlEntities_table["&delta;"] = ""    -- δ
    htmlEntities_table["&epsilon;"] = ""  -- ε
    htmlEntities_table["&zeta;"] = ""     -- ζ
    htmlEntities_table["&eta;"] = ""      -- η
    htmlEntities_table["&theta;"] = ""    -- θ
    htmlEntities_table["&iota;"] = ""     -- ι
    ]]
    htmlEntities_table["&kappa;"] = "k" -- κ
    --[[
    htmlEntities_table["&lambda;"] = ""   -- λ
    htmlEntities_table["&mu;"] = ""       -- μ
    ]]
    htmlEntities_table["&nu;"] = "v" -- ν
    --htmlEntities_table["&xi;"] = ""       -- ξ
    htmlEntities_table["&omicron;"] = "o" -- ο
    --htmlEntities_table["&pi;"] = ""       -- π
    htmlEntities_table["&rho;"] = "p" -- ρ
    --[[
    htmlEntities_table["&sigmaf;"] = ""   -- ς
    htmlEntities_table["&sigma;"] = ""    -- σ
    htmlEntities_table["&tau;"] = ""      -- τ
    ]]
    htmlEntities_table["&upsilon;"] = "u" -- υ
    --htmlEntities_table["&phi;"] = ""      -- φ
    htmlEntities_table["&chi;"] = "X" -- χ
    --[[
    htmlEntities_table["&psi;"] = ""      -- ψ
    htmlEntities_table["&omega;"] = ""    -- ω
    htmlEntities_table["&thetasym;"] = "" -- ϑ
    ]]
    htmlEntities_table["&upsih;"] = "Y" -- ϒ
    --htmlEntities_table["&piv;"] = ""      --ϖ
end

function htmlEntities.replaceSomeMiscellaneousHTMLEntitiesWithASCII()
    htmlEntities_table["&OElig;"] = "OE"
    htmlEntities_table["&oelig;"] = "oe"
    --htmlEntities_table["&Scaron;"] =
    --htmlEntities_table["&scaron;"] =
    --htmlEntities_table["&Yuml;"] =
    htmlEntities_table["&fnof;"] = "f"
    htmlEntities_table["&circ;"] = "^"
    htmlEntities_table["&tilde;"] = "~"
    --htmlEntities_table["&ensp;"] =
    --htmlEntities_table["&emsp;"] =
    --htmlEntities_table["&thinsp;"] =
    --htmlEntities_table["&zwnj;"] =
    --htmlEntities_table["&zwj;"] =
    --htmlEntities_table["&lrm;"] =
    --htmlEntities_table["&rlm;"] =
    htmlEntities_table["&ndash;"] = "-"
    htmlEntities_table["&mdash;"] = "-"
    htmlEntities_table["&lsquo;"] = "'"
    htmlEntities_table["&rsquo;"] = "'"
    htmlEntities_table["&sbquo;"] = ","
    htmlEntities_table["&ldquo;"] = '"'
    htmlEntities_table["&rdquo;"] = '"'
    htmlEntities_table["&bdquo;"] = '"'
    --htmlEntities_table["&dagger;"] =
    --htmlEntities_table["&Dagger;"] =
    --htmlEntities_table["&bull;"] =
    htmlEntities_table["&hellip;"] = "..."
    htmlEntities_table["&permil;"] = "%"
    htmlEntities_table["&prime;"] = "'"
    htmlEntities_table["&Prime;"] = '"'
    htmlEntities_table["&lsaquo;"] = "<"
    htmlEntities_table["&rsaquo;"] = ">"
    --htmlEntities_table["&oline;"] =
    htmlEntities_table["&euro;"] = "Euro"
    htmlEntities_table["&trade;"] = "TM"
    htmlEntities_table["&larr;"] = "<-"
    --htmlEntities_table["&uarr;"] =
    htmlEntities_table["&rarr;"] = "->"
    --htmlEntities_table["&darr;"] =
    htmlEntities_table["&harr;"] = "<->"
    --htmlEntities_table["&crarr;"] =
    --htmlEntities_table["&lceil;"] =
    --htmlEntities_table["&rceil;"] =
    --htmlEntities_table["&lfloor;"] =
    --htmlEntities_table["&rfloor;"] =
    --htmlEntities_table["&loz;"] =
    --htmlEntities_table["&spades;"] =
    --htmlEntities_table["&clubs;"] =
    htmlEntities_table["&hearts;"] = "<3"
    --htmlEntities_table["&diams;"] =
end

function htmlEntities.replaceSomeEntitiesWithASCII()
    htmlEntities.replaceSomeMathSymbolsWithASCII()
    htmlEntities.replaceSomeGreekLettersWithASCII()
    htmlEntities.replaceSomeMiscellaneousHTMLEntitiesWithASCII()
end

function htmlEntities.enableCCSupport()
    htmlEntities.replaceSomeEntitiesWithASCII()

    htmlEntities_table["&bull;"] = "\7" -- •
    htmlEntities_table["&bullet;"] = "\7" -- •
    htmlEntities_table["&oline;"] = "\175" -- ‾
    htmlEntities_table["&spades;"] = "\6" -- ♠
    htmlEntities_table["&clubs;"] = "\5" -- ♣
    htmlEntities_table["&hearts;"] = "\3" -- ♥
    htmlEntities_table["&diams;"] = "\4" -- ♦
    htmlEntities_table["&larr;"] = "\27" -- ←
    htmlEntities_table["&uarr;"] = "\24" -- ↑
    htmlEntities_table["&rarr;"] = "\26" -- →
    htmlEntities_table["&darr;"] = "\25" -- ↓
    htmlEntities_table["&harr;"] = "\29" -- ↔
end

function htmlEntities.filter(input, table)
    assert(input, "input value is nil")
    assert(table, "table value is nil")

    local output = input
    for s, v in pairs(table) do
        output = output:gsub(s, v)
    end
    return output
end

function htmlEntities.ASCII_HEX(input)
    assert(input, "input value is nil")

    if utf8 and utf8.char then
        return utf8.char(input)
    end

    input = math.abs(input)

    if input < 128 then
        return string.char(input)
    end

    --> FIX UTF8 for Lua 5.2 and 5.1 https://stackoverflow.com/a/26052539
    local bytemarkers = { { 0x7FF, 192 }, { 0xFFFF, 224 }, { 0x1FFFFF, 240 } }
    local charbytes = {}
    for bytes, vals in ipairs(bytemarkers) do
        if input <= vals[1] then
            for b = bytes + 1, 2, -1 do
                local mod = input % 64
                input = (input - mod) / 64
                charbytes[b] = string.char(128 + mod)
            end
            charbytes[1] = string.char(vals[2] + input)
            break
        end
    end

    return table.concat(charbytes)
end

function htmlEntities.ASCII_DEC(input)
    assert(input, "input value is nil")
    return htmlEntities.ASCII_HEX(tonumber(input, 16))
end

local function replaceStrings(input, replacements)
    local output = input
    for oldStr, newStr in pairs(replacements) do
        output = output:gsub(oldStr, newStr)
    end
    return output
end

--[[- Decode HTML entities
    @tparam string input The string to decode
    @tparam[opt=true] boolean decodeASCII Decode of entities in ASCII
    @treturn string decoded string
    @usage Example:

        local htmlEntities = require("htmlEntities")
        print(htmlEntities.decode("&amp;#67;&amp;#111;&amp;#109;&amp;#109;&amp;#97;&amp;#110;&amp;#100;&amp;#99;&amp;#114;&amp;#97;&amp;#99;&amp;#107;&amp;#101;&amp;#114;"))
]]
function htmlEntities.decode(input, decodeASCII)
    assert(input, "input value is nil")

    --local output = replace(input, htmlEntities_table)
    local output = input:gsub("&[%w#]-;", htmlEntities_table)
    -- FIXME: Handel htmlEntities without a ; at the end
    --local output = replaceStrings(input, htmlEntities_table)

    if decodeASCII ~= false then
        return (output:gsub("&#x([%w%d]+);", htmlEntities.ASCII_DEC):gsub("&#([%d]+);", htmlEntities.ASCII_HEX))
    end

    return output
end

local function encodeCharToEntity(char)
    local charbyte = char:byte()
    if #char == 1 then
        -- 32 = Space char
        if charbyte == 32 then
            return " "
        end
        return "&#" .. charbyte .. ";"
    end
    return char
end

--[[- Encode in HTML entities (in ASCII) NOTE: Emoji is not supported here!
    @tparam string input The string to encode
    @tparam[opt=true] boolean encodeASCII Decode of entities in ASCII
    @treturn string encoded string
    @usage Example:

        local htmlEntities = require("htmlEntities")
        print(htmlEntities.encode("Commandcracker"))
]]
function htmlEntities.encode(input, encodeASCII)
    assert(input, "input value is nil")

    input = htmlEntities.decode(input, encodeASCII)

    -- https://gist.github.com/CapsAdmin/848c322047b65e0a9da7e0e57f4dada4
    --input = replace(input, table_invert(htmlEntities_table))

    input = input:gsub("([%z\1-\127\194-\244][\128-\191]*)", encodeCharToEntity)

    return input
end

--- Replace special characters `&`, `<` and `>` to HTML-safe sequences.
-- If the optional flag quote is true (the default), the quotation mark
-- characters, both double quote (`"`) and single quote (`'`) characters are also
-- translated.
-- @tparam string str The input string to escape.
-- @tparam[opt=true] boolean quote Flag indicating whether to escape quotation mark characters.
-- @treturn string The escaped string.
function htmlEntities.escape(str, quote)
    str = str
        :gsub("&", "&amp;") -- Must be done first!
        :gsub("<", "&lt;")
        :gsub(">", "&gt;")
    if quote ~= false then
        return (str:gsub('"', "&quot;"):gsub("'", "&#x27;"))
    end
    return str
end

-- maps the HTML entity name to the Unicode code point
-- from https://html.spec.whatwg.org/multipage/named-characters.html
local name2codepoint = {
    ["AElig"] = 0x00c6, -- latin capital letter AE = latin capital ligature AE, U+00C6 ISOlat1
    ["Aacute"] = 0x00c1, -- latin capital letter A with acute, U+00C1 ISOlat1
    ["Acirc"] = 0x00c2, -- latin capital letter A with circumflex, U+00C2 ISOlat1
    ["Agrave"] = 0x00c0, -- latin capital letter A with grave = latin capital letter A grave, U+00C0 ISOlat1
    ["Alpha"] = 0x0391, -- greek capital letter alpha, U+0391
    ["Aring"] = 0x00c5, -- latin capital letter A with ring above = latin capital letter A ring, U+00C5 ISOlat1
    ["Atilde"] = 0x00c3, -- latin capital letter A with tilde, U+00C3 ISOlat1
    ["Auml"] = 0x00c4, -- latin capital letter A with diaeresis, U+00C4 ISOlat1
    ["Beta"] = 0x0392, -- greek capital letter beta, U+0392
    ["Ccedil"] = 0x00c7, -- latin capital letter C with cedilla, U+00C7 ISOlat1
    ["Chi"] = 0x03a7, -- greek capital letter chi, U+03A7
    ["Dagger"] = 0x2021, -- double dagger, U+2021 ISOpub
    ["Delta"] = 0x0394, -- greek capital letter delta, U+0394 ISOgrk3
    ["ETH"] = 0x00d0, -- latin capital letter ETH, U+00D0 ISOlat1
    ["Eacute"] = 0x00c9, -- latin capital letter E with acute, U+00C9 ISOlat1
    ["Ecirc"] = 0x00ca, -- latin capital letter E with circumflex, U+00CA ISOlat1
    ["Egrave"] = 0x00c8, -- latin capital letter E with grave, U+00C8 ISOlat1
    ["Epsilon"] = 0x0395, -- greek capital letter epsilon, U+0395
    ["Eta"] = 0x0397, -- greek capital letter eta, U+0397
    ["Euml"] = 0x00cb, -- latin capital letter E with diaeresis, U+00CB ISOlat1
    ["Gamma"] = 0x0393, -- greek capital letter gamma, U+0393 ISOgrk3
    ["Iacute"] = 0x00cd, -- latin capital letter I with acute, U+00CD ISOlat1
    ["Icirc"] = 0x00ce, -- latin capital letter I with circumflex, U+00CE ISOlat1
    ["Igrave"] = 0x00cc, -- latin capital letter I with grave, U+00CC ISOlat1
    ["Iota"] = 0x0399, -- greek capital letter iota, U+0399
    ["Iuml"] = 0x00cf, -- latin capital letter I with diaeresis, U+00CF ISOlat1
    ["Kappa"] = 0x039a, -- greek capital letter kappa, U+039A
    ["Lambda"] = 0x039b, -- greek capital letter lambda, U+039B ISOgrk3
    ["Mu"] = 0x039c, -- greek capital letter mu, U+039C
    ["Ntilde"] = 0x00d1, -- latin capital letter N with tilde, U+00D1 ISOlat1
    ["Nu"] = 0x039d, -- greek capital letter nu, U+039D
    ["OElig"] = 0x0152, -- latin capital ligature OE, U+0152 ISOlat2
    ["Oacute"] = 0x00d3, -- latin capital letter O with acute, U+00D3 ISOlat1
    ["Ocirc"] = 0x00d4, -- latin capital letter O with circumflex, U+00D4 ISOlat1
    ["Ograve"] = 0x00d2, -- latin capital letter O with grave, U+00D2 ISOlat1
    ["Omega"] = 0x03a9, -- greek capital letter omega, U+03A9 ISOgrk3
    ["Omicron"] = 0x039f, -- greek capital letter omicron, U+039F
    ["Oslash"] = 0x00d8, -- latin capital letter O with stroke = latin capital letter O slash, U+00D8 ISOlat1
    ["Otilde"] = 0x00d5, -- latin capital letter O with tilde, U+00D5 ISOlat1
    ["Ouml"] = 0x00d6, -- latin capital letter O with diaeresis, U+00D6 ISOlat1
    ["Phi"] = 0x03a6, -- greek capital letter phi, U+03A6 ISOgrk3
    ["Pi"] = 0x03a0, -- greek capital letter pi, U+03A0 ISOgrk3
    ["Prime"] = 0x2033, -- double prime = seconds = inches, U+2033 ISOtech
    ["Psi"] = 0x03a8, -- greek capital letter psi, U+03A8 ISOgrk3
    ["Rho"] = 0x03a1, -- greek capital letter rho, U+03A1
    ["Scaron"] = 0x0160, -- latin capital letter S with caron, U+0160 ISOlat2
    ["Sigma"] = 0x03a3, -- greek capital letter sigma, U+03A3 ISOgrk3
    ["THORN"] = 0x00de, -- latin capital letter THORN, U+00DE ISOlat1
    ["Tau"] = 0x03a4, -- greek capital letter tau, U+03A4
    ["Theta"] = 0x0398, -- greek capital letter theta, U+0398 ISOgrk3
    ["Uacute"] = 0x00da, -- latin capital letter U with acute, U+00DA ISOlat1
    ["Ucirc"] = 0x00db, -- latin capital letter U with circumflex, U+00DB ISOlat1
    ["Ugrave"] = 0x00d9, -- latin capital letter U with grave, U+00D9 ISOlat1
    ["Upsilon"] = 0x03a5, -- greek capital letter upsilon, U+03A5 ISOgrk3
    ["Uuml"] = 0x00dc, -- latin capital letter U with diaeresis, U+00DC ISOlat1
    ["Xi"] = 0x039e, -- greek capital letter xi, U+039E ISOgrk3
    ["Yacute"] = 0x00dd, -- latin capital letter Y with acute, U+00DD ISOlat1
    ["Yuml"] = 0x0178, -- latin capital letter Y with diaeresis, U+0178 ISOlat2
    ["Zeta"] = 0x0396, -- greek capital letter zeta, U+0396
    ["aacute"] = 0x00e1, -- latin small letter a with acute, U+00E1 ISOlat1
    ["acirc"] = 0x00e2, -- latin small letter a with circumflex, U+00E2 ISOlat1
    ["acute"] = 0x00b4, -- acute accent = spacing acute, U+00B4 ISOdia
    ["aelig"] = 0x00e6, -- latin small letter ae = latin small ligature ae, U+00E6 ISOlat1
    ["agrave"] = 0x00e0, -- latin small letter a with grave = latin small letter a grave, U+00E0 ISOlat1
    ["alefsym"] = 0x2135, -- alef symbol = first transfinite cardinal, U+2135 NEW
    ["alpha"] = 0x03b1, -- greek small letter alpha, U+03B1 ISOgrk3
    ["amp"] = 0x0026, -- ampersand, U+0026 ISOnum
    ["and"] = 0x2227, -- logical and = wedge, U+2227 ISOtech
    ["ang"] = 0x2220, -- angle, U+2220 ISOamso
    ["aring"] = 0x00e5, -- latin small letter a with ring above = latin small letter a ring, U+00E5 ISOlat1
    ["asymp"] = 0x2248, -- almost equal to = asymptotic to, U+2248 ISOamsr
    ["atilde"] = 0x00e3, -- latin small letter a with tilde, U+00E3 ISOlat1
    ["auml"] = 0x00e4, -- latin small letter a with diaeresis, U+00E4 ISOlat1
    ["bdquo"] = 0x201e, -- double low-9 quotation mark, U+201E NEW
    ["beta"] = 0x03b2, -- greek small letter beta, U+03B2 ISOgrk3
    ["brvbar"] = 0x00a6, -- broken bar = broken vertical bar, U+00A6 ISOnum
    ["bull"] = 0x2022, -- bullet = black small circle, U+2022 ISOpub
    ["cap"] = 0x2229, -- intersection = cap, U+2229 ISOtech
    ["ccedil"] = 0x00e7, -- latin small letter c with cedilla, U+00E7 ISOlat1
    ["cedil"] = 0x00b8, -- cedilla = spacing cedilla, U+00B8 ISOdia
    ["cent"] = 0x00a2, -- cent sign, U+00A2 ISOnum
    ["chi"] = 0x03c7, -- greek small letter chi, U+03C7 ISOgrk3
    ["circ"] = 0x02c6, -- modifier letter circumflex accent, U+02C6 ISOpub
    ["clubs"] = 0x2663, -- black club suit = shamrock, U+2663 ISOpub
    ["cong"] = 0x2245, -- approximately equal to, U+2245 ISOtech
    ["copy"] = 0x00a9, -- copyright sign, U+00A9 ISOnum
    ["crarr"] = 0x21b5, -- downwards arrow with corner leftwards = carriage return, U+21B5 NEW
    ["cup"] = 0x222a, -- union = cup, U+222A ISOtech
    ["curren"] = 0x00a4, -- currency sign, U+00A4 ISOnum
    ["dArr"] = 0x21d3, -- downwards double arrow, U+21D3 ISOamsa
    ["dagger"] = 0x2020, -- dagger, U+2020 ISOpub
    ["darr"] = 0x2193, -- downwards arrow, U+2193 ISOnum
    ["deg"] = 0x00b0, -- degree sign, U+00B0 ISOnum
    ["delta"] = 0x03b4, -- greek small letter delta, U+03B4 ISOgrk3
    ["diams"] = 0x2666, -- black diamond suit, U+2666 ISOpub
    ["divide"] = 0x00f7, -- division sign, U+00F7 ISOnum
    ["eacute"] = 0x00e9, -- latin small letter e with acute, U+00E9 ISOlat1
    ["ecirc"] = 0x00ea, -- latin small letter e with circumflex, U+00EA ISOlat1
    ["egrave"] = 0x00e8, -- latin small letter e with grave, U+00E8 ISOlat1
    ["empty"] = 0x2205, -- empty set = null set = diameter, U+2205 ISOamso
    ["emsp"] = 0x2003, -- em space, U+2003 ISOpub
    ["ensp"] = 0x2002, -- en space, U+2002 ISOpub
    ["epsilon"] = 0x03b5, -- greek small letter epsilon, U+03B5 ISOgrk3
    ["equiv"] = 0x2261, -- identical to, U+2261 ISOtech
    ["eta"] = 0x03b7, -- greek small letter eta, U+03B7 ISOgrk3
    ["eth"] = 0x00f0, -- latin small letter eth, U+00F0 ISOlat1
    ["euml"] = 0x00eb, -- latin small letter e with diaeresis, U+00EB ISOlat1
    ["euro"] = 0x20ac, -- euro sign, U+20AC NEW
    ["exist"] = 0x2203, -- there exists, U+2203 ISOtech
    ["fnof"] = 0x0192, -- latin small f with hook = function = florin, U+0192 ISOtech
    ["forall"] = 0x2200, -- for all, U+2200 ISOtech
    ["frac12"] = 0x00bd, -- vulgar fraction one half = fraction one half, U+00BD ISOnum
    ["frac14"] = 0x00bc, -- vulgar fraction one quarter = fraction one quarter, U+00BC ISOnum
    ["frac34"] = 0x00be, -- vulgar fraction three quarters = fraction three quarters, U+00BE ISOnum
    ["frasl"] = 0x2044, -- fraction slash, U+2044 NEW
    ["gamma"] = 0x03b3, -- greek small letter gamma, U+03B3 ISOgrk3
    ["ge"] = 0x2265, -- greater-than or equal to, U+2265 ISOtech
    ["gt"] = 0x003e, -- greater-than sign, U+003E ISOnum
    ["hArr"] = 0x21d4, -- left right double arrow, U+21D4 ISOamsa
    ["harr"] = 0x2194, -- left right arrow, U+2194 ISOamsa
    ["hearts"] = 0x2665, -- black heart suit = valentine, U+2665 ISOpub
    ["hellip"] = 0x2026, -- horizontal ellipsis = three dot leader, U+2026 ISOpub
    ["iacute"] = 0x00ed, -- latin small letter i with acute, U+00ED ISOlat1
    ["icirc"] = 0x00ee, -- latin small letter i with circumflex, U+00EE ISOlat1
    ["iexcl"] = 0x00a1, -- inverted exclamation mark, U+00A1 ISOnum
    ["igrave"] = 0x00ec, -- latin small letter i with grave, U+00EC ISOlat1
    ["image"] = 0x2111, -- blackletter capital I = imaginary part, U+2111 ISOamso
    ["infin"] = 0x221e, -- infinity, U+221E ISOtech
    ["int"] = 0x222b, -- integral, U+222B ISOtech
    ["iota"] = 0x03b9, -- greek small letter iota, U+03B9 ISOgrk3
    ["iquest"] = 0x00bf, -- inverted question mark = turned question mark, U+00BF ISOnum
    ["isin"] = 0x2208, -- element of, U+2208 ISOtech
    ["iuml"] = 0x00ef, -- latin small letter i with diaeresis, U+00EF ISOlat1
    ["kappa"] = 0x03ba, -- greek small letter kappa, U+03BA ISOgrk3
    ["lArr"] = 0x21d0, -- leftwards double arrow, U+21D0 ISOtech
    ["lambda"] = 0x03bb, -- greek small letter lambda, U+03BB ISOgrk3
    ["lang"] = 0x2329, -- left-pointing angle bracket = bra, U+2329 ISOtech
    ["laquo"] = 0x00ab, -- left-pointing double angle quotation mark = left pointing guillemet, U+00AB ISOnum
    ["larr"] = 0x2190, -- leftwards arrow, U+2190 ISOnum
    ["lceil"] = 0x2308, -- left ceiling = apl upstile, U+2308 ISOamsc
    ["ldquo"] = 0x201c, -- left double quotation mark, U+201C ISOnum
    ["le"] = 0x2264, -- less-than or equal to, U+2264 ISOtech
    ["lfloor"] = 0x230a, -- left floor = apl downstile, U+230A ISOamsc
    ["lowast"] = 0x2217, -- asterisk operator, U+2217 ISOtech
    ["loz"] = 0x25ca, -- lozenge, U+25CA ISOpub
    ["lrm"] = 0x200e, -- left-to-right mark, U+200E NEW RFC 2070
    ["lsaquo"] = 0x2039, -- single left-pointing angle quotation mark, U+2039 ISO proposed
    ["lsquo"] = 0x2018, -- left single quotation mark, U+2018 ISOnum
    ["lt"] = 0x003c, -- less-than sign, U+003C ISOnum
    ["macr"] = 0x00af, -- macron = spacing macron = overline = APL overbar, U+00AF ISOdia
    ["mdash"] = 0x2014, -- em dash, U+2014 ISOpub
    ["micro"] = 0x00b5, -- micro sign, U+00B5 ISOnum
    ["middot"] = 0x00b7, -- middle dot = Georgian comma = Greek middle dot, U+00B7 ISOnum
    ["minus"] = 0x2212, -- minus sign, U+2212 ISOtech
    ["mu"] = 0x03bc, -- greek small letter mu, U+03BC ISOgrk3
    ["nabla"] = 0x2207, -- nabla = backward difference, U+2207 ISOtech
    ["nbsp"] = 0x00a0, -- no-break space = non-breaking space, U+00A0 ISOnum
    ["ndash"] = 0x2013, -- en dash, U+2013 ISOpub
    ["ne"] = 0x2260, -- not equal to, U+2260 ISOtech
    ["ni"] = 0x220b, -- contains as member, U+220B ISOtech
    ["not"] = 0x00ac, -- not sign, U+00AC ISOnum
    ["notin"] = 0x2209, -- not an element of, U+2209 ISOtech
    ["nsub"] = 0x2284, -- not a subset of, U+2284 ISOamsn
    ["ntilde"] = 0x00f1, -- latin small letter n with tilde, U+00F1 ISOlat1
    ["nu"] = 0x03bd, -- greek small letter nu, U+03BD ISOgrk3
    ["oacute"] = 0x00f3, -- latin small letter o with acute, U+00F3 ISOlat1
    ["ocirc"] = 0x00f4, -- latin small letter o with circumflex, U+00F4 ISOlat1
    ["oelig"] = 0x0153, -- latin small ligature oe, U+0153 ISOlat2
    ["ograve"] = 0x00f2, -- latin small letter o with grave, U+00F2 ISOlat1
    ["oline"] = 0x203e, -- overline = spacing overscore, U+203E NEW
    ["omega"] = 0x03c9, -- greek small letter omega, U+03C9 ISOgrk3
    ["omicron"] = 0x03bf, -- greek small letter omicron, U+03BF NEW
    ["oplus"] = 0x2295, -- circled plus = direct sum, U+2295 ISOamsb
    ["or"] = 0x2228, -- logical or = vee, U+2228 ISOtech
    ["ordf"] = 0x00aa, -- feminine ordinal indicator, U+00AA ISOnum
    ["ordm"] = 0x00ba, -- masculine ordinal indicator, U+00BA ISOnum
    ["oslash"] = 0x00f8, -- latin small letter o with stroke, = latin small letter o slash, U+00F8 ISOlat1
    ["otilde"] = 0x00f5, -- latin small letter o with tilde, U+00F5 ISOlat1
    ["otimes"] = 0x2297, -- circled times = vector product, U+2297 ISOamsb
    ["ouml"] = 0x00f6, -- latin small letter o with diaeresis, U+00F6 ISOlat1
    ["para"] = 0x00b6, -- pilcrow sign = paragraph sign, U+00B6 ISOnum
    ["part"] = 0x2202, -- partial differential, U+2202 ISOtech
    ["permil"] = 0x2030, -- per mille sign, U+2030 ISOtech
    ["perp"] = 0x22a5, -- up tack = orthogonal to = perpendicular, U+22A5 ISOtech
    ["phi"] = 0x03c6, -- greek small letter phi, U+03C6 ISOgrk3
    ["pi"] = 0x03c0, -- greek small letter pi, U+03C0 ISOgrk3
    ["piv"] = 0x03d6, -- greek pi symbol, U+03D6 ISOgrk3
    ["plusmn"] = 0x00b1, -- plus-minus sign = plus-or-minus sign, U+00B1 ISOnum
    ["pound"] = 0x00a3, -- pound sign, U+00A3 ISOnum
    ["prime"] = 0x2032, -- prime = minutes = feet, U+2032 ISOtech
    ["prod"] = 0x220f, -- n-ary product = product sign, U+220F ISOamsb
    ["prop"] = 0x221d, -- proportional to, U+221D ISOtech
    ["psi"] = 0x03c8, -- greek small letter psi, U+03C8 ISOgrk3
    ["quot"] = 0x0022, -- quotation mark = APL quote, U+0022 ISOnum
    ["rArr"] = 0x21d2, -- rightwards double arrow, U+21D2 ISOtech
    ["radic"] = 0x221a, -- square root = radical sign, U+221A ISOtech
    ["rang"] = 0x232a, -- right-pointing angle bracket = ket, U+232A ISOtech
    ["raquo"] = 0x00bb, -- right-pointing double angle quotation mark = right pointing guillemet, U+00BB ISOnum
    ["rarr"] = 0x2192, -- rightwards arrow, U+2192 ISOnum
    ["rceil"] = 0x2309, -- right ceiling, U+2309 ISOamsc
    ["rdquo"] = 0x201d, -- right double quotation mark, U+201D ISOnum
    ["real"] = 0x211c, -- blackletter capital R = real part symbol, U+211C ISOamso
    ["reg"] = 0x00ae, -- registered sign = registered trade mark sign, U+00AE ISOnum
    ["rfloor"] = 0x230b, -- right floor, U+230B ISOamsc
    ["rho"] = 0x03c1, -- greek small letter rho, U+03C1 ISOgrk3
    ["rlm"] = 0x200f, -- right-to-left mark, U+200F NEW RFC 2070
    ["rsaquo"] = 0x203a, -- single right-pointing angle quotation mark, U+203A ISO proposed
    ["rsquo"] = 0x2019, -- right single quotation mark, U+2019 ISOnum
    ["sbquo"] = 0x201a, -- single low-9 quotation mark, U+201A NEW
    ["scaron"] = 0x0161, -- latin small letter s with caron, U+0161 ISOlat2
    ["sdot"] = 0x22c5, -- dot operator, U+22C5 ISOamsb
    ["sect"] = 0x00a7, -- section sign, U+00A7 ISOnum
    ["shy"] = 0x00ad, -- soft hyphen = discretionary hyphen, U+00AD ISOnum
    ["sigma"] = 0x03c3, -- greek small letter sigma, U+03C3 ISOgrk3
    ["sigmaf"] = 0x03c2, -- greek small letter final sigma, U+03C2 ISOgrk3
    ["sim"] = 0x223c, -- tilde operator = varies with = similar to, U+223C ISOtech
    ["spades"] = 0x2660, -- black spade suit, U+2660 ISOpub
    ["sub"] = 0x2282, -- subset of, U+2282 ISOtech
    ["sube"] = 0x2286, -- subset of or equal to, U+2286 ISOtech
    ["sum"] = 0x2211, -- n-ary summation, U+2211 ISOamsb
    ["sup"] = 0x2283, -- superset of, U+2283 ISOtech
    ["sup1"] = 0x00b9, -- superscript one = superscript digit one, U+00B9 ISOnum
    ["sup2"] = 0x00b2, -- superscript two = superscript digit two = squared, U+00B2 ISOnum
    ["sup3"] = 0x00b3, -- superscript three = superscript digit three = cubed, U+00B3 ISOnum
    ["supe"] = 0x2287, -- superset of or equal to, U+2287 ISOtech
    ["szlig"] = 0x00df, -- latin small letter sharp s = ess-zed, U+00DF ISOlat1
    ["tau"] = 0x03c4, -- greek small letter tau, U+03C4 ISOgrk3
    ["there4"] = 0x2234, -- therefore, U+2234 ISOtech
    ["theta"] = 0x03b8, -- greek small letter theta, U+03B8 ISOgrk3
    ["thetasym"] = 0x03d1, -- greek small letter theta symbol, U+03D1 NEW
    ["thinsp"] = 0x2009, -- thin space, U+2009 ISOpub
    ["thorn"] = 0x00fe, -- latin small letter thorn with, U+00FE ISOlat1
    ["tilde"] = 0x02dc, -- small tilde, U+02DC ISOdia
    ["times"] = 0x00d7, -- multiplication sign, U+00D7 ISOnum
    ["trade"] = 0x2122, -- trade mark sign, U+2122 ISOnum
    ["uArr"] = 0x21d1, -- upwards double arrow, U+21D1 ISOamsa
    ["uacute"] = 0x00fa, -- latin small letter u with acute, U+00FA ISOlat1
    ["uarr"] = 0x2191, -- upwards arrow, U+2191 ISOnum
    ["ucirc"] = 0x00fb, -- latin small letter u with circumflex, U+00FB ISOlat1
    ["ugrave"] = 0x00f9, -- latin small letter u with grave, U+00F9 ISOlat1
    ["uml"] = 0x00a8, -- diaeresis = spacing diaeresis, U+00A8 ISOdia
    ["upsih"] = 0x03d2, -- greek upsilon with hook symbol, U+03D2 NEW
    ["upsilon"] = 0x03c5, -- greek small letter upsilon, U+03C5 ISOgrk3
    ["uuml"] = 0x00fc, -- latin small letter u with diaeresis, U+00FC ISOlat1
    ["weierp"] = 0x2118, -- script capital P = power set = Weierstrass p, U+2118 ISOamso
    ["xi"] = 0x03be, -- greek small letter xi, U+03BE ISOgrk3
    ["yacute"] = 0x00fd, -- latin small letter y with acute, U+00FD ISOlat1
    ["yen"] = 0x00a5, -- yen sign = yuan sign, U+00A5 ISOnum
    ["yuml"] = 0x00ff, -- latin small letter y with diaeresis, U+00FF ISOlat1
    ["zeta"] = 0x03b6, -- greek small letter zeta, U+03B6 ISOgrk3
    ["zwj"] = 0x200d, -- zero width joiner, U+200D NEW RFC 2070
    ["zwnj"] = 0x200c, -- zero width non-joiner, U+200C NEW RFC 2070
}

-- maps the HTML5 named character references to the equivalent Unicode character(s)
local html5 = {}

for k, v in pairs(htmlEntities_table) do
    html5[k:sub(2)] = v
end

-- see https://html.spec.whatwg.org/multipage/parsing.html#numeric-character-reference-end-state
local _invalid_charrefs = {
    [0x00] = "�", -- REPLACEMENT CHARACTER
    [0x0d] = "\r", -- CARRIAGE RETURN
    [0x80] = "€", -- EURO SIGN
    [0x81] = "ü", -- <control> \x81
    [0x82] = "‚", -- SINGLE LOW-9 QUOTATION MARK
    [0x83] = "ƒ", -- LATIN SMALL LETTER F WITH HOOK
    [0x84] = "„", -- DOUBLE LOW-9 QUOTATION MARK
    [0x85] = "…", -- HORIZONTAL ELLIPSIS
    [0x86] = "†", -- DAGGER
    [0x87] = "‡", -- DOUBLE DAGGER
    [0x88] = "ˆ", -- MODIFIER LETTER CIRCUMFLEX ACCENT
    [0x89] = "‰", -- PER MILLE SIGN
    [0x8a] = "Š", -- LATIN CAPITAL LETTER S WITH CARON
    [0x8b] = "‹", -- SINGLE LEFT-POINTING ANGLE QUOTATION MARK
    [0x8c] = "Œ", -- LATIN CAPITAL LIGATURE OE
    [0x8d] = "ì", -- <control> \x8d
    [0x8e] = "Ž", -- LATIN CAPITAL LETTER Z WITH CARON
    [0x8f] = "Å", -- <control> \x8f
    [0x90] = "É", -- <control> \x90
    [0x91] = "‘", -- LEFT SINGLE QUOTATION MARK
    [0x92] = "’", -- RIGHT SINGLE QUOTATION MARK
    [0x93] = "“", -- LEFT DOUBLE QUOTATION MARK
    [0x94] = "”", -- RIGHT DOUBLE QUOTATION MARK
    [0x95] = "•", -- BULLET
    [0x96] = "–", -- EN DASH
    [0x97] = "—", -- EM DASH
    [0x98] = "˜", -- SMALL TILDE
    [0x99] = "™", -- TRADE MARK SIGN
    [0x9a] = "š", -- LATIN SMALL LETTER S WITH CARON
    [0x9b] = "›", -- SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
    [0x9c] = "œ", -- LATIN SMALL LIGATURE OE
    [0x9d] = "Ø", -- <control> \x9d
    [0x9e] = "ž", -- LATIN SMALL LETTER Z WITH CARON
    [0x9f] = "Ÿ", -- LATIN CAPITAL LETTER Y WITH DIAERESIS
}

local invalid_codepoints = {
    -- 0x0001 to 0x0008
    [0x0001] = true,
    [0x0002] = true,
    [0x0003] = true,
    [0x0004] = true,
    [0x0005] = true,
    [0x0006] = true,
    [0x0007] = true,
    [0x0008] = true,
    -- 0x000E to 0x001F
    [0x000E] = true,
    [0x000F] = true,
    [0x0010] = true,
    [0x0011] = true,
    [0x0012] = true,
    [0x0013] = true,
    [0x0014] = true,
    [0x0015] = true,
    [0x0016] = true,
    [0x0017] = true,
    [0x0018] = true,
    [0x0019] = true,
    [0x001A] = true,
    [0x001B] = true,
    [0x001C] = true,
    [0x001D] = true,
    [0x001E] = true,
    [0x001F] = true,
    -- 0x007F to 0x009F
    [0x007F] = true,
    [0x0080] = true,
    [0x0081] = true,
    [0x0082] = true,
    [0x0083] = true,
    [0x0084] = true,
    [0x0085] = true,
    [0x0086] = true,
    [0x0087] = true,
    [0x0088] = true,
    [0x0089] = true,
    [0x008A] = true,
    [0x008B] = true,
    [0x008C] = true,
    [0x008D] = true,
    [0x008E] = true,
    [0x008F] = true,
    [0x0090] = true,
    [0x0091] = true,
    [0x0092] = true,
    [0x0093] = true,
    [0x0094] = true,
    [0x0095] = true,
    [0x0096] = true,
    [0x0097] = true,
    [0x0098] = true,
    [0x0099] = true,
    [0x009A] = true,
    [0x009B] = true,
    [0x009C] = true,
    [0x009D] = true,
    [0x009E] = true,
    [0x009F] = true,
    [0xFDDE] = true,
    [0xFDDF] = true,
    [0xFDE0] = true,
    [0xFDE1] = true,
    [0xFDE2] = true,
    [0xFDE3] = true,
    [0xFDE4] = true,
    [0xFDE5] = true,
    [0xFDE6] = true,
    [0xFDE7] = true,
    [0xFDE8] = true,
    [0xFDE9] = true,
    [0xFDEA] = true,
    [0xFDEB] = true,
    [0xFDEC] = true,
    [0xFDED] = true,
    [0xFDEE] = true,
    [0xFDEF] = true,
    -- Others
    [0x000B] = true,
    [0xFFFE] = true,
    [0xFFFF] = true,
    [0x1FFFE] = true,
    [0x1FFFF] = true,
    [0x2FFFE] = true,
    [0x2FFFF] = true,
    [0x3FFFE] = true,
    [0x3FFFF] = true,
    [0x4FFFE] = true,
    [0x4FFFF] = true,
    [0x5FFFE] = true,
    [0x5FFFF] = true,
    [0x6FFFE] = true,
    [0x6FFFF] = true,
    [0x7FFFE] = true,
    [0x7FFFF] = true,
    [0x8FFFE] = true,
    [0x8FFFF] = true,
    [0x9FFFE] = true,
    [0x9FFFF] = true,
    [0xAFFFE] = true,
    [0xAFFFF] = true,
    [0xBFFFE] = true,
    [0xBFFFF] = true,
    [0xCFFFE] = true,
    [0xCFFFF] = true,
    [0xDFFFE] = true,
    [0xDFFFF] = true,
    [0xEFFFE] = true,
    [0xEFFFF] = true,
    [0xFFFFE] = true,
    [0xFFFFF] = true,
    [0x10FFFE] = true,
    [0x10FFFF] = true,
}

local function replace_charref(s)
    s = s:sub(2, -2) -- Remove the leading '&' and trailing ';'

    if s:sub(1, 1) == "#" then
        local num
        -- Numeric charref
        if s:sub(2, 2):lower() == "x" then
            num = tonumber(s:sub(3, -2), 16)
        else
            num = tonumber(s:sub(2, -2))
        end

        if _invalid_charrefs[num] then
            return _invalid_charrefs[num]
        end

        if num >= 0xD800 and num <= 0xDFFF or num > 0x10FFFF then
            return "´┐¢"
        end

        if invalid_codepoints[num] then
            return ""
        end

        return utf8.char(num)
    end

    -- Named charref
    if html5[s] then
        return html5[s]
    end

    -- Find the longest matching name
    for x = #s - 1, 1, -1 do
        local prefix = s:sub(1, x)
        if html5[prefix] then
            return html5[prefix] .. s:sub(x + 1)
        end
    end

    return "&" .. s
end

--- Convert all named and numeric character references (e.g. `&gt;`, `&#62;`,
-- `&x3e;`) in the string s to the corresponding unicode characters.
-- This function uses the rules defined by the HTML 5 standard
-- for both valid and invalid character references, and the list of
-- HTML 5 named character references defined in html.entities.html5.
-- @tparam string str The input string containing character references.
-- @return string The input string with character references replaced by Unicode characters.
function htmlEntities.unescape(str)
    if not str:find("&") then
        return str
    end
    return (str:gsub("&(#[0-9]+;?|#x[0-9a-fA-F]+;?|[^%s<&#;]{1,32};?)", replace_charref))
end

return htmlEntities
