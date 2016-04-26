local assert = assert
local string = string
local type = type
local char = string.char
local byte = string.byte
local rep = string.rep
local sub = string.sub
local padding = {}
function padding.pad(data, blocksize, optional)
    blocksize = blocksize or 16
    assert(type(blocksize) == "number" and blocksize > 0 and blocksize < 257, "Invalid block size")
    local ps = blocksize - #data % blocksize
    if ps == 0 then
        if optional then return data end
        ps = blocksize
    end
    return data .. rep("\0", ps - 1) .. char(ps)
end
function padding.unpad(data, blocksize)
    blocksize = blocksize or 16
    assert(type(blocksize) == "number" and blocksize > 0 and blocksize < 257, "Invalid block size")
    local len = #data
    assert(len % blocksize == 0, "Data's length is not a multiple of the block size")
    local chr = sub(data, -1)
    local rem = byte(chr)
    assert(rem > 0 and rem <= blocksize, "Invalid padding found")
    local chk = sub(data, -rem)
    assert(chk == rep("\0", rem - 1) .. chr, "Invalid padding found")
    return sub(data, 1, len - rem)
end
return padding